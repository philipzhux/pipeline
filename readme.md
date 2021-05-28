# Project 3 Report
*Note: Hazards solved with forwarding and stalling.*
ZHU Chuyan (119010486). CSC 3050 Spring 2021.
## 1. How to Run
### 1.1 File Structure:
```shell
.
+-- report.pdf
+-- src
|   +-- CPU.v,CPU_test.v
|   +-- pc_reg.v,if_id_reg.v,id_ex_reg.v,ex_mem_reg.v,mem_wb_reg.v
|   +-- forward.v,hazard_detection.v
|   +-- registerfile.v,mux.v,ctrl.v,InstructionRAM.v,MainMemory.v
|   +-- Makefile
```
### 1.2 Run with makefile:

>For your convenience, I have formulated a makefile where you can pass your testing machine code path to **make** and get the result without diving into InstructionRAM.v to change.

*Required dependency: Icarus Verilog. Testing version: version 10.2 (stable).*

To compile the verilog files and run the test bench at same time use:
```shell
    cd ./src
    make run IN=/tmp/xx/xxxxx/machine_codeX.txt
    # REPLACE THE VALUE WITH TESTING MACHINE CODE FILE PATH
    # or if instructions.bin is already ready simply:
    # make runraw
```
This will generate a verilog executable file named **compiled** and a copy of your machine code **instructions.bin**, and the result of main memory is located in **result.txt** in the src directory.
You can also clean the related files with ```make clean``` or compile without execution with ```make compile```.

## 2. Big Picture
The central idea of pipelined CPU is to increase the overall throughput, or say, utilization of the CPU, by enabling different (usually neighboring) instructions to run concurrently, with each of them in different stages. Isolation is very important in concurrency, so we need to devide a single cycle data path into multiple stages and for the 5-stage pipelined CPU, the five stages are:
* ```IF```:  Instruction Fetching
* ```ID```:  Instruction Decoding
* ```EX```:  Excecution
* ```MEM```: Memory Access or Write
* ```WB```:  Write Back

To isolate the operations/data of a particular stage within a cycle (prevent the result in a one stage from intervening another), we need four pipeline registers (buffer) to restrict the move of data to happend only at a positive clock edge (actually five, the program counter also needs one register to hold). They are ```IF/ID```, ```ID/EX```, ```EX/MEM```, and ```MEM/WB```.

Inside each of the five stage, the strucure is similar to the single-path MIPS CPU:
* ```IF``` stage is resposible for instruction fetching. Therefore, there is a structure to feed the desired address (either **previous-pc+4** or **jump/branch address**) to the ```Instruction Memory``` to fetch the correct instruction and pass it to the intermediate register ```IF/ID```. It is also in charge of incrementing the PC by 4 and pass to ```IF/ID```.
* ```ID``` stage is in charge of the decoding of instruction, and by decoding it means: 
    1. decode the instruction into control signals with a control unit;
    2. fetch the needed data through register address specified in a instructions from the register file and/or process the intermidiate data lying within the instruction; 
    3. feed the result of **1** and **2** above to the next register ```ID/MEM```.

    Note that in ```ID``` stage, the feedback of ```WB``` from previous stage is forwarded to this stage to write back the data to the register. To reduce the branch penalty, the branch condiction comparison can also be placed in the second stage.
* ```EX``` stage is reponsible for ALU execution to conduct arithmetic operation (either arithmetic results, address calculation, etc.) for future stages based on the control signal provided by the ```ID``` stage.
* ```MEM``` stage is reponsible for read and write of the main memory (such as those in ```lw``` and ```sw``` instructions)
* ```WB``` stage is reponsible to select the right data (either data from memory read or from ALU result) and generate the write signal to feed the write ports of register file in second stage.

