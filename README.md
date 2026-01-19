##  CGG_thesis


## Free-Ride 架構
目前都提供  `Payload(1008,504)` 搭配 `H(10,5)` ， 如果需跑 `Extra-BCH(15,7)` 或者改成其它 `Payload`，需更改 `H_combine/H_combine.m file` 裡面造`code`設定，和 `makefile` 設定。

## Folder 大綱
- `Payload1008_Extra10_fullycombined\*` : 採用 `Payload(1008,504)` 搭配 `H(10,5)` 去跑 `fully-combined` 架構。
- `Payload1008_Extra10_fullycombined_Partial\*` : 採用 `Payload(1008,504)` 搭配 `H(10,5)` 去跑 `fully-combined & Partial` 架構。
- `Payload1008_Extra10_Enhanced\*` : 採用 `Payload(1008,504)` 搭配 `H(10,5)` 去跑 `Enhanced` 架構。
- `Payload1008_Extra10_Enhanced_Partial` : 採用 `Payload(1008,504)` 搭配 `H(10,5)` 去跑 `Enhanced & Partial` 架構。
- `Original_Free-Ride/SDD_SameG_InterLeaver` : 原本 `Free-Ride` 採用`soft decsion decoding` 且用 `maximun likihood` 方法去解碼。
- `PCM` : 有用到過的 `PCM`
- `GM`  : 有用到過的`PCM`所對應的`GM`