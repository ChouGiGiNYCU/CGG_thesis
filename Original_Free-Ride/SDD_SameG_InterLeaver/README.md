# FreeRide-LDPC - SDD
在 `PEGReg504x1008` PayLoad LDPC Code 上面疊加 `H_10_5` Extra LDPC Code 做傳輸。透過 `Soft-Decision Decoding` 的方式先解出 `Extra`，再把 `Extra` 的 `Interference` 給去除掉，最後透過 `BP` 把 `PayLoad` 給解回來。

`Extra` 採用 `6 bits` (對比`H(10,5)`)，並且共用 `Payload Generative matrix`(剩餘其他 `info_bits` 為 0)，編碼完後做`InterLeaver` 順序打亂 ，最後在疊加到 `PayLoad CodeWord`上。

----
### Algorithm
![SDD Algorithm](img/SDD_Alg.png)
#### Equation 43 - 45
![SDD Algorithm](img/SDD_equation.png)

Reference : [Free-Ride paper](https://ieeexplore.ieee.org/document/9584875)

---

## 檔案

- `FreeRide_SDD_func.h` : 原本 `free-ride` 採用 `soft decoding + ML`
- `UseFuction.h` : 一些有用到的 `function`
- `random_number_generator.h` : `Gaussian noise` 產生
- `makefile` : 一些 `code` 執行所需要參數、讀取的一些 `file` 
