# 簡介

> OP-TEE 文件：[REE Filesystem TA](https://optee.readthedocs.io/en/latest/architecture/trusted_applications.html#ree-filesystem-ta)

TEE 的系統其實需仰賴 TEE 和 REE 協作來運行，舉例來說，物件可以存放在 REE 檔案系統，但在需要信任的情況下，藉由簽名和加密的方式，保證物件的機密性和完整性，確保 TEE 獲取的資源都是可信任。

實際上，其中一種 TA ---- REE Filesystem TA（REE FS TA）就是將 TA 儲存在REE 檔案系統上。 TA 以 `<UUID>.ta` 名稱儲存在 REE 的磁碟上，例如 Linux 檔案系統，檔案內容包含 ELF 檔、簽名，並且可以選擇對其加密。這比將 TA 燒錄在 secure flash（如 RPMB 或 secure storage）要靈活許多，特別適合開發階段使用。

## REE FS TA 格式

共分為以下三種格式：

- Legacy TA：簽章、不加密。自 OP-TEE 3.7.0 起已不支援自動產生
    ```c
    hash = H(<struct shdr> || <stripped ELF>)
    signature = RSA-Sign(hash)
    legacy_binary = <struct shdr> || <hash> || <signature> || <stripped ELF>
    ```
- Bootstrap TA：簽章、不加密
    ```c
    hash = H(<struct shdr> || <struct shdr_bootstrap_ta> || <stripped ELF>)
    signature = RSA-Sign(<hash>)
    bootstrap_binary = <struct shdr> || <hash> || <signature> ||
                       <struct shdr_bootstrap_ta> || <stripped ELF>
    ```
- Encrypted TA：先進行簽章、加密，再做 MAC 驗證
    ```c
    nonce = <unique random value>
    ciphertext, tag = AES_GCM(<stripped ELF>)
    hash = H(<struct shdr> || <struct shdr_bootstrap_ta> ||
             <struct shdr_encrypted_ta> || <nonce> || <tag> || <stripped ELF>)
    signature = RSA-Sign(<hash>)
    encrypted_binary = <struct shdr> || <hash> || <signature> ||
                       <struct shdr_bootstrap_ta> ||
                       <struct shdr_encrypted_ta> || <nonce> || <tag> ||
                       <ciphertext>
    ```
