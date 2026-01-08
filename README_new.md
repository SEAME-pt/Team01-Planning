
## Project Overview

This project aims to create a prototype of an autonomous car.
The car should be able to navigate most roads regardless of weather conditions, and it should also be capable of identifying traffic signs and reacting to them as necessary.
To identify roads and traffic signs, only a single camera will be used.
The main purpose of this project is training and learning the technologies used in the market.

## Objectives:
- Identification of road lane markings 
- Identification of traffic signs
- Implementation of an instrument cluster
- Vehicle movement based on the previously mentioned data
- Learning the basic operation of the hardware
- Familiarization with technologies in the area: AGL, CAN, ThreadX, Qt, etc.
- Implementation of tests that can validate that our code works correctly
## System Architecture

### Hardware 
<p align="center">
  <img src="https://res.cloudinary.com/dtyy8f2os/image/upload/v1758021621/76256064-7c6a-4b7a-8057-de01047c410c.png">
</p>

### Struct_the project  softwere :

This project has its basic structure centered on two key controllers: a [ Raspberry Pi ](https://github.com/SEAME-pt/Car_control_Raspberry/blob/main/) and an [ STM32 ](https://github.com/SEAME-pt/STM32_Microcontroller). 
The Raspberry Pi is responsible for the instrument cluster based on Qt, where we can visualize all vehicle information such as speed, temperature, trajectory, etc.
In addition to displaying data to the user, the Raspberry Pi has the important mission of converting data from the car’s camera into indications that will be sent to the STM32.
The STM32 is responsible for managing all the commands sent by the Raspberry Pi, assigning the appropriate priority to each received command, and deciding whether to stop the car, increase speed, or execute other actions.
# Hardwere :
	 - Raspberry Pi 5 → will be the brain of the car, from which all commands will be issued
	 - Expansion board (JetRacer car kit) → motor and steering control kit
	 - Raspberry Pi AI HAT → responsible for heavy AI computations
	 - NVMe SSD → Raspberry Pi storage
	 - Display → will show speed values as well as the identified traffic signs to the driver
## Software:
#### Raspberry:
On the Raspberry Pi, we have a customized distribution of AGL (Automotive Grade Linux).
This is used to run the AI programs and the remaining applications that establish communication with the joystick and with CAN-FD.
These programs are written in C++.
#### STM32:
The STM32 B-U585I-IOT02A microcontroller is responsible for managing the car’s motors and steering, and for communicating everything to the Raspberry Pi via CAN.
To ensure that all commands are executed safely, the STM32 runs an RTOS (Real-Time Operating System), ThreadX, which allows strict control over the execution of one or multiple tasks.
## Safety strategy :
--

# Testing :
Test types and methodology

##  Project Status
- [x] Build AGL -> Implemented 
- [x] ThreadX in stm32 -> Implemnted
- [ ] Can-fd communication -> In progress
	- [ ] STM32 Can-fd
 	- [ ] Raspbery Can-fd
- [ ] STM32 communication with expansion board via I2C
- [ ] road identification
- [ ] Automatic steering control
        

## Technologies Used
[ AGL ](https://www.automotivelinux.org/), [ Qt ](https://www.qt.io/), [ ThreadX ](https://github.com/eclipse-threadx/threadx) , [ CAN ](https://www.csselectronics.com/pages/can-fd-flexible-data-rate-intro), [OpenCV](https://opencv.org/), etc.

##  Build & Documentation
- [ AGL ]( https://github.com/SEAME-pt/Team01-Planning/blob/main/AGL/Doc/AGL_minimal_build.md )
- [ Raspberry ](https://github.com/SEAME-pt/Car_control_Raspberry/blob/main/)
- [ QT_softwere ](https://github.com/SEAME-pt/Qt_Interface)
- [ github_acion/testing](https://github.com/SEAME-pt/Team01-Planning/blob/main/Documentation/Git_Actions.md#what-is-github-actions)



