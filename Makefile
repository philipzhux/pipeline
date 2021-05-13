runraw: compile;@vvp compiled;echo "[Success] Please check the result at result.txt";
run: copy compile;@vvp compiled;echo "[Success] Please check the result at result.txt";
compile: CPU.v CPU_test.v ctrl.v pc_reg.v if_id_reg.v id_ex_reg.v ex_mem_reg.v mem_wb_reg.v forward.v hazard_detection.v registerfile.v mux.v InstructionRAM.v MainMemory.v; @iverilog -o compiled CPU_test.v;
copy:$(IN);@cp -f $(IN) ./instructions.bin;
clean: compiled instructions.bin result.txt;@rm -f compiled instructions.bin result.txt;