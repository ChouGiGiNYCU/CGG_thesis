CC = g++
CFLAGS = -Wfatal-errors -std=c++11
TARGET = CBP_punc_FC
SRCS = CBP_punc_FC.cpp
##########################
SNR_min = 1
SNR_max = 2.5
SNR_Ratio = 0.25
Iteration_Limit = 200
##########################
payload_PCM = ../PCM/PEGReg504x1008.txt
extra_PCM   = ../PCM/H_10_5.txt
Combine_PCM       = PCM_P1008_E10_FC.txt
puncture_pos_file = Pos_PCM_P1008_E10_FC.txt
PayLoad_out_file = Punc_1SR_P1008_E10_PayLoad_it$(Iteration_Limit).csv
Extra_out_file   = Punc_1SR_P1008_E10_Extra_it$(Iteration_Limit).csv

############# G setting ###########
payload_Generater_matrix_file = ../GM/PEGReg504x1008_G.txt
extra_Generater_matrix_file = ../GM/H_10_5_G.txt
###################################
Open_Iteration = 0


$(TARGET): $(SRCS)
	$(CC) $(CFLAGS)  $(SRCS) -o  $(TARGET) -lpthread

BP:$(TARGET)
	./$(TARGET) $(Combine_PCM) $(PayLoad_out_file) $(Extra_out_file) $(payload_PCM) $(extra_PCM) $(puncture_pos_file) $(payload_Generater_matrix_file) $(extra_Generater_matrix_file) $(Iteration_Limit) $(SNR_min) $(SNR_max) $(SNR_Ratio) $(Open_Iteration)

clean:
	rm -f $(TARGET) 
	