# 實作

課程提供的 aes 專案位於目錄 aes/。aes 依賴 OP-TEE 的專案，並且 OP-TEE 路徑與 aes/Makefile 相符。專案的結構如下：

- aes/
    - host/：CA 的目錄
        - Makefile：不能直接使用
        - main.c：CA 程式，需要同學修改
    - ta/：TA 的目錄
        - Makefile：不能直接使用
        - aes_ta.c：TA 程式，需要同學修改
        - ...
    - Makefile：生成或清除 aes 專案的目標檔案
    - ...

程式修改完以後，可以在 qemu 內執行測試。首先使用生成目標檔案
```shell
# 在 aes/
$ make
```

然後將檔案放到 buildroot 對應的路徑

```shell
# 在 aes/
$ make install
```

重新執行 buildroot 的建置再啟動 qemu

```shell
# 在 optee/build/
$ make run
```
