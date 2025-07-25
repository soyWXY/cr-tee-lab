# 執行OP-TEE系統

專案建置完成後，可以啟動 qemu 運行 OP-TEE

```shell
# 在 ~/optee/build/
$ make run-only
```

如果要新增檔案到虛擬機的檔案系統，需要重新執行 buildroot 的建置再啟動 qemu，命令則要改成：

```shell
# 在 ~/optee/build/
$ make run
```

接著，輸入 `make` 的終端會進入 qemu 的 CLI，並且會生成兩個新的終端機，分別是安全世界（Secure World）和正常世界（Normal World）。qemu CLI 會輸出提示等待用戶反應，用戶輸入 c 後，其他的終端會開始輸出 OP-TEE 開機過程的日誌

```shell
(qemu) c
```

接著在正常世界的終端，可以輸入登入的使用者。完成登入後，就可以執行 OP-TEE 專案包含的測試和範例

```shell
# 測試
$ xtest
```

```shell
# 範例
$ optee_example_hello_world
```
