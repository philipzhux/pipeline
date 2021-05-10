# Project 3 Report
ZHU Chuyan (119010486). CSC 3050 Spring 2021.
## 1. How to Run
### 1.1 File Structure:
```
.
+-- report.pdf
+-- src
|   +-- CPU.v
|   +-- CPU_test.v
|   +-- ctrl.v
|   +-- pc_reg.v
|   +-- if_id_reg.v
|   +-- id_ex_reg.v
|   +-- ex_mem_reg.v
|   +-- mem_wb_reg.v
|   +-- 
|   +-- Makefile
```
### 1.2 Run with makefile:
Required dependency: Icarus Verilog. Testing version: version 10.2 (stable).
To compile the verilog files and run the test bench at same time use:
```
    cd ./src
    make test
```
This will generate a verilog executable file named **compiled** and a vcd result file **a2_result.vcd**, and output the result to **stdout** in format like:
```
Instruction(0b)    OP(0x)    Funct(0x)    Rs(0x)    Rt(0x)    Imm(0x)    Result(0x)    Flags(0b)
```
You can also compile without execution with ```make compile``` or clean the related files with ```make clean```