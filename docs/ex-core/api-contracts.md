```yaml
openapi: 3.0.3
info:
  title: Exchange Core API
  description: API specification for cryptocurrency exchange core trading operations
  version: 1.0.0
  contact:
    name: Exchange Development Team
servers:
  - url: /exchange-core
    description: Exchange Core API server

tags:
  - name: Orders
    description: Operations related to trading orders
  - name: Trades
    description: Operations related to trade execution and history
  - name: Market Data
    description: Operations related to market data and statistics
  - name: Trading Pairs
    description: Operations related to trading pair configuration
  - name: Favorites
    description: Operations related to user favorite trading pairs

paths:
  /orders:
    post:
      tags:
        - Orders
      summary: Place a new trading order
      description: Creates a new buy or sell order for cryptocurrency trading
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateOrderRequest'
      responses:
        '200':
          description: Order placed successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'
        '400':
          description: Invalid order parameters
        '500':
          description: Insufficient balance or system error

  /orders/{orderId}:
    get:
      tags:
        - Orders
      summary: Get order details
      description: Retrieves detailed information about a specific order
      parameters:
        - name: orderId
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Order details retrieved successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ExchangeOrder'
        '404':
          description: Order not found

    delete:
      tags:
        - Orders
      summary: Cancel an order
      description: Cancels an active trading order
      parameters:
        - name: orderId
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Order cancelled successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'
        '400':
          description: Order cannot be cancelled

  /orders/current:
    get:
      tags:
        - Orders
      summary: Get current trading orders
      description: Retrieves user's currently active trading orders
      parameters:
        - name: memberId
          in: query
          required: true
          schema:
            type: integer
            format: int64
        - name: symbol
          in: query
          schema:
            type: string
        - name: pageNo
          in: query
          schema:
            type: integer
            default: 0
        - name: pageSize
          in: query
          schema:
            type: integer
            default: 20
      responses:
        '200':
          description: Current orders retrieved successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderPage'

  /orders/history:
    get:
      tags:
        - Orders
      summary: Get order history
      description: Retrieves user's historical trading orders
      parameters:
        - name: memberId
          in: query
          required: true
          schema:
            type: integer
            format: int64
        - name: symbol
          in: query
          schema:
            type: string
        - name: type
          in: query
          schema:
            $ref: '#/components/schemas/ExchangeOrderType'
        - name: status
          in: query
          schema:
            $ref: '#/components/schemas/ExchangeOrderStatus'
        - name: direction
          in: query
          schema:
            $ref: '#/components/schemas/ExchangeOrderDirection'
        - name: startTime
          in: query
          schema:
            type: string
        - name: endTime
          in: query
          schema:
            type: string
        - name: pageNo
          in: query
          schema:
            type: integer
            default: 1
        - name: pageSize
          in: query
          schema:
            type: integer
            default: 20
      responses:
        '200':
          description: Order history retrieved successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderPage'

  /trades/latest:
    get:
      tags:
        - Trades
      summary: Get latest trades
      description: Retrieves latest completed trades for a trading pair
      parameters:
        - name: symbol
          in: query
          required: true
          schema:
            type: string
        - name: size
          in: query
          schema:
            type: integer
            default: 50
      responses:
        '200':
          description: Latest trades retrieved successfully
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/ExchangeTrade'

  /trades/process:
    post:
      tags:
        - Trades
      summary: Process trade execution
      description: Processes a matched trade between buy and sell orders
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ProcessTradeRequest'
      responses:
        '200':
          description: Trade processed successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'
        '500':
          description: Trade processing failed

  /market/kline:
    get:
      tags:
        - Market Data
      summary: Get K-line data
      description: Retrieves candlestick chart data for technical analysis
      parameters:
        - name: symbol
          in: query
          required: true
          schema:
            type: string
        - name: period
          in: query
          required: true
          schema:
            type: string
            enum: [1m, 5m, 15m, 30m, 1h, 4h, 1d, 1w, 1M]
        - name: from
          in: query
          schema:
            type: integer
            format: int64
        - name: to
          in: query
          schema:
            type: integer
            format: int64
      responses:
        '200':
          description: K-line data retrieved successfully
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/KLine'

  /market/depth:
    get:
      tags:
        - Market Data
      summary: Get order book depth
      description: Retrieves order book depth information
      parameters:
        - name: symbol
          in: query
          required: true
          schema:
            type: string
        - name: limit
          in: query
          schema:
            type: integer
            default: 20
      responses:
        '200':
          description: Order book depth retrieved successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TradePlateResponse'

  /market/ticker:
    get:
      tags:
        - Market Data
      summary: Get market ticker
      description: Retrieves current market statistics and price information
      parameters:
        - name: symbol
          in: query
          schema:
            type: string
      responses:
        '200':
          description: Market ticker retrieved successfully
          content:
            application/json:
              schema:
                oneOf:
                  - $ref: '#/components/schemas/CoinThumb'
                  - type: array
                    items:
                      $ref: '#/components/schemas/CoinThumb'

  /trading-pairs:
    get:
      tags:
        - Trading Pairs
      summary: Get trading pairs
      description: Retrieves available trading pair configurations
      parameters:
        - name: zone
          in: query
          schema:
            type: integer
      responses:
        '200':
          description: Trading pairs retrieved successfully
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/ExchangeCoin'

  /trading-pairs/{symbol}:
    get:
      tags:
        - Trading Pairs
      summary: Get trading pair details
      description: Retrieves detailed configuration for a specific trading pair
      parameters:
        - name: symbol
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Trading pair details retrieved successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ExchangeCoin'
        '404':
          description: Trading pair not found

  /favorites:
    get:
      tags:
        - Favorites
      summary: Get favorite symbols
      description: Retrieves user's favorite trading pairs
      parameters:
        - name: memberId
          in: query
          required: true
          schema:
            type: integer
            format: int64
      responses:
        '200':
          description: Favorite symbols retrieved successfully
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/FavorSymbol'

    post:
      tags:
        - Favorites
      summary: Add favorite symbol
      description: Adds a trading pair to user's favorites
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/AddFavoriteRequest'
      responses:
        '200':
          description: Favorite added successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

  /favorites/{id}:
    delete:
      tags:
        - Favorites
      summary: Remove favorite symbol
      description: Removes a trading pair from user's favorites
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: integer
            format: int64
      responses:
        '200':
          description: Favorite removed successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

components:
  schemas:
    ExchangeOrder:
      type: object
      properties:
        orderId:
          type: string
          description: Unique order identifier
        memberId:
          type: integer
          format: int64
          description: User ID
        type:
          $ref: '#/components/schemas/ExchangeOrderType'
        amount:
          type: number
          format: decimal
          description: Order amount/quantity
        symbol:
          type: string
          description: Trading pair symbol
        tradedAmount:
          type: number
          format: decimal
          description: Amount already traded
        turnover:
          type: number
          format: decimal
          description: Total turnover value
        coinSymbol:
          type: string
          description: Trading coin symbol
        baseSymbol:
          type: string
          description: Base currency symbol
        status:
          $ref: '#/components/schemas/ExchangeOrderStatus'
        direction:
          $ref: '#/components/schemas/ExchangeOrderDirection'
        price:
          type: number
          format: decimal
          description: Order price
        time:
          type: integer
          format: int64
          description: Order placement timestamp
        completedTime:
          type: integer
          format: int64
          description: Order completion timestamp
        canceledTime:
          type: integer
          format: int64
          description: Order cancellation timestamp
        useDiscount:
          type: string
          description: Discount usage flag
      required:
        - orderId
        - memberId
        - type
        - amount
        - symbol
        - coinSymbol
        - baseSymbol
        - status
        - direction

    ExchangeTrade:
      type: object
      properties:
        symbol:
          type: string
          description: Trading pair symbol
        price:
          type: number
          format: decimal
          description: Trade price
        amount:
          type: number
          format: decimal
          description: Trade amount
        buyTurnover:
          type: number
          format: decimal
          description: Buy side turnover
        sellTurnover:
          type: number
          format: decimal
          description: Sell side turnover
        direction:
          $ref: '#/components/schemas/ExchangeOrderDirection'
        buyOrderId:
          type: string
          description: Buy order ID
        sellOrderId:
          type: string
          description: Sell order ID
        time:
          type: integer
          format: int64
          description: Trade timestamp
      required:
        - symbol
        - price
        - amount
        - direction
        - time

    ExchangeCoin:
      type: object
      properties:
        symbol:
          type: string
          description: Trading pair symbol
        coinSymbol:
          type: string
          description: Trading coin symbol
        baseSymbol:
          type: string
          description: Base currency symbol
        enable:
          type: integer
          description: Enable status
        fee:
          type: number
          format: decimal
          description: Trading fee rate
        sort:
          type: integer
          description: Display sort order
        coinScale:
          type: integer
          description: Coin decimal precision
        baseCoinScale:
          type: integer
          description: Base coin decimal precision
        minSellPrice:
          type: number
          format: decimal
          description: Minimum sell price
        maxBuyPrice:
          type: number
          format: decimal
          description: Maximum buy price
        enableMarketSell:
          type: boolean
          description: Market sell enabled
        enableMarketBuy:
          type: boolean
          description: Market buy enabled
        maxTradingTime:
          type: integer
          description: Max trading time in seconds
        maxTradingOrder:
          type: integer
          description: Max concurrent orders
        visible:
          type: integer
          description: Visibility status
        exchangeable:
          type: integer
          description: Exchangeable status
      required:
        - symbol
        - coinSymbol
        - baseSymbol

    KLine:
      type: object
      properties:
        openPrice:
          type: number
          format: decimal
          description: Opening price
        highestPrice:
          type: number
          format: decimal
          description: Highest price
        lowestPrice:
          type: number
          format: decimal
          description: Lowest price
        closePrice:
          type: number
          format: decimal
          description: Closing price
        time:
          type: integer
          format: int64
          description: Time period timestamp
        period:
          type: string
          description: Time period
        count:
          type: integer
          description: Number of trades
        volume:
          type: number
          format: decimal
          description: Trading volume
        turnover:
          type: number
          format: decimal
          description: Trading turnover
      required:
        - time
        - period

    CoinThumb:
      type: object
      properties:
        symbol:
          type: string
          description: Trading pair symbol
        open:
          type: number
          format: decimal
          description: Opening price (24h)
        high:
          type: number
          format: decimal
          description: Highest price (24h)
        low:
          type: number
          format: decimal
          description: Lowest price (24h)
        close:
          type: number
          format: decimal
          description: Current price
        chg:
          type: number
          format: decimal
          description: Price change amount
        change:
          type: number
          format: decimal
          description: Price change percentage
        volume:
          type: number
          format: decimal
          description: Trading volume (24h)
        turnover:
          type: number
          format: decimal
          description: Trading turnover (24h)
        lastDayClose:
          type: number
          format: decimal
          description: Previous day closing price
        usdRate:
          type: number
          format: decimal
          description: USD exchange rate
        baseUsdRate:
          type: number
          format: decimal
          description: Base currency USD rate
        zone:
          type: integer
          description: Trading zone
      required:
        - symbol

    FavorSymbol:
      type: object
      properties:
        id:
          type: integer
          format: int64
          description: Favorite ID
        symbol:
          type: string
          description: Trading pair symbol
        memberId:
          type: integer
          format: int64
          description: User ID
        addTime:
          type: string
          description: Addition timestamp
      required:
        - symbol
        - memberId

    TradePlateResponse:
      type: object
      properties:
        asks:
          type: array
          items:
            $ref: '#/components/schemas/TradePlateItem'
          description: Sell orders (asks)
        bids:
          type: array
          items:
            $ref: '#/components/schemas/TradePlateItem'
          description: Buy orders (bids)

    TradePlateItem:
      type: object
      properties:
        price:
          type: number
          format: decimal
          description: Price level
        amount:
          type: number
          format: decimal
          description: Total amount at this price
      required:
        - price
        - amount

    CreateOrderRequest:
      type: object
      properties:
        memberId:
          type: integer
          format: int64
          description: User ID
        type:
          $ref: '#/components/schemas/ExchangeOrderType'
        amount:
          type: number
          format: decimal
          description: Order amount
        symbol:
          type: string
          description: Trading pair symbol
        direction:
          $ref: '#/components/schemas/ExchangeOrderDirection'
        price:
          type: number
          format: decimal
          description: Order price (required for limit orders)
      required:
        - memberId
        - type
        - amount
        - symbol
        - direction

    ProcessTradeRequest:
      type: object
      properties:
        trade:
          $ref: '#/components/schemas/ExchangeTrade'
        secondReferrerAward:
          type: boolean
          description: Second referrer award flag
          default: true
      required:
        - trade

    AddFavoriteRequest:
      type: object
      properties:
        symbol:
          type: string
          description: Trading pair symbol
        memberId:
          type: integer
          format: int64
          description: User ID
      required:
        - symbol
        - memberId

    OrderPage:
      type: object
      properties:
        content:
          type: array
          items:
            $ref: '#/components/schemas/ExchangeOrder'
        totalElements:
          type: integer
          format: int64
          description: Total number of elements
        totalPages:
          type: integer
          description: Total number of pages
        size:
          type: integer
          description: Page size
        number:
          type: integer
          description: Current page number
        first:
          type: boolean
          description: Is first page
        last:
          type: boolean
          description: Is last page

    MessageResult:
      type: object
      properties:
        code:
          type: integer
          description: Response code (0 for success)
        message:
          type: string
          description: Response message
        data:
          type: object
          description: Response data
      required:
        - code
        - message

    ExchangeOrderType:
      type: string
      enum:
        - MARKET_PRICE
        - LIMIT_PRICE
      description: Order type

    ExchangeOrderStatus:
      type: string
      enum:
        - TRADING
        - COMPLETED
        - CANCELED
        - OVERTIMED
      description: Order status

    ExchangeOrderDirection:
      type: string
      enum:
        - BUY
        - SELL
      description: Order direction
```