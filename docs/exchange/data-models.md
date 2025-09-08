# Exchange Service Data Models

This document describes the core data models of the Exchange Service and their relationships.

## Core Entities

### 1. ExchangeOrder

Represents a buy or sell order placed by a user for a specific trading pair.

```java
public class ExchangeOrder {
    private String orderId;              // Unique order identifier
    private Long memberId;               // User who placed the order
    private ExchangeOrderType type;      // MARKET_PRICE or LIMIT_PRICE
    private BigDecimal amount;           // Order quantity (for limit orders) or budget (for market buy orders)
    private String symbol;               // Trading pair symbol (e.g., "BTC/USDT")
    private BigDecimal tradedAmount;     // Amount that has been executed
    private BigDecimal turnover;         // Total value of executed trades
    private String coinSymbol;           // Trading coin symbol (e.g., "BTC")
    private String baseSymbol;           // Base currency symbol (e.g., "USDT")
    private ExchangeOrderStatus status;  // TRADING, COMPLETED, CANCELED, OVERTIMED
    private ExchangeOrderDirection direction; // BUY or SELL
    private BigDecimal price;            // Limit price (for limit orders)
    private Long time;                   // Order creation timestamp
    private Long completedTime;          // Order completion timestamp
    private Long canceledTime;           // Order cancellation timestamp
    private String useDiscount;          // Whether to use trading fee discount
    private List<ExchangeOrderDetail> detail; // Order execution details
}
```

### 2. ExchangeTrade

Represents a completed trade transaction between two orders.

```java
public class ExchangeTrade {
    private String symbol;              // Trading pair symbol
    private BigDecimal price;           // Trade execution price
    private BigDecimal amount;          // Trade quantity
    private BigDecimal buyTurnover;     // Value for buy side
    private BigDecimal sellTurnover;    // Value for sell side
    private ExchangeOrderDirection direction; // Trade direction from taker perspective
    private String buyOrderId;          // Buy order identifier
    private String sellOrderId;         // Sell order identifier
    private Long time;                  // Trade execution timestamp
}
```

### 3. ExchangeCoin

Defines a trading pair configuration and its trading rules.

```java
public class ExchangeCoin {
    private String symbol;              // Trading pair symbol (primary key)
    private String coinSymbol;          // Trading coin symbol
    private String baseSymbol;          // Base currency symbol
    private int enable;                 // 1=enabled, 2=disabled
    private BigDecimal fee;             // Trading fee rate
    private int sort;                   // Display sort order
    private int coinScale;              // Trading coin decimal precision
    private int baseCoinScale;          // Base coin decimal precision
    private BigDecimal minSellPrice;    // Minimum sell price
    private BigDecimal maxBuyPrice;     // Maximum buy price
    private BooleanEnum enableMarketSell; // Whether market sell orders are allowed
    private BooleanEnum enableMarketBuy;  // Whether market buy orders are allowed
    private int maxTradingTime;         // Order timeout in seconds (0=no timeout)
    private int maxTradingOrder;        // Max concurrent orders per user (0=unlimited)
    private int robotType;              // Trading bot configuration type
    private int flag;                   // Feature flags (0=default, 1=recommended)
    private BigDecimal minTurnover;     // Minimum trade value
    private int zone;                   // Trading zone identifier
    private BigDecimal minVolume;       // Minimum order size
    private BigDecimal maxVolume;       // Maximum order size
    private ExchangeCoinPublishType publishType; // Special trading mode
    private String startTime;           // Activity start time
    private String endTime;             // Activity end time
    private String clearTime;           // Settlement time
    private BigDecimal publishPrice;    // Fixed price for special modes
    private BigDecimal publishAmount;   // Available quantity for special modes
    private int visible;                // Frontend visibility (1=visible, 2=hidden)
    private int exchangeable;           // Whether trading is allowed
}
```

### 4. TradePlate

Represents the order book depth for a specific trading direction (buy or sell).

