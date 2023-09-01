# Position Control on Hydraulic Cylinder using Fuzzy PID

The aim of the project is to realize the position control on a single hydraulic cylinder. The project will be carried out in several stages. First, we will build the Fuzzy PID model in MATLAB and test it with the simulated hydraulic system in Simulink. After that, the fuzzy PID will be implemented on the real hardware to control the position of the hydraulic cylinder. Finally, it will be used on the position control of multiple hydraulic cylinder on whether the backhoe arm, the hydraulic boom or whatever related with hydraulic.

## Table of Contents

- [Software](#software)
- [Hardware](#hardware)

## Software

### IDE
- MATLAB R2020a
- Thonny

## Hardware

### Electronics
- Raspberry Pi Pico
[Rasberry Pi Pico Image](https://static.cytron.io/image/cache/catalog/products/V-RPI-PICO/V-RPI-PICO_d-800x800.jpg)
- Double Channel Relay
- UART Cable
- 12V Battery x2

### Hydraulic
- A double acting hydraulic cylinder
- A hydraulic power pack (consists of a pump, AC motor, and tank)
- A solenoid valve