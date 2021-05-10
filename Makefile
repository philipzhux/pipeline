run: compile;vvp compiled > result.txt;
compile: copy CPU.v CPU_test.v;
copy:$(FILE);cp -f $(FILE) ./test_code.txt;
clean: compiled test_code.txt result.txt;rm -f compiled test_code.v result.txt;