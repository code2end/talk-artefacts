# OTC Core Data Models

This document describes the core data models of the OTC (Over-the-Counter) trading system that are supported by the OTC Core infrastructure component. While the OTC Core module itself doesn't define entities (it provides configuration services), it enables session management, caching, and messaging for the key OTC trading entities defined in the core module.

## Core Entities

### 1. OtcCoin

Represents cryptocurrencies that can be traded in the OTC (Over-the-Counter) marketplace.

```java
@Entity
public class OtcCoin {
    private Long id;
    private String name;           // Cryptocurrency name
    private String nameCn;         // Chinese name
    private String unit;           // Currency unit (e.g., BTC, ETH)
    private CommonStatus status;   // NORMAL or FORBIDDEN
    private BigDecimal jyRate;     // Transaction fee rate
    private BigDecimal sellMinAmount;  // Minimum sell amount
    private BigDecimal buyMinAmount;   // Minimum buy amount
    private int sort;              // Display sort order
    private BooleanEnum isPlatformCoin; // Platform coin flag
}
```

### 2. Order (OTC Order)

Represents peer-to-peer trading orders between users in the OTC system.

```java
@Entity
@Table(name = "otc_order")
public class Order {
    private Long id;
    private String orderSn;         // Unique order number
    private AdvertiseType advertiseType; // BUY or SELL
    private Date createTime;
    
    // Member information
    private Long memberId;          // Order creator
    private String memberName;
    private String memberRealName;
    private Long customerId;        // Trading partner
    private String customerName;
    private String customerRealName;
    
    // Trading details
    private OtcCoin coin;          // Cryptocurrency being traded
    private BigDecimal price;      // Trading price
    private BigDecimal maxLimit;   // Maximum transaction amount
    private BigDecimal minLimit;   // Minimum transaction amount
    private String country;        // Trading country
    private Integer timeLimit;     // Payment time limit (minutes)
    
    // Financial details
    private BigDecimal money;      // Fiat currency amount
    private BigDecimal number;     // Cryptocurrency amount
    private BigDecimal commission; // Transaction fee
    
    // Status tracking
    private OrderStatus status;    // Order lifecycle status
    private Date payTime;          // Payment timestamp
    private Date cancelTime;       // Cancellation timestamp
    private Date releaseTime;      // Fund release timestamp
    
    // Payment information
    private String payMode;        // Payment methods (comma separated)
    private Long advertiseId;      // Related advertisement
    private Alipay alipay;        // Embedded payment info
    private BankInfo bankInfo;    // Embedded payment info
    private WechatPay wechatPay;  // Embedded payment info
    
    private String remark;         // Order notes
    private Long version;          // Optimistic locking
}
```

### 3. Advertise

Represents trading advertisements created by users to buy or sell cryptocurrencies.

```java
@Entity
public class Advertise {
    private Long id;
    private BigDecimal price;           // Current trading price
    private AdvertiseType advertiseType; // BUY or SELL
    private Member member;              // Advertisement owner
    private Date createTime;
    private Date updateTime;
    
    // Trading configuration
    private OtcCoin coin;              // Cryptocurrency
    private Country country;           // Trading country
    private BigDecimal minLimit;       // Minimum trade amount
    private BigDecimal maxLimit;       // Maximum trade amount
    private Integer timeLimit;         // Payment time limit
    private String payMode;            // Accepted payment methods
    
    // Pricing strategy
    private BigDecimal premiseRate;    // Premium percentage
    private PriceType priceType;       // Fixed or market-based pricing
    
    // Inventory management
    private BigDecimal number;         // Total planned amount
    private BigDecimal dealAmount;     // Currently trading amount
    private BigDecimal remainAmount;   // Remaining available amount
    
    // Settings
    private AdvertiseLevel level;      // Advertisement priority level
    private AdvertiseControlStatus status; // PUT_ON_SHELVES/PUT_OFF_SHELVES
    private BooleanEnum auto;          // Auto-reply enabled
    private String autoword;           // Auto-reply message
    private String remark;             // Advertisement notes
    
    private Long version;              // Optimistic locking
}
```

