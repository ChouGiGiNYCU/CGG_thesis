CC     = g++ 
CFLAGS = -Wfatal-errors -std=c++11
TARGET = CBP_punc_PayLoad_Extra_EnhacedStructure
SRCS   = CBP_punc_PayLoad_Extra_EnhacedStructure.cpp
##########################
SNR_min         = 1
SNR_max         = 2.5
SNR_Ratio       = 0.25
Iteration_Limit = 200
##########################
payload_PCM  = ../../../PCM/PEGReg504x1008.txt
extra_PCM    = ../../../PCM/BCH_15_7.txt
Combine_PCM  = PCM_P1008_E15_EnhanceStruc.txt

##########################
Superposition_Payload_Extra_origin_file          = Table_Superposition_Extra_Payload.csv
Superpostion_Payload_Extra_NewStructure_pos_file = ExtraVNs_NewStrcuture.csv

############# G setting ###########
payload_Generater_matrix_file = ../../../GM/H_2640_1320.txt
# payload_Generater_matrix_file = None
extra_Generater_matrix_file   = ../../../GM/BCH_15_7_G.txt
###################################
Open_Iteration = 100
Time_File = time.csv

$(TARGET): $(SRCS)
	$(CC) $(CFLAGS)  $(SRCS) -o  $(TARGET) -lpthread

BP:$(TARGET)
	./$(TARGET) $(Combine_PCM) $(PayLoad_out_file) $(Extra_out_file) $(Super_out_file) $(payload_PCM) $(extra_PCM)  $(payload_Generater_matrix_file) $(extra_Generater_matrix_file) $(Iteration_Limit) $(SNR_min) $(SNR_max) $(SNR_Ratio) $(Open_Iteration)   $(Superposition_Payload_Extra_origin_file)  $(Superpostion_Payload_Extra_NewStructure_pos_file) $(Time_File)

clean:
	rm -f $(TARGET) 
	