# OTC API Entity Relationship Diagram

```mermaid
classDiagram
    class OrderDetail {
        +String orderSn
        +AdvertiseType type
        +String unit
        +OrderStatus status
        +BigDecimal price
        +BigDecimal money
        +BigDecimal amount
        +BigDecimal commission
        +Date createTime
        +Date payTime
        +int timeLimit
        +String otherSide
        +long myId
        +long hisId
        +String memberMobile
    }

    class PreOrderInfo {
        +String username
        +BooleanEnum emailVerified
        +BooleanEnum phoneVerified
        +BooleanEnum idCardVerified
        +int transactions
        +long otcCoinId
        +String unit
        +BigDecimal price
        +BigDecimal number
        +String payMode
        +BigDecimal minLimit
        +BigDecimal maxLimit
        +int timeLimit
        +String country
        +AdvertiseType advertiseType
        +String remark
        +BigDecimal maxTradableAmount
    }

    class PayInfo {
        +String realName
        +Alipay alipay
        +WechatPay wechatPay
        +BankInfo bankInfo
    }

    class ScanOrder {
        +String orderSn
        +Date createTime
        +String unit
        +AdvertiseType type
        +String name
        +BigDecimal price
        +BigDecimal money
        +BigDecimal commission
        +BigDecimal amount
        +OrderStatus status
        +Long memberId
        +String avatar
    }

    class ScanMemberAddress {
        +long id
        +String unit
        +String remark
        +String address
    }

    class AppealApply {
        +String orderSn
        +String remark
    }

    class ChatMessageRecord {
        +String orderId
        +String uidFrom
        +String uidTo
        +String nameFrom
        +String nameTo
        +String content
        +long sendTime
        +String sendTimeStr
    }

    class BaseMessage {
        <<abstract>>
    }

    class Member {
        <<external>>
        +Long id
        +String username
        +String realName
        +String mobilePhone
        +String email
        +String avatar
        +int transactions
        +MemberLevelEnum memberLevel
    }

    class Order {
        <<external>>
        +String orderSn
        +Long memberId
        +Long customerId
        +OrderStatus status
        +BigDecimal number
        +BigDecimal money
        +BigDecimal price
        +BigDecimal commission
        +AdvertiseType advertiseType
        +Date createTime
        +Date payTime
    }

    class Advertise {
        <<external>>
        +Long id
        +AdvertiseType advertiseType
        +BigDecimal price
        +BigDecimal number
        +BigDecimal remainAmount
        +BigDecimal minLimit
        +BigDecimal maxLimit
        +String payMode
        +int timeLimit
        +AdvertiseControlStatus status
    }

    class OtcCoin {
        <<external>>
        +Long id
        +String unit
        +String name
        +String nameCn
        +BigDecimal jyRate
        +BigDecimal sellMinAmount
        +BigDecimal buyMinAmount
    }

    class MemberWallet {
        <<external>>
        +Long memberId
        +BigDecimal balance
        +BigDecimal frozenBalance
    }

    class Alipay {
        <<external>>
        +String aliNo
        +String qrCodeUrl
    }

    class WechatPay {
        <<external>>
        +String wechat
        +String qrCodeUrl
    }

    class BankInfo {
        <<external>>
        +String bank
        +String branch
        +String cardNo
        +String realName
    }

    class MemberAddress {
        <<external>>
        +Long id
        +String address
        +String remark
    }

    class Country {
        <<external>>
        +String zhName
        +String enName
    }

    %% Composition relationships
    OrderDetail "1" *-- "1" PayInfo : contains
    PayInfo "1" *-- "0..1" Alipay : includes
    PayInfo "1" *-- "0..1" WechatPay : includes
    PayInfo "1" *-- "0..1" BankInfo : includes

    %% Inheritance
    ChatMessageRecord --|> BaseMessage : extends

    %% Reference relationships
    PreOrderInfo "many" --> "1" OtcCoin : references
    OrderDetail "1" --> "1" Order : represents
    ScanOrder "1" --> "1" Order : summarizes
    ScanOrder "1" --> "1" Member : references
    ScanMemberAddress "1" --> "1" MemberAddress : transforms
    AppealApply "1" --> "1" Order : appeals
    ChatMessageRecord "many" --> "1" Order : discusses

    %% External entity relationships
    Order "many" --> "1" Advertise : created_from
    Order "many" --> "1" Member : member
    Order "many" --> "1" Member : customer
    Order "many" --> "1" OtcCoin : trades
    Advertise "many" --> "1" Member : created_by
    Advertise "many" --> "1" OtcCoin : offers
    Advertise "many" --> "1" Country : located_in
    MemberWallet "many" --> "1" Member : belongs_to
    MemberWallet "many" --> "1" OtcCoin : holds
    MemberAddress "many" --> "1" Member : belongs_to
    Member "1" --> "0..1" Alipay : has
    Member "1" --> "0..1" WechatPay : has
    Member "1" --> "0..1" BankInfo : has
```

