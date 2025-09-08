# Exchange API Data Models

This document describes the core data models of the Exchange API service and their relationships.

## Core Entities

### 1. ExchangeOrder

Represents a trading order placed by a user for buying or selling cryptocurrency.

```java
public class ExchangeOrder {
    private String orderId;                    // Unique order identifier
    private Long memberId;                     // ID of the user who placed the order
    private ExchangeOrderType type;            // MARKET_PRICE or LIMIT_PRICE
    private BigDecimal amount;                 // Order quantity or budget amount
    private String symbol;                     // Trading pair symbol (e.g., "BTC/USDT")
    private BigDecimal tradedAmount;           // Amount that has been executed
    private BigDecimal turnover;               // Total value of executed trades
    private String coinSymbol;                 // Trading coin symbol (e.g., "BTC") 
    private String baseSymbol;                 // Base currency symbol (e.g., "USDT")
    private ExchangeOrderStatus status;        // TRADING, COMPLETED, CANCELED, OVERTIMED
    private ExchangeOrderDirection direction;  // BUY or SELL
    private BigDecimal price;                  // Limit price for limit orders
    private Long time;                         // Order creation timestamp
    private Long completedTime;                // Order completion timestamp  
    private Long canceledTime;                 // Order cancellation timestamp
    private String useDiscount;                // Whether to use trading fee discount ("0" or "1")
    private List<ExchangeOrderDetail> detail;  // Order execution details (transient)
}
```

### 2. ExchangeCoin

Defines a trading pair configuration including trading rules, restrictions, and special event settings.

```java
public class ExchangeCoin {
    private String symbol;                     // Trading pair symbol (primary key, e.g., "BTC/USDT")
    private String coinSymbol;                 // Trading coin symbol (e.g., "BTC")
    private String baseSymbol;                 // Base currency symbol (e.g., "USDT")
    private int enable;                        // 1=enabled, 2=disabled
    private BigDecimal fee;                    // Trading fee rate
    private int sort;                          // Display sort order
    private int coinScale;                     // Trading coin decimal precision
    private int baseCoinScale;                 // Base coin decimal precision
    private BigDecimal minSellPrice;           // Minimum allowed sell price
    private BigDecimal maxBuyPrice;            // Maximum allowed buy price
    private BooleanEnum enableMarketSell;      // Whether market sell orders are allowed
    private BooleanEnum enableMarketBuy;       // Whether market buy orders are allowed
    private int maxTradingTime;                // Order timeout in seconds (0=no timeout)
    private int maxTradingOrder;               // Max concurrent orders per user (0=unlimited)
    private int robotType;                     // Trading bot configuration type
    private int flag;                          // Feature flags (0=default, 1=recommended)
    private BigDecimal minTurnover;            // Minimum trade value
    private int zone;                          // Trading zone identifier
    private BigDecimal minVolume;              // Minimum order size
    private BigDecimal maxVolume;              // Maximum order size
    private ExchangeCoinPublishType publishType; // Special trading mode (NONE, QIANGGOU, FENTAN)
    private String startTime;                  // Activity start time (for special modes)
    private String endTime;                    // Activity end time (for special modes)
    private String clearTime;                  // Settlement time (for special modes)
    private BigDecimal publishPrice;           // Fixed price for special modes
    private BigDecimal publishAmount;          // Available quantity for special modes
    private int visible;                       // Frontend visibility (1=visible, 2=hidden)
    private int exchangeable;                  // Whether trading is allowed (1=allowed, 2=disabled)
}
```

### 3. FavorSymbol

Represents a user's favorite trading pair in their watchlist.

```java
public class FavorSymbol {
    private Long id;                           // Unique identifier
    private Long memberId;                     // User ID who added the favorite
    private String symbol;                     // Trading pair symbol
    private Long addTime;                      // Timestamp when added to favorites
}
```

### 4. ExchangeOrderDetail

Represents individual trade executions that partially or fully fill an order.

```java
public class ExchangeOrderDetail {
    private String orderId;                    // Reference to the parent order
    private BigDecimal price;                  // Execution price
    private BigDecimal amount;                 // Executed quantity
    private BigDecimal turnover;               // Executed value (price * amount)
    private BigDecimal fee;                    // Trading fee charged
    private Long time;                         // Execution timestamp
}
```

### 5. Member

User account entity (from core module, referenced by ExchangeOrder).

