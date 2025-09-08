```yaml
openapi: 3.0.3
info:
  title: Market Service API
  description: API for cryptocurrency exchange market data, real-time prices, K-line charts, and trading pair information
  version: 1.0.0
  contact:
    name: Bizzan Exchange Team
servers:
  - url: /market
    description: Default API server

tags:
  - name: Market Data
    description: Operations related to market data and trading pair information
  - name: Historical Data  
    description: Historical K-line charts and trade data
  - name: Exchange Rates
    description: Fiat currency exchange rate operations
  - name: Order Book
    description: Order book and trading depth information
  - name: Administration
    description: Administrative operations

paths:
  /symbol:
    get:
      tags:
        - Market Data
      summary: Get all supported trading pairs
      description: Retrieves a list of all visible and supported cryptocurrency trading pairs
      responses:
        '200':
          description: List of supported trading pairs
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/ExchangeCoin'

  /overview:
    get:
      tags:
        - Market Data
      summary: Get market overview
      description: Retrieves market overview including recommended coins and top gainers
      responses:
        '200':
          description: Market overview data
          content:
            application/json:
              schema:
                type: object
                properties:
                  recommend:
                    type: array
                    items:
                      $ref: '#/components/schemas/CoinThumb'
                    description: Recommended trading pairs
                  changeRank:
                    type: array
                    items:
                      $ref: '#/components/schemas/CoinThumb'
                    description: Top 5 gainers by price change

  /engines:
    get:
      tags:
        - Market Data
      summary: Get trading engine status
      description: Returns the operational status of trading engines for each symbol
      responses:
        '200':
          description: Engine status by symbol
          content:
            application/json:
              schema:
                type: object
                additionalProperties:
                  type: integer
                  enum: [1, 2]
                  description: 1=Running, 2=K-line generation stopped

  /coin-info:
    get:
      tags:
        - Market Data
      summary: Get coin information
      description: Retrieves detailed information about a specific cryptocurrency
      parameters:
        - name: unit
          in: query
          required: true
          schema:
            type: string
          description: Coin symbol/unit (e.g., BTC, ETH)
          example: BTC
      responses:
        '200':
          description: Detailed coin information
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Coin'

  /ctc-usdt:
    get:
      tags:
        - Exchange Rates
      summary: Get USDT to CNY rate for C2C trading
      description: Retrieves USDT to Chinese Yuan exchange rate with buy/sell spread for C2C trading
      responses:
        '200':
          description: USDT/CNY exchange rate data
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

  /symbol-info:
    get:
      tags:
        - Market Data
      summary: Get trading pair details
      description: Retrieves detailed configuration and current status of a trading pair
      parameters:
        - name: symbol
          in: query
          required: true
          schema:
            type: string
          description: Trading pair symbol (e.g., BTC/USDT)
          example: BTC/USDT
      responses:
        '200':
          description: Trading pair details
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ExchangeCoin'

  /symbol-thumb:
    get:
      tags:
        - Market Data
      summary: Get market data thumbnails
      description: Retrieves condensed market data for all visible trading pairs
      responses:
        '200':
          description: List of market data thumbnails
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/CoinThumb'

  /symbol-thumb-trend:
    get:
      tags:
        - Market Data
      summary: Get market data with 24h price trends
      description: Retrieves market data thumbnails with 24-hour price trend data
      responses:
        '200':
          description: Market data with trend information
          content:
            application/json:
              schema:
                type: array
                items:
                  type: object
                  allOf:
                    - $ref: '#/components/schemas/CoinThumb'
                    - type: object
                      properties:
                        trend:
                          type: array
                          items:
                            type: number
                          description: 24-hour hourly price trend data

  /history:
    get:
      tags:
        - Historical Data
      summary: Get historical K-line data
      description: Retrieves historical candlestick chart data for a trading pair within a time range
      parameters:
        - name: symbol
          in: query
          required: true
          schema:
            type: string
          description: Trading pair symbol
          example: BTC/USDT
        - name: from
          in: query
          required: true
          schema:
            type: integer
            format: int64
          description: Start timestamp (milliseconds)
        - name: to
          in: query
          required: true
          schema:
            type: integer
            format: int64
          description: End timestamp (milliseconds)
        - name: resolution
          in: query
          required: true
          schema:
            type: string
            enum: [1, 5, 15, 30, 60, 240, 1440, 10080, 43200, 1H, 1D, 1W, 1M]
          description: K-line resolution/period
          example: 1H
      responses:
        '200':
          description: Historical K-line data
          content:
            application/json:
              schema:
                type: array
                items:
                  type: array
                  items:
                    oneOf:
                      - type: integer
                      - type: number
                  minItems: 6
                  maxItems: 6
                  description: [timestamp, open, high, low, close, volume]

  /latest-trade:
    get:
      tags:
        - Historical Data
      summary: Get recent trade records
      description: Retrieves the most recent trade execution records for a trading pair
      parameters:
        - name: symbol
          in: query
          required: true
          schema:
            type: string
          description: Trading pair symbol
          example: BTC/USDT
        - name: size
          in: query
          required: true
          schema:
            type: integer
            minimum: 1
            maximum: 100
          description: Maximum number of records to return
          example: 20
      responses:
        '200':
          description: List of recent trades
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/ExchangeTrade'

  /exchange-plate:
    get:
      tags:
        - Order Book
      summary: Get order book data
      description: Retrieves buy and sell order book depth data for a trading pair
      parameters:
        - name: symbol
          in: query
          required: true
          schema:
            type: string
          description: Trading pair symbol
          example: BTC/USDT
      responses:
        '200':
          description: Order book data
          content:
            application/json:
              schema:
                type: object
                properties:
                  ask:
                    type: array
                    items:
                      $ref: '#/components/schemas/TradePlateItem'
                    description: Sell orders (asks)
                  bid:
                    type: array
                    items:
                      $ref: '#/components/schemas/TradePlateItem'
                    description: Buy orders (bids)

  /exchange-plate-mini:
    get:
      tags:
        - Order Book
      summary: Get compact order book data
      description: Retrieves condensed order book data with limited depth
      parameters:
        - name: symbol
          in: query
          required: true
          schema:
            type: string
          description: Trading pair symbol
          example: BTC/USDT
      responses:
        '200':
          description: Compact order book data
          content:
            application/json:
              schema:
                type: object
                properties:
                  ask:
                    type: object
                    description: Condensed sell order data
                  bid:
                    type: object
                    description: Condensed buy order data

  /exchange-plate-full:
    get:
      tags:
        - Order Book
      summary: Get full order book data
      description: Retrieves complete order book data with full depth
      parameters:
        - name: symbol
          in: query
          required: true
          schema:
            type: string
          description: Trading pair symbol
          example: BTC/USDT
      responses:
        '200':
          description: Full order book data
          content:
            application/json:
              schema:
                type: object
                properties:
                  ask:
                    type: object
                    description: Complete sell order data
                  bid:
                    type: object
                    description: Complete buy order data

  /exchange-rate/usd/{coin}:
    get:
      tags:
        - Exchange Rates
      summary: Get USD exchange rate for coin
      description: Retrieves the current USD exchange rate for a specified cryptocurrency
      parameters:
        - name: coin
          in: path
          required: true
          schema:
            type: string
          description: Cryptocurrency symbol
          example: BTC
      responses:
        '200':
          description: USD exchange rate
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

  /exchange-rate/usdtcny:
    get:
      tags:
        - Exchange Rates
      summary: Get USDT to CNY exchange rate
      description: Retrieves the current USDT to Chinese Yuan exchange rate
      responses:
        '200':
          description: USDT/CNY exchange rate
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

  /exchange-rate/cny/{coin}:
    get:
      tags:
        - Exchange Rates
      summary: Get CNY exchange rate for coin
      description: Retrieves the current Chinese Yuan exchange rate for a specified cryptocurrency
      parameters:
        - name: coin
          in: path
          required: true
          schema:
            type: string
          description: Cryptocurrency symbol
          example: BTC
      responses:
        '200':
          description: CNY exchange rate
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

  /exchange-rate/jpy/{coin}:
    get:
      tags:
        - Exchange Rates
      summary: Get JPY exchange rate for coin
      description: Retrieves the current Japanese Yen exchange rate for a specified cryptocurrency
      parameters:
        - name: coin
          in: path
          required: true
          schema:
            type: string
          description: Cryptocurrency symbol
          example: BTC
      responses:
        '200':
          description: JPY exchange rate
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

  /exchange-rate/hkd/{coin}:
    get:
      tags:
        - Exchange Rates
      summary: Get HKD exchange rate for coin
      description: Retrieves the current Hong Kong Dollar exchange rate for a specified cryptocurrency
      parameters:
        - name: coin
          in: path
          required: true
          schema:
            type: string
          description: Cryptocurrency symbol
          example: BTC
      responses:
        '200':
          description: HKD exchange rate
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

  /exchange-rate/usd-{unit}:
    get:
      tags:
        - Exchange Rates
      summary: Get USD to fiat exchange rate
      description: Retrieves USD to various fiat currency exchange rates
      parameters:
        - name: unit
          in: path
          required: true
          schema:
            type: string
            enum: [CNY, JPY, HKD]
          description: Target fiat currency
          example: CNY
      responses:
        '200':
          description: USD to fiat exchange rate
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

  /add_dictionary/{bond}/{value}:
    get:
      tags:
        - Administration
      summary: Update dictionary cache
      description: Administrative endpoint to update dictionary data in Redis cache
      parameters:
        - name: bond
          in: path
          required: true
          schema:
            type: string
          description: Dictionary key/bond identifier
        - name: value
          in: path
          required: true
          schema:
            type: string
          description: Dictionary value to cache
      responses:
        '200':
          description: Cache update result
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

components:
  schemas:
    ExchangeCoin:
      type: object
      properties:
        symbol:
          type: string
          description: Trading pair symbol
          example: BTC/USDT
        coinSymbol:
          type: string
          description: Trading coin symbol
          example: BTC
        baseSymbol:
          type: string
          description: Base coin symbol
          example: USDT
        enable:
          type: integer
          enum: [1, 2]
          description: Enable status (1=enabled, 2=disabled)
        fee:
          type: number
          format: decimal
          description: Trading fee percentage
        sort:
          type: integer
          description: Display sort order
        coinScale:
          type: integer
          description: Trading coin decimal precision
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
        visible:
          type: integer
          enum: [1, 2]
          description: Frontend visibility (1=visible, 2=hidden)
        exchangeable:
          type: integer
          enum: [1, 2]
          description: Trading enabled (1=enabled, 2=disabled)
        zone:
          type: integer
          description: Trading zone identifier
        currentTime:
          type: integer
          format: int64
          description: Server current timestamp

    CoinThumb:
      type: object
      properties:
        symbol:
          type: string
          description: Trading pair symbol
          example: BTC/USDT
        open:
          type: number
          format: decimal
          description: 24h opening price
        high:
          type: number
          format: decimal
          description: 24h highest price
        low:
          type: number
          format: decimal
          description: 24h lowest price
        close:
          type: number
          format: decimal
          description: Current/latest price
        chg:
          type: number
          format: decimal
          description: Price change percentage
        change:
          type: number
          format: decimal
          description: Absolute price change
        volume:
          type: number
          format: decimal
          description: 24h trading volume
        turnover:
          type: number
          format: decimal
          description: 24h trading turnover
        lastDayClose:
          type: number
          format: decimal
          description: Previous day closing price
        usdRate:
          type: number
          format: decimal
          description: USD exchange rate for trading coin
        baseUsdRate:
          type: number
          format: decimal
          description: USD exchange rate for base coin
        zone:
          type: integer
          description: Trading zone identifier

    ExchangeTrade:
      type: object
      properties:
        symbol:
          type: string
          description: Trading pair symbol
          example: BTC/USDT
        price:
          type: number
          format: decimal
          description: Trade execution price
        amount:
          type: number
          format: decimal
          description: Trade amount/volume
        buyTurnover:
          type: number
          format: decimal
          description: Buy side turnover value
        sellTurnover:
          type: number
          format: decimal
          description: Sell side turnover value
        direction:
          type: string
          enum: [BUY, SELL]
          description: Trade direction
        buyOrderId:
          type: string
          description: Buy order identifier
        sellOrderId:
          type: string
          description: Sell order identifier
        time:
          type: integer
          format: int64
          description: Trade execution timestamp

    TradePlateItem:
      type: object
      properties:
        price:
          type: number
          format: decimal
          description: Order price level
        amount:
          type: number
          format: decimal
          description: Total amount at price level

    Coin:
      type: object
      properties:
        unit:
          type: string
          description: Coin symbol/unit
        name:
          type: string
          description: Coin full name
        nameCn:
          type: string
          description: Chinese name
        jyRate:
          type: number
          format: decimal
          description: Exchange rate
        sort:
          type: integer
          description: Display sort order
        status:
          type: integer
          description: Coin status

    MessageResult:
      type: object
      properties:
        code:
          type: integer
          description: Response code (0=success, other=error)
          example: 0
        message:
          type: string
          description: Response message
          example: success
        data:
          oneOf:
            - type: string
            - type: number
            - type: object
          description: Response data payload
      required:
        - code
        - message
```