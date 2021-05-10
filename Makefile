run: compile;vvp compiled > result.txt;
compile: copy CPU.v CPU_test.v ctrl.v pc_reg.v if_id_reg.v id_ex_reg.v ex_mem_reg.v mem_wb_reg.v forward.v hazard_detection.v registerfile.v mux.v InstructionRAM.v MainMemory.v; iverilog -o compiled CPU_test.v;
copy:$(FILE);cp -f $(FILE) ./test_code.txt;
clean: compiled test_code.txt result.txt;rm -f compiled test_code.v result.txt;