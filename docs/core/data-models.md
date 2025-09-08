# Cryptocurrency Exchange Core Data Models

This document describes the core data models of the Bizzan Cryptocurrency Exchange Core module and their relationships.

## Core Entities

### 1. Member

Represents a registered user of the cryptocurrency exchange platform with comprehensive profile and status information.

```java
@Entity
public class Member {
    private Long id;
    private String username;
    private String password;
    private String salt;
    private String realName;
    private String idNumber;
    private String email;
    private String mobilePhone;
    private Location location;
    private MemberLevelEnum memberLevel;
    private CommonStatus status;
    private Date registrationTime;
    private Date lastLoginTime;
    private String token;
    private String superPartner;
    private int transactions;
    private BankInfo bankInfo;
    private Alipay alipay;
    private WechatPay wechatPay;
    private int appealTimes;
    private int appealSuccessTimes;
    private Long inviterId;
    private String promotionCode;
    private Country country;
    private RealNameStatus realNameStatus;
    private CertifiedBusinessStatus certifiedBusinessStatus;
    private String avatar;
    private BooleanEnum publishAdvertise;
    private BooleanEnum transactionStatus;
    private Boolean signInAbility;
}
```

### 2. MemberWallet

Digital cryptocurrency wallet containing balance information and transaction capabilities for each member and cryptocurrency pair.

```java
@Entity
public class MemberWallet {
    private Long id;
    private Long memberId;
    private Coin coin;
    private BigDecimal balance;           // Available balance
    private BigDecimal frozenBalance;     // Locked/frozen balance
    private BigDecimal toReleased;        // Amount pending release
    private String address;               // Crypto wallet address
    private int version;                  // Optimistic locking version
    private BooleanEnum isLock;           // Wallet lock status
    private String memo;                  // Memo for certain cryptocurrencies
}
```

### 3. Coin

Configuration and metadata for supported cryptocurrencies including rates, fees, and operational parameters.

```java
@Entity
public class Coin {
    @Id
    private String name;                  // Primary key: coin name
    private String nameCn;                // Chinese display name
    private String unit;                  // Currency unit (BTC, ETH, etc.)
    private CommonStatus status;
    private double minTxFee;              // Minimum transaction fee
    private double maxTxFee;              // Maximum transaction fee
    private double cnyRate;               // CNY exchange rate
    private double usdRate;               // USD exchange rate
    private BooleanEnum enableRpc;        // RPC interface support
    private int sort;                     // Display sort order
    private BooleanEnum canWithdraw;      // Withdrawal capability
    private BooleanEnum canRecharge;      // Deposit capability
    private BooleanEnum canTransfer;      // Transfer capability
    private BooleanEnum canAutoWithdraw;  // Auto-withdrawal capability
    private BigDecimal withdrawThreshold;
    private BigDecimal minWithdrawAmount;
    private BigDecimal maxWithdrawAmount;
    private BigDecimal minRechargeAmount;
    private BooleanEnum isPlatformCoin;
    private Boolean hasLegal;             // Legal tender support
    private String coldWalletAddress;     // Cold storage address
    private BigDecimal minerFee;          // Network miner fee
    private int withdrawScale;            // Decimal precision for withdrawals
    private String infolink;              // Information link
    private String information;           // Coin description
    private int accountType;              // Account type (0: default, 1: EOS)
    private String depositAddress;        // Deposit address for account-based coins
}
```

### 4. Order

OTC (Over-The-Counter) trading order representing peer-to-peer cryptocurrency transactions with fiat payment methods.

