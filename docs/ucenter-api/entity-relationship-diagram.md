# ucenter-api Entity Relationship Diagram

```mermaid
classDiagram
    class Member {
        +Long id
        +String username
        +String password
        +String jyPassword
        +String salt
        +String realName
        +String idNumber
        +String email
        +String mobilePhone
        +Location location
        +MemberLevelEnum memberLevel
        +CommonStatus status
        +Date registrationTime
        +Date lastLoginTime
        +String token
        +Date tokenExpireTime
        +String superPartner
        +int transactions
        +BankInfo bankInfo
        +Alipay alipay
        +WechatPay wechatPay
        +int appealTimes
        +int appealSuccessTimes
        +Long inviterId
        +String promotionCode
        +int firstLevel
        +int secondLevel
        +int thirdLevel
        +Country country
        +RealNameStatus realNameStatus
        +int loginCount
        +CertifiedBusinessStatus certifiedBusinessStatus
        +Date certifiedBusinessApplyTime
        +Date applicationTime
        +Date certifiedBusinessCheckTime
        +String avatar
        +BooleanEnum publishAdvertise
        +BooleanEnum transactionStatus
        +Boolean signInAbility
    }

    class MemberWallet {
        +Long id
        +Long memberId
        +Coin coin
        +BigDecimal balance
        +BigDecimal frozenBalance
        +BigDecimal toReleased
        +String address
        +int version
        +BooleanEnum isLock
        +String memo
    }

    class Coin {
        +String name
        +String nameCn
        +String unit
        +CommonStatus status
        +double minTxFee
        +double maxTxFee
        +double cnyRate
        +double usdRate
        +BooleanEnum enableRpc
        +int sort
        +BooleanEnum canWithdraw
        +BooleanEnum canRecharge
        +BooleanEnum canTransfer
        +BooleanEnum canAutoWithdraw
        +BigDecimal withdrawThreshold
        +BigDecimal minWithdrawAmount
        +BigDecimal maxWithdrawAmount
        +BigDecimal minRechargeAmount
        +BooleanEnum isPlatformCoin
        +Boolean hasLegal
        +String coldWalletAddress
        +BigDecimal minerFee
        +int withdrawScale
        +String infolink
        +String information
        +int accountType
        +String depositAddress
    }

    class MemberTransaction {
        +Long id
        +Long memberId
        +BigDecimal amount
        +Date createTime
        +TransactionType type
        +String symbol
        +String address
        +BigDecimal fee
        +int flag
        +String realFee
        +String discountFee
    }

    class WithdrawRecord {
        +Long id
        +Long memberId
        +Coin coin
        +BigDecimal totalAmount
        +BigDecimal fee
        +BigDecimal arrivedAmount
        +Date createTime
        +Date dealTime
        +WithdrawStatus status
        +BooleanEnum isAuto
        +Admin admin
        +BooleanEnum canAutoWithdraw
        +String transactionNumber
        +String address
        +String remark
    }

    class PromotionCard {
        +Long id
        +Long memberId
        +int isEnabled
        +String cardName
        +String cardNo
        +String cardDesc
        +Coin coin
        +int count
        +int exchangeCount
        +BigDecimal amount
        +BigDecimal totalAmount
        +int isFree
        +int isLock
        +int lockDays
        +Date createTime
    }

    class MemberAddress {
        +Long id
        +Long memberId
        +String address
        +String remark
        +String unit
        +Date createTime
        +CommonStatus status
    }

    class Country {
        +String zhName
        +String enName
        +String areaCode
        +String language
        +String localCurrency
    }

    class Location {
        +String country
        +String province
        +String city
        +String district
    }

    class BankInfo {
        +String bankName
        +String bankAccount
        +String branch
        +String realName
    }

    class Alipay {
        +String aliNo
        +String qrCodeUrl
    }

    class WechatPay {
        +String wechat
        +String qrCodeUrl
    }

    class Admin {
        +Long id
        +String username
        +String password
        +Date lastLoginTime
        +String roleId
        +CommonStatus status
    }

    %% Relationships
    Member "1" *-- "many" MemberWallet : owns
    Member "1" *-- "many" MemberTransaction : has
    Member "1" *-- "many" WithdrawRecord : requests
    Member "1" *-- "many" PromotionCard : creates
    Member "1" *-- "many" MemberAddress : maintains
    Member "many" --> "1" Country : belongs_to
    Member "1" *-- "1" Location : has
    Member "1" *-- "1" BankInfo : has
    Member "1" *-- "1" Alipay : has
    Member "1" *-- "1" WechatPay : has
    Member "many" --> "1" Member : refers (inviterId)
    
    MemberWallet "many" --> "1" Coin : denominated_in
    WithdrawRecord "many" --> "1" Coin : withdraws
    WithdrawRecord "many" --> "1" Admin : processed_by
    PromotionCard "many" --> "1" Coin : denominated_in
    
    Coin "1" *-- "many" MemberWallet : used_in
    Coin "1" *-- "many" WithdrawRecord : withdrawn
    Coin "1" *-- "many" PromotionCard : rewards
```

