# Sparse Neural Belief Propagation (NN-BP) for LDPC Decoding (PyTorch)

這個專案用 **PyTorch** 實作一個「**稀疏連接 (sparse / masked) 的 Neural Belief Propagation Decoder**」，把 LDPC 的 BP 訊息傳遞流程展開成固定次數的迭代網路（預設 **20 iterations**），並只在 **Variable Node (VN) update** 引入可訓練參數，同時用 **mask** 強制維持 Tanner graph 的稀疏拓樸（不允許不在 H 中的邊產生連線或被訓練）。

---

## Features

- **Tanner Graph consistent masking**
  - 由 parity-check matrix `H` 建立 `CN2VN` / `VN2CN` 邊集合與 mask。
  - 訓練時對權重梯度與 channel LLR 的注入位置套用 mask，確保拓樸不被破壞。

- **Unrolled BP**
  - 將 BP 的 `CN update -> VN update` 流程展開為固定層數（迭代次數）。
  - 最後輸出每個 bit 的 posterior（sigmoid 機率 / 或可視需求轉 hard decision）。

- **Trainable VN update**
  - VN update 使用 masked linear transform（只在合法連線位置可學習）。
  - 每個 iteration 另有 channel LLR 的可學習 scaling（同樣受 mask 控制）。

- **AWGN simulation + BER/FER evaluation**
  - 支援 AWGN 通道下的模擬、在多個 SNR 下統計 BER/FER，並輸出 CSV。

---

## Repository Structure

- `sparse_bp_model.py`  
  核心模型：CN update layer、VN update layer、Unrolled forward（多次迭代）。

- `function.py`  
  由 `H` 建立 Tanner graph 連線資訊與 mask；也包含測試資料集生成函式。

- `read_PCM_G.py`  
  讀取 parity-check matrix `H`（及可選的 generator matrix `G`）的自訂文字格式解析器。

- `Gaussian_Noise.py`  
  高斯雜訊產生器（AWGN）。

- `mutiloss_BP_train.py`  
  訓練腳本：產生訓練樣本、跑 epoch、計算 loss、在 test set 上評估並存最佳模型。

- `simulation.py`  
  模擬腳本：載入 `.pth`，在多個 SNR 下跑 BER/FER，輸出 CSV 結果。

- `DownLoad_weight.py`  
  將模型權重輸出成 `.txt`（方便觀察或匯入其他環境）。

---

## Requirements

- Python 3.8+
- PyTorch (CPU / CUDA GPU)
- numpy
- matplotlib
- tqdm

Install:
```bash
pip install torch numpy matplotlib tqdm
```


## Quick Start

### 1) Train

打開 `mutiloss_BP_train.py`，並確認或修改以下設定（**至少需要修改 `H_file_name`**）：

- `H_file_name`  
  Parity-check matrix (`H`) 的檔案路徑

- `G_file_name`  
  Generator matrix (`G`) 的檔案路徑（可設為 `None`）

- `Save_model_file_name`  
  訓練完成後儲存的模型檔名（例如 `NNBP_Best.pth`）

- `SNR_MIN`, `SNR_MAX`, `SNT_RATIO`  
  訓練使用的 SNR 範圍設定

- `EPOCHS`, `BATCH_SIZE`, `learning_ratio`  
  訓練超參數設定

#### Run
```bash
python mutiloss_BP_train.py
```


## 2) Evaluate / Simulate (BER / FER)

本步驟用來評估已訓練完成的 NN-BP 模型在 **AWGN 通道**下的解碼效能，並統計 **BER / FER** 隨 SNR 變化的結果。

### Configuration

請先打開 `simulation.py`，並設定以下參數：

- `H_file_name`  
  Parity-check matrix (`H`) 的檔案路徑

- `Load_model_file_name`  
  已訓練完成的模型權重檔（`.pth`）

- `CSV_file_name`  
  模擬結果輸出的 CSV 檔名或路徑

- `SNR_MIN`, `SNR_MAX`, `SNR_RATIO`  
  模擬使用的 SNR 範圍設定

- `Frame_Error_Bound`  
  每個 SNR 點累積到指定數量的 frame errors 後即停止模擬  
  （用於加速高 SNR 區段的模擬）

### Run

```bash
python simulation.py