## Entity Relationship Description

This class diagram illustrates the key entities in the OTC API service and their relationships:

### 1. Core API Entities

The main entities handled directly by the OTC API:

- **OrderDetail**: Comprehensive order information for API responses, containing all details needed for order management UI
- **PreOrderInfo**: Pre-transaction information displayed to users before order creation, including seller verification status and trading limits  
- **PayInfo**: Aggregates payment method information (Alipay, WeChat Pay, Bank Transfer) used in order transactions
- **ScanOrder**: Lightweight order representation optimized for list views and order history
- **ScanMemberAddress**: Cryptocurrency address information for scanning and validation
- **AppealApply**: Data transfer object for creating order appeals/disputes
- **ChatMessageRecord**: Real-time messaging between trading parties during order execution

### 2. Key Relationships

#### Composition Relationships
- **OrderDetail ↔ PayInfo**: OrderDetail contains PayInfo as a component, providing complete payment method details
- **PayInfo ↔ Payment Methods**: PayInfo aggregates multiple payment options (Alipay, WeChat, Bank) based on what the user supports

#### Transformation Relationships  
- **Order → OrderDetail**: Full Order entity is transformed into OrderDetail for API responses
- **Order → ScanOrder**: Order entities are summarized into ScanOrder for efficient listing views
- **MemberAddress → ScanMemberAddress**: External address entities are transformed for scanning operations

#### Reference Relationships
- **PreOrderInfo → OtcCoin**: References supported cryptocurrency information including trading rates and limits
- **ChatMessageRecord → Order**: Chat messages are linked to specific orders via orderSn for contextual communication
- **AppealApply → Order**: Appeal requests reference specific orders for dispute resolution

### 3. External Entity Integration

The API integrates with several external entities from core services:

#### User Management
- **Member**: Core user entity with verification status, transaction history, and payment method configurations
- **MemberWallet**: User cryptocurrency balances and frozen amounts for escrow functionality
- **MemberAddress**: User's cryptocurrency receiving addresses

#### Trading Core  
- **Order**: Full order entity with complete transaction lifecycle and financial details
- **Advertise**: Trading advertisements with terms, limits, and availability status
- **OtcCoin**: Supported cryptocurrencies with trading rates, minimum amounts, and market information

#### Geographic & Payment
- **Country**: Regional information for localized trading rules
- **Payment Methods**: External payment system integrations (Alipay, WeChat Pay, Banking)

### 4. Status Enumerations

The system uses several enumerations to manage entity states:

#### Trading States
- **AdvertiseType**: BUY (user wants to buy crypto) / SELL (user wants to sell crypto)
- **OrderStatus**: NONPAYMENT → PAID → COMPLETED (successful flow) or CANCELLED/APPEALED (failure flows)
- **AdvertiseControlStatus**: PUT_ON_SHELVES (available) / PUT_OFF_SHELVES (unavailable) / TURNOFF (deleted)

#### Verification States  
- **BooleanEnum**: IS_TRUE / IS_FALSE for user verification status indicators
- **MemberLevelEnum**: User verification levels determining trading privileges

### 5. Data Flow Patterns

#### Order Creation Flow
1. **PreOrderInfo** displays advertisement details and seller verification
2. User creates **Order** which generates **OrderDetail** for tracking
3. **PayInfo** provides payment methods based on **Member** configuration
4. **ChatMessageRecord** entries enable communication during transaction

#### Advertisement Management Flow
1. **Member** creates **Advertise** for **OtcCoin** in specific **Country**
2. **MemberWallet** balance is frozen when advertisement goes on shelves
3. **PreOrderInfo** exposes advertisement details to potential buyers
4. Background jobs monitor and auto-manage advertisement status

#### Appeal and Resolution Flow
1. **AppealApply** creates formal dispute for problematic **Order**
2. **ChatMessageRecord** preserves communication history for dispute resolution
3. System tracks appeal status through **OrderStatus** updates

This diagram provides a comprehensive view of how the OTC API manages the complex relationships between users, trading entities, and external system integrations while maintaining data consistency and transaction integrity across the distributed trading platform.
