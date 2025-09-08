# Wallet Service Data Models

This document describes the core data models used by the Wallet Service and their relationships with other components in the Bizzan cryptocurrency exchange system.

## Core Entities

### 1. MemberWallet

Represents a cryptocurrency wallet for a specific member and coin combination.

```java
@Entity
@Table(uniqueConstraints = {@UniqueConstraint(columnNames={"memberId", "coin_id"})})
public class MemberWallet {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private Long memberId;              // Reference to Member entity
    
    @ManyToOne
    @JoinColumn(name = "coin_id")
    private Coin coin;                  // Associated cryptocurrency
    
    @Column(columnDefinition = "decimal(26,16) comment '可用余额'")
    private BigDecimal balance;         // Available balance
    
    @Column(columnDefinition = "decimal(26,16) comment '冻结余额'")
    private BigDecimal frozenBalance;   // Frozen/locked balance
    
    @Column(columnDefinition = "decimal(18,8) comment '待释放总量'")
    private BigDecimal toReleased;      // Amount pending release
    
    private String address;             // Blockchain wallet address
    
    @Version
    private int version;                // Optimistic locking version
    
    @Enumerated(EnumType.ORDINAL)
    @Column(columnDefinition = "int default 0 comment '钱包不是锁定'")
    private BooleanEnum isLock;         // Wallet lock status
    
    @Transient
    private String memo;                // Memo for EOS/XRP-type coins
}
```

### 2. Coin

Configuration and metadata for supported cryptocurrencies.

```java
@Entity
public class Coin {
    @Id
    private String name;                // Primary key - full coin name
    private String nameCn;              // Chinese display name
    private String unit;                // Currency unit symbol (BTC, ETH, etc.)
    private CommonStatus status;        // Active/inactive status
    private double minTxFee;            // Minimum transaction fee
    private double maxTxFee;            // Maximum transaction fee
    private double cnyRate;             // CNY exchange rate
    private double usdRate;             // USD exchange rate
    private BooleanEnum enableRpc;      // RPC interface support
    private int sort;                   // Display sort order
    private BooleanEnum canWithdraw;    // Withdrawal capability
    private BooleanEnum canRecharge;    // Deposit capability
    private BooleanEnum canTransfer;    // Transfer capability
    private BooleanEnum canAutoWithdraw; // Auto-withdrawal capability
    private BigDecimal withdrawThreshold;
    private BigDecimal minWithdrawAmount;
    private BigDecimal maxWithdrawAmount;
    private BigDecimal minRechargeAmount;
    private BooleanEnum isPlatformCoin;
    private Boolean hasLegal;           // Legal tender support
    private String coldWalletAddress;   // Cold storage address
    private BigDecimal minerFee;        // Network miner fee
    private int accountType;            // Account type (0=address, 1=memo)
}
```

### 3. Member

User account information (referenced by MemberWallet).

```java
@Entity
public class Member {
    @Id
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

### 4. WithdrawRecord

Record of withdrawal transactions processed by the wallet service.

```java
@Entity
public class WithdrawRecord {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private Long memberId;              // Member making withdrawal
    private Coin coin;                  // Cryptocurrency being withdrawn
    private BigDecimal totalAmount;     // Total amount requested
    private BigDecimal arriveAmount;    // Amount to arrive after fees
    private BigDecimal fee;             // Withdrawal fee
    private String address;             // Destination address
    private String txid;                // Blockchain transaction ID
    private WithdrawStatus status;      // Processing status
    private Date createTime;
    private Date dealTime;              // Processing completion time
    private String remark;              // Processing notes
}
```

### 5. RewardRecord

Record of rewards given to members (registration bonuses, etc.).

```java
@Entity
public class RewardRecord {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private Member member;              // Member receiving reward
    private Coin coin;                  // Reward cryptocurrency
    private BigDecimal amount;          // Reward amount
    private RewardRecordType type;      // Type of reward
    private String remark;              // Reward description
    private Date createTime;
}
```

### 6. MemberTransaction

Audit trail of all balance changes and transactions.

```java
@Entity
public class MemberTransaction {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private Long memberId;              // Member ID
    private BigDecimal amount;          // Transaction amount
    private TransactionType type;       // Transaction type
    private String symbol;              // Currency symbol
    private BigDecimal fee;             // Transaction fee
    private String discountFee;         // Discount applied to fee
    private String realFee;             // Actual fee charged
    private Date createTime;
}
```

## Relationships

1. **Member to MemberWallet**: One-to-Many
   - Each member can have multiple wallets (one per supported cryptocurrency)
   - Unique constraint prevents duplicate wallets for same member-coin pair

2. **Coin to MemberWallet**: One-to-Many
   - Each coin can be held in multiple member wallets
   - Coin configuration determines wallet capabilities (withdraw/deposit/transfer)

3. **Member to WithdrawRecord**: One-to-Many
   - Each member can have multiple withdrawal records
   - Tracks complete withdrawal history per member

4. **Coin to WithdrawRecord**: One-to-Many
   - Each coin can have multiple withdrawal records
   - Withdrawal processing rules vary by coin configuration

5. **Member to RewardRecord**: One-to-Many
   - Each member can receive multiple rewards
   - Different reward types (registration, activity, etc.)

6. **Member to MemberTransaction**: One-to-Many
   - Complete audit trail of all balance changes
   - Links to specific transactions across the platform

## Status Enumerations

### BooleanEnum
- **IS_FALSE** (0): False/disabled state
- **IS_TRUE** (1): True/enabled state

### CommonStatus
- **NORMAL**: Active/operational state
- **ILLEGAL**: Blocked/illegal state

### WithdrawStatus
- **PROCESSING**: Withdrawal being processed
- **SUCCESS**: Withdrawal completed successfully
- **FAILED**: Withdrawal failed
- **WAITING**: Waiting for approval/processing

### TransactionType
- **RECHARGE**: Deposit transaction
- **WITHDRAW**: Withdrawal transaction
- **TRANSFER_ACCOUNTS**: Internal transfer
- **ACTIVITY_AWARD**: Reward/bonus transaction
- **PROMOTION_AWARD**: Referral reward
- **DIVIDEND**: Dividend payment

### RewardRecordType
- **ACTIVITY**: Activity-based reward
- **PROMOTION**: Referral reward
- **DIVIDEND**: Dividend distribution

### ActivityRewardType
- **REGISTER**: Registration bonus

## Processing Flow

The typical processing flow involving these entities:

1. **Member Registration**: 
   - New Member entity created
   - MemberWallet entities created for all supported Coins
   - Optional RewardRecord created for registration bonus
   - MemberTransaction records audit trail

2. **Deposit Processing**:
   - Blockchain transaction detected
   - MemberWallet balance updated
   - MemberTransaction record created for audit

3. **Withdrawal Processing**:
   - WithdrawRecord created with PROCESSING status
   - MemberWallet frozen balance updated
   - Blockchain transaction submitted via RPC
   - WithdrawRecord status updated based on result
   - MemberTransaction record created

4. **Address Management**:
   - New addresses generated via RPC services
   - MemberWallet address field updated
   - Supports both address-based and memo-based coins

## Data Integrity Considerations

- **Optimistic Locking**: MemberWallet uses version field to prevent concurrent balance updates
- **Unique Constraints**: MemberWallet enforces one wallet per member-coin combination
- **Balance Consistency**: Available + frozen balance represents total wallet value
- **Audit Trail**: All balance changes tracked in MemberTransaction table
- **Transaction Safety**: Database transactions ensure consistency across related entities