```java
public class TradePlate {
    private LinkedList<TradePlateItem> items; // Ordered list of price levels
    private int maxDepth;               // Maximum number of price levels (default 100)
    private ExchangeOrderDirection direction; // BUY or SELL
    private String symbol;              // Trading pair symbol
}
```

### 5. TradePlateItem

Represents a single price level in the order book with aggregated volume.

```java
public class TradePlateItem {
    private BigDecimal price;           // Price level
    private BigDecimal amount;          // Total volume at this price level
}
```

### 6. MergeOrder

Container for multiple orders at the same price level within the order book.

```java
public class MergeOrder {
    private List<ExchangeOrder> orders; // Orders at same price level (FIFO ordered)
}
```

### 7. CoinTrader

The core trading engine that maintains order books and processes trades for a single trading pair.

```java
public class CoinTrader {
    private String symbol;              // Trading pair this engine handles
    private TreeMap<BigDecimal,MergeOrder> buyLimitPriceQueue;  // Buy orders (price descending)
    private TreeMap<BigDecimal,MergeOrder> sellLimitPriceQueue; // Sell orders (price ascending)
    private LinkedList<ExchangeOrder> buyMarketQueue;  // Market buy orders (time ordered)
    private LinkedList<ExchangeOrder> sellMarketQueue; // Market sell orders (time ordered)
    private TradePlate sellTradePlate;  // Sell side order book depth
    private TradePlate buyTradePlate;   // Buy side order book depth
    private boolean tradingHalt;        // Whether trading is paused
    private boolean ready;              // Whether engine is ready to process orders
    private ExchangeCoinPublishType publishType; // Special trading mode
    private String clearTime;           // Settlement time for special modes
}
```

## Relationships

1. **ExchangeOrder to ExchangeTrade**: One-to-Many
   - Each order can participate in multiple trades as it gets partially filled
   - Each trade references exactly two orders (buy and sell)

2. **ExchangeCoin to CoinTrader**: One-to-One
   - Each trading pair has exactly one trading engine instance
   - Trading engine configuration is derived from ExchangeCoin settings

3. **CoinTrader to ExchangeOrder**: One-to-Many
   - Each trading engine manages all active orders for its trading pair
   - Orders are organized in price-time priority queues

4. **TradePlate to TradePlateItem**: One-to-Many
   - Each order book side contains multiple price levels
   - Price levels are ordered by price (ascending for sells, descending for buys)

5. **MergeOrder to ExchangeOrder**: One-to-Many
   - Orders at the same price level are grouped together
   - Orders within a price level are processed in FIFO order

## Status Enumerations

### ExchangeOrderType
- **MARKET_PRICE**: Order executes immediately at best available price
- **LIMIT_PRICE**: Order executes only at specified price or better

### ExchangeOrderDirection  
- **BUY**: Purchase order (bids)
- **SELL**: Sale order (asks)

### ExchangeOrderStatus
- **TRADING**: Order is active and can be matched
- **COMPLETED**: Order has been fully executed
- **CANCELED**: Order was cancelled before full execution
- **OVERTIMED**: Order expired due to time limits

### ExchangeCoinPublishType
- **NONE**: Normal trading mode
- **QIANGGOU**: Flash sale mode (first-come-first-served)
- **FENTAN**: Distribution mode (proportional allocation)

## Processing Flow

The typical processing flow involving these entities:

1. **Order Placement**: ExchangeOrder created with initial state
2. **Engine Assignment**: CoinTrader for the trading pair receives the order
3. **Order Book Update**: Order added to appropriate queue (limit/market, buy/sell)
4. **Order Matching**: Engine matches compatible orders
5. **Trade Execution**: ExchangeTrade records created for successful matches
6. **Order Update**: Participating ExchangeOrders updated with execution details
7. **Market Data**: TradePlate updated to reflect new market depth
8. **Completion**: Fully executed orders marked as COMPLETED

The system maintains strict consistency between order states, trade records, and market depth information through synchronized processing within each trading engine.
