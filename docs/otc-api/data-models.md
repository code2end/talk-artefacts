# OTC API Data Models

This document describes the core data models of the OTC API service and their relationships.

## Core Entities

### 1. OrderDetail

Represents detailed information about an OTC order for API responses.

```java
public class OrderDetail {
    private String orderSn;           // Unique order serial number
    private AdvertiseType type;       // BUY or SELL from user's perspective
    private String unit;              // Cryptocurrency unit (BTC, ETH, etc.)
    private OrderStatus status;       // Current order status
    private BigDecimal price;         // Price per unit of cryptocurrency
    private BigDecimal money;         // Total fiat money amount
    private BigDecimal amount;        // Cryptocurrency amount
    private BigDecimal commission;    // Trading commission/fee
    private PayInfo payInfo;          // Payment method information
    private Date createTime;          // Order creation timestamp
    private Date payTime;             // Payment confirmation timestamp
    private int timeLimit;            // Payment time limit in minutes
    private String otherSide;         // Username of the counterparty
    private long myId;               // Current user's member ID
    private long hisId;              // Counterparty's member ID
    private String memberMobile;      // Contact mobile number
}
```

### 2. PreOrderInfo

Contains pre-order information displayed before order creation.

```java
public class PreOrderInfo {
    private String username;              // Advertisement publisher username
    private BooleanEnum emailVerified;    // Email verification status
    private BooleanEnum phoneVerified;    // Phone verification status  
    private BooleanEnum idCardVerified;   // Identity verification status
    private int transactions;             // Total completed transactions
    private long otcCoinId;              // OTC coin identifier
    private String unit;                 // Cryptocurrency unit
    private BigDecimal price;            // Current price per unit
    private BigDecimal number;           // Available amount
    private String payMode;              // Supported payment methods
    private BigDecimal minLimit;         // Minimum transaction limit
    private BigDecimal maxLimit;         // Maximum transaction limit
    private int timeLimit;               // Payment time limit
    private String country;              // Country/region
    private AdvertiseType advertiseType; // Advertisement type (BUY/SELL)
    private String remark;               // Advertisement remarks
    private BigDecimal maxTradableAmount; // Maximum tradeable amount
}
```

### 3. PayInfo

Encapsulates payment method information for orders.

```java
public class PayInfo {
    private String realName;     // Real name for payment
    private Alipay alipay;      // Alipay payment info
    private WechatPay wechatPay; // WeChat Pay payment info
    private BankInfo bankInfo;   // Bank account payment info
}
```

### 4. ScanOrder

Lightweight order representation for listing views.

```java
public class ScanOrder {
    private String orderSn;           // Order serial number
    private Date createTime;          // Creation timestamp
    private String unit;              // Cryptocurrency unit
    private AdvertiseType type;       // Order type from user perspective
    private String name;              // Counterparty name
    private BigDecimal price;         // Price per unit
    private BigDecimal money;         // Total money amount
    private BigDecimal commission;    // Commission fee
    private BigDecimal amount;        // Cryptocurrency amount
    private OrderStatus status;       // Current status
    private Long memberId;           // Member ID
    private String avatar;           // User avatar URL
}
```

### 5. ScanMemberAddress

Represents cryptocurrency addresses for member scanning.

```java
public class ScanMemberAddress {
    private long id;           // Address ID
    private String unit;       // Cryptocurrency unit
    private String remark;     // Address remark/label
    private String address;    // Cryptocurrency address
}
```

### 6. AppealApply

Data transfer object for order appeal requests.

```java
public class AppealApply {
    private String orderSn;    // Order serial number to appeal
    private String remark;     // Appeal reason/description
}
```

### 7. Chat Message Entities

#### BaseMessage

Base class for chat message functionality.

```java
public class BaseMessage {
    // Base properties for chat messaging system
}
```

#### ChatMessageRecord

Records chat messages between trading parties.

```java
public class ChatMessageRecord {
    private String orderId;       // Associated order ID
    private String uidFrom;       // Sender user ID
    private String uidTo;         // Recipient user ID
    private String nameFrom;      // Sender username
    private String nameTo;        // Recipient username
    private String content;       // Message content
    private long sendTime;        // Send timestamp (milliseconds)
    private String sendTimeStr;   // Formatted send time string
}
```

## Relationships

1. **OrderDetail to PayInfo**: One-to-one composition
   - OrderDetail contains PayInfo for payment method details
   - PayInfo aggregates multiple payment method options

2. **Order to ChatMessageRecord**: One-to-many
   - Each order can have multiple chat messages between parties
   - Chat records are stored in MongoDB for real-time messaging

3. **PreOrderInfo to OtcCoin**: Many-to-one reference
   - PreOrderInfo references OtcCoin via otcCoinId
   - Provides coin-specific trading limits and information

4. **ScanOrder to Member**: Many-to-one reference
   - ScanOrder contains member information for counterparty details
   - Includes avatar and contact information

5. **Appeal to Order**: One-to-one
   - AppealApply references specific order via orderSn
   - Creates formal dispute record in the system

## Status Enumerations

### AdvertiseType
- **BUY**: Advertisement for buying cryptocurrency (user wants to buy)
- **SELL**: Advertisement for selling cryptocurrency (user wants to sell)

### OrderStatus
- **NONPAYMENT**: Order created, waiting for payment
- **PAID**: Payment confirmed by buyer
- **COMPLETED**: Order completed successfully
- **CANCELLED**: Order cancelled by either party
- **APPEALED**: Order under dispute/appeal

### BooleanEnum
- **IS_TRUE**: True/enabled state
- **IS_FALSE**: False/disabled state

### PayMode (String-based)
- **ALI**: Alipay payment method
- **WECHAT**: WeChat Pay payment method  
- **BANK**: Bank transfer payment method

## Processing Flow

The typical processing flow involving these entities:

1. **Advertisement Creation**: Users create advertisements with specific terms and payment methods
2. **Pre-Order Display**: PreOrderInfo shows advertisement details to potential traders
3. **Order Creation**: When user responds to advertisement, Order entity is created
4. **Payment Processing**: Order moves through status changes (NONPAYMENT → PAID → COMPLETED)
5. **Communication**: ChatMessageRecord enables real-time communication during trades
6. **Dispute Handling**: AppealApply allows formal dispute resolution if needed
7. **Order Completion**: Final settlement with wallet updates and transaction records

## Data Storage Strategy

- **Transactional Data**: OrderDetail, PreOrderInfo, PayInfo stored in MySQL with ACID properties
- **Chat Data**: ChatMessageRecord stored in MongoDB for scalable messaging
- **Search Data**: Order and advertisement data indexed in Elasticsearch for fast queries
- **Session Data**: User session information cached in Redis for performance
- **Aggregated Data**: Order statistics and analytics aggregated in MongoDB

## Integration Points

### External Entity References

The OTC API entities reference several external entities from core services:

- **Member**: User account information (from core service)
- **OtcCoin**: Supported cryptocurrency information (from otc-core)
- **Advertise**: Advertisement entities (from otc-core)
- **Order**: Full order entities (from otc-core)
- **MemberWallet**: User cryptocurrency wallets (from core service)
- **Country**: Country/region information (from core service)

### Data Transformation

The API layer transforms between:
- **Full entities** ↔ **Lightweight DTOs** (Order ↔ ScanOrder)
- **Internal models** ↔ **API responses** (PreOrderInfo for client display)
- **Database entities** ↔ **Message payloads** (ChatMessageRecord for real-time updates)

This design separates concerns between data persistence, API contracts, and user interface requirements while maintaining referential integrity across the distributed system.
