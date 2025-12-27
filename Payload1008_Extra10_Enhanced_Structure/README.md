# Puncture LDPC
在 `PEGReg504x1008` PayLoad LDPC Code 上面疊加 `H_10_5` Extra LDPC Code 做傳輸。把兩個 `PCM` 合併起來形成一個新的 `PCM` 把疊加的位置給 puncture ，且在`Payload`和`Extra`新增一些連結，讓`Payload`和`Extra`不再像是兩個分開的子圖，而是整合成一個大的`Code`，大的`Code`中一部分是`Payload`/一部分是`Extra`，`Decoding`一樣是透過`BP`。

當 `iteration` 小於 `iteration_limit` 且 `PayLoad_syndrome` 非全零的時候，訊息只在`PayLoad`裡面做傳遞(不會傳送進`Extra`裡面)。

Puncture method 採用 k-SR 的概念去做 。

## 檔案

- `PCM_P1008_E10_EnhanceStruc.txt` : 合併的`PCM`檔案
- `Table_FullyCombine_Extra_Payload.csv` : `Puncture` 的 `VN Node(fully-combined)` (start idx = 1)
- `ExtraVNs_EnhancedStrcuture.csv` : 新的結構中，所連接到的 `Payload bits`(`Enhanced` 結構) (start idx = 1)


## 執行程式
可以使用 `Ubuntu` 執行 `makefile`

Linux:
```
make BP
```
