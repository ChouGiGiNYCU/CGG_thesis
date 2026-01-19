%%
clc;
clear all;
close all;
%%
H1_file = '..\..\PCM\PEGReg504x1008.txt'; % payload data
H2_file = '..\..\PCM\H_10_5.txt'; % extra data
H_combine_file = 'PCM_P1008_E10_FC.txt';
puncture_position_bits_file = ['Pos_', H_combine_file];
H1 = readHFromFileByLine(H1_file);
H2 = readHFromFileByLine(H2_file);
[H1_r,H1_c] = size(H1);
[H2_r,H2_c] = size(H2);
% H_combine = [  H1     zero1   zero2 
%               zero3     H2    zero4
%               punc_p  punc_e    I
%             ] 
zero1 = zeros([H1_r H2_c]);
zero2 = zeros([H1_r H2_c]);
zero3 = zeros([H2_r H1_c]);
zero4 = zeros([H2_r H2_c]);
H_combine = [[H1,zero1,zero2];[zero3,H2,zero4]];

punc_pos_bits = maximize_oneSR_method(H1,H2_c);
%% check  punc_pos_bits 是否都是 1-SR
for Punc_VN=punc_pos_bits 
    Punc_SCNs = transpose(find(H1(:,Punc_VN)==1));
    SCNs_num = 0;
    for SCN=Punc_SCNs
        Nei_SCN_VNs = setdiff(find(H1(SCN,:)==1),Punc_VN);
        if ~any(ismember(punc_pos_bits,Nei_SCN_VNs))
            SCNs_num  = SCNs_num + 1;
        end
    end
    if SCNs_num==0
        disp("find no 1-SR punc vn !!\n");
    end
end
%%

punc_payload_mat = zeros([H2_c,H1_c]);
for r=1:H2_c
    punc_vn = punc_pos_bits(r);
    punc_payload_mat(r,punc_vn) = 1;
end
punc_extra_mat = eye(H2_c);
I = eye(H2_c);
H_combine = [H_combine;punc_payload_mat,punc_extra_mat,I];

% write H_combine to PCM 
writePCM(H_combine,H_combine_file);

% write payload data with puncture bits position 
fileID = fopen(puncture_position_bits_file, 'w');
for pos=punc_pos_bits
    fprintf(fileID, '%d ', pos);
end
fprintf(fileID, '\n');
fclose(fileID);
