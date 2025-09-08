# ucenter-api Data Models

This document describes the core data models of the ucenter-api service and their relationships.

## Core Entities

### 1. Member

Represents a registered user in the cryptocurrency exchange platform.

```java
public class Member {
    private Long id;                           // Primary key
    private String username;                   // Unique username
    private String password;                   // Encrypted login password
    private String jyPassword;                 // Encrypted trading password
    private String salt;                       // Password salt
    private String realName;                   // Real name for KYC
    private String idNumber;                   // Identity document number
    private String email;                      // Unique email address
    private String mobilePhone;                // Unique mobile phone number
    private Location location;                 // Embedded location data
    private MemberLevelEnum memberLevel;       // User verification level
    private CommonStatus status;               // Account status
    private Date registrationTime;             // Registration timestamp
    private Date lastLoginTime;                // Last login timestamp
    private String token;                      // API access token
    private Date tokenExpireTime;              // Token expiration
    private String superPartner;               // Partner level indicator
    private int transactions;                  // Number of completed transactions
    private BankInfo bankInfo;                 // Embedded bank information
    private Alipay alipay;                     // Embedded Alipay information
    private WechatPay wechatPay;              // Embedded WeChat Pay information
    private int appealTimes;                   // Number of appeals made
    private int appealSuccessTimes;            // Number of successful appeals
    private Long inviterId;                    // Referrer member ID
    private String promotionCode;              // Personal promotion code
    private int firstLevel;                    // First-level referrals count
    private int secondLevel;                   // Second-level referrals count
    private int thirdLevel;                    // Third-level referrals count
    private Country country;                   // User's country
    private RealNameStatus realNameStatus;     // KYC verification status
    private int loginCount;                    // Total login count
    private CertifiedBusinessStatus certifiedBusinessStatus; // Business verification status
    private Date certifiedBusinessApplyTime;  // Business application time
    private Date applicationTime;              // KYC application time
    private Date certifiedBusinessCheckTime;  // Business verification time
    private String avatar;                     // Profile avatar URL
    private BooleanEnum publishAdvertise;      // Can publish ads flag
    private BooleanEnum transactionStatus;     // Can trade flag
    private Boolean signInAbility;             // Can sign in for rewards
}
```

### 2. MemberWallet

Represents a user's cryptocurrency wallet for a specific coin.

```java
public class MemberWallet {
    private Long id;                    // Primary key
    private Long memberId;              // Reference to Member
    private Coin coin;                  // Associated cryptocurrency
    private BigDecimal balance;         // Available balance
    private BigDecimal frozenBalance;   // Frozen/locked balance
    private BigDecimal toReleased;      // Amount pending release
    private String address;             // Deposit address
    private int version;                // Optimistic locking version
    private BooleanEnum isLock;         // Wallet lock status
    private String memo;                // Transaction memo (for coins like EOS, XRP)
}
```

### 3. Coin

Represents a cryptocurrency supported by the exchange.

```java
public class Coin {
    private String name;                      // Primary key - coin name
    private String nameCn;                    // Chinese name
    private String unit;                      // Symbol (BTC, ETH, etc.)
    private CommonStatus status;              // Coin status
    private double minTxFee;                  // Minimum transaction fee
    private double maxTxFee;                  // Maximum transaction fee
    private double cnyRate;                   // CNY exchange rate
    private double usdRate;                   // USD exchange rate
    private BooleanEnum enableRpc;            // RPC interface enabled
    private int sort;                         // Display sort order
    private BooleanEnum canWithdraw;          // Withdrawal allowed
    private BooleanEnum canRecharge;          // Deposits allowed
    private BooleanEnum canTransfer;          // Transfers allowed
    private BooleanEnum canAutoWithdraw;      // Auto-withdrawal enabled
    private BigDecimal withdrawThreshold;     // Auto-withdrawal threshold
    private BigDecimal minWithdrawAmount;     // Minimum withdrawal amount
    private BigDecimal maxWithdrawAmount;     // Maximum withdrawal amount
    private BigDecimal minRechargeAmount;     // Minimum deposit amount
    private BooleanEnum isPlatformCoin;       // Is exchange's native coin
    private Boolean hasLegal;                 // Is fiat currency
    private String coldWalletAddress;         // Cold storage address
    private BigDecimal minerFee;              // Network mining fee
    private int withdrawScale;                // Withdrawal decimal precision
    private String infolink;                  // Information URL
    private String information;               // Coin description
    private int accountType;                  // Account type (0: default, 1: EOS-like)
    private String depositAddress;            // Shared deposit address (EOS-like coins)
}
```

### 4. MemberTransaction

Records all user financial transactions including deposits, withdrawals, and transfers.

```java
public class MemberTransaction {
    private Long id;                    // Primary key
    private Long memberId;              // Reference to Member
    private BigDecimal amount;          // Transaction amount
    private Date createTime;            // Creation timestamp
    private TransactionType type;       // Transaction type enum
    private String symbol;              // Coin symbol
    private String address;             // Transaction address
    private BigDecimal fee;             // Transaction fee
    private int flag;                   // Special status flag
    private String realFee;             // Actual fee charged
    private String discountFee;         // Discounted fee amount
}
```

### 5. WithdrawRecord

Represents withdrawal requests and their processing status.

