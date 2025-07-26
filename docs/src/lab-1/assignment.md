# 作業說明

本次lab的作業分成實作跟回答問題兩個部份。

繳交時請把實作執行的部份截圖並說明，連同回答問題的部份打成一個PDF，上傳到eeclass。

檔名格式請按照: `HW1_<學號>`。e.g. `HW1_113062595`。

## 1. 操作說明

課程提供的 aes 專案位於目錄`~/aes`。aes 依賴於前面我們編譯完的 OP-TEE 專案，並且 OP-TEE 路徑與 aes 專案中的Makefile記錄的路徑需相符，否則會無法編譯 aes 專案。
<img alt="image" src="https://github.com/user-attachments/assets/bb05310f-178e-4ff0-bbf5-d32b41fcebe4" />

aes 專案的結構如下：

- host/：CA 的目錄
    - Makefile：不能直接使用
    - main.c：CA 程式，需要同學修改
- ta/：TA 的目錄
    - Makefile：不能直接使用
    - aes_ta.c：TA 程式，需要同學修改
    - ...
- Makefile：生成或清除 aes 專案的目標檔案
- ...

### a. 實作目標
參考`ta/include/aes_ta.h`的檔案內容。e.g.  
<img alt="image" src="https://github.com/user-attachments/assets/b3070c56-31d8-4fea-bcce-e54cfdee0ba3" />

並完成`host/main.c`, `ta/aes_ta.c`中指定的TODO修改。

### b. 測試
程式修改完以後，可以在 qemu 內執行測試。首先使用生成目標檔案
```shell
# 在aes專案目錄下
$ make
```

然後將檔案放到 buildroot 對應的路徑

```shell
# 在aes專案目錄下
$ make install
```

重新執行 buildroot 的建置再啟動 qemu

```shell
# 在 optee/build/
$ make run
```

在Normal World中登入之後，應該就會出現下列指令可以使用來測試我們修改完的 aes 專案:
```shell
$ optee_example_aes
```

## 2. 回答問題
- 說明 aes 程式修改的部分
- 說明 aes CA 程式流程
- key/op handle api 流程？程式內對應呼叫的地方？
- TA_InvokeCommandEntryPoint 最多能傳入幾個 32 bit 的參數？
- CA 和 TA 的共享記憶體應該屬於安全還是非安全的記憶體？
