```yaml
openapi: 3.0.3
info:
  title: Exchange Service API
  description: API for the cryptocurrency exchange matching engine service, providing monitoring and control capabilities for trading engines
  version: 1.0.0
  contact:
    name: Exchange Service Team
servers:
  - url: /exchange
    description: Exchange Service API server

tags:
  - name: Monitoring
    description: Operations for monitoring trading engines and order books
  - name: Engine Control
    description: Operations for controlling trading engine lifecycle

paths:
  /monitor/overview:
    get:
      tags:
        - Monitoring
      summary: Get trading engine overview
      description: Returns statistical overview of a trading engine including order counts and market depth
      parameters:
        - name: symbol
          in: query
          required: true
          description: Trading pair symbol (e.g., BTC/USDT)
          schema:
            type: string
            example: "BTC/USDT"
      responses:
        '200':
          description: Trading engine overview data
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/EngineOverview'
        '404':
          description: Trading engine not found

  /monitor/trader-detail:
    get:
      tags:
        - Monitoring
      summary: Get detailed trading engine state
      description: Returns detailed information about order queues and trading state
      parameters:
        - name: symbol
          in: query
          required: true
          description: Trading pair symbol
          schema:
            type: string
            example: "BTC/USDT"
      responses:
        '200':
          description: Detailed trading engine state
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TraderDetail'
        '404':
          description: Trading engine not found

  /monitor/plate:
    get:
      tags:
        - Monitoring
      summary: Get order book depth
      description: Returns current market depth showing bid and ask orders
      parameters:
        - name: symbol
          in: query
          required: true
          description: Trading pair symbol
          schema:
            type: string
            example: "BTC/USDT"
      responses:
        '200':
          description: Current order book depth
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TradePlateResponse'
        '404':
          description: Trading engine not found

  /monitor/plate-mini:
    get:
      tags:
        - Monitoring
      summary: Get condensed order book depth
      description: Returns condensed market depth with up to 24 price levels
      parameters:
        - name: symbol
          in: query
          required: true
          description: Trading pair symbol
          schema:
            type: string
            example: "BTC/USDT"
      responses:
        '200':
          description: Condensed order book depth
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TradePlateJsonResponse'
        '404':
          description: Trading engine not found

  /monitor/plate-full:
    get:
      tags:
        - Monitoring
      summary: Get full order book depth
      description: Returns full market depth with up to 100 price levels
      parameters:
        - name: symbol
          in: query
          required: true
          description: Trading pair symbol
          schema:
            type: string
            example: "BTC/USDT"
      responses:
        '200':
          description: Full order book depth
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TradePlateJsonResponse'
        '404':
          description: Trading engine not found

  /monitor/symbols:
    get:
      tags:
        - Monitoring
      summary: List all trading symbols
      description: Returns list of all active trading pair symbols
      responses:
        '200':
          description: List of trading symbols
          content:
            application/json:
              schema:
                type: array
                items:
                  type: string
                  example: "BTC/USDT"

  /monitor/engines:
    get:
      tags:
        - Monitoring
      summary: Get all engine statuses
      description: Returns status of all trading engines
      responses:
        '200':
          description: Map of trading symbols to their engine status
          content:
            application/json:
              schema:
                type: object
                additionalProperties:
                  type: integer
                  description: Engine status (1=running, 2=halted)
                example:
                  "BTC/USDT": 1
                  "ETH/USDT": 2

  /monitor/order:
    get:
      tags:
        - Monitoring
      summary: Find specific order
      description: Locates a specific order within the trading engine
      parameters:
        - name: symbol
          in: query
          required: true
          description: Trading pair symbol
          schema:
            type: string
            example: "BTC/USDT"
        - name: orderId
          in: query
          required: true
          description: Order identifier
          schema:
            type: string
        - name: direction
          in: query
          required: true
          description: Order direction
          schema:
            $ref: '#/components/schemas/ExchangeOrderDirection'
        - name: type
          in: query
          required: true
          description: Order type
          schema:
            $ref: '#/components/schemas/ExchangeOrderType'
      responses:
        '200':
          description: Order details
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ExchangeOrder'
        '404':
          description: Order not found

  /monitor/start-trader:
    post:
      tags:
        - Engine Control
      summary: Start trading engine
      description: Starts or resumes a trading engine for the specified symbol
      parameters:
        - name: symbol
          in: query
          required: true
          description: Trading pair symbol
          schema:
            type: string
            example: "BTC/USDT"
      responses:
        '200':
          description: Engine started successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'
        '500':
          description: Engine start failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

  /monitor/stop-trader:
    post:
      tags:
        - Engine Control
      summary: Stop trading engine
      description: Halts a trading engine for the specified symbol
      parameters:
        - name: symbol
          in: query
          required: true
          description: Trading pair symbol
          schema:
            type: string
            example: "BTC/USDT"
      responses:
        '200':
          description: Engine stopped successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'
        '500':
          description: Engine stop failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

  /monitor/reset-trader:
    post:
      tags:
        - Engine Control
      summary: Reset trading engine
      description: Completely resets and reinitializes a trading engine
      parameters:
        - name: symbol
          in: query
          required: true
          description: Trading pair symbol
          schema:
            type: string
            example: "BTC/USDT"
      responses:
        '200':
          description: Engine reset successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'
        '500':
          description: Engine reset failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

components:
  schemas:
    EngineOverview:
      type: object
      properties:
        ask:
          $ref: '#/components/schemas/OrderBookSummary'
        bid:
          $ref: '#/components/schemas/OrderBookSummary'
      description: Summary statistics for both sides of the order book

    OrderBookSummary:
      type: object
      properties:
        limit_price_order_count:
          type: integer
          description: Number of limit orders
        market_price_order_count:
          type: integer
          description: Number of market orders
        depth:
          type: integer
          description: Number of price levels in order book

    TraderDetail:
      type: object
      properties:
        ask:
          type: object
          properties:
            limit_price_queue:
              type: object
              description: Sell limit order queue
            market_price_queue:
              type: array
              items:
                $ref: '#/components/schemas/ExchangeOrder'
              description: Sell market order queue
        bid:
          type: object
          properties:
            limit_price_queue:
              type: object
              description: Buy limit order queue
            market_price_queue:
              type: array
              items:
                $ref: '#/components/schemas/ExchangeOrder'
              description: Buy market order queue

    TradePlateResponse:
      type: object
      properties:
        bid:
          type: array
          items:
            $ref: '#/components/schemas/TradePlateItem'
          description: Buy side order book items
        ask:
          type: array
          items:
            $ref: '#/components/schemas/TradePlateItem'
          description: Sell side order book items

    TradePlateJsonResponse:
      type: object
      properties:
        bid:
          type: object
          description: Buy side order book summary
        ask:
          type: object
          description: Sell side order book summary

    TradePlateItem:
      type: object
      properties:
        price:
          type: string
          format: decimal
          description: Price level
          example: "50000.00000000"
        amount:
          type: string
          format: decimal
          description: Total volume at this price
          example: "1.50000000"
      required:
        - price
        - amount

    ExchangeOrder:
      type: object
      properties:
        orderId:
          type: string
          description: Unique order identifier
        memberId:
          type: integer
          format: int64
          description: User ID who placed the order
        type:
          $ref: '#/components/schemas/ExchangeOrderType'
        amount:
          type: string
          format: decimal
          description: Order amount
        symbol:
          type: string
          description: Trading pair symbol
        tradedAmount:
          type: string
          format: decimal
          description: Amount already executed
        turnover:
          type: string
          format: decimal
          description: Total value of executed trades
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
          type: string
          format: decimal
          description: Limit price
        time:
          type: integer
          format: int64
          description: Order creation timestamp
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
          description: Whether to use fee discount
      required:
        - orderId
        - type
        - amount
        - symbol
        - direction

    ExchangeOrderType:
      type: string
      enum:
        - MARKET_PRICE
        - LIMIT_PRICE
      description: Order execution type

    ExchangeOrderDirection:
      type: string
      enum:
        - BUY
        - SELL
      description: Order direction

    ExchangeOrderStatus:
      type: string
      enum:
        - TRADING
        - COMPLETED
        - CANCELED
        - OVERTIMED
      description: Current order status

    MessageResult:
      type: object
      properties:
        code:
          type: integer
          description: Response code (200=success, 500=error)
        message:
          type: string
          description: Response message
        data:
          type: object
          description: Response data
      required:
        - code
        - message
```