```java
@Entity
public class Order {
    private Long id;
    private String orderSn;               // Unique order number
    private AdvertiseType advertiseType;  // BUY or SELL
    private Date createTime;
    private Long memberId;                // Advertiser member ID
    private String memberName;
    private String memberRealName;
    private Long customerId;              // Trading partner member ID
    private String customerName;
    private String customerRealName;
    private OtcCoin coin;                 // Cryptocurrency being traded
    private BigDecimal price;             // Unit price
    private BigDecimal maxLimit;          // Maximum trade amount
    private BigDecimal minLimit;          // Minimum trade amount
    private String country;
    private String remark;                // Order notes
    private Integer timeLimit;            // Payment time limit (minutes)
    private BigDecimal money;             // Total fiat amount
    private BigDecimal number;            // Cryptocurrency quantity
    private BigDecimal commission;        // Transaction fee
    private OrderStatus status;           // Order processing status
    private Date payTime;                 // Payment timestamp
    private String payMode;               // Payment methods (comma-separated)
    private Long advertiseId;             // Source advertisement ID
    private Date cancelTime;
    private Date releaseTime;
    private Alipay alipay;               // Alipay payment details
    private BankInfo bankInfo;           // Bank payment details
    private WechatPay wechatPay;         // WeChat payment details
    private Long version;                // Optimistic locking
}
```

### 5. Advertise

Advertisement posted by members offering to buy or sell cryptocurrency at specified terms and conditions.

```java
@Entity
public class Advertise {
    private Long id;
    private BigDecimal price;             // Trading price
    private AdvertiseType advertiseType;  // BUY or SELL advertisement
    private Member member;                // Advertisement owner
    private Date createTime;
    private Date updateTime;
    private OtcCoin coin;                 // Cryptocurrency offered
    private Country country;              // Geographic restriction
    private BigDecimal minLimit;          // Minimum order amount
    private BigDecimal maxLimit;          // Maximum order amount
    private String remark;                // Advertisement description
    private Integer timeLimit;            // Payment time window
    private BigDecimal premiseRate;       // Premium/discount percentage
    private AdvertiseLevel level;         // Advertisement priority level
    private String payMode;               // Accepted payment methods
    private Long version;                 // Optimistic locking
    private AdvertiseControlStatus status; // Advertisement status
    private PriceType priceType;          // Fixed or market-based pricing
    private BigDecimal number;            // Total available quantity
    private BigDecimal dealAmount;        // Currently locked in orders
    private BigDecimal remainAmount;      // Available remaining quantity
    private BooleanEnum auto;             // Auto-reply capability
    private BigDecimal marketPrice;       // Current market reference price
    private String autoword;              // Auto-reply message
}
```

### 6. MemberTransaction

Comprehensive transaction log recording all member financial activities across the platform.

```java
@Entity
public class MemberTransaction {
    private Long id;
    private Long memberId;
    private BigDecimal amount;            // Transaction amount
    private Date createTime;
    private TransactionType type;         // Transaction category
    private String symbol;                // Cryptocurrency symbol
    private String address;               // Blockchain address involved
    private BigDecimal fee;               // Transaction fee charged
    private String comment;               // Transaction description
    private BigDecimal realFee;           // Actual fee paid
    private BigDecimal discountFee;       // Fee discount applied
}
```

### 7. OtcCoin

OTC-specific cryptocurrency configuration extending base coin functionality with trading parameters.

```java
@Entity
public class OtcCoin {
    private Long id;
    private String name;                  // Coin name
    private String nameCn;               // Chinese name
    private String unit;                 // Currency unit
    private CommonStatus status;
    private BigDecimal jyRate;           // Trading fee rate
    private BigDecimal sellMinAmount;    // Minimum sell advertisement amount
    private BigDecimal buyMinAmount;     // Minimum buy advertisement amount
    private int sort;                    // Display order
    private BooleanEnum isPlatformCoin;  // Platform native token flag
}
```

### 8. Country

Geographic region configuration supporting localization and payment method restrictions.

```java
@Entity
public class Country {
    @Id
    private String zhName;               // Chinese country name (Primary Key)
    private String enName;               // English country name
    private String areaCode;             // International dialing code
    private String language;             // Primary language
    private String localCurrency;        // Local fiat currency
    private int sort;                    // Display order
}
```

## Relationships

1. **Member to MemberWallet**: One-to-Many
   - Each member can have multiple wallets (one per supported cryptocurrency)
   - Unique constraint on (memberId, coin_id) pair

