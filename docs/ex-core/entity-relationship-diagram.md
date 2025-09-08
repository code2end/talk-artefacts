# Exchange Core Entity Relationship Diagram

```mermaid
classDiagram
    class ExchangeOrder {
        +String orderId (PK)
        +Long memberId (FK)
        +ExchangeOrderType type
        +BigDecimal amount
        +String symbol (FK)
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

    class ExchangeTrade {
        +String symbol
        +BigDecimal price
        +BigDecimal amount
        +BigDecimal buyTurnover
        +BigDecimal sellTurnover
        +ExchangeOrderDirection direction
        +String buyOrderId (FK)
        +String sellOrderId (FK)
        +Long time
    }

    class ExchangeCoin {
        +String symbol (PK)
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
        +String orderId (FK)
        +BigDecimal price
        +BigDecimal amount
        +BigDecimal turnover
        +BigDecimal fee
        +long time
    }

    class KLine {
        +BigDecimal openPrice
        +BigDecimal highestPrice
        +BigDecimal lowestPrice
        +BigDecimal closePrice
        +long time
        +String period
        +int count
        +BigDecimal volume
        +BigDecimal turnover
    }

    class CoinThumb {
        +String symbol
        +BigDecimal open
        +BigDecimal high
        +BigDecimal low
        +BigDecimal close
        +BigDecimal chg
        +BigDecimal change
        +BigDecimal volume
        +BigDecimal turnover
        +BigDecimal lastDayClose
        +BigDecimal usdRate
        +BigDecimal baseUsdRate
        +int zone
    }

    class TradePlate {
        +LinkedList~TradePlateItem~ items
        +int maxDepth
        +ExchangeOrderDirection direction
        +String symbol
        +add(ExchangeOrder order) boolean
        +remove(ExchangeOrder order)
        +getHighestPrice() BigDecimal
        +getLowestPrice() BigDecimal
        +getMaxAmount() BigDecimal
        +getMinAmount() BigDecimal
    }

    class TradePlateItem {
        +BigDecimal price
        +BigDecimal amount
    }

    class FavorSymbol {
        +Long id (PK)
        +String symbol (FK)
        +Long memberId (FK)
        +String addTime
    }

    class OrderDetailAggregation {
        +OrderTypeEnum type
        +double amount
        +double fee
        +Long time
        +ExchangeOrderDirection direction
        +String orderId (FK)
        +String unit
        +Long memberId (FK)
        +String username
        +String realName
    }

    class Member {
        +Long id (PK)
        +String username
        +String realName
        +Long inviterId (FK)
        +Date registrationTime
    }

    class MergeOrder {
        +BigDecimal price
        +BigDecimal amount
        +ExchangeOrderDirection direction
    }

    class TempWealthInfo {
        +String symbol
        +BigDecimal totalWealth
    }

    %% Relationships
    ExchangeCoin ||--o{ ExchangeOrder : "trading pair has many orders"
    ExchangeOrder ||--o{ ExchangeOrderDetail : "order has many execution details"
    ExchangeOrder }|--|| ExchangeTrade : "orders participate in trades"
    Member ||--o{ ExchangeOrder : "member places many orders"
    Member ||--o{ FavorSymbol : "member has favorite symbols"
    ExchangeCoin ||--o{ FavorSymbol : "trading pair can be favorited"
    ExchangeOrder ||--o{ OrderDetailAggregation : "order generates aggregation records"
    Member ||--o{ OrderDetailAggregation : "member generates aggregations"
    TradePlate ||--o{ TradePlateItem : "trade plate contains price levels"
    ExchangeCoin ||--|| CoinThumb : "trading pair has ticker data"
    ExchangeCoin ||--o{ KLine : "trading pair has K-line data"
    Member ||--o{ Member : "referral relationship"

    %% Enumerations
    class ExchangeOrderType {
        <<enumeration>>
        MARKET_PRICE
        LIMIT_PRICE
    }

    class ExchangeOrderStatus {
        <<enumeration>>
        TRADING
        COMPLETED
        CANCELED
        OVERTIMED
    }

    class ExchangeOrderDirection {
        <<enumeration>>
        BUY
        SELL
    }

    class ExchangeCoinPublishType {
        <<enumeration>>
        NONE
        RUSH_PUBLISH
        SHARE_PUBLISH
    }

    class OrderTypeEnum {
        <<enumeration>>
        EXCHANGE
    }

    %% Enum relationships
    ExchangeOrder }|--|| ExchangeOrderType : "has type"
    ExchangeOrder }|--|| ExchangeOrderStatus : "has status"
    ExchangeOrder }|--|| ExchangeOrderDirection : "has direction"
    ExchangeTrade }|--|| ExchangeOrderDirection : "has direction"
    TradePlate }|--|| ExchangeOrderDirection : "has direction"
    OrderDetailAggregation }|--|| ExchangeOrderDirection : "has direction"
    OrderDetailAggregation }|--|| OrderTypeEnum : "has type"
    ExchangeCoin }|--|| ExchangeCoinPublishType : "has publish type"
```

