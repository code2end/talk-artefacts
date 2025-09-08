# Exchange Service Entity Relationship Diagram

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

    class ExchangeTrade {
        +String symbol
        +BigDecimal price
        +BigDecimal amount
        +BigDecimal buyTurnover
        +BigDecimal sellTurnover
        +ExchangeOrderDirection direction
        +String buyOrderId
        +String sellOrderId
        +Long time
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

    class CoinTrader {
        +String symbol
        +TreeMap~BigDecimal,MergeOrder~ buyLimitPriceQueue
        +TreeMap~BigDecimal,MergeOrder~ sellLimitPriceQueue
        +LinkedList~ExchangeOrder~ buyMarketQueue
        +LinkedList~ExchangeOrder~ sellMarketQueue
        +TradePlate sellTradePlate
        +TradePlate buyTradePlate
        +boolean tradingHalt
        +boolean ready
        +ExchangeCoinPublishType publishType
        +String clearTime
        +trade(ExchangeOrder)
        +cancelOrder(ExchangeOrder)
        +addLimitPriceOrder(ExchangeOrder)
        +addMarketPriceOrder(ExchangeOrder)
    }

    class MergeOrder {
        +List~ExchangeOrder~ orders
        +add(ExchangeOrder)
        +get() ExchangeOrder
        +size() int
        +getPrice() BigDecimal
        +getTotalAmount() BigDecimal
        +iterator() Iterator~ExchangeOrder~
    }

    class TradePlate {
        +LinkedList~TradePlateItem~ items
        +int maxDepth
        +ExchangeOrderDirection direction
        +String symbol
        +add(ExchangeOrder) boolean
        +remove(ExchangeOrder, BigDecimal)
        +getHighestPrice() BigDecimal
        +getLowestPrice() BigDecimal
        +getMaxAmount() BigDecimal
        +getMinAmount() BigDecimal
        +getDepth() int
        +toJSON() JSONObject
    }

    class TradePlateItem {
        +BigDecimal price
        +BigDecimal amount
    }

    class CoinTraderFactory {
        +ConcurrentHashMap~String,CoinTrader~ traderMap
        +addTrader(String, CoinTrader)
        +getTrader(String) CoinTrader
        +containsTrader(String) boolean
        +resetTrader(String, CoinTrader)
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

    %% Relationships
    ExchangeCoin "1" --> "1" CoinTrader : configures
    CoinTrader "1" --> "many" ExchangeOrder : manages
    CoinTrader "1" --> "2" TradePlate : maintains
    CoinTrader "1" --> "many" MergeOrder : organizes_by_price
    MergeOrder "1" --> "many" ExchangeOrder : contains
    TradePlate "1" --> "many" TradePlateItem : aggregates
    ExchangeOrder "many" --> "many" ExchangeTrade : participates_in
    CoinTraderFactory "1" --> "many" CoinTrader : creates_and_manages
    
    ExchangeOrder --> ExchangeOrderType : has_type
    ExchangeOrder --> ExchangeOrderDirection : has_direction
    ExchangeOrder --> ExchangeOrderStatus : has_status
    ExchangeCoin --> ExchangeCoinPublishType : has_publish_type
    TradePlate --> ExchangeOrderDirection : has_direction
```

## Entity Relationship Description

This class diagram illustrates the key entities in the Exchange Service and their relationships:

### 1. Core Entities

- **ExchangeOrder**: The fundamental unit representing a user's buy or sell request with price, quantity, and execution details
- **ExchangeTrade**: A completed transaction record created when two compatible orders are matched and executed
- **ExchangeCoin**: Configuration entity defining trading rules, limits, and behaviors for each trading pair
- **CoinTrader**: The core trading engine that processes orders and maintains order books for a single trading pair
- **TradePlate**: Real-time market depth representation showing aggregated order volumes at different price levels

### 2. Key Relationships

- **ExchangeCoin ↔ CoinTrader (1:1)**: Each trading pair has exactly one dedicated trading engine configured with its specific rules
- **CoinTrader ↔ ExchangeOrder (1:Many)**: Each engine manages all active orders for its trading pair, organizing them in price-time priority queues
- **CoinTrader ↔ TradePlate (1:2)**: Each engine maintains separate buy and sell order book depth representations
- **ExchangeOrder ↔ ExchangeTrade (Many:Many)**: Orders can participate in multiple trades during partial execution, and each trade involves exactly two orders
- **MergeOrder ↔ ExchangeOrder (1:Many)**: Orders at identical price levels are grouped together and processed in FIFO order

### 3. Embedded Objects

- **TradePlateItem**: Price-volume pairs that make up the order book depth display
- **MergeOrder**: Container grouping orders at the same price level within the trading engine's order queues
- **CoinTraderFactory**: Singleton factory managing multiple trading engines across different trading pairs

### 4. Status Enumerations

- **ExchangeOrderType**: MARKET_PRICE (immediate execution), LIMIT_PRICE (specific price execution)
- **ExchangeOrderDirection**: BUY (purchase orders), SELL (sale orders)  
- **ExchangeOrderStatus**: TRADING (active), COMPLETED (fully executed), CANCELED (user cancelled), OVERTIMED (expired)
- **ExchangeCoinPublishType**: NONE (normal trading), QIANGGOU (flash sale), FENTAN (proportional distribution)

### 5. Data Flow and Processing

The relationships support the following data flow:
1. **Configuration Loading**: ExchangeCoin configurations initialize CoinTrader engines
2. **Order Processing**: Incoming ExchangeOrders are assigned to appropriate CoinTrader engines
3. **Order Organization**: Orders are grouped by price level (MergeOrder) and maintained in priority queues
4. **Trade Matching**: Compatible orders are matched and ExchangeTrade records are created
5. **Market Data**: TradePlate structures are updated to reflect current market depth
6. **State Management**: Order statuses are updated and completion notifications are sent

This diagram provides a visual representation of the actual data model relationships in the codebase, emphasizing the central role of the CoinTrader as the orchestrator of all trading activity for a specific trading pair.
