```yaml
openapi: 3.0.3
info:
  title: Exchange API Service
  description: REST API for cryptocurrency exchange trading operations including order management, trading pair information, and user favorites management
  version: 1.0.0
  contact:
    name: Bizzan Exchange Development Team
servers:
  - url: /exchange
    description: Exchange API server

tags:
  - name: Order Management
    description: Operations related to trading order placement, cancellation, and querying
  - name: Exchange Coins
    description: Operations for retrieving trading pair information and market data
  - name: Favorites
    description: Operations for managing user's favorite trading pairs

paths:
  /order/add:
    post:
      tags:
        - Order Management
      summary: Place a new trading order
      description: Creates a new buy or sell order for a specified trading pair with validation of trading rules and user balances
      parameters:
        - name: direction
          in: query
          required: true
          schema:
            $ref: '#/components/schemas/ExchangeOrderDirection'
          description: Order direction (BUY or SELL)
        - name: symbol
          in: query
          required: true
          schema:
            type: string
            example: "BTC/USDT"
          description: Trading pair symbol
        - name: price
          in: query
          required: true
          schema:
            type: number
            format: decimal
            example: 50000.00
          description: Order price (ignored for market orders)
        - name: amount
          in: query
          required: true
          schema:
            type: number
            format: decimal
            example: 0.1
          description: Order amount (quantity for limit orders, budget for market buy orders)
        - name: type
          in: query
          required: true
          schema:
            $ref: '#/components/schemas/ExchangeOrderType'
          description: Order type (MARKET_PRICE or LIMIT_PRICE)
      responses:
        '200':
          description: Order placed successfully
          content:
            application/json:
              schema:
                allOf:
                  - $ref: '#/components/schemas/MessageResult'
                  - type: object
                    properties:
                      data:
                        type: string
                        description: Order ID of the created order
                        example: "1234567890123456789"
        '500':
          description: Order placement failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

  /order/cancel/{orderId}:
    post:
      tags:
        - Order Management
      summary: Cancel an active trading order
      description: Cancels an active trading order if it belongs to the authenticated user and is in TRADING status
      parameters:
        - name: orderId
          in: path
          required: true
          schema:
            type: string
          description: Unique identifier of the order to cancel
      responses:
        '200':
          description: Order cancelled successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'
        '500':
          description: Order cancellation failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

  /order/current:
    get:
      tags:
        - Order Management
      summary: Get current active orders
      description: Retrieves paginated list of active orders for the authenticated user and specified trading pair
      parameters:
        - name: symbol
          in: query
          required: true
          schema:
            type: string
            example: "BTC/USDT"
          description: Trading pair symbol
        - name: pageNo
          in: query
          required: true
          schema:
            type: integer
            minimum: 1
            example: 1
          description: Page number (1-based)
        - name: pageSize
          in: query
          required: true
          schema:
            type: integer
            minimum: 1
            maximum: 100
            example: 10
          description: Number of records per page
      responses:
        '200':
          description: Current orders retrieved successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ExchangeOrderPage'

  /order/history:
    get:
      tags:
        - Order Management
      summary: Get order history
      description: Retrieves paginated list of completed orders for the authenticated user and specified trading pair
      parameters:
        - name: symbol
          in: query
          required: true
          schema:
            type: string
            example: "BTC/USDT"
          description: Trading pair symbol
        - name: pageNo
          in: query
          required: true
          schema:
            type: integer
            minimum: 1
            example: 1
          description: Page number (1-based)
        - name: pageSize
          in: query
          required: true
          schema:
            type: integer
            minimum: 1
            maximum: 100
            example: 10
          description: Number of records per page
      responses:
        '200':
          description: Order history retrieved successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ExchangeOrderPage'

  /order/personal/history:
    get:
      tags:
        - Order Management
      summary: Get personal order history with filters
      description: Retrieves paginated and filtered list of user's historical orders with multiple filter options
      parameters:
        - name: symbol
          in: query
          required: false
          schema:
            type: string
            example: "BTC/USDT"
          description: Trading pair symbol filter
        - name: type
          in: query
          required: false
          schema:
            $ref: '#/components/schemas/ExchangeOrderType'
          description: Order type filter
        - name: status
          in: query
          required: false
          schema:
            $ref: '#/components/schemas/ExchangeOrderStatus'
          description: Order status filter
        - name: direction
          in: query
          required: false
          schema:
            $ref: '#/components/schemas/ExchangeOrderDirection'
          description: Order direction filter
        - name: startTime
          in: query
          required: false
          schema:
            type: string
            format: date-time
          description: Start time filter (ISO 8601)
        - name: endTime
          in: query
          required: false
          schema:
            type: string
            format: date-time
          description: End time filter (ISO 8601)
        - name: pageNo
          in: query
          schema:
            type: integer
            minimum: 1
            default: 1
          description: Page number (1-based)
        - name: pageSize
          in: query
          schema:
            type: integer
            minimum: 1
            maximum: 100
            default: 10
          description: Number of records per page
      responses:
        '200':
          description: Personal order history retrieved successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ExchangeOrderPage'

  /order/personal/current:
    get:
      tags:
        - Order Management
      summary: Get personal current orders with filters
      description: Retrieves paginated and filtered list of user's active orders with multiple filter options
      parameters:
        - name: symbol
          in: query
          required: false
          schema:
            type: string
            example: "BTC/USDT"
          description: Trading pair symbol filter
        - name: type
          in: query
          required: false
          schema:
            $ref: '#/components/schemas/ExchangeOrderType'
          description: Order type filter
        - name: direction
          in: query
          required: false
          schema:
            $ref: '#/components/schemas/ExchangeOrderDirection'
          description: Order direction filter
        - name: startTime
          in: query
          required: false
          schema:
            type: string
            format: date-time
          description: Start time filter (ISO 8601)
        - name: endTime
          in: query
          required: false
          schema:
            type: string
            format: date-time
          description: End time filter (ISO 8601)
        - name: pageNo
          in: query
          schema:
            type: integer
            minimum: 1
            default: 1
          description: Page number (1-based)
        - name: pageSize
          in: query
          schema:
            type: integer
            minimum: 1
            maximum: 100
            default: 10
          description: Number of records per page
      responses:
        '200':
          description: Personal current orders retrieved successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ExchangeOrderPage'

  /order/detail/{orderId}:
    get:
      tags:
        - Order Management
      summary: Get order execution details
      description: Retrieves detailed execution information for a specific order belonging to the authenticated user
      parameters:
        - name: orderId
          in: path
          required: true
          schema:
            type: string
          description: Unique identifier of the order
      responses:
        '200':
          description: Order details retrieved successfully
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/ExchangeOrderDetail'

  /order/time_limit:
    get:
      tags:
        - Order Management
      summary: Get order time limits
      description: Retrieves system configuration for order placement time restrictions
      responses:
        '200':
          description: Time limit configuration retrieved successfully
          content:
            application/json:
              schema:
                allOf:
                  - $ref: '#/components/schemas/MessageResult'
                  - type: object
                    properties:
                      data:
                        type: integer
                        description: Time limit in seconds
                        example: 300

  /exchange-coin/base-symbol:
    get:
      tags:
        - Exchange Coins
      summary: Get available base symbols
      description: Retrieves list of base currency symbols available for trading
      responses:
        '200':
          description: Base symbols retrieved successfully
          content:
            application/json:
              schema:
                allOf:
                  - $ref: '#/components/schemas/MessageResult'
                  - type: object
                    properties:
                      data:
                        type: array
                        items:
                          type: string
                          example: "USDT"
        '500':
          description: Failed to retrieve base symbols
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

  /favor/add:
    post:
      tags:
        - Favorites
      summary: Add trading pair to favorites
      description: Adds a trading pair to the authenticated user's favorite symbols list
      parameters:
        - name: symbol
          in: query
          required: true
          schema:
            type: string
            example: "BTC/USDT"
          description: Trading pair symbol to add to favorites
      responses:
        '200':
          description: Trading pair added to favorites successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'
        '500':
          description: Failed to add to favorites
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

  /favor/delete:
    post:
      tags:
        - Favorites
      summary: Remove trading pair from favorites
      description: Removes a trading pair from the authenticated user's favorite symbols list
      parameters:
        - name: symbol
          in: query
          required: true
          schema:
            type: string
            example: "BTC/USDT"
          description: Trading pair symbol to remove from favorites
      responses:
        '200':
          description: Trading pair removed from favorites successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'
        '500':
          description: Failed to remove from favorites
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

  /favor/find:
    get:
      tags:
        - Favorites
      summary: Get user's favorite trading pairs
      description: Retrieves list of trading pairs that the authenticated user has added to favorites
      responses:
        '200':
          description: Favorite trading pairs retrieved successfully
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/FavorSymbol'

components:
  schemas:
    MessageResult:
      type: object
      properties:
        code:
          type: integer
          description: Response code (0 for success, non-zero for errors)
          example: 0
        message:
          type: string
          description: Response message
          example: "success"
        data:
          type: object
          description: Response data payload
      required:
        - code
        - message

    ErrorResponse:
      allOf:
        - $ref: '#/components/schemas/MessageResult'
        - type: object
          properties:
            code:
              type: integer
              example: 500
            message:
              type: string
              example: "Operation failed"

    ExchangeOrder:
      type: object
      properties:
        orderId:
          type: string
          description: Unique order identifier
          example: "1234567890123456789"
        memberId:
          type: integer
          format: int64
          description: User ID who placed the order
          example: 12345
        type:
          $ref: '#/components/schemas/ExchangeOrderType'
        amount:
          type: number
          format: decimal
          description: Order quantity or budget amount
          example: 0.1
        symbol:
          type: string
          description: Trading pair symbol
          example: "BTC/USDT"
        tradedAmount:
          type: number
          format: decimal
          description: Amount that has been executed
          example: 0.05
        turnover:
          type: number
          format: decimal
          description: Total value of executed trades
          example: 2500.00
        coinSymbol:
          type: string
          description: Trading coin symbol
          example: "BTC"
        baseSymbol:
          type: string
          description: Base currency symbol
          example: "USDT"
        status:
          $ref: '#/components/schemas/ExchangeOrderStatus'
        direction:
          $ref: '#/components/schemas/ExchangeOrderDirection'
        price:
          type: number
          format: decimal
          description: Order price (limit orders only)
          example: 50000.00
        time:
          type: integer
          format: int64
          description: Order creation timestamp
          example: 1640995200000
        completedTime:
          type: integer
          format: int64
          description: Order completion timestamp
          example: 1640995500000
        canceledTime:
          type: integer
          format: int64
          description: Order cancellation timestamp
          example: 1640995300000
        useDiscount:
          type: string
          description: Whether to use trading fee discount
          example: "0"
        detail:
          type: array
          items:
            $ref: '#/components/schemas/ExchangeOrderDetail'
          description: Order execution details
      required:
        - orderId
        - memberId
        - type
        - amount
        - symbol
        - status
        - direction

    ExchangeOrderDetail:
      type: object
      properties:
        orderId:
          type: string
          description: Reference to parent order
          example: "1234567890123456789"
        price:
          type: number
          format: decimal
          description: Execution price
          example: 50000.00
        amount:
          type: number
          format: decimal
          description: Executed quantity
          example: 0.01
        turnover:
          type: number
          format: decimal
          description: Executed value
          example: 500.00
        fee:
          type: number
          format: decimal
          description: Trading fee charged
          example: 0.50
        time:
          type: integer
          format: int64
          description: Execution timestamp
          example: 1640995200000
      required:
        - orderId
        - price
        - amount
        - turnover
        - time

    FavorSymbol:
      type: object
      properties:
        id:
          type: integer
          format: int64
          description: Unique identifier
          example: 12345
        memberId:
          type: integer
          format: int64
          description: User ID who added the favorite
          example: 67890
        symbol:
          type: string
          description: Trading pair symbol
          example: "BTC/USDT"
        addTime:
          type: integer
          format: int64
          description: Timestamp when added to favorites
          example: 1640995200000
      required:
        - id
        - memberId
        - symbol

    ExchangeOrderPage:
      type: object
      properties:
        content:
          type: array
          items:
            $ref: '#/components/schemas/ExchangeOrder'
          description: List of orders in current page
        pageable:
          $ref: '#/components/schemas/Pageable'
        totalElements:
          type: integer
          format: int64
          description: Total number of orders
          example: 150
        totalPages:
          type: integer
          description: Total number of pages
          example: 15
        size:
          type: integer
          description: Page size
          example: 10
        number:
          type: integer
          description: Current page number (0-based)
          example: 0
        first:
          type: boolean
          description: Whether this is the first page
          example: true
        last:
          type: boolean
          description: Whether this is the last page
          example: false
      required:
        - content
        - totalElements
        - totalPages
        - size
        - number
        - first
        - last

    Pageable:
      type: object
      properties:
        page:
          type: integer
          description: Current page number (0-based)
          example: 0
        size:
          type: integer
          description: Page size
          example: 10
        sort:
          type: string
          description: Sort criteria
          example: "time,desc"

    ExchangeOrderType:
      type: string
      enum:
        - MARKET_PRICE
        - LIMIT_PRICE
      description: |
        Order type:
        * MARKET_PRICE - Order executes immediately at best available price
        * LIMIT_PRICE - Order executes only at specified price or better

    ExchangeOrderDirection:
      type: string
      enum:
        - BUY
        - SELL
      description: |
        Order direction:
        * BUY - Purchase order (bids)
        * SELL - Sale order (asks)

    ExchangeOrderStatus:
      type: string
      enum:
        - TRADING
        - COMPLETED
        - CANCELED
        - OVERTIMED
      description: |
        Order status:
        * TRADING - Order is active and can be matched
        * COMPLETED - Order has been fully executed
        * CANCELED - Order was cancelled before full execution
        * OVERTIMED - Order expired due to time limits

  securitySchemes:
    sessionAuth:
      type: apiKey
      in: cookie
      name: JSESSIONID
      description: Session-based authentication using HTTP sessions

security:
  - sessionAuth: []
```