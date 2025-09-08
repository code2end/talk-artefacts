# OTC Core Entity Relationship Diagram

This document provides a visual representation of the data model relationships for OTC (Over-the-Counter) trading entities supported by the OTC Core infrastructure module.

```mermaid
classDiagram
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

    class Member {
        +Long id
        +String username
        +String realName
        +String mobilePhone
        +String email
        +MemberLevel memberLevel
        +Date registrationTime
    }

    class Country {
        +Long id
        +String zhName
        +String enName
        +String areaCode
        +String language
    }

    class Advertise {
        +Long id
        +BigDecimal price
        +AdvertiseType advertiseType
        +Date createTime
        +Date updateTime
        +BigDecimal minLimit
        +BigDecimal maxLimit
        +String remark
        +Integer timeLimit
        +BigDecimal premiseRate
        +AdvertiseLevel level
        +String payMode
        +AdvertiseControlStatus status
        +PriceType priceType
        +BigDecimal number
        +BigDecimal dealAmount
        +BigDecimal remainAmount
        +BooleanEnum auto
        +String autoword
        +Long version
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
        +Long version
    }

    class Alipay {
        <<embedded>>
        +String aliNo
        +String qrCodeUrl
    }

    class BankInfo {
        <<embedded>>
        +String bank
        +String branch
        +String cardNo
    }

    class WechatPay {
        <<embedded>>
        +String wechat
        +String qrWeCodeUrl
    }

    class OrderDetail {
        <<DTO>>
        +String orderSn
        +AdvertiseType type
        +String unit
        +OrderStatus status
        +BigDecimal price
        +BigDecimal money
        +BigDecimal amount
        +BigDecimal commission
        +PayInfo payInfo
        +Date createTime
        +Date payTime
        +int timeLimit
        +String otherSide
        +long myId
        +long hisId
        +String memberMobile
    }

    class PayInfo {
        <<DTO>>
        +String realName
        +Alipay alipay
        +WechatPay wechatPay
        +BankInfo bankInfo
    }

    %% Relationships
    Advertise "many" --> "1" Member : owned_by
    Advertise "many" --> "1" OtcCoin : trades
    Advertise "many" --> "1" Country : located_in
    
    Order "many" --> "1" OtcCoin : involves
    Order "many" --> "1" Member : created_by
    Order "many" --> "1" Member : trades_with
    Order "many" --> "1" Advertise : responds_to
    
    Order "1" --> "1" Alipay : contains
    Order "1" --> "1" BankInfo : contains
    Order "1" --> "1" WechatPay : contains
    
    OrderDetail "1" --> "1" PayInfo : includes
    PayInfo "1" --> "1" Alipay : contains
    PayInfo "1" --> "1" BankInfo : contains
    PayInfo "1" --> "1" WechatPay : contains

    %% Status Enums
    class AdvertiseType {
        <<enumeration>>
        BUY
        SELL
    }

    class OrderStatus {
        <<enumeration>>
        CANCELLED
        NONPAYMENT
        PAID
        COMPLETED
        APPEAL
    }

    class AdvertiseControlStatus {
        <<enumeration>>
        PUT_OFF_SHELVES
        PUT_ON_SHELVES
    }

    class CommonStatus {
        <<enumeration>>
        NORMAL
        FORBIDDEN
    }
```

## Entity Relationship Description

This class diagram illustrates the key entities in the OTC Core system and their relationships:

### 1. Core Entities

- **OtcCoin**: Represents cryptocurrencies available for OTC trading with configuration like minimum amounts and fee rates
- **Member**: Users who can create advertisements and place orders in the OTC marketplace  
- **Country**: Geographic regions where OTC trading is supported with localization settings
- **Advertise**: Trading offers created by users to buy or sell cryptocurrency at specified terms
- **Order**: Actual trade transactions between users, created from advertisements

### 2. Key Relationships

- **Member to Advertise (1:many)**: Each member can create multiple trading advertisements
- **Member to Order (1:many, bidirectional)**: Each member can be both order creator and trading partner
- **OtcCoin to Advertise (1:many)**: Each cryptocurrency can have multiple active advertisements
- **OtcCoin to Order (1:many)**: Each cryptocurrency can be involved in multiple trading orders
- **Country to Advertise (1:many)**: Each country/region can host multiple advertisements
- **Advertise to Order (1:many)**: Each advertisement can generate multiple orders from different users

### 3. Embedded Objects

- **Alipay**: Embedded payment information for Alipay transactions with account and QR code details
- **BankInfo**: Embedded bank account information including bank name, branch, and card number
- **WechatPay**: Embedded WeChat Pay information with account ID and QR code URL

### 4. Data Transfer Objects (DTOs)

- **OrderDetail**: Comprehensive order information DTO for API responses with derived fields
- **PayInfo**: Aggregated payment information container combining all payment method details

### 5. Status Enumerations

- **AdvertiseType**: BUY (purchase crypto with fiat) or SELL (sell crypto for fiat)
- **OrderStatus**: Complete order lifecycle from NONPAYMENT through COMPLETED or CANCELLED
- **AdvertiseControlStatus**: Advertisement visibility (PUT_ON_SHELVES/PUT_OFF_SHELVES)
- **CommonStatus**: General entity status (NORMAL/FORBIDDEN)

### 6. Infrastructure Support Features

The OTC Core module provides infrastructure support enabling these relationships through:

- **Session Management**: Secure user authentication for creating advertisements and orders
- **Caching Strategy**: Redis-based caching for frequently accessed advertisement and coin data
- **Message Processing**: Kafka-based event handling for order status changes and notifications
- **Data Serialization**: JSON serialization for complex payment information and order details

### 7. Business Process Flow

The typical entity interaction flow:

1. **Member** creates **Advertise** for specific **OtcCoin** in target **Country**
2. Another **Member** places **Order** against the **Advertise**
3. **Order** contains embedded payment details (**Alipay**, **BankInfo**, **WechatPay**)
4. Order status transitions through **OrderStatus** lifecycle
5. **OrderDetail** and **PayInfo** DTOs provide structured data for API consumers

This diagram provides a visual representation of the actual data model relationships supported by the OTC Core infrastructure in the codebase.
