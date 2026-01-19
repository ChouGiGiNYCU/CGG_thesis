# Time counting
去跑平均解成功一次需要多少時間。 可以把 `H_combine` 後那些檔案(`.txt` 、 `.csv`)放置此資料夾裡面去測時間。


## 檔案
- `CBP_punc_PayLoad_Extra.cpp` : 去跑平均解成功一次需要多少時間。
- `PCM_P1008_E15BCH_1SR.txt` : 合併過後 `Enhanced` 矩陣
- `Pos_PCM_P1008_E15BCH_1SR.txt` : `Puncture` 的 `VN Node(fully-combined)` 位置 (start idx = 1)
- `random_number_generator.h` : `Gaussian noise` 產生
- `UseFuction.h` : 一些有用到的 `function`
- `makefile` : 一些 `code` 執行所需要參數、讀取的一些 `file` 

## 執行程式
可以使用 `Ubuntu` 執行 `makefile`

Linux:
```
make BP
```
