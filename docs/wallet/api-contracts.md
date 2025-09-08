```yaml
openapi: 3.0.3
info:
  title: Wallet Service API
  description: |
    API for the Bizzan Cryptocurrency Exchange Wallet Service.
    
    This service primarily operates as a message-driven microservice for processing 
    cryptocurrency wallet operations including deposits, withdrawals, and balance management.
    External APIs are limited to testing and monitoring endpoints.
    
    **Note**: The core functionality is driven by Kafka message consumption rather than 
    HTTP APIs. Most wallet operations are triggered by messages from other services.
  version: 1.0.0
  contact:
    name: Bizzan Development Team

servers:
  - url: /service-wallet
    description: Wallet Service API server

tags:
  - name: Testing
    description: Testing and monitoring endpoints for service health validation
  - name: Monitoring
    description: Service health and connectivity monitoring

paths:
  /test/height/{unit}:
    get:
      tags:
        - Testing
      summary: Test RPC connectivity for specific cryptocurrency
      description: |
        Tests the connectivity and health of RPC service for a specific cryptocurrency unit.
        This endpoint validates that the wallet service can communicate with the blockchain 
        RPC node for the specified currency.
      parameters:
        - name: unit
          in: path
          required: true
          description: Cryptocurrency unit symbol (e.g., BTC, ETH, LTC)
          schema:
            type: string
            example: BTC
      responses:
        '200':
          description: RPC connectivity test result
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'
              examples:
                success:
                  summary: Successful RPC connection
                  value:
                    code: 0
                    message: "success"
                    data:
                      statusCode:
                        value: 200
                      body:
                        code: 0
                        message: "RPC service responsive"
                        data: 12345
                failure:
                  summary: RPC connection failure
                  value:
                    code: 500
                    message: "RPC service unavailable"
                    data: null
        '400':
          description: Invalid cryptocurrency unit provided
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
        '500':
          description: Internal server error or RPC service unavailable
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

  /test/rpc:
    get:
      tags:
        - Monitoring
      summary: Test RPC connectivity for all supported cryptocurrencies
      description: |
        Performs connectivity tests for all RPC-enabled cryptocurrencies configured 
        in the system. Returns a comprehensive status report showing which blockchain 
        nodes are accessible and responsive.
      responses:
        '200':
          description: Comprehensive RPC connectivity status for all coins
          content:
            application/json:
              schema:
                allOf:
                  - $ref: '#/components/schemas/MessageResult'
                  - type: object
                    properties:
                      data:
                        type: object
                        additionalProperties:
                          $ref: '#/components/schemas/RpcTestResult'
                        example:
                          "http://SERVICE-RPC-BTC/rpc/height":
                            statusCode:
                              value: 200
                            body:
                              code: 0
                              message: "success"
                              data: 750123
                          "http://SERVICE-RPC-ETH/rpc/height":
                            statusCode:
                              value: 200
                            body:
                              code: 0
                              message: "success"  
                              data: 18234567
        '500':
          description: No RPC coins configured or service error
          content:
            application/json:
              schema:
                allOf:
                  - $ref: '#/components/schemas/MessageResult'
                  - type: object
                    properties:
                      code:
                        example: 500
                      message:
                        example: "no rpc coin!"

components:
  schemas:
    MessageResult:
      type: object
      description: Standard response wrapper used throughout the Bizzan platform
      properties:
        code:
          type: integer
          description: Response code (0 = success, non-zero = error)
          example: 0
        message:
          type: string
          description: Response message or error description
          example: "success"
        data:
          description: Response payload data (varies by endpoint)
          oneOf:
            - type: object
            - type: array
            - type: string
            - type: number
            - type: boolean
            - type: "null"
      required:
        - code
        - message

    RpcTestResult:
      type: object
      description: Result of RPC connectivity test for a specific service
      properties:
        statusCode:
          type: object
          properties:
            value:
              type: integer
              description: HTTP status code from RPC service
              example: 200
        body:
          $ref: '#/components/schemas/MessageResult'
      required:
        - statusCode
        - body

    ErrorResponse:
      type: object
      description: Error response format
      properties:
        code:
          type: integer
          description: Error code
          example: 400
        message:
          type: string
          description: Error message
          example: "Invalid request parameter"
        data:
          type: "null"
          description: No data returned for errors
      required:
        - code
        - message

  # Message Schemas for Kafka Integration
  # Note: These are not HTTP APIs but message formats consumed by the service
  
    # Kafka Message Schemas
    CoinStartMessage:
      type: object
      description: Message format for coin-start topic (new coin activation)
      properties:
        name:
          type: string
          description: Full name of the cryptocurrency
          example: "Bitcoin"
      required:
        - name

    DepositMessage:
      type: object
      description: Message format for deposit topic (incoming cryptocurrency transactions)
      properties:
        amount:
          type: number
          format: decimal
          description: Deposit amount
          example: 0.5
        txid:
          type: string
          description: Blockchain transaction ID
          example: "abc123def456..."
        address:
          type: string
          description: Wallet address receiving the deposit
          example: "1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa"
        userId:
          type: integer
          format: int64
          description: User ID for memo-based coins (EOS, XRP)
          example: 345679
      required:
        - amount
        - txid
        - address

    WithdrawMessage:
      type: object
      description: Message format for withdraw topic (withdrawal requests)
      properties:
        withdrawId:
          type: integer
          format: int64
          description: Withdrawal record ID
          example: 12345
        address:
          type: string
          description: Destination withdrawal address
          example: "1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN2"
        arriveAmount:
          type: number
          format: decimal
          description: Amount to arrive after fees
          example: 0.49
      required:
        - withdrawId
        - address
        - arriveAmount

    WithdrawNotifyMessage:
      type: object
      description: Message format for withdraw-notify topic (withdrawal status updates)
      properties:
        withdrawId:
          type: integer
          format: int64
          description: Withdrawal record ID
          example: 12345
        txid:
          type: string
          description: Blockchain transaction ID (if successful)
          example: "def456abc123..."
        status:
          type: integer
          description: Withdrawal status (0=failed, 1=success)
          enum: [0, 1]
          example: 1
      required:
        - withdrawId
        - status

    MemberRegisterMessage:
      type: object
      description: Message format for member-register topic (new user registration)
      properties:
        uid:
          type: integer
          format: int64
          description: New member's user ID
          example: 12345
      required:
        - uid

    ResetMemberAddressMessage:
      type: object
      description: Message format for reset-member-address topic (address regeneration)
      properties:
        uid:
          type: integer
          format: int64
          description: Member's user ID
          example: 12345
      required:
        - uid

# Additional API Documentation Notes:
#
# Kafka Topics Consumed:
# - coin-start: Triggered when new cryptocurrency is activated
# - deposit: Blockchain deposit notifications
# - withdraw: Withdrawal processing requests  
# - withdraw-notify: Withdrawal completion notifications
# - member-register: New member registration events
# - reset-member-address: Address regeneration requests
#
# RPC Service Dependencies:
# - SERVICE-RPC-{COIN}: Individual RPC services for each cryptocurrency
# - Endpoints: /rpc/height, /rpc/address/{account}, /rpc/address/batch, /rpc/withdraw
#
# The service operates primarily in message-driven mode with minimal HTTP API exposure.
# External integration should focus on Kafka message publishing rather than direct API calls.
```