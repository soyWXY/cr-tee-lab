# TA簽署流程

> OP-TEE 文件：[Signing of TAs](https://optee.readthedocs.io/en/latest/building/trusted_applications.html#signing-of-tas)


所有 REE FS TA 都必須簽章。OP-TEE 的原始碼中，預設包含一把私鑰用於對 TA 簽名，對應的公鑰則會被編進 optee_os 的二進位中。每次載入 TA 時，核心都會用這把公鑰驗證該 TA 的簽章是否合法。

<div class="warning">
    原始碼中預設的私鑰僅適用於開發與測試，產品環境的部署應更換為私人的金鑰
</div>

## 簽署相關元件介紹

在 optee_os 下有底下元件

- keys/default_ta.pem：預設私鑰
- scripts/sign_encrypt.py：用來簽署的腳本。使用說明可以查看

```shell
$ sign_encrypt.py -h
$ sign_encrypt.py <command> -h
```

- ta/mk/ta_dev_kit.mk：cross compile 的 makefile，用來編譯執行在 optee_os 上 TA，會生成 TA 的 `.stripped.elf` 和 `.ta` 檔。

<div class="warning">

ta_dev_kit.mk 雖然會生成 `.ta`，但是簽署的私鑰是採用 default_ta.pem，產品環境需要改以私人金鑰對 `.stripped.elf` 簽署
</div>

## 簽署操作流程

#### 0. 在安全環境中產生 RSA 金鑰（2048 或 4096 bit）並匯出公鑰

```shell
$ openssl genrsa -out <privkey>.pem 2048
$ openssl rsa -in <privkey>.pem -pubout -out <pubkey>.pem
```

#### 1. 編譯 OP-TEE OS 並指定公鑰。沒設定 `TA_PUBLIC_KEY` 的情況會自動生成和使用 default_ta.pem 對應的公鑰

```shell
$ TA_PUBLIC_KEY=<pubkey>.pem make all
```

#### 2. 編譯、生成 TA 的 `.stripped.elf`
#### 3. 設置 UUID 與金鑰變數

```shell
$ export TA_SIGN_KEY=<privkey>.pem
$ export TA_PUBLIC_KEY=<pubkey>.pem
$ export UUID=<uuid>
```

#### 4. 產生 digest

```shell
$ sign_encrypt.py digest --key $TA_PUBLIC_KEY --uuid $UUID \
    --in $UUID.stripped.elf --dig $UUID.dig
```

#### 5. 離線簽署 digest

```shell
$ base64 --decode $UUID.dig | \
    openssl pkeyutl -sign -inkey $TA_SIGN_KEY \
    -pkeyopt digest:sha256 -pkeyopt rsa_padding_mode:pss \
    -pkeyopt rsa_pss_saltlen:digest -pkeyopt rsa_mgf1_md:sha256 | \
    base64 > $UUID.sig
```

#### 6. 合併 TA 與簽章

```shell
$ sign_encrypt.py stitch --key $TA_PUBLIC_KEY --uuid $UUID \
    --in $UUID.stripped.elf --sig $UUID.sig --out $UUID.ta
```
