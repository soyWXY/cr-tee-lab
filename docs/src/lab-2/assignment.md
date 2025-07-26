# 作業說明

本次lab的作業分成實作跟回答問題兩個部份。

繳交時請把實作執行的部份截圖並說明，連同回答問題的部份打成一個PDF，上傳到eeclass。

檔名格式請按照: `HW2_<學號>`。e.g. `HW2_113062595`。

## 實作
- 使用下方的 UUID 修改 LAB 1 的 aes 專案，並根據[簽署操作流程](ta-signing.md)再次生成 `.ta` (需逐步截圖)。
- 私鑰使用 default_ta.pem，因此 OP-TEE OS 可以不用重新編譯

    ```
    // 修改~/aes/ta/Makefile中的BINARY (檔名)
    aed564f1-960e-4117-8bb4-417b4e79c130

    // 在~/aes/ta/user_ta_header_defines.h中修改TA_UUID (寫入ELF的UUID)
    #define TA_UUID
        { 0xaed564f1, 0x960e, 0x4117, \
            { 0x8b, 0xb4, 0x41, 0x7b, 0x4e, 0x79, 0xc1, 0x30} }

    ```

    紀錄以下兩個命令的輸出結果

```shell
$ sign_encrypt.py display --in <.ta>
$ sign_encrypt.py verify --uuid <uuid> --in <.ta> --key <default_ta.pem>
```


## 問題
- 參考 [1](https://optee.readthedocs.io/en/latest/architecture/trusted_applications.html#verifying-with-subkeys)、[2](https://optee.readthedocs.io/en/latest/architecture/subkeys.html#subkeys) 說明 subkeys 機制、流程
