from machine import Pin, ADC, PWM, Timer, UART
import time

# Pin definitions
# Built-in led
pin_led = Pin(25, mode=Pin.OUT)

# Using GPIO pin to supply 3.3V to the gefran ldt
voltage_pin = Pin(16, mode=Pin.OUT, value=1)

# The ldt is read using ADC
ldt_pin = Pin(26, mode=Pin.IN)
ldt_adc = ADC(ldt_pin)

# Control the solenoid using pwm to the relay
sol_a_pin = Pin(19, mode=Pin.OUT)
sol_b_pin = Pin(20, mode=Pin.OUT)

pwm_a = PWM(sol_a_pin)
pwm_b = PWM(sol_b_pin)

# Need to find out the valve response time, therefore a suitable
# pwm frequency for the valve to respond
valve_freq = 20

duty_cycle = 100

pwm_a.freq(valve_freq)
pwm_b.freq(valve_freq)

# timer callback
def interruption_handler(timer):
    global fivems_flag
    fivems_flag = 1
    
# UART
uart = UART(1, baudrate=115200, tx=Pin(4), rx=Pin(5))
uart.init(bits=8, parity=None, stop=1)
    
# S - 0.2
# MS - 0.4
# M - 0.6
# MB - 0.8
# B - 1.0
Kp_Rules = [[0.2, 0.2, 0.2, 0.4, 1.0],
            [0.2, 0.2, 0.2, 0.4, 1.0],
            [0.2, 0.2, 0.2, 1.0, 1.0],
            [0.2, 0.4, 0.2, 0.8, 1.0],
            [0.2, 0.4, 0.2, 0.8, 1.0]]

Ki_Rules = [[0.2, 0.2, 0.2, 0.4, 1.0],
            [0.2, 0.2, 0.2, 1.0, 1.0],
            [0.2, 0.2, 0.2, 0.8, 1.0],
            [0.4, 0.2, 0.2, 0.6, 1.0],
            [0.4, 0.4, 0.2, 0.8, 1.0]]

Kd_Rules = [[1.0, 0.8, 1.0, 0.2, 0.2],
            [0.8, 0.6, 1.0, 0.2, 0.2],
            [0.6, 0.6, 1.0, 0.6, 0.2],
            [0.4, 0.4, 1.0, 0.8, 0.2],
            [0.2, 0.4, 1.0, 1.0, 0.2]]

KU_MAX = 65_535
KE_MAX = 250
KEC_MAX = 500 # need to find out
KES_MAX = 1000
KP_BASE = 0.8
KI_BASE = 0.25
KD_BASE  = 0.1
KP_PARAM = 1.0
KI_PARAM = 0.5
KD_PARAM = 0.1
    
# Fuzzy PID
class FuzzyPID:
    
    def __init__(self, ku, err_max, errc_max, errs_max, kp_base, ki_base, kd_base, kp_param, ki_param, kd_param, Kp_Rules, Ki_Rules, Kd_Rules):
        self.KU_MAX = ku
        self.KE_MAX = err_max
        self.KE_MIN = -err_max
        self.KEC_MAX = errc_max
        self.KEC_MIN = -errc_max
        self.KES_MAX = errs_max
        self.KES_MIN = -errs_max
        self.Kp_B = kp_base
        self.Ki_B = ki_base
        self.Kd_B = kd_base
        self.Kp_P = kp_param
        self.Ki_P = ki_param
        self.Kd_P = kd_param
        self.Kp_Rules = Kp_Rules
        self.Ki_Rules = Ki_Rules
        self.Kd_Rules = Kd_Rules
        
        self.prev_err = 0.0
        self.errs = 0.0
        
    def fpid(self, sp, pv):
        global output
        err = sp - pv
        errc = err - self.prev_err
        self.prev_err = err;
        
        if (abs(err) < 2.0):
            self.errs = 0.0
            output = 0.0
        else:
            self.errs += err
            
            if (abs(err) > self.KE_MAX):
                if (err > 0.0):
                    err = KE_MAX
                else:
                    err = self.KE_MIN
                    
            if (abs(errc) > self.KEC_MAX):
                if (errc > 0.0):
                    err = self.KEC_MAX
                else:
                    err = self.KEC_MIN
            
            if (abs(self.errs) > self.KES_MAX):
                if (self.errs > 0.0):
                    self.errs = self.KES_MAX
                else:
                    self.errs = self.KES_MIN

            if (err > 0):
                errCal = int(err * 2.0 / self.KE_MAX + 0.5)
            else:
                errCal = int(err * 2.0 / self.KE_MAX - 0.5)
                
            if (errc > 0):
                errcCal = int(errc * 2.0 / self.KEC_MAX + 0.5)
            else:
                errcCal = int(errc * 2.0 / self.KEC_MAX - 0.5)
                
            set_Kp = self.Kp_Rules[errcCal+2][errCal+2]
            set_Ki = self.Ki_Rules[errcCal+2][errCal+2]
            set_Kd = self.Kd_Rules[errcCal+2][errCal+2]
            
            Kp = self.Kp_B + set_Kp * self.Kp_P
            Ki = self.Ki_B + set_Ki * self.Ki_P
            Kd = self.Kd_B + set_Kd * self.Kd_P

#             Kp = self.Kp_B
#             Ki = self.Ki_B
#             Kd = self.Kd_B
            
            output = err * Kp + self.errs * Ki + errc * Kd
            output = output / self.KE_MAX
            output = output * self.KU_MAX
            
            if (abs(output) > self.KU_MAX):
                if output > 0.0:
                    output = self.KU_MAX
                else:
                    output = -self.KU_MAX
            
# Flags
fivems_flag = 0

# Set point for the length of hydraulic cylinder
ldt_x_target = 0

output = 0


if __name__ == "__main__":
    soft_timer = Timer(mode=Timer.PERIODIC, period=5, callback=interruption_handler)
    cyl_fpid = FuzzyPID(KU_MAX, KE_MAX, KEC_MAX, KES_MAX, KP_BASE, KI_BASE, KD_BASE, KP_PARAM, KI_PARAM, KD_PARAM, Kp_Rules, Ki_Rules, Kd_Rules)
    
    while True:
        if uart.any():
                rxData = uart.read()
                ldt_x_target = int(rxData)
        if fivems_flag:
            pin_led.value(not pin_led.value())
            ldt_x_curr = ldt_adc.read_u16() * 250.0 / 65_535
            ldt_x_target = float(ldt_x_target)
#             uart.write('curr: '+str(ldt_x_curr)+'\r\n')
#             uart.write(str(ldt_x_target*1000)+'\r\n')
#             print(ldt_x_target)
            uart.write(str(ldt_x_curr)+'\r\n')
            cyl_fpid.fpid(ldt_x_target, ldt_x_curr)
            
            if output > 0.0:
                pwm_a.duty_u16(int(output))
                pwm_b.duty_u16(0)
#                 uart.write('output a: '+str(output)+'\r\n')
            else:
                pwm_a.duty_u16(0)
                pwm_b.duty_u16(int(-1.0 * output))
#                 uart.write('output b: '+str(output)+'\r\n')
            fivems_flag = 0
