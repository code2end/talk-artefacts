# Exchange Core Data Models

This document describes the core data models of the Exchange Core module and their relationships.

## Core Entities

### 1. ExchangeOrder

The central entity representing a trading order placed by a user for buying or selling cryptocurrency.

```java
@Entity
public class ExchangeOrder {
    @Id
    private String orderId;                    // Unique order identifier
    private Long memberId;                     // User ID who placed the order
    private ExchangeOrderType type;            // MARKET_PRICE or LIMIT_PRICE
    private BigDecimal amount;                 // Order quantity/amount
    private String symbol;                     // Trading pair symbol (e.g., BTC/USDT)
    private BigDecimal tradedAmount;           // Amount already executed
    private BigDecimal turnover;               // Total transaction value
    private String coinSymbol;                 // Trading cryptocurrency symbol
    private String baseSymbol;                 // Base currency symbol
    private ExchangeOrderStatus status;        // Order status
    private ExchangeOrderDirection direction;  // BUY or SELL
    private BigDecimal price;                  // Order price (for limit orders)
    private Long time;                         // Order placement timestamp
    private Long completedTime;                // Order completion timestamp
    private Long canceledTime;                 // Order cancellation timestamp
    private String useDiscount;                // Discount usage flag
}
```

### 2. ExchangeTrade

Represents a completed trade transaction resulting from order matching.

```java
public class ExchangeTrade {
    private String symbol;                     // Trading pair symbol
    private BigDecimal price;                  // Trade execution price
    private BigDecimal amount;                 // Trade quantity
    private BigDecimal buyTurnover;            // Buy side transaction value
    private BigDecimal sellTurnover;           // Sell side transaction value
    private ExchangeOrderDirection direction;  // Trade direction
    private String buyOrderId;                 // Buy order ID
    private String sellOrderId;                // Sell order ID
    private Long time;                         // Trade execution timestamp
}
```

### 3. ExchangeCoin

Configuration entity for trading pairs, defining market rules and parameters.

```java
@Entity
public class ExchangeCoin {
    @Id
    private String symbol;                     // Trading pair symbol (primary key)
    private String coinSymbol;                 // Trading cryptocurrency symbol
    private String baseSymbol;                 // Base currency symbol
    private int enable;                        // Enable status (1=enabled, 2=disabled)
    private BigDecimal fee;                    // Trading fee rate
    private int sort;                          // Display sort order
    private int coinScale;                     // Trading coin decimal precision
    private int baseCoinScale;                 // Base coin decimal precision
    private BigDecimal minSellPrice;           // Minimum sell price
    private BigDecimal maxBuyPrice;            // Maximum buy price
    private BooleanEnum enableMarketSell;      // Market sell enabled flag
    private BooleanEnum enableMarketBuy;       // Market buy enabled flag
    private int maxTradingTime;                // Order timeout in seconds
    private int maxTradingOrder;               // Max concurrent orders per user
    private int robotType;                     // Trading bot type
    private int flag;                          // Recommendation flag
    private BigDecimal minTurnover;            // Minimum transaction value
    private int zone;                          // Trading zone
    private BigDecimal minVolume;              // Minimum order volume
    private BigDecimal maxVolume;              // Maximum order volume
    private ExchangeCoinPublishType publishType; // Publishing type
    private String startTime;                  // Activity start time
    private String endTime;                    // Activity end time
    private String clearTime;                  // Settlement time
    private BigDecimal publishPrice;           // Publishing price
    private BigDecimal publishAmount;          // Publishing amount
    private int visible;                       // Frontend visibility
    private int exchangeable;                  // Trading allowed flag
}
```

### 4. ExchangeOrderDetail

Individual trade execution details for an order, stored in MongoDB for analytics.

```java
@Document(collection = "exchange_order_detail")
public class ExchangeOrderDetail {
    private String orderId;                    // Reference to ExchangeOrder
    private BigDecimal price;                  // Execution price
    private BigDecimal amount;                 // Execution quantity
    private BigDecimal turnover;               // Execution value
    private BigDecimal fee;                    // Trading fee charged
    private long time;                         // Execution timestamp
}
```

### 5. KLine

Candlestick chart data for technical analysis and market visualization.

```java
public class KLine {
    private BigDecimal openPrice;              // Opening price
    private BigDecimal highestPrice;           // Highest price in period
    private BigDecimal lowestPrice;            // Lowest price in period
    private BigDecimal closePrice;             // Closing price
    private long time;                         // Time period timestamp
    private String period;                     // Time period (1m, 5m, 1h, 1d, etc.)
    private int count;                         // Number of trades
    private BigDecimal volume;                 // Trading volume
    private BigDecimal turnover;               // Trading turnover
}
```

### 6. TradePlate

Order book depth information representing buy/sell order aggregation by price level.

