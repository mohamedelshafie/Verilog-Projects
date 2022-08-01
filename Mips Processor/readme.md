implemention of a 32-bit single-cycle microarchitecture MIPS processor based on Harvard Architecture. 

The language used is Verilog
The single-cycle microarchitecture executes an entire instruction in one cycle. 
In other words instruction fetch, instruction decode, execute, write back, and program counter update occurs within a single clock cycle. 

We begin constructing the datapath by connecting the state elements with combinational logic that can execute the various instructions. 
Control signals determine which specific instruction is carried out by the datapath at any given time. 
The controller contains combinational logic that generates the appropriate control signals based on the current instruction. 

Main modules are: ALU, Program Counter, Instruction Memory (ROM), Register File, Data Memory (RAM), and Control Unit.

Small modules are: Sign Extend, Shift Left, Adder, Multiplexer.

Main Modules:
1- An Arithmetic/Logical Unit (ALU) combines a variety of mathematical and logical operations into a single unit. 
For example, a typical ALU might perform addition, subtraction, magnitude comparison, AND, and OR operations. 
The ALU forms the heart of most computer systems. The 3-bit ALUControl signal specifies the operation. 
The ALU generates a 32-bit ALUResult and a Zero flag, that indicates whether ALUResult == 0. 
The following table lists the specified functions that our ALU can perform.

2- The program counter (PC) register contains the 32-bit address of the instruction to execute. 
The program counter is a synchronous unit that is updated at the rising edge of the clock signal “clk”. 
The program counter is asynchronously cleared (zeroed) whenever the active low reset signal “rst” is asserted.

3- Instruction Memory: The PC is simply connected to the address input of the instruction memory. 
The instruction memory reads out, or fetches, the 32-bit instruction, labeled Instr. 
Our instruction memory is a Read Only Memory (ROM) that holds the program that your CPU will execute. 
The ROM Memory has width = 32 bits and depth = 100 entries. Instr is read asynchronously.

4- The Register File contains the 32 32-bit MIPS registers. 
The register file has two read output ports (RD1 and RD2) and a single input write port (WD3). 
The register file is read asynchronously and written synchronously at the rising edge of the clock. 
The register file supports simultaneous read and writes. 
The register file has width = 32 bits and depth = 32 entries.

5- The data memory is a RAM that provides a store for the CPU to load from and store to. 
The Data Memory has one output read port (RD) and one input write port (WD). 
Reads are asynchronous while writes are synchronous to the rising edge of the “clk” signal. 
The Word width of the data memory is 32-bits to match the datapath width. 
The data memory contains 100 entries.
test_value is read from address 0x0000_0000 (First location on Memory) the least 16 significant bits. 
This signal is for only testing purposes to be able to see the results of the testing programs on the four digital tubes after configuration.

6- The control unit computes the control signals based on the opcode and funct fields of the instruction, Instr31:26 and Instr5:0. 
Most of the control information comes from the opcode, but R-type instructions also use the funct field to determine the ALU operation. 
Thus, we will simplify our design by factoring the control unit into two blocks of combinational logic.

Small Modules:
1- Sign extension simply copies the sign bit (most significant bit) of a short input (16 bits) into all of the upper bits of the longer output (32 bits).

2- Shift Left: This block only shift the input to the left twice. 
You need to make this block parameterized, as you need two versions of it in your top module with two different data input width.

3- Adder is a simple combination block. 
It is an adder block that adds two 32-bit data inputs to each other (A and B) and produces the output to the 32-bit port C.

4- Multiplexer: A 2x1 parametrized mux is used in this project.

For the test of the project:
Two different test programs are used. 
The two test programs are GCD Program and Factorial Number Program.
It is required to compile and load it onto the Instruction Memory (ROM Memory) and reset your processor to start executing from memory location 0000 0000h.
Each program would test some instructions.
