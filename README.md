# Parking Lot Management System in Verilog

This repository contains a Verilog implementation of a parking lot management system, along with a test bench to verify its correctness. The design ensures priority parking for university staff and manages the dynamic allocation of parking spaces based on the time of day.

## Table of Contents

- [Overview](#overview)
- [Verilog Module](#verilog-module)
  - [Module Interface](#module-interface)
  - [Functionality](#functionality)
- [Test Bench](#test-bench)
  - [Test Scenarios](#test-scenarios)
- [How to Run](#how-to-run)
- [Results](#results)
- [License](#license)
- [Contributing](#contributing)
- [Contact](#contact)

## Overview

The parking lot management system is designed with the following constraints:
1. **Priority for University Staff:** Maximum capacity for university staff is 500 cars.
2. **Total Parking Capacity:** Total capacity is 700 cars. From 8 AM to 1 PM, only 200 spaces are available for public parking.
3. **Incremental Public Parking Capacity:** From 1 PM to 4 PM, public parking capacity increases by 50 cars per hour, reaching 500 cars by 4 PM.

## Verilog Module

The `parking_lot.v` file contains the Verilog implementation of the parking lot management system. The module dynamically adjusts parking capacities based on the current hour and manages both university and public parking spaces.


### Module Interface

``verilog
module parking_lot #(
    parameter UNI_CAP = 500,
    parameter PUB_CAP = 200,
    parameter PHASE = 50
)(
    input car_entered, 
    input is_uni_car_entered,
    input car_exited, 
    input is_uni_car_exited, 
    input [5:0] hour,
    output reg [9:0] uni_parked_car = 0,
    output reg [9:0] parked_car = 0,
    output reg [9:0] uni_vacated_space = UNI_CAP,
    output reg [9:0] vacated_space = PUB_CAP,
    output reg uni_is_vacated_space = 1, 
    output reg is_vacated_space = 1
);

### Functionality

- **Morning Hours (8 AM - 1 PM):** University staff have priority, with 500 spaces allocated to them and 200 to public.
- **Afternoon Hours (1 PM - 4 PM):** Public parking capacity increases by 50 cars per hour.
- **Evening Hours (After 4 PM):** Equal distribution of parking spaces between university and public.
