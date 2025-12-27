############# compile command #############
CC     = g++
CFLAGS = -Wfatal-errors -std=c++11
TARGET = CBP_PayLoad_Extra_EnhancedStructure
SRCS   = CBP_PayLoad_Extra_EnhancedStructure.cpp
############# BP decoding setting ###########
SNR_min         = 1
SNR_max         = 2.5
SNR_Ratio       = 0.25
Iteration_Limit = 200
Open_Iteration = 100
############# PCM setting ###########
payload_PCM  = /mnt/c/Users/USER/Desktop/LDPC/PCM/PEGReg504x1008.txt
extra_PCM    = /mnt/c/Users/USER/Desktop/LDPC/PCM/H_10_5.txt
############# Generative Matrix setting ###########
payload_Generater_matrix_file = /mnt/c/Users/USER/Desktop/LDPC/GM/PEGReg504x1008_G.txt
extra_Generater_matrix_file   = /mnt/c/Users/USER/Desktop/LDPC/GM/H_10_5_G.txt
############# Enhanced Matrix setting ###########
Combine_PCM  = PCM_P1008_E10_EnhanceStruc.txt
fully_combine_Payload_Extra_origin_file          = Table_FullyCombine_Extra_Payload.csv
Enhanced_Payload_Extra_pos_file = ExtraVNs_EnhancedStrcuture.csv

PayLoad_out_file = Punc_kSR_P1008_E10_PayLoad_it$(Iteration_Limit)_EnhanceStruc_Open100.csv
Extra_out_file   = Punc_kSR_P1008_E10_Extra_it$(Iteration_Limit)_EnhanceStruc_Open100.csv




$(TARGET): $(SRCS)
	$(CC) $(CFLAGS)  $(SRCS) -o  $(TARGET) -lpthread

BP:$(TARGET)
	./$(TARGET) $(Combine_PCM) $(PayLoad_out_file) $(Extra_out_file) $(payload_PCM) $(extra_PCM)  $(payload_Generater_matrix_file) $(extra_Generater_matrix_file) $(Iteration_Limit) $(SNR_min) $(SNR_max) $(SNR_Ratio) $(Open_Iteration)    $(fully_combine_Payload_Extra_origin_file) $(Enhanced_Payload_Extra_pos_file)

clean:
	rm -f $(TARGET) 
	