```java
public class WithdrawRecord {
    private Long id;                     // Primary key
    private Long memberId;               // Reference to Member
    private Coin coin;                   // Withdrawal coin
    private BigDecimal totalAmount;      // Total withdrawal amount
    private BigDecimal fee;              // Withdrawal fee
    private BigDecimal arrivedAmount;    // Net amount after fees
    private Date createTime;             // Request creation time
    private Date dealTime;               // Processing completion time
    private WithdrawStatus status;       // Processing status
    private BooleanEnum isAuto;          // Automatic processing flag
    private Admin admin;                 // Admin who processed request
    private BooleanEnum canAutoWithdraw; // Auto-withdrawal eligibility
    private String transactionNumber;    // Blockchain transaction hash
    private String address;              // Withdrawal destination address
    private String remark;               // Optional notes
}
```

### 6. PromotionCard

Represents promotional cards/coupons used in the referral system.

```java
public class PromotionCard {
    private Long id;                 // Primary key
    private Long memberId;           // Card creator ID
    private int isEnabled;           // Card validity status
    private String cardName;         // Card display name
    private String cardNo;           // Unique card number
    private String cardDesc;         // Card description
    private Coin coin;               // Associated cryptocurrency
    private int count;               // Total card quantity
    private int exchangeCount;       // Number of cards redeemed
    private BigDecimal amount;       // Value per card
    private BigDecimal totalAmount;  // Total value of all cards
    private int isFree;              // Is free promotional card
    private int isLock;              // Lock rewards after redemption
    private int lockDays;            // Lock period in days
    private Date createTime;         // Creation timestamp
}
```

## Relationships

1. **Member to MemberWallet**: One-to-Many
   - Each member can have multiple wallets (one per supported coin)
   - Unique constraint on (memberId, coin_id)

2. **Member to MemberTransaction**: One-to-Many
   - Each member can have multiple transaction records
   - All user financial activities are logged here

3. **Member to WithdrawRecord**: One-to-Many
   - Each member can have multiple withdrawal requests
   - Tracks withdrawal history and processing status

4. **Member to PromotionCard**: One-to-Many
   - Each member can create multiple promotional cards
   - Used for referral and reward programs

5. **Coin to MemberWallet**: One-to-Many
   - Each coin can be held in multiple member wallets
   - Defines the cryptocurrency properties and limits

6. **Coin to WithdrawRecord**: One-to-Many
   - Each withdrawal record is associated with one coin type
   - Inherits withdrawal rules from coin configuration

7. **Coin to PromotionCard**: One-to-Many
   - Each promotional card is denominated in one cryptocurrency
   - Defines the reward currency

8. **Member Hierarchical Relationships**:
   - **inviterId**: Creates referral hierarchy
   - **firstLevel/secondLevel/thirdLevel**: Counts referrals at each level
   - **promotionCode**: Unique code for each member to share

## Status Enumerations

### MemberLevelEnum
- GENERAL: Basic unverified user
- REALNAME: Real-name verified user
- AUTHENTICATED: Fully authenticated user

### CommonStatus
- NORMAL: Active/enabled status
- ILLEGAL: Disabled/suspended status

### RealNameStatus
- NOT_CERTIFIED: No KYC verification
- AUDITING: KYC under review
- CERTIFIED: KYC approved
- CANCEL: KYC rejected

### WithdrawStatus
- PROCESSING: Request submitted, awaiting review
- WAITING: Approved, awaiting blockchain processing
- SUCCESS: Successfully completed
- FAIL: Failed or rejected
- CANCELLED: Cancelled by user or admin

### TransactionType
- RECHARGE: Cryptocurrency deposit
- WITHDRAW: Cryptocurrency withdrawal
- TRANSFER_ACCOUNTS: Internal transfer
- EXCHANGE: Trading activity
- WITHDRAW_PROMOTE_REWARD: Referral reward withdrawal
- DEPOSIT_PROMOTE_REWARD: Referral reward credit
- ADMIN_RECHARGE: Administrative deposit
- ADMIN_WITHDRAW: Administrative withdrawal
- MATCH: Exchange matching fee

### BooleanEnum
- IS_FALSE: False/disabled (0)
- IS_TRUE: True/enabled (1)

## Processing Flow

The typical user interaction flow involves these entities:

1. **User Registration**: Creates Member record with basic information
2. **Wallet Initialization**: Creates MemberWallet records for supported coins
3. **Deposit Processing**: Creates MemberTransaction records for incoming funds
4. **Balance Updates**: Updates MemberWallet balance and creates transaction records
5. **Withdrawal Requests**: Creates WithdrawRecord and freezes MemberWallet balance
6. **Withdrawal Processing**: Updates WithdrawRecord status and creates final MemberTransaction
7. **Promotional Activities**: Creates and manages PromotionCard records for referral rewards

## Embedded Objects

### Location
- **country**: Country name
- **province**: Province/state name
- **city**: City name
- **district**: District/area name

### BankInfo
- **bankName**: Bank name
- **bankAccount**: Account number
- **branch**: Branch name
- **realName**: Account holder name

### Alipay
- **aliNo**: Alipay account
- **qrCodeUrl**: QR code image URL

### WechatPay
- **wechat**: WeChat account
- **qrCodeUrl**: QR code image URL

This data model supports a comprehensive cryptocurrency exchange with user management, multi-currency wallets, transaction tracking, withdrawal processing, and promotional systems.
