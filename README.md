# Position Control on Hydraulic Cylinder using Fuzzy PID

The aim of the project is to realize the position control on a single hydraulic cylinder. The project will be carried out in several stages. First, we will build the Fuzzy PID model in MATLAB and test it with the simulated hydraulic system in Simulink. After that, the fuzzy PID will be implemented on the real hardware to control the position of the hydraulic cylinder. Finally, it will be used on the position control of multiple hydraulic cylinder on whether the backhoe arm, the hydraulic boom or whatever related with hydraulic.

## Table of Contents

- [Software](#software)
- [Hardware](#hardware)
- [Reference](#reference)

## Software

### IDE
- MATLAB R2020a
- Thonny

## Hardware

### Electronics
- Raspberry Pi Pico
![Rasberry Pi Pico Image](https://github.com/lex-debug/FuzzyPID/blob/main/img/V-RPI-PICO_d-800x800.jpg)
- Double Channel Relay
![Relay Image](https://github.com/lex-debug/FuzzyPID/blob/main/img/2nhUX1bL1629401083-1444x1444.jpg)
- UART Cable
![UART Cable Image](https://github.com/lex-debug/FuzzyPID/blob/main/img/ed425db5315c558064073b7a91e71bc2.jpg)
- 12V Battery x2

You can use either lead acid battery or lipo battery but be extra careful when handling with battery

Lead Acid Battery

![Lead Acid Battery Image](https://github.com/lex-debug/FuzzyPID/blob/main/img/images.jpg)

LiPo Battery

![LiPo Battery Image](https://github.com/lex-debug/FuzzyPID/blob/main/img/78448c337bce01db00d5d8527dade7a8.jpg)

### Hydraulic
- A double acting hydraulic cylinder
- A hydraulic power pack (consists of a pump, AC motor, and tank)
- A solenoid valve

## How to run the simulation

1. Open the MATLAB
2. Open the file SugenoFuzzyPIDModel.m. Click Run. After finished running, you will see the following graphs.
![Graphs of Fuzzy PID](https://github.com/lex-debug/FuzzyPID/blob/main/img/Screenshot%202023-09-01%20142402.png)
3. Open the Simulink
4. Open the model hydralic_system_model_with_fuzzy_pid.slx. You will see the following model.
![Simulink Model Image](https://github.com/lex-debug/FuzzyPID/blob/main/img/Screenshot%202023-09-01%20142451.png)
5. If there is no any error (red border around each block), you can proceed to click Run.
6. You can observe the result by clicking each scope. There are scope which visulaize the position, the velocity of the cylinder, the pressure of the channel A and source of the valve and so on.

## Reference