## Entity Relationship Description

This class diagram illustrates the key entities in the ucenter-api and their relationships:

### 1. Core Entities

- **Member**: Central entity representing registered users with comprehensive profile information, authentication credentials, and account status
- **MemberWallet**: Individual cryptocurrency wallets owned by members, with balance tracking and transaction capabilities
- **Coin**: Cryptocurrency configuration entity defining supported digital assets, withdrawal limits, and operational parameters
- **MemberTransaction**: Financial transaction log recording all user account activities (deposits, withdrawals, transfers)
- **WithdrawRecord**: Withdrawal request tracking with approval workflow and compliance verification
- **PromotionCard**: Promotional campaign management for referral rewards and marketing activities

### 2. Key Relationships

- **Member to MemberWallet** (1:N): Each user can have multiple wallets, one for each supported cryptocurrency
- **Member to MemberTransaction** (1:N): Complete audit trail of all user financial activities
- **Member to WithdrawRecord** (1:N): Withdrawal request history with approval status tracking
- **Member to PromotionCard** (1:N): User-created promotional campaigns and referral cards
- **Member to MemberAddress** (1:N): Whitelisted withdrawal addresses for enhanced security
- **Member Self-Reference** (N:1): Referral hierarchy through `inviterId` field creating multi-level marketing structure
- **MemberWallet to Coin** (N:1): Each wallet is denominated in a specific cryptocurrency
- **WithdrawRecord to Coin** (N:1): Withdrawal requests specify the cryptocurrency type
- **WithdrawRecord to Admin** (N:1): Administrative approval workflow for manual withdrawal processing

### 3. Embedded Objects

- **Location**: Geographic information embedded in Member entity for compliance and localization
- **BankInfo**: Traditional banking details for fiat currency operations
- **Alipay**: Chinese payment system integration for local market support
- **WechatPay**: WeChat payment system integration for Chinese users

### 4. Supporting Entities

- **Country**: Reference data for supported countries and regional settings
- **Admin**: Administrative users who process withdrawal requests and manage system operations
- **MemberAddress**: Withdrawal address whitelist for security and compliance

### 5. Status Enumerations

- **MemberLevelEnum**: User verification levels (GENERAL, REALNAME, AUTHENTICATED)
- **CommonStatus**: Generic status indicator (NORMAL, ILLEGAL) used across multiple entities
- **RealNameStatus**: KYC verification status (NOT_CERTIFIED, AUDITING, CERTIFIED, CANCEL)
- **WithdrawStatus**: Withdrawal processing states (PROCESSING, WAITING, SUCCESS, FAIL, CANCELLED)
- **TransactionType**: Categories of financial transactions (RECHARGE, WITHDRAW, TRANSFER_ACCOUNTS, etc.)
- **BooleanEnum**: Type-safe boolean representation (IS_FALSE, IS_TRUE)

### 6. Design Patterns

- **Unique Constraints**: Composite unique constraint on (memberId, coin_id) for MemberWallet ensures one wallet per coin per user
- **Optimistic Locking**: Version field in MemberWallet prevents concurrent modification conflicts
- **Audit Trail**: Comprehensive transaction logging with timestamps and transaction types
- **Soft Delete**: Status fields allow logical deletion while preserving audit history
- **Referential Integrity**: Foreign key relationships maintain data consistency across related entities

This diagram provides a visual representation of the actual data model relationships in the ucenter-api codebase, showing how user accounts, financial operations, promotional systems, and administrative processes are interconnected within the cryptocurrency exchange platform.
