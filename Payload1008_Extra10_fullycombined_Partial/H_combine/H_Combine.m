%%
clc;
clear all;
close all;
%%
H1_file = '..\..\PCM\PEGReg504x1008.txt'; % payload data
H2_file = '..\..\PCM\H_10_5.txt'; % extra data
H_combine_file = 'PCM_P1008_E10_PartialExtraTransmit.txt';
puncture_position_bits_file = "Table_Superposition_Extra_Payload.csv";
Transmit_Extra_VNs_table_file     = "Table_ExtraTransmitVNs_to_PuncPosPayload.csv";

H1 = readHFromFileByLine(H1_file);
H2 = readHFromFileByLine(H2_file);
[H1_r,H1_c] = size(H1);
[H2_r,H2_c] = size(H2);
Extra_Transmit_Ratio = 0.5;
Extra_Transmit_number = floor(Extra_Transmit_Ratio *  H2_c);
Punc_p_r = H2_c-Extra_Transmit_number;

% 要傳送的部分 Extra VNs
Transmit_Extra_VNs = sort(randperm(H2_c, Extra_Transmit_number));


% H_combine = [  H1     zero1       zero2 
%               zero3     H2        zero4
%               punc_p  punc_e        I
%             ] 
zero1 = zeros([H1_r H2_c]);
zero2 = zeros([H1_r Punc_p_r]);
zero3 = zeros([H2_r H1_c]);
zero4 = zeros([H2_r Punc_p_r]);
H_combine = [[H1,zero1,zero2];[zero3,H2,zero4]];


punc_pos_bits_origin = maximize_oneSR_method(H1,H2_c); % idx = 1
% punc_pos_bits_origin = [76 136 196 272 362 465 496 583 682 684 712 756 882 923 932]; 

remove_idx = randperm(length(punc_pos_bits_origin), Extra_Transmit_number); % 隨機選擇 num 個 index 要刪掉
Extra_Transmit_OnPayload_vn = punc_pos_bits_origin(remove_idx);
punc_pos_bits_origin(remove_idx) = [];


punc_payload_mat = zeros([Punc_p_r,H1_c]);
for r=1:Punc_p_r
    punc_vn = punc_pos_bits_origin(r);
    punc_payload_mat(r,punc_vn) = 1;
end
punc_extra_mat = zeros([Punc_p_r H2_c]);
remaining_Extra_VN = setdiff(1:H2_c, Transmit_Extra_VNs);  % 找出剩下的部分
for r=1:Punc_p_r
    remain_vn = remaining_Extra_VN(r);
    punc_extra_mat(r,remain_vn) = 1;
end
I = eye(Punc_p_r);
H_combine = [H_combine;punc_payload_mat,punc_extra_mat,I];

% write H_combine to PCM 
writePCM(H_combine,H_combine_file);

% write payload data with puncture bits position 
T = table(remaining_Extra_VN.',punc_pos_bits_origin.','VariableNames', {'Extra_VNs', 'Payload_VNs'});  % 建立 table
writetable(T, puncture_position_bits_file);  % 輸出 csv
% fileID = fopen(puncture_position_bits_file, 'w');
% for pos=punc_pos_bits_origin
%     fprintf(fileID, '%d ', pos);
% end
% fprintf(fileID, '\n');
% fclose(fileID);


T = table(Transmit_Extra_VNs.',Extra_Transmit_OnPayload_vn.','VariableNames', {'Extra_VNs', 'Payload_VNs'});  % 建立 table
writetable(T, Transmit_Extra_VNs_table_file);  % 輸出 csv