## Entity Relationship Description

This class diagram illustrates the key entities in the Exchange Core module and their relationships:

### 1. Core Entities

#### **ExchangeOrder**
The central entity representing trading orders placed by users. Contains comprehensive order information including type, amount, price, status, and timestamps. Implements business logic for determining order completion status.

#### **ExchangeTrade** 
Represents completed trade transactions that result from matching buy and sell orders. Links to both buy and sell orders and contains execution details including price, amount, and turnover values.

#### **ExchangeCoin**
Configuration entity for trading pairs that defines market rules, trading parameters, fees, and operational settings. Serves as the foundation for all trading operations on a specific cryptocurrency pair.

#### **ExchangeOrderDetail**
Granular execution records stored in MongoDB that track individual fills of an order. Provides detailed audit trail of how orders are executed over time.

### 2. Key Relationships

#### **Order-to-Trade Relationships**
- **ExchangeOrder to ExchangeTrade**: Many-to-many relationship where orders participate in trades as either buy or sell side
- **ExchangeOrder to ExchangeOrderDetail**: One-to-many relationship tracking all partial executions of an order

#### **Configuration Relationships**
- **ExchangeCoin to ExchangeOrder**: One-to-many relationship where trading pair configuration governs order rules and parameters
- **ExchangeCoin to CoinThumb**: One-to-one relationship providing real-time market statistics for each trading pair
- **ExchangeCoin to KLine**: One-to-many relationship storing historical candlestick data

#### **User Relationships**
- **Member to ExchangeOrder**: One-to-many relationship tracking all orders placed by a user
- **Member to FavorSymbol**: One-to-many relationship storing user's favorite trading pairs
- **Member to Member**: Self-referencing relationship for referral hierarchies

### 3. Market Data Entities

#### **TradePlate & TradePlateItem**
Composite structure representing order book depth with TradePlate containing ordered lists of TradePlateItem objects representing price levels and their aggregated volumes.

#### **KLine**
Time-series data entity storing OHLCV (Open, High, Low, Close, Volume) information for technical analysis across different time periods.

#### **CoinThumb**
Real-time market ticker providing current price, volume, and change statistics for trading pairs.

### 4. Analytics and Aggregation

#### **OrderDetailAggregation**
MongoDB-stored aggregation records that provide summarized trading data for analytics, reporting, and business intelligence purposes.

### 5. Status Enumerations

#### **ExchangeOrderType**
- **MARKET_PRICE**: Orders executed at current market price
- **LIMIT_PRICE**: Orders with specific price requirements

#### **ExchangeOrderStatus** 
- **TRADING**: Active orders available for matching
- **COMPLETED**: Fully executed orders
- **CANCELED**: Orders cancelled before completion
- **OVERTIMED**: Orders that expired due to timeout

#### **ExchangeOrderDirection**
- **BUY**: Purchase orders
- **SELL**: Sale orders

#### **ExchangeCoinPublishType**
- **NONE**: Standard trading mode
- **RUSH_PUBLISH**: Special rush purchase events
- **SHARE_PUBLISH**: Share-based distribution events

### 6. Data Storage Strategy

The entity design reflects a hybrid storage approach:
- **MySQL**: Transactional data requiring ACID properties (orders, trades, configuration)
- **MongoDB**: Time-series and analytical data (order details, aggregations, market data)

### 7. Business Process Flow

The relationships support the complete trading lifecycle:
1. **Order Placement**: User creates ExchangeOrder referencing ExchangeCoin configuration
2. **Order Book Management**: Orders populate TradePlate structures for matching
3. **Trade Execution**: Successful matches create ExchangeTrade records
4. **Settlement**: ExchangeOrderDetail records track individual executions
5. **Aggregation**: OrderDetailAggregation provides analytical summaries
6. **Market Data**: KLine and CoinThumb entities updated with trade information

This diagram provides a visual representation of the actual data model relationships in the Exchange Core codebase, showing how cryptocurrency trading operations are modeled and managed within the system.
