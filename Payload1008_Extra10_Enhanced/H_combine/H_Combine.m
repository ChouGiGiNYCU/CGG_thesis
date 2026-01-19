%%
clc;
clear all;
close all;
% 部分 Extra 傳送 (部分 payload 被 Puncture)
% 所有Extra 都跟payload 做 Enhnaced 連結
% setting parameter or file path
Payload_file = '..\..\PCM\PEGReg504x1008.txt'; % payload PCM 檔案位置
Extra_file = '..\..\PCM\H_10_5.txt'; % extra PCM 檔案位置
H_combine_file = 'PCM_P1008_E10_EnhanceStruc.txt'; % 合併後的矩陣檔案位置
puncture_position_bits_outfile = "Table_FullyCombine_Extra_Payload.csv"; % 對應payload 、 extra puncture位置， fully-combined 的結構
New_puncture_position_bits_outfile = "ExtraVNs_EnhancedStrcuture.csv"; % 對應payload 、 extra  enhanced 的結構
Already_PuncVNs = []; % 5G NR payload code 規格已經有puncture的地方 可以填在這
Payload_H = readHFromFileByLine(Payload_file);
Extra_H = readHFromFileByLine(Extra_file);
[Payload_H_r,Payload_H_c] = size(Payload_H);
[Extra_H_r,Extra_H_c] = size(Extra_H);
Non_select_VNs = 1:Payload_H_c;
Payload_punc_bits_num = Extra_H_c * 2 ; % 總在payload 上面puncture的數量

punc_pos_bits = Rate_Compatible_Punctured_With_Short_Block_Lengths(Payload_H,Payload_punc_bits_num,Already_PuncVNs); % start idx = 1
if length(punc_pos_bits)~=length(unique(punc_pos_bits))
    fprintf('Not unique\n'); % 簡單檢查puncture 算法找出來的是否剛好數量
end
%% check  punc_pos_bits 是否都是 1-SR
for Punc_VN=punc_pos_bits 
    Punc_SCNs = transpose(find(Payload_H(:,Punc_VN)==1));
    SCNs_num = 0;
    for SCN=Punc_SCNs
        Nei_SCN_VNs = setdiff(find(Payload_H(SCN,:)==1),Punc_VN);
        if ~any(ismember(punc_pos_bits,Nei_SCN_VNs))
            SCNs_num  = SCNs_num + 1;
        end
    end
    if SCNs_num==0
        disp("find no 1-SR punc vn !!\n");
    end
end
%%
% 把找到的punc bits 分成 Payload+Extra(fully-combined)、 enhanced
punc_pos_bits_fully_combined      =  punc_pos_bits(1:Extra_H_c); % full-combined
punc_pos_bits_Enhanced =  punc_pos_bits(Extra_H_c+1:end); % enhanced
Non_select_VNs = setdiff(Non_select_VNs,punc_pos_bits);
%% 找跟 payload 連接的 bits(不需要被punc) 但不能跟enhanced中被puncture vn 相鄰(避免short cycle)
punc_pos_bits_enhanced_nonpunc = []; % 在 New Structure 中 跟Extra 做第一次疊加的 VNs
for r=1:Extra_H_c
    Punc_VN = punc_pos_bits_Enhanced(r);
    while true
        idx = randi(numel(Non_select_VNs));    % 在 1 到 arr 元素總數間隨機選一個整數
        choose_VN = Non_select_VNs(idx);   % 用線性索引取出該元素
        Nei_CN = transpose(find(Payload_H(:,Punc_VN)==1));
        Nei_CN_VNs_set = [];
        for CN=Nei_CN
            Nei_CN_VNs = find(Payload_H(CN,:)==1);
            Nei_CN_VNs_set = union(Nei_CN_VNs_set,Nei_CN_VNs);
        end
        if any(ismember(Nei_CN_VNs_set,choose_VN))
            continue;
        else
            punc_pos_bits_enhanced_nonpunc(end+1) = choose_VN;
            Non_select_VNs = setdiff(Non_select_VNs,choose_VN);
            break;
        end
    end
end
%% define 各個連接的矩陣
FC_payload_mat = zeros([Extra_H_c,Payload_H_c]);
for r=1:Extra_H_c
    punc_vn = punc_pos_bits_fully_combined(r);
    FC_payload_mat(r,punc_vn) = 1;
end

Enhanced_payload_mat_1 = zeros([Extra_H_c,Payload_H_c]);
for r=1:Extra_H_c
    punc_vn = punc_pos_bits_enhanced_nonpunc(r);
    Enhanced_payload_mat_1(r,punc_vn) = 1;
end

Enhanced_payload_mat_2 = zeros([Extra_H_c,Payload_H_c]);
for r=1:Extra_H_c
    punc_vn = punc_pos_bits_Enhanced(r);
    Enhanced_payload_mat_2(r,punc_vn) = 1;
end


%% 用enhanced方式合併矩陣
% H_combine = [  Payload_H        zero1       zero1            zero1   zero1 
%               zero2        Extra_H       zero3             zero3   zero3 
%                FC_p        I          I               zero4   zero4
%               Enhanced1    I        zero4              I      zero4
%               Enhanced2  zero       zero              I       I      
%             ]
I = eye(Extra_H_c);
zero1 = zeros([Payload_H_r Extra_H_c]);
zero2 = zeros([Extra_H_r Payload_H_c]);
zero3 = zeros([Extra_H_r Extra_H_c]);
zero4 = zeros([Extra_H_c Extra_H_c]);
H_combine = [  
                Payload_H ,                     zero1 , zero1 , zero1 , zero1;
                zero2 ,                  Extra_H    , zero3 , zero3 , zero3;
                FC_payload_mat ,         I     ,  I    , zero4 , zero4;
                Enhanced_payload_mat_1 , I     , zero4 ,     I , zero4;
                Enhanced_payload_mat_2 , zero4 , zero4 ,     I , I;
            
            ];

%% 輸出檔案
writePCM(H_combine,H_combine_file); % write H_combine to PCM 

% write payload data with puncture bits position with Superposition
T = table([1:Extra_H_c].',punc_pos_bits_fully_combined.','VariableNames', {'Extra_VNs', 'Payload_VNs'});  % 建立 table
writetable(T, puncture_position_bits_outfile);  % 輸出 csv

% write payload data with NonTransmit Extra bits puncture bits position with NewStructure 
T = table([1:Extra_H_c].',punc_pos_bits_enhanced_nonpunc.',punc_pos_bits_Enhanced.','VariableNames', {'Extra bits','Payloadb_NonPunc(b)', 'Payloadc_Punc(c)'});  % 建立 table
writetable(T, New_puncture_position_bits_outfile);  % 輸出 csv