```java
public class Member {
    private Long id;                           // Unique user identifier
    private String username;                   // User login name
    private MemberLevelEnum memberLevel;       // KYC verification level
    private BooleanEnum transactionStatus;     // Whether user can trade
    // Additional user properties...
}
```

### 6. MemberWallet

User's cryptocurrency wallet balance (from core module).

```java
public class MemberWallet {
    private Long id;                           // Unique wallet identifier
    private Long memberId;                     // Owner user ID
    private String coinUnit;                   // Cryptocurrency unit (e.g., "BTC")
    private BigDecimal balance;                // Available balance
    private BigDecimal frozenBalance;          // Locked balance (in pending orders)
    private BooleanEnum isLock;                // Whether wallet is locked
    // Additional wallet properties...
}
```

### 7. Coin

Cryptocurrency configuration entity (from core module).

```java
public class Coin {
    private String unit;                       // Cryptocurrency symbol (primary key)
    private String name;                       // Full name of the cryptocurrency
    private int status;                        // Coin status (active/inactive)
    private int sort;                          // Display sort order
    // Additional coin properties...
}
```

## Relationships

1. **ExchangeOrder to Member**: Many-to-One
   - Each order belongs to exactly one user (member)
   - One user can have multiple orders

2. **ExchangeOrder to ExchangeCoin**: Many-to-One
   - Each order is placed for a specific trading pair
   - One trading pair can have multiple orders

3. **ExchangeOrder to ExchangeOrderDetail**: One-to-Many
   - Each order can have multiple execution details as it gets partially filled
   - Each execution detail belongs to exactly one order

4. **FavorSymbol to Member**: Many-to-One
   - Each favorite symbol entry belongs to one user
   - One user can have multiple favorite symbols

5. **FavorSymbol to ExchangeCoin**: Many-to-One (implicit)
   - Each favorite references a trading pair symbol
   - One trading pair can be favorited by multiple users

6. **Member to MemberWallet**: One-to-Many
   - Each user can have multiple wallets for different cryptocurrencies
   - Each wallet belongs to exactly one user

7. **ExchangeCoin to Coin**: Many-to-One (via coinSymbol and baseSymbol)
   - Each trading pair references two coins (trading coin and base coin)
   - One coin can participate in multiple trading pairs

## Status Enumerations

### ExchangeOrderType
- **MARKET_PRICE**: Order executes immediately at the best available market price
- **LIMIT_PRICE**: Order executes only at the specified price or better

### ExchangeOrderDirection  
- **BUY**: Purchase order (bids)
- **SELL**: Sale order (asks)

### ExchangeOrderStatus
- **TRADING**: Order is active and can be matched with other orders
- **COMPLETED**: Order has been fully executed
- **CANCELED**: Order was cancelled before full execution
- **OVERTIMED**: Order expired due to configured time limits

### ExchangeCoinPublishType
- **NONE**: Normal trading mode with standard order matching
- **QIANGGOU**: Flash sale mode (first-come-first-served, limited quantity)
- **FENTAN**: Distribution mode (proportional allocation at fixed price)

### BooleanEnum
- **IS_TRUE**: Enabled/Active state
- **IS_FALSE**: Disabled/Inactive state

### MemberLevelEnum  
- **GENERAL**: Basic user level (may have trading restrictions)
- **REALNAME**: Identity-verified user with full trading privileges
- **ENTERPRISE**: Corporate account with enhanced features

## Processing Flow

The typical processing flow involving these entities:

1. **User Authentication**: Member entity validated for trading permissions
2. **Order Validation**: 
   - ExchangeCoin configuration checked for trading rules
   - Member wallet balances verified
   - Trading restrictions and limits enforced
3. **Order Creation**: ExchangeOrder entity created with initial TRADING status
4. **Order Submission**: Order sent to trading engine via Kafka message
5. **Order Matching**: External trading engine matches compatible orders
6. **Trade Execution**: ExchangeOrderDetail records created for successful matches
7. **Order Updates**: ExchangeOrder status and amounts updated based on executions
8. **Completion**: Fully executed orders marked as COMPLETED, wallet balances updated

Special considerations:
- **Special Trading Modes**: QIANGGOU and FENTAN modes enforce time-based restrictions and price constraints
- **Order Timeouts**: Orders can be automatically cancelled after configured time limits
- **Concurrency Limits**: Users may be limited in the number of concurrent orders per trading pair
- **Price Precision**: All prices and amounts are handled with configurable decimal precision per trading pair