However, three type of hazards may occur in this pipelined model: **structural hazard**, **data hazard**, and **control hazard**.
* Structural hazard: it occurs when read and write of the register file happen at the same time in the second stage, which can be simply eliminated by **deviding the cycle into two halves: write at rising edge and read at falling edge** (as the writing instruction must be prior to the reading instruction)
* Data hazard: it occurs when the sucessing instruction is accessing the register which the previous instruction is going to but has not yet written to. <br>It can be eliminated by forwarding if the desired data is ready at the point of use (e.g. data in EX/MEM or MEM/WB can be forwarded to feed the EX stage if it matches the register if requires). <br>But if it is not ready (e.g. *need lw data from precedent instruction to feed the EX stage* **or** *for branch instuction it need EX result from precedent instriction to determine the condition in second stage*), we need to **stall for a cycle** by repeating the same PC and flush the control signal from ```ID/EX``` to prevent writing.
* Control hazard: it occurs in case of taken case of branch and all jumps (actually for ```J``` and ```JAL``` instuction we are capable of jumping right at the first stage, but for simplicity I decided to make all jump instructions equall). It can be fixed by flushing the incorrect instuctions that have entered the pipeline. Penalty can be reduced by moving the condition determining process to the second stage so only one cycle is wasted in case of flush.
## 3. Data Path
Shown below is the datapath of my designed modified from the one provided in a textbook.  
![Datapath](https://raw.githubusercontent.com/hackchor/privateruleset/main/20210511001518-0001-2.png "Data Path")
* The forwarding multiplexer in ID stage is modified into a 3-way multiplexer to support forwarding from both MEM_ALUout and WB_Result.  
* Extra ```Jump-branch Control``` (```JBContorl```) Unit is feeding the now 3-way multiplexer to select PC.
* Extra ```Jump Add & Shift Unit``` processes the 26-bit raw jump address into the 32-bit jump address for ```J``` and ```JAL```.
* An extra multiplexer selects between the result of ```Jump Add & Shift Unit``` (```J``` and ```JAL```) and ```RD1``` (for ```JR```) and gives the jump address.
* For ```JAL```, ```Link``` signal is passed one step per cycle up to ```WB``` stage to determine whether the jump address is feed as the result to write back. 
*To correct my minor mistake in the graph, the ```ReadData1E (for JAL)``` should come from the jump address in the second stage but not ```RD1```.*
* ```Hazard Unit``` includes forwarding module and hazard detection module.

## 4. Implementation Ideas
A bottom-up approach is adpoted to implement the design, which firstly breaks down the design into parts then assembles and connects them up, and finally tests the whole design.
### 4.1 Break-down
After the observation of the whole structure, I break it down into serveral modules:
* 5 Buffer Registers: ```PC_Reg```,```IF_ID_Reg```,```ID_EX_Reg```, ```EX_MEM_Reg``` and ```MEM_WB_teg```
* ALU module
* Control Modules including main control and JBControl nested in ```ctrl.v```
* Serveral Multiplexer Modules nested in ```mux.v```
* Register File Module in ```registerfile.v```
* InstructionRAM Module in ```InstructionRAM.v```
* MainMemory Module in ```MainMemory.v```
* Other utilities including adder, comparator, shifting, sign extending and parsing modules nested inside ```utils.v```
* Forwarding module in ```forward.v```
* Hazard detection module in ```hazard_detection.v```
#### 4.1.1 Buffer Registers
All buffer register use non-blocking assignment at every rising edge of a clock to pass the values synchronously.  
Specially, for ```PC_Reg``` a ```PC_Stall``` signal decides whether it hold or pass the PC; for ```IF_ID_Reg```, ```IF_ID_Flush``` signal decides whether it flushes all data to zero or not and ```IF_ID_Stall``` decides holding or passing.   
*No flush signal for ```ID_EX``` as there is a ```controlmux``` signal in control module to flush all control signals to zero before it reaches ```ID_EX_Reg``` to prevent writing in case of stalls.*
#### 4.1.2 Control Modules
A switch-case strucure is used to decode the instuctions into control signals including ```RegWrite```,```MemtoReg```,```Branch```,```ALUControl```,```ALUSrc```,```RegDst```,```MemWrite``` and ```JBControlSignal```/```LinkSignal```
#### 4.1.3 Register Files
Implemented with 32 of 32-bit registers. Write at ```posedge clk``` and read at ```negedge clk```.
#### 4.1.4 Forwarding Unit
Either forwarding **from** ```EX_MEM``` or ```MEM_RB``` and **to** ```ID``` or ```EX``` (and **to** ```RS``` or ```RT```) or either **not forwarding**. Can be implemented with 4 *if-elseif-else* causes to cover all these cases and generate all possible signals to feed the 4 three-way MUXs for forwarding.
#### 4.1.5 Hazard Detection Unit
Four cases,using *if-elseif-elseif-else* clause: 1. Result of ```lw``` from prior instructions is needed for EX stage, which can be detected in advanced by comparing read register in ```IF/ID``` with write register in ```ID/EX``` and screen by checking ```memwrite``` signal in ```ID/EX```: Stall PC, Stall IF/ID and Flush **Control Signal** of ID/EX  (Data hazard)
2. Result of EX or MEM needed for ID stage in case of ```branch```: Stall PC, Stall ```IF/ID``` and Flush **Control Signal** of ```ID/EX```  (Data hazard)
3. Flush for Branch/Jump: Flush ```IF/ID``` only (Control hazard)
4. No stall needed (No hazards or fixed by forwarding)
### 4.2 Aseembling
Inside ```CPU.v``` I instantialise the modules designed above and connect them with wires according the the datapath in the third part.
### 4.3 Testing
Inside ```CPU_test.v``` I generate the clock signal by toggling after a half-period delay inside a while block until it reaches the instruction 32'hFFFF_FFFF, and using ```$display``` keyword to print out 512 lines (words) of memory.
With the makefile as is described in Part 1 (how to test), I have tested and sucessfully passed all the 8 provided machine codes.

## 5. Implementation Tricks
At the exact point of ```posedge clk```, write data from ```WB``` stage is not yet updated yet the register file still takes it as the writing data to write into the register which leads to an error. Therefore, I add a very short delay (```#2;```) before the write to the register file to fix the problem.
