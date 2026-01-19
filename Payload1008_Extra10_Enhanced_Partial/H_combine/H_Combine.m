%%
clc;
clear all;
close all;
% 部分 Extra 傳送 (部分 payload 被 Puncture)
% 所有Extra 都跟payload 做 New_Structure 連結
% setting parameter or file path
Payload_H = '..\..\PCM\PEGReg504x1008.txt'; % payload data
Extra_H = '..\..\PCM\H_10_5.txt'; % extra data
H_combine_file = 'PCM_P1008_E10_EnhancedPartial.txt';
puncture_position_bits_outfile = "Table_Superposition_Extra_Payload_50percent.csv"; % 對應payload 、 extra puncture位置(原本的方法)
Transmit_Extra_VNs_table_outfile     = "Table_ExtraTransmitVNs_to_PuncPosPayload_50percent.csv"; % 傳送的extra bits 位置 、不傳送的payload bits file
New_puncture_position_bits_outfile = "ExtraVNs_NewStrcuture_50percent.csv";

%% Read PCM file 
Payload_H = readHFromFileByLine(Payload_H);
Extra_H = readHFromFileByLine(Extra_H);
[Payload_H_r,Payload_H_c] = size(Payload_H);
[Extra_H_r,Extra_H_c] = size(Extra_H);
Non_select_VNs = 1:Payload_H_c;
%%  random choose Extra transmit VNs
Extra_Transmit_Ratio = 0.5; % Extra 傳送數量的比例
Extra_Transmit_number = floor(Extra_Transmit_Ratio *  Extra_H_c);
Transmit_Extra_VNs = randperm(Extra_H_c,Extra_Transmit_number); % random choose extra vn
Transmit_Extra_VNs = sort(Transmit_Extra_VNs);
non_Transmit_Extra_VNs = setdiff(1:Extra_H_c, Transmit_Extra_VNs);  % 找出剩下沒有傳送的Extra_bits

non_Transmit_Extra_VNs_num = size(non_Transmit_Extra_VNs,2);
I_mat_size = non_Transmit_Extra_VNs_num;
Already_Punc_VNs =[];
%% find Payload Punc bits
punc_bits_num =  Extra_H_c * 3 ; % 總共 punc bits 為 Extra(部分Superposition、Extra傳送) + Enhanced 
punc_pos_bits = Rate_Compatible_Punctured_With_Short_Block_Lengths(Payload_H,punc_bits_num,Already_Punc_VNs)
% 把找到的punc bits 分成 Payload+Extra(Superposition)、 Partial Transmit Extra(payload不傳送的) 、 Enhanced
punc_pos_bits_origin      =  punc_pos_bits(1:non_Transmit_Extra_VNs_num); % Superposition(fully-combined)
payload_punc_unsend       =  punc_pos_bits(non_Transmit_Extra_VNs_num+1:Extra_H_c); % Partial Transmit Extra(payload不傳送的)
punc_pos_bits_New_Struct1 =  punc_pos_bits(Extra_H_c+1:Extra_H_c*2); % 沒有被punc掉(跟Extra 做疊加)
punc_pos_bits_New_Struct2 =  punc_pos_bits(Extra_H_c*2+1:end); % 被 punc
Non_select_VNs = setdiff(Non_select_VNs,punc_pos_bits);

%% define 各個連接的矩陣
sup_payload_mat = zeros([non_Transmit_Extra_VNs_num,Payload_H_c]);
for r=1:non_Transmit_Extra_VNs_num
    punc_vn = punc_pos_bits_origin(r);
    sup_payload_mat(r,punc_vn) = 1;
end

sup_extra_mat = zeros([non_Transmit_Extra_VNs_num,Extra_H_c]);
for r=1:non_Transmit_Extra_VNs_num
    punc_vn = non_Transmit_Extra_VNs(r);
    sup_extra_mat(r,punc_vn) = 1;
end

punc_payload_mat_NewStructure1 = zeros([Extra_H_c,Payload_H_c]);
for r=1:Extra_H_c
    punc_vn = punc_pos_bits_New_Struct1(r);
    punc_payload_mat_NewStructure1(r,punc_vn) = 1;
end

punc_payload_mat_NewStructure2 = zeros([Extra_H_c,Payload_H_c]);
for r=1:Extra_H_c
    punc_vn = punc_pos_bits_New_Struct2(r);
    punc_payload_mat_NewStructure2(r,punc_vn) = 1;
end

I = eye(non_Transmit_Extra_VNs_num);
%%
% H_combine = [  Payload_H     zero1       zero2                     zero4   zero4 
%               zero3     Extra_H        zero5                     zero6   zero6 
%                sup_p   sup_e        I(unsend extra vn)      zero7   zero7
%               puncs1  punc_e      zeor9                       I     zeor8
%               puncs2  zero10      zeor9                       I       I      
%             ] 
zero1 = zeros([Payload_H_r Extra_H_c]);
zero2 = zeros([Payload_H_r non_Transmit_Extra_VNs_num]);
zero3 = zeros([Extra_H_r Payload_H_c]);
zero4 = zeros([Payload_H_r Extra_H_c]);

zero5 = zeros([Extra_H_r non_Transmit_Extra_VNs_num]);
zero6 = zeros([Extra_H_r Extra_H_c]);
zero7 = zeros([non_Transmit_Extra_VNs_num Extra_H_c]);

zero8 = zeros([Extra_H_c Extra_H_c]);
zero9 = zeros([Extra_H_c non_Transmit_Extra_VNs_num]);
zero10 = zeros([Extra_H_c Extra_H_c]);
I_sup = eye(non_Transmit_Extra_VNs_num);
I_New_Strcture = eye(Extra_H_c);
H_combine = [  
                Payload_H ,                                 zero1 , zero2 , zero4 , zero4;
                zero3 ,                              Extra_H    , zero5 , zero6 , zero6;
                sup_payload_mat ,            sup_extra_mat , I_sup , zero7 , zero7;
                punc_payload_mat_NewStructure1 , I_New_Strcture , zero9 , I_New_Strcture , zero8;
                punc_payload_mat_NewStructure2 , zero10 , zero9    , I_New_Strcture ,I_New_Strcture;
            
            ];

%% 輸出檔案
writePCM(H_combine,H_combine_file); % write H_combine to PCM 

% write payload data with puncture bits position with Superposition
T = table(non_Transmit_Extra_VNs.',punc_pos_bits_origin.','VariableNames', {'Extra_VNs', 'Payload_VNs'});  % 建立 table
writetable(T, puncture_position_bits_outfile);  % 輸出 csv

% write payload data with NonTransmit Extra bits puncture bits position with NewStructure 
T = table([1:Extra_H_c].',punc_pos_bits_New_Struct1.',punc_pos_bits_New_Struct2.','VariableNames', {'Extra bits','Payloadb_NonPunc(b)', 'Payloadc_Punc(c)'});  % 建立 table
writetable(T, New_puncture_position_bits_outfile);  % 輸出 csv

% Extra 傳送 payload不傳送的 各個bits
T = table(Transmit_Extra_VNs.',payload_punc_unsend.','VariableNames', {'Extra_VNs', 'Payload_VNs'});  % 建立 table
writetable(T, Transmit_Extra_VNs_table_outfile);  % 輸出 csv