### 4. OrderDetail (DTO)

Data transfer object containing comprehensive order information for API responses.

```java
@Builder
public class OrderDetail {
    private String orderSn;
    private AdvertiseType type;
    private String unit;
    private OrderStatus status;
    private BigDecimal price;
    private BigDecimal money;
    private BigDecimal amount;
    private BigDecimal commission;
    private PayInfo payInfo;
    private Date createTime;
    private Date payTime;
    private int timeLimit;
    private String otherSide;      // Trading partner username
    private long myId;             // Current user ID
    private long hisId;            // Partner user ID
    private String memberMobile;   // Contact phone number
}
```

### 5. PayInfo (Payment Information)

Aggregated payment information container for order processing.

```java
@Builder
public class PayInfo {
    private String realName;       // Account holder's real name
    private Alipay alipay;        // Alipay payment details
    private WechatPay wechatPay;  // WeChat Pay details
    private BankInfo bankInfo;    // Bank account details
}
```

## Embedded Payment Entities

### Alipay

```java
@Embeddable
public class Alipay {
    private String aliNo;         // Alipay account number
    private String qrCodeUrl;     // QR code image URL
}
```

### BankInfo

```java
@Embeddable
public class BankInfo {
    private String bank;          // Bank name
    private String branch;        // Branch name
    private String cardNo;        // Bank card number
}
```

### WechatPay

```java
@Embeddable
public class WechatPay {
    private String wechat;        // WeChat ID
    private String qrWeCodeUrl;   // WeChat Pay QR code URL
}
```

## Relationships

1. **Order to OtcCoin**: Many-to-One
   - Each order involves one cryptocurrency for trading

2. **Order to Member**: Many-to-One (multiple relationships)
   - Each order has one owner (memberId) and one trading partner (customerId)

3. **Advertise to Member**: Many-to-One
   - Each advertisement is owned by one member

4. **Advertise to OtcCoin**: Many-to-One
   - Each advertisement specifies one cryptocurrency to trade

5. **Advertise to Country**: Many-to-One
   - Each advertisement targets one specific country/region

6. **Order to Advertise**: Many-to-One
   - Each order is created from one advertisement

7. **Order to Payment Info**: One-to-One (embedded)
   - Each order contains embedded payment method details

## Status Enumerations

### OrderStatus
- **CANCELLED (0)**: Order has been cancelled
- **NONPAYMENT (1)**: Order created, awaiting payment
- **PAID (2)**: Payment made by buyer, awaiting seller confirmation
- **COMPLETED (3)**: Order completed successfully
- **APPEAL (4)**: Order in dispute resolution process

### AdvertiseType
- **BUY (0)**: Advertisement to purchase cryptocurrency (buy crypto with fiat)
- **SELL (1)**: Advertisement to sell cryptocurrency (sell crypto for fiat)

### AdvertiseControlStatus
- **PUT_OFF_SHELVES**: Advertisement is offline/disabled
- **PUT_ON_SHELVES**: Advertisement is active and visible

## Processing Flow

The typical OTC trading flow involving these entities:

1. **Advertisement Creation**: Member creates an `Advertise` for buying/selling cryptocurrency
2. **Order Placement**: Another member places an `Order` against the advertisement
3. **Payment Processing**: Buyer makes payment using methods specified in `PayInfo`
4. **Confirmation**: Seller confirms payment receipt
5. **Settlement**: Cryptocurrency is transferred and order status becomes COMPLETED

## Infrastructure Support

The OTC Core module provides essential infrastructure support for these entities:

- **Session Management**: Secure user sessions for advertisement and order operations
- **Caching**: Redis-based caching for frequently accessed advertisement and price data
- **Message Processing**: Kafka-based event handling for order status changes and notifications
- **Data Serialization**: JSON serialization for complex order and payment data structures

This infrastructure enables efficient, secure, and scalable OTC trading operations across the platform.
