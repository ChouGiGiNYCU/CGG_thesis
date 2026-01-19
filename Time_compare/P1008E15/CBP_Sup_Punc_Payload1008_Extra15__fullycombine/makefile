CC = g++
CFLAGS = -Wfatal-errors -std=c++11
TARGET = CBP_punc_PayLoad_Extra
SRCS = CBP_punc_PayLoad_Extra.cpp
##########################
SNR_min = 1
SNR_max = 2.5
SNR_Ratio = 0.25
Iteration_Limit = 200
##########################
payload_PCM = ../../../PCM/PEGReg504x1008.txt
extra_PCM = ../../../PCM/BCH_15_7.txt
Combine_PCM = PCM_P1008_E15BCH_1SR.txt

############# G setting ###########
payload_Generater_matrix_file = ../../../GM/PEGReg504x1008_G.txt
# payload_Encdoe_Flag = 0
extra_Generater_matrix_file = ../../../GM/BCH_15_7_G.txt
# extra_Encdoe_Flag = 0
###################################
Open_Iteration = 100
time_file = time.csv

$(TARGET): $(SRCS)
	$(CC) $(CFLAGS)  $(SRCS) -o  $(TARGET) -lpthread

BP:$(TARGET)

	./$(TARGET) $(Combine_PCM) $(PayLoad_out_file) $(Extra_out_file) $(payload_PCM) $(extra_PCM) $(puncture_pos_file) $(payload_Generater_matrix_file) $(extra_Generater_matrix_file) $(Iteration_Limit) $(SNR_min) $(SNR_max) $(SNR_Ratio) $(Open_Iteration) $(time_file)

clean:
	rm -f $(TARGET) 
	