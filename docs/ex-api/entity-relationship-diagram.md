# Exchange API Entity Relationship Diagram

```mermaid
classDiagram
    class ExchangeOrder {
        +String orderId
        +Long memberId
        +ExchangeOrderType type
        +BigDecimal amount
        +String symbol
        +BigDecimal tradedAmount
        +BigDecimal turnover
        +String coinSymbol
        +String baseSymbol
        +ExchangeOrderStatus status
        +ExchangeOrderDirection direction
        +BigDecimal price
        +Long time
        +Long completedTime
        +Long canceledTime
        +String useDiscount
        +isCompleted() boolean
    }

    class ExchangeCoin {
        +String symbol
        +String coinSymbol
        +String baseSymbol
        +int enable
        +BigDecimal fee
        +int sort
        +int coinScale
        +int baseCoinScale
        +BigDecimal minSellPrice
        +BigDecimal maxBuyPrice
        +BooleanEnum enableMarketSell
        +BooleanEnum enableMarketBuy
        +int maxTradingTime
        +int maxTradingOrder
        +int robotType
        +int flag
        +BigDecimal minTurnover
        +int zone
        +BigDecimal minVolume
        +BigDecimal maxVolume
        +ExchangeCoinPublishType publishType
        +String startTime
        +String endTime
        +String clearTime
        +BigDecimal publishPrice
        +BigDecimal publishAmount
        +int visible
        +int exchangeable
    }

    class ExchangeOrderDetail {
        +String orderId
        +BigDecimal price
        +BigDecimal amount
        +BigDecimal turnover
        +BigDecimal fee
        +Long time
    }

    class FavorSymbol {
        +Long id
        +Long memberId
        +String symbol
        +Long addTime
    }

    class Member {
        +Long id
        +String username
        +MemberLevelEnum memberLevel
        +BooleanEnum transactionStatus
    }

    class MemberWallet {
        +Long id
        +Long memberId
        +String coinUnit
        +BigDecimal balance
        +BigDecimal frozenBalance
        +BooleanEnum isLock
    }

    class Coin {
        +String unit
        +String name
        +int status
        +int sort
    }

    class ExchangeOrderType {
        <<enumeration>>
        MARKET_PRICE
        LIMIT_PRICE
    }

    class ExchangeOrderDirection {
        <<enumeration>>
        BUY
        SELL
    }

    class ExchangeOrderStatus {
        <<enumeration>>
        TRADING
        COMPLETED
        CANCELED
        OVERTIMED
    }

    class ExchangeCoinPublishType {
        <<enumeration>>
        NONE
        QIANGGOU
        FENTAN
    }

    class BooleanEnum {
        <<enumeration>>
        IS_TRUE
        IS_FALSE
    }

    class MemberLevelEnum {
        <<enumeration>>
        GENERAL
        REALNAME
        ENTERPRISE
    }

    %% Primary Relationships
    ExchangeOrder "many" --> "1" Member : belongs to
    ExchangeOrder "many" --> "1" ExchangeCoin : placed for
    ExchangeOrder "1" --> "many" ExchangeOrderDetail : contains
    FavorSymbol "many" --> "1" Member : owned by
    Member "1" --> "many" MemberWallet : has wallets
    
    %% Enum Relationships
    ExchangeOrder --> ExchangeOrderType
    ExchangeOrder --> ExchangeOrderDirection
    ExchangeOrder --> ExchangeOrderStatus
    ExchangeCoin --> ExchangeCoinPublishType
    ExchangeCoin --> BooleanEnum
    Member --> MemberLevelEnum
    Member --> BooleanEnum
    MemberWallet --> BooleanEnum

    %% Implicit Relationships (via foreign keys/symbols)
    FavorSymbol "many" -.-> "1" ExchangeCoin : references via symbol
    ExchangeCoin "many" -.-> "1" Coin : trading coin
    ExchangeCoin "many" -.-> "1" Coin : base coin
    MemberWallet "many" -.-> "1" Coin : coin type
```

## Entity Relationship Description

This class diagram illustrates the key entities in the Exchange API Service and their relationships:

### 1. Core Entities

- **ExchangeOrder**: The central entity representing trading orders with comprehensive order lifecycle management
- **ExchangeCoin**: Configuration entity defining trading pairs, rules, and constraints
- **Member**: User entity representing traders in the system  
- **ExchangeOrderDetail**: Detailed execution records for partial order fulfillment
- **FavorSymbol**: User preference entity for maintaining watchlists
- **MemberWallet**: User balance management for different cryptocurrencies
- **Coin**: Cryptocurrency definition and configuration

### 2. Key Relationships

#### Primary Foreign Key Relationships:
- **ExchangeOrder ↔ Member** (Many-to-One): Each order belongs to a specific user
- **ExchangeOrder ↔ ExchangeCoin** (Many-to-One): Each order is placed for a specific trading pair
- **ExchangeOrder ↔ ExchangeOrderDetail** (One-to-Many): Orders can have multiple execution details
- **FavorSymbol ↔ Member** (Many-to-One): Each favorite belongs to a user
- **Member ↔ MemberWallet** (One-to-Many): Users can have multiple cryptocurrency wallets

#### Implicit Relationships (via symbols/references):
- **FavorSymbol ↔ ExchangeCoin**: Favorites reference trading pairs by symbol
- **ExchangeCoin ↔ Coin**: Trading pairs reference both trading coin and base coin
- **MemberWallet ↔ Coin**: Wallets are associated with specific cryptocurrencies

### 3. Embedded Objects

- **Authentication Context**: Member information is embedded in API requests via session authentication
- **Pagination Objects**: Standard Spring Data pagination wrappers for list responses
- **Transient Fields**: Non-persistent computed fields like order completion status

### 4. Status Enumerations

- **ExchangeOrderType**: MARKET_PRICE (immediate execution), LIMIT_PRICE (conditional execution)
- **ExchangeOrderDirection**: BUY (purchase orders), SELL (sale orders)  
- **ExchangeOrderStatus**: TRADING (active), COMPLETED (fulfilled), CANCELED (user cancelled), OVERTIMED (expired)
- **ExchangeCoinPublishType**: NONE (normal trading), QIANGGOU (flash sale), FENTAN (proportional distribution)
- **BooleanEnum**: IS_TRUE/IS_FALSE for feature toggles and status flags
- **MemberLevelEnum**: GENERAL (basic), REALNAME (verified), ENTERPRISE (corporate)

### 5. Business Rules Encoded in Relationships

#### Order Validation Rules:
- Orders must reference valid trading pairs (ExchangeCoin.enable = 1)
- Users must have sufficient wallet balance for order placement
- Order amounts must respect min/max volume constraints from ExchangeCoin
- Special trading modes (QIANGGOU/FENTAN) enforce time-based restrictions

#### Data Consistency Rules:
- Order status transitions follow strict state machine rules
- Wallet balances are locked during active orders (frozenBalance)
- Order details maintain audit trail of all partial executions
- Trading pair visibility controls frontend display independent of trading availability

#### Security and Access Control:
- All order operations are scoped to authenticated Member
- Order cancellation restricted to order owner
- Special mock endpoints restricted to specific admin user IDs
- Session-based authentication with member context propagation

This diagram provides a visual representation of the actual data model relationships implemented in the Exchange API codebase, emphasizing both explicit JPA relationships and implicit business logic connections.