2. **Member to Order**: One-to-Many (as both advertiser and customer)
   - Members can create multiple orders as sellers (memberId relationship)
   - Members can participate in multiple orders as buyers (customerId relationship)

3. **Member to Advertise**: One-to-Many
   - Each member can create multiple advertisements
   - Advertisement ownership tracked via member relationship

4. **Coin to MemberWallet**: One-to-Many
   - Each cryptocurrency can be held in multiple member wallets
   - Wallet balance tracking per coin type

5. **OtcCoin to Order**: One-to-Many
   - Each OTC-enabled cryptocurrency can have multiple trading orders
   - Order pricing and limits based on OTC coin configuration

6. **OtcCoin to Advertise**: One-to-Many
   - Each OTC cryptocurrency can have multiple advertisements
   - Advertisement terms constrained by OTC coin parameters

7. **Country to Member**: One-to-Many
   - Members associated with their country of residence
   - Country determines available payment methods and regulations

8. **Country to Advertise**: One-to-Many
   - Advertisements can be restricted to specific countries
   - Regional payment method and compliance requirements

9. **Advertise to Order**: One-to-Many
   - Each advertisement can generate multiple orders
   - Order inherits terms and conditions from source advertisement

10. **Member to MemberTransaction**: One-to-Many
    - Complete audit trail of all member financial activities
    - Transaction history includes deposits, withdrawals, trades, fees, and rewards

## Status Enumerations

### OrderStatus
- **CANCELLED**: Order cancelled by participant or system
- **NONPAYMENT**: Awaiting payment from buyer
- **PAID**: Payment completed, awaiting seller confirmation
- **COMPLETED**: Transaction successfully completed
- **APPEAL**: Dispute raised, under arbitration

### TransactionType
- **RECHARGE**: Cryptocurrency deposit
- **WITHDRAW**: Cryptocurrency withdrawal
- **TRANSFER_ACCOUNTS**: Internal transfer between accounts
- **EXCHANGE**: Spot trading transaction
- **OTC_BUY**: OTC purchase transaction
- **OTC_SELL**: OTC sell transaction
- **ACTIVITY_AWARD**: Promotional activity reward
- **PROMOTION_AWARD**: Referral commission
- **DIVIDEND**: Profit sharing distribution
- **ADMIN_RECHARGE**: Manual administrative deposit
- **RED_OUT**: Red envelope sent
- **RED_IN**: Red envelope received

### AdvertiseType
- **BUY**: Advertisement to buy cryptocurrency (offering fiat)
- **SELL**: Advertisement to sell cryptocurrency (requesting fiat)

### RealNameStatus
- **NOT_CERTIFIED**: No KYC verification submitted
- **VERIFIED**: KYC documentation approved
- **FAILED**: KYC verification rejected
- **PENDING**: KYC under review

### CommonStatus
- **NORMAL**: Active and operational
- **ILLEGAL**: Suspended or banned
- **LOCKED**: Temporarily locked

## Processing Flow

The typical processing flow involving these entities follows this pattern:

1. **Member Registration**: New members register with basic information and receive initial wallet setup
2. **KYC Verification**: Members submit identity documents to achieve verified status enabling higher limits
3. **Wallet Funding**: Members deposit cryptocurrency which creates MemberTransaction records and updates wallet balances
4. **Advertisement Creation**: Verified members create buy/sell advertisements specifying terms, prices, and payment methods
5. **Order Placement**: Other members place orders against advertisements, creating Order records and freezing wallet balances
6. **Payment Process**: Buyers make fiat payments and mark orders as paid, initiating seller confirmation workflow
7. **Order Completion**: Sellers confirm payment receipt, triggering cryptocurrency transfer and order completion
8. **Transaction Recording**: All balance changes generate corresponding MemberTransaction audit records

This data model supports both high-frequency automated trading and manual peer-to-peer transactions while maintaining comprehensive audit trails and regulatory compliance capabilities.
