# Cryptocurrency Exchange Core - Entity Relationship Diagram

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
        +int withdrawScale
        +String infolink
        +String information
        +int accountType
        +String depositAddress
    }

    class Order {
        +Long id
        +String orderSn
        +AdvertiseType advertiseType
        +Date createTime
        +Long memberId
        +String memberName
        +String memberRealName
        +Long customerId
        +String customerName
        +String customerRealName
        +OtcCoin coin
        +BigDecimal price
        +BigDecimal maxLimit
        +BigDecimal minLimit
        +String country
        +String remark
        +Integer timeLimit
        +BigDecimal money
        +BigDecimal number
        +BigDecimal commission
        +OrderStatus status
        +Date payTime
        +String payMode
        +Long advertiseId
        +Date cancelTime
        +Date releaseTime
        +Alipay alipay
        +BankInfo bankInfo
        +WechatPay wechatPay
        +Long version
    }

    class Advertise {
        +Long id
        +BigDecimal price
        +AdvertiseType advertiseType
        +Member member
        +Date createTime
        +Date updateTime
        +OtcCoin coin
        +Country country
        +BigDecimal minLimit
        +BigDecimal maxLimit
        +String remark
        +Integer timeLimit
        +BigDecimal premiseRate
        +AdvertiseLevel level
        +String payMode
        +Long version
        +AdvertiseControlStatus status
        +PriceType priceType
        +BigDecimal number
        +BigDecimal dealAmount
        +BigDecimal remainAmount
        +BooleanEnum auto
        +BigDecimal marketPrice
        +String autoword
    }

    class OtcCoin {
        +Long id
        +String name
        +String nameCn
        +String unit
        +CommonStatus status
        +BigDecimal jyRate
        +BigDecimal sellMinAmount
        +BigDecimal buyMinAmount
        +int sort
        +BooleanEnum isPlatformCoin
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
        +String comment
        +BigDecimal realFee
        +BigDecimal discountFee
    }

    class Country {
        +String zhName
        +String enName
        +String areaCode
        +String language
        +String localCurrency
        +int sort
    }

    class Location {
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

    %% Relationships
    Member "1" *-- "many" MemberWallet : owns
    Member "1" *-- "many" Order : creates_as_advertiser
    Member "1" *-- "many" Order : participates_as_customer
    Member "1" *-- "many" Advertise : creates
    Member "1" *-- "many" MemberTransaction : has_transactions
    Member "many" --> "1" Country : resides_in
    Member "1" *-- "1" Location : has_location
    Member "1" *-- "1" BankInfo : has_bank_info
    Member "1" *-- "1" Alipay : has_alipay
    Member "1" *-- "1" WechatPay : has_wechat_pay

    MemberWallet "many" --> "1" Coin : holds
    
    Order "many" --> "1" OtcCoin : trades
    Order "many" --> "1" Advertise : originates_from
    Order "1" *-- "1" Alipay : payment_via_alipay
    Order "1" *-- "1" BankInfo : payment_via_bank
    Order "1" *-- "1" WechatPay : payment_via_wechat
    
    Advertise "many" --> "1" OtcCoin : offers
    Advertise "many" --> "1" Country : restricted_to
    Advertise "1" --> "many" Order : generates

    MemberTransaction "many" --> "1" Member : belongs_to
```

## Entity Relationship Description

This class diagram illustrates the key entities in the Cryptocurrency Exchange Core module and their relationships:

### 1. Core Entities

- **Member**: Central user entity representing exchange participants with comprehensive profile information, KYC status, and trading capabilities
- **MemberWallet**: Digital asset storage containers tracking available and frozen balances for each cryptocurrency per member
- **Coin**: Master configuration for supported cryptocurrencies including rates, fees, and operational parameters
- **Order**: OTC trading records representing peer-to-peer cryptocurrency transactions with fiat payment settlement
- **Advertise**: Member-created trading offers specifying terms, prices, and conditions for buying or selling cryptocurrency
- **OtcCoin**: OTC-specific cryptocurrency configuration extending base coin functionality with P2P trading parameters
- **MemberTransaction**: Comprehensive audit trail of all member financial activities across the platform
- **Country**: Geographic region configuration supporting localization and payment method restrictions

### 2. Key Relationships

- **Member to MemberWallet (1:many)**: Each member can hold multiple cryptocurrency wallets with unique constraint per coin type
- **Member to Order (1:many, dual role)**: Members participate as both advertisers (creators) and customers (takers) in OTC orders
- **Member to Advertise (1:many)**: Members can create multiple trading advertisements with different terms and cryptocurrencies
- **Member to MemberTransaction (1:many)**: Complete financial audit trail linking all member activities
- **Advertise to Order (1:many)**: Each advertisement can spawn multiple orders as customers respond to offers
- **Order to OtcCoin (many:1)**: Orders trade specific OTC-enabled cryptocurrencies with associated fee structures
- **MemberWallet to Coin (many:1)**: Wallets hold balances of specific cryptocurrencies based on platform coin configuration
- **Country relationships**: Members and advertisements are associated with countries for regulatory compliance and payment method restrictions

### 3. Embedded Objects

- **Location**: Geographic details embedded within Member for address information
- **BankInfo**: Traditional banking details embedded in Member and Order for fiat payment processing
- **Alipay**: Alipay payment account information embedded for Chinese market payment processing
- **WechatPay**: WeChat Pay account details embedded for mobile payment processing in Chinese market

### 4. Status Enumerations

- **OrderStatus**: CANCELLED, NONPAYMENT, PAID, COMPLETED, APPEAL - tracking OTC order processing workflow
- **TransactionType**: RECHARGE, WITHDRAW, EXCHANGE, OTC_BUY, OTC_SELL, ACTIVITY_AWARD, PROMOTION_AWARD, etc. - categorizing all financial activities
- **AdvertiseType**: BUY, SELL - distinguishing between purchase and sale advertisements
- **RealNameStatus**: NOT_CERTIFIED, VERIFIED, FAILED, PENDING - tracking KYC verification progress
- **CommonStatus**: NORMAL, ILLEGAL, LOCKED - standard status enumeration for operational entities
- **CertifiedBusinessStatus**: Business verification status for professional traders
- **BooleanEnum**: IS_TRUE, IS_FALSE - standardized boolean representation with explicit ordinal mapping

### 5. Data Integrity Features

- **Optimistic Locking**: Version fields in MemberWallet, Order, and Advertise entities prevent concurrent modification conflicts
- **Unique Constraints**: Username, email, and mobile phone uniqueness enforced at database level
- **Cascade Relationships**: Proper JPA cascade configurations ensure referential integrity
- **Audit Trails**: MemberTransaction provides complete financial audit capability with immutable records
- **Balance Consistency**: Dual balance tracking (available/frozen) with atomic operations prevents financial inconsistencies

This diagram provides a visual representation of the actual data model relationships in the codebase, showing how the cryptocurrency exchange platform maintains data integrity while supporting complex trading workflows and regulatory compliance requirements.
