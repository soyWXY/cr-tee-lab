# 應用開發

<img alt="image" src="https://github.com/user-attachments/assets/658dcbd0-3a11-495d-af72-84d4922e3894" />

圖三：TEE 交互

CA 和 TA 的通訊會依序使用圖三列出的 api，由 CA 主動呼叫，最終調用 TA 對應的函式。

- TEEC_InitializaContext/TA_CreateEntryPoint：TOS 對 TA 進行驗證，然後動態將執行檔載入記憶體
- TEEC_OpenSession/TA_OpenSessionEntryPoint：CA 和 TA 以 session 的形式建立溝通，此步驟進行登入、驗證
- TEEC_InvokeCommand/TA_InvokeCommandEntryPoint：使用 TA 提供的各項功能，可能重複多次
    ```c
    TEEC_Result TEEC_InvokeCommand(
            TEEC_Session*    session,
            uint32_t         commandID,
            TEEC_Operation*  operation,
            uint32_t*        returnOrigin)
    ```
    更進一步解釋，TA 會根據 `commandID` 判斷 CA 請求的服務，實際的參數則透過 `operation` 傳遞
- 其他負責完成執行以後，清理的部分

## 傳遞參數
```c
typedef union {
    TEEC_TempMemoryReference        tmpref;
    TEEC_RegisteredMemoryReference  memref;
    TEEC_Value                      value;
} TEEC_Parameter;

typedef struct {
    uint32_t            started;
    uint32_t            paramTypes;
    TEEC_Parameter      params[4];
    <Implementation-Defined Type> imp;
} TEEC_Operation;
```

總共可以傳遞四個參數，每個 `TEEC_Parameter` 參數可能代表 `TEEC_TempMemoryReference`、`TEEC_RegisteredMemoryReference` 或 `TEEC_Value` 的其中之一。

- `TEEC_RegisteredMemoryReference`：使用 api 申請或註冊的記憶體，作業不會用到
- `TEEC_TempMemoryReference`：不用 api 申請或註冊，CA 中的任意一塊記憶體
- `TEEC_Value`：小的資料，例如 `uint32_t`

在 `TEEC_Operation` 中，另一個重要的成員就是 `paramTypes`，type 除了上面三種分類，另外還會依據輸入輸出分類，總共有以下九類

- TEEC_RegisteredMemoryReference
    | Parameter Type            | Field to use |
    |---------------------------|--------------|
    | TEEC_MEMREF_WHOLE_INPUT   | memref       |
    | TEEC_MEMREF_PARTIAL_OUTPUT| memref       |
    | TEEC_MEMREF_PARTIAL_INOUT | memref       |

- TEEC_TempMemoryReference
    | Parameter Type           | Field to use |
    |--------------------------|--------------|
    | TEEC_MEMREF_TEMP_INPUT   | tmpref       |
    | TEEC_MEMREF_TEMP_OUTPUT  | tmpref       |
    | TEEC_MEMREF_TEMP_INOUT   | tmpref       |

- TEEC_Value
    | Parameter Type    | Field to use |
    |-------------------|--------------|
    | TEEC_VALUE_INPUT  | value        |
    | TEEC_VALUE_OUTPUT | value        |
    | TEEC_VALUE_INOUT  | value        |
