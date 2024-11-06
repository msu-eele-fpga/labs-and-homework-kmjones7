# Lab 6

In this lab, registers were created that can interact with software. This interaction will allow us to control the LED Patterns hardware with software in future labs.

A component called led_patterns_avalon was created. This component instantiated the LED_Patterns component and created registers. Platform Designer was used to integrate the led_patterns_avalon component to the HPS-to-FPGA Lightweight bus. 

## System Architecture

include updated block diagram with avalon bus wrapper and registers

## Register Map

include description of registers that you created
use bitfield diagrams showing what each 32 bit registers correspond to
create a table with address map, show what address each register is at

## Platform Designer

how did you connect the these registers to the ARM CPUs in the HPS?

led_patterns_avalon instantiates led_patterns component, and it creates registers. Platform designer was used to connect the led_paterns_avalon file to the HPS-to-FPGA lightweight bus. 

what is the base address of your component in your platform designer system?

the base address of my component in the platform designer system is 
