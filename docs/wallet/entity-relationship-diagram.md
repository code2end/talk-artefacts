# Wallet Service Entity Relationship Diagram

```mermaid
classDiagram
    class Member {
        +Long id
        +String username
        +String password
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
        +String superPartner
        +int transactions
        +BankInfo bankInfo
        +Alipay alipay
        +WechatPay wechatPay
        +int appealTimes
        +int appealSuccessTimes
        +Long inviterId
        +String promotionCode
        +Country country
        +RealNameStatus realNameStatus
        +CertifiedBusinessStatus certifiedBusinessStatus
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
        +int accountType
    }

    class WithdrawRecord {
        +Long id
        +Long memberId
        +Coin coin
        +BigDecimal totalAmount
        +BigDecimal arriveAmount
        +BigDecimal fee
        +String address
        +String txid
        +WithdrawStatus status
        +Date createTime
        +Date dealTime
        +String remark
    }

    class RewardRecord {
        +Long id
        +Member member
        +Coin coin
        +BigDecimal amount
        +RewardRecordType type
        +String remark
        +Date createTime
    }

    class MemberTransaction {
        +Long id
        +Long memberId
        +BigDecimal amount
        +TransactionType type
        +String symbol
        +BigDecimal fee
        +String discountFee
        +String realFee
        +Date createTime
    }

    class RewardActivitySetting {
        +Long id
        +ActivityRewardType type
        +Coin coin
        +String info
        +CommonStatus status
        +Date createTime
        +Date updateTime
    }

    class Location {
        +String country
        +String province
        +String city
        +String district
    }

    class BankInfo {
        +String bank
        +String branch
        +String cardNo
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

    class Country {
        +String zhName
        +String enName
        +String areaCode
        +String language
        +String localCurrency
    }

    %% Primary Relationships
    Member "1" *-- "many" MemberWallet : owns
    Coin "1" *-- "many" MemberWallet : supports
    Member "1" *-- "many" WithdrawRecord : initiates
    Coin "1" *-- "many" WithdrawRecord : withdrawal_currency
    Member "1" *-- "many" RewardRecord : receives
    Coin "1" *-- "many" RewardRecord : reward_currency
    Member "1" *-- "many" MemberTransaction : performs
    
    %% Configuration Relationships
    Coin "1" *-- "many" RewardActivitySetting : reward_config
    
    %% Embedded Objects
    Member "1" *-- "1" Location : has_location
    Member "1" *-- "1" BankInfo : has_bank_info
    Member "1" *-- "1" Alipay : has_alipay
    Member "1" *-- "1" WechatPay : has_wechat
    Member "1" --> "1" Country : belongs_to
    
    %% Referral Relationship
    Member "1" --> "many" Member : refers
```

## Entity Relationship Description

This class diagram illustrates the key entities in the Wallet Service and their relationships:

### 1. Core Entities

#### **Member**
- Central user entity representing registered exchange users
- Contains comprehensive profile information, KYC status, and referral data
- Primary key for all user-related operations

#### **MemberWallet** 
- Junction entity connecting Members to Coins
- Stores balance information (available, frozen, pending release)
- Contains blockchain addresses and wallet-specific configuration
- Uses optimistic locking (version field) for concurrent balance updates
- Unique constraint on (memberId, coin_id) ensures one wallet per member-coin pair

#### **Coin**
- Configuration entity for supported cryptocurrencies
- Defines operational parameters (fees, limits, capabilities)
- Controls RPC integration and automatic processing features
- Primary key is the full coin name, with unit as the symbol

### 2. Key Relationships

#### **Member ↔ MemberWallet (1:many)**
- Each member can have multiple wallets (one per supported cryptocurrency)
- Wallet creation triggered by member registration events
- Cascade operations maintain referential integrity

#### **Coin ↔ MemberWallet (1:many)**
- Each coin can be held in multiple member wallets
- Coin configuration determines wallet capabilities
- New coin activation creates wallets for all existing members

#### **Member ↔ WithdrawRecord (1:many)**
- Complete audit trail of withdrawal requests per member
- Links to specific coin being withdrawn
- Status tracking through withdrawal processing pipeline

#### **Member ↔ RewardRecord (1:many)**
- Tracks all rewards issued to members
- Different reward types (registration, activity, referral)
- Links reward to specific cryptocurrency

#### **Member ↔ MemberTransaction (1:many)**
- Comprehensive audit trail of all balance changes
- Links to transaction type and affected cryptocurrency
- Financial compliance and reporting support

### 3. Embedded Objects

#### **Location, BankInfo, Alipay, WechatPay**
- Embedded value objects within Member entity
- Support various payment methods and geographical data
- Not separate database tables but structured data within Member

#### **Country**
- Reference data entity for geographical organization
- Supports multi-currency and localization features

### 4. Status Enumerations

#### **CommonStatus**: NORMAL, ILLEGAL
- General status indicator for entities

#### **WithdrawStatus**: PROCESSING, SUCCESS, FAILED, WAITING
- Withdrawal processing state machine

#### **TransactionType**: RECHARGE, WITHDRAW, TRANSFER_ACCOUNTS, ACTIVITY_AWARD, PROMOTION_AWARD, DIVIDEND
- Categorizes different types of balance changes

#### **BooleanEnum**: IS_FALSE (0), IS_TRUE (1)
- Standardized boolean representation across the platform

#### **RewardRecordType**: ACTIVITY, PROMOTION, DIVIDEND
- Categories of rewards that can be issued

#### **ActivityRewardType**: REGISTER
- Specific activity types that trigger rewards

### 5. Processing Flow Relationships

1. **Member Registration Flow**:
   ```
   Member → MemberWallet (created for all Coins) → RewardRecord (if applicable) → MemberTransaction (audit)
   ```

2. **Deposit Processing Flow**:
   ```
   Blockchain Event → MemberWallet (balance update) → MemberTransaction (audit record)
   ```

3. **Withdrawal Processing Flow**:
   ```
   WithdrawRecord (created) → MemberWallet (frozen balance) → Blockchain RPC → WithdrawRecord (status update) → MemberTransaction (audit)
   ```

### 6. Data Integrity Features

- **Unique Constraints**: MemberWallet prevents duplicate wallets per member-coin
- **Optimistic Locking**: MemberWallet version field prevents concurrent updates
- **Foreign Key Relationships**: Maintain referential integrity across entities
- **Cascade Operations**: Ensure related data consistency during updates
- **Audit Trails**: MemberTransaction provides complete financial audit capability

This diagram represents the actual data model relationships implemented in the Bizzan Wallet Service codebase and demonstrates how financial operations are tracked and managed within the cryptocurrency exchange platform.
