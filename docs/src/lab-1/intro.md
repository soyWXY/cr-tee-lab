# 系統簡介

<img width="890" height="574" alt="image" src="https://github.com/user-attachments/assets/2e80f0ee-8f9d-4af3-95db-c32f9683e51b" />

圖一：ARM v8 系統設計

在圖一展示的 ARM 系統中，橘底的方形標示出傳統系統的部分。隨著 non-secure OS（又稱 rich OS）的功能增強，漏洞也隨之增加。一旦rich OS（ROS）遭攻破，攻擊者便可操控所有分配給 ROS 記憶體與周邊設備，威脅所有程式的機密性與完整性。*信任執行環境*（TEE）為了解決此問題，確保系統安全，在系統中加入 TrustZone 的硬體進行隔離，並且為了避免攻擊面擴大，只有重視安全的服務會被分配到 Secure 的環境，其他的功能仍然是透過 ROS 完成。

<img width="859" height="603" alt="image" src="https://github.com/user-attachments/assets/257d6688-c667-4e8a-8d00-6038251fda74" />

圖二：OP-TEE 系統設計

OP-TEE 是個基於上述概念實作的專案。在這個環境下，應用開發將分為非安全的 client app（CA）和安全的 trusted app（TA）兩部分。 CA 可以使用 ROS 系統呼叫提供一般功能，另外，可以透過 TEE 客戶端 API 與 TEE 交互；TA 則會使用 TEE 內部 API，處理敏感數據與安全操作，如加密、認證等。