```java
public class TradePlate {
    private LinkedList<TradePlateItem> items;  // Ordered price levels
    private int maxDepth;                      // Maximum depth (default 100)
    private ExchangeOrderDirection direction;  // BUY or SELL side
    private String symbol;                     // Trading pair symbol
}
```

### 7. TradePlateItem

Individual price level within the order book.

```java
public class TradePlateItem {
    private BigDecimal price;                  // Price level
    private BigDecimal amount;                 // Aggregated quantity at this price
}
```

### 8. CoinThumb

Market ticker data providing current market statistics for a trading pair.

```java
public class CoinThumb {
    private String symbol;                     // Trading pair symbol
    private BigDecimal open;                   // Opening price (24h)
    private BigDecimal high;                   // Highest price (24h)
    private BigDecimal low;                    // Lowest price (24h)
    private BigDecimal close;                  // Current/closing price
    private BigDecimal chg;                    // Price change amount
    private BigDecimal change;                 // Price change percentage
    private BigDecimal volume;                 // Trading volume (24h)
    private BigDecimal turnover;               // Trading turnover (24h)
    private BigDecimal lastDayClose;           // Previous day closing price
    private BigDecimal usdRate;                // Trading coin to USD rate
    private BigDecimal baseUsdRate;            // Base coin to USD rate
    private int zone;                          // Trading zone
}
```

### 9. FavorSymbol

User's favorite trading pairs for personalized experience.

```java
@Entity
@Table(name="exchange_favor_symbol")
public class FavorSymbol {
    @Id
    @GeneratedValue
    private Long id;                           // Primary key
    private String symbol;                     // Trading pair symbol
    private Long memberId;                     // User ID
    private String addTime;                    // Addition timestamp
}
```

### 10. OrderDetailAggregation

Aggregated order details stored in MongoDB for analytics and reporting.

```java
@Document
public class OrderDetailAggregation {
    private OrderTypeEnum type;                // Order type (EXCHANGE)
    private double amount;                     // Order amount
    private double fee;                        // Fee charged
    private Long time;                         // Timestamp
    private ExchangeOrderDirection direction;  // Order direction
    private String orderId;                    // Order reference
    private String unit;                       // Currency unit
    private Long memberId;                     // User ID
    private String username;                   // Username
    private String realName;                   // User's real name
}
```

## Relationships

1. **ExchangeOrder to ExchangeOrderDetail**: One-to-Many
   - Each order can have multiple execution details as it gets partially filled

2. **ExchangeOrder to ExchangeTrade**: Many-to-Many
   - Multiple orders can participate in a single trade (buyer and seller)

3. **ExchangeCoin to ExchangeOrder**: One-to-Many
   - Each trading pair configuration supports multiple orders

4. **Member to ExchangeOrder**: One-to-Many
   - Each user can place multiple orders

5. **ExchangeOrder to OrderDetailAggregation**: One-to-Many
   - Each order generates aggregation records for analytics

6. **Member to FavorSymbol**: One-to-Many
   - Each user can have multiple favorite trading pairs

7. **TradePlate to TradePlateItem**: One-to-Many
   - Each order book side contains multiple price levels

## Status Enumerations

### ExchangeOrderStatus
- **TRADING**: Order is active and available for matching
- **COMPLETED**: Order has been fully executed
- **CANCELED**: Order was cancelled before completion
- **OVERTIMED**: Order expired due to timeout

### ExchangeOrderType
- **MARKET_PRICE**: Market order executed at current market price
- **LIMIT_PRICE**: Limit order with specified price

### ExchangeOrderDirection
- **BUY**: Purchase order
- **SELL**: Sale order

### ExchangeCoinPublishType
- **NONE**: No special publishing activity
- **RUSH_PUBLISH**: Rush purchase publishing
- **SHARE_PUBLISH**: Share-based publishing

### OrderTypeEnum
- **EXCHANGE**: Standard exchange trading order

## Processing Flow

The typical processing flow involving these entities follows this pattern:

1. **Order Placement**: User places an ExchangeOrder through the system
2. **Validation**: System validates against ExchangeCoin configuration and user balances
3. **Order Book Update**: TradePlate is updated with the new order
4. **Matching**: Trading engine attempts to match orders
5. **Trade Execution**: Successful matches create ExchangeTrade records
6. **Detail Recording**: ExchangeOrderDetail records are created for each execution
7. **Settlement**: User wallets are updated and transaction records created
8. **Aggregation**: OrderDetailAggregation records are stored for analytics
9. **Market Data Update**: KLine and CoinThumb data are updated with new trade information
10. **Order Completion**: Order status updated to COMPLETED or remains TRADING for partial fills

This flow ensures data consistency across all related entities while maintaining audit trails and enabling comprehensive market data analytics.
