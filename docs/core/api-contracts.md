```yaml
openapi: 3.0.3
info:
  title: Cryptocurrency Exchange Core Module API
  description: |
    Core module API for the Bizzan cryptocurrency exchange platform. This module primarily provides
    business logic services and data models consumed by other exchange modules. The REST API surface
    is minimal as this is a shared library component.
    
    Most public-facing APIs are implemented in specialized modules:
    - ucenter-api: Member management and authentication APIs
    - exchange-api: Trading and market data APIs  
    - otc-api: Over-the-counter trading APIs
    - admin: Administrative management APIs
  version: 1.0.0
  contact:
    name: Bizzan Exchange Team
    url: https://www.bizzan.com

servers:
  - url: /core
    description: Core module server (typically not exposed externally)

tags:
  - name: Security
    description: Security and validation operations
  - name: Internal Services
    description: Internal business service interfaces (not REST endpoints)

paths:
  /captcha:
    get:
      tags:
        - Security
      summary: Generate CAPTCHA image
      description: |
        Generates a visual CAPTCHA image for form validation. The CAPTCHA text is stored
        in the HTTP session for subsequent validation. This endpoint is typically used
        by registration and login forms.
      parameters:
        - name: cid
          in: query
          required: false
          description: Client identifier for session management
          schema:
            type: string
            example: "login_form"
      responses:
        '200':
          description: CAPTCHA image generated successfully
          content:
            image/jpeg:
              schema:
                type: string
                format: binary
          headers:
            Cache-Control:
              description: Prevent caching of CAPTCHA images
              schema:
                type: string
                example: "no-store"
            Pragma:
              description: HTTP/1.0 caching directive
              schema:
                type: string
                example: "no-cache"
            Expires:
              description: Expiration timestamp
              schema:
                type: string
                example: "0"

# Note: The following are internal service interfaces, not REST endpoints
# They are documented here for completeness as they represent the primary
# contract interfaces provided by the core module to other components

components:
  schemas:
    MessageResult:
      type: object
      description: Standard response wrapper for service operations
      properties:
        code:
          type: integer
          description: Response code (0 = success, non-zero = error)
          example: 0
        message:
          type: string
          description: Response message
          example: "SUCCESS"
        data:
          type: object
          description: Response payload (varies by operation)
      required:
        - code
        - message

    Member:
      type: object
      description: Exchange member/user entity
      properties:
        id:
          type: integer
          format: int64
          description: Unique member identifier
        username:
          type: string
          description: Unique username
          example: "john_doe"
        email:
          type: string
          format: email
          description: Member email address
          example: "john@example.com"
        mobilePhone:
          type: string
          description: Mobile phone number
          example: "+1234567890"
        realName:
          type: string
          description: Real name from KYC verification
          example: "John Doe"
        memberLevel:
          type: integer
          description: Member verification level
          enum: [0, 1, 2, 3]
        status:
          type: integer
          description: Account status
          enum: [0, 1, 2]  # NORMAL, ILLEGAL, LOCKED
        realNameStatus:
          type: integer
          description: KYC verification status
          enum: [0, 1, 2, 3]  # NOT_CERTIFIED, VERIFIED, FAILED, PENDING
        registrationTime:
          type: string
          format: date-time
          description: Account registration timestamp
        transactionStatus:
          type: integer
          description: Trading permission status
          enum: [0, 1]  # DISABLED, ENABLED
      required:
        - id
        - username
        - email
        - status

    MemberWallet:
      type: object
      description: Member cryptocurrency wallet
      properties:
        id:
          type: integer
          format: int64
          description: Unique wallet identifier
        memberId:
          type: integer
          format: int64
          description: Owner member ID
        coin:
          $ref: '#/components/schemas/Coin'
        balance:
          type: string
          pattern: '^[0-9]+(\.[0-9]+)?$'
          description: Available balance (decimal string for precision)
          example: "1.50000000"
        frozenBalance:
          type: string
          pattern: '^[0-9]+(\.[0-9]+)?$'
          description: Frozen/locked balance
          example: "0.25000000"
        address:
          type: string
          description: Cryptocurrency wallet address
          example: "1A2B3C4D5E6F7G8H9I0J1K2L3M4N5O6P7Q"
        isLock:
          type: integer
          description: Wallet lock status
          enum: [0, 1]  # UNLOCKED, LOCKED
      required:
        - id
        - memberId
        - coin
        - balance
        - frozenBalance

    Coin:
      type: object
      description: Cryptocurrency configuration
      properties:
        name:
          type: string
          description: Cryptocurrency name (primary key)
          example: "Bitcoin"
        unit:
          type: string
          description: Currency unit symbol
          example: "BTC"
        nameCn:
          type: string
          description: Chinese display name
          example: "比特币"
        status:
          type: integer
          description: Coin operational status
          enum: [0, 1, 2]  # NORMAL, ILLEGAL, LOCKED
        cnyRate:
          type: number
          format: double
          description: Exchange rate to Chinese Yuan
          example: 285000.00
        usdRate:
          type: number
          format: double
          description: Exchange rate to US Dollar
          example: 42000.00
        canWithdraw:
          type: integer
          description: Withdrawal capability
          enum: [0, 1]
        canRecharge:
          type: integer
          description: Deposit capability
          enum: [0, 1]
        minWithdrawAmount:
          type: string
          description: Minimum withdrawal amount
          example: "0.001"
        maxWithdrawAmount:
          type: string
          description: Maximum withdrawal amount
          example: "100.0"
      required:
        - name
        - unit
        - status

    Order:
      type: object
      description: OTC trading order
      properties:
        id:
          type: integer
          format: int64
          description: Unique order identifier
        orderSn:
          type: string
          description: Human-readable order number
          example: "OTC20231201001"
        advertiseType:
          type: integer
          description: Order type
          enum: [0, 1]  # BUY, SELL
        status:
          type: integer
          description: Order processing status
          enum: [0, 1, 2, 3, 4]  # CANCELLED, NONPAYMENT, PAID, COMPLETED, APPEAL
        memberId:
          type: integer
          format: int64
          description: Order creator (advertiser) ID
        customerId:
          type: integer
          format: int64
          description: Order taker (customer) ID
        coin:
          $ref: '#/components/schemas/OtcCoin'
        price:
          type: string
          description: Unit price in fiat currency
          example: "42000.00"
        number:
          type: string
          description: Cryptocurrency amount
          example: "0.5"
        money:
          type: string
          description: Total fiat amount
          example: "21000.00"
        commission:
          type: string
          description: Platform fee
          example: "0.005"
        payMode:
          type: string
          description: Payment methods (comma-separated)
          example: "BANK_TRANSFER,ALIPAY"
        createTime:
          type: string
          format: date-time
          description: Order creation time
      required:
        - id
        - orderSn
        - advertiseType
        - status
        - memberId
        - customerId

    OtcCoin:
      type: object
      description: OTC-enabled cryptocurrency configuration
      properties:
        id:
          type: integer
          format: int64
          description: Unique OTC coin identifier
        name:
          type: string
          description: Cryptocurrency name
          example: "Bitcoin"
        unit:
          type: string
          description: Currency unit
          example: "BTC"
        nameCn:
          type: string
          description: Chinese name
          example: "比特币"
        status:
          type: integer
          description: OTC trading status
          enum: [0, 1, 2]
        jyRate:
          type: string
          description: Trading fee rate
          example: "0.002"
        buyMinAmount:
          type: string
          description: Minimum buy advertisement amount
          example: "0.01"
        sellMinAmount:
          type: string
          description: Minimum sell advertisement amount
          example: "0.01"
      required:
        - id
        - name
        - unit
        - status

    MemberTransaction:
      type: object
      description: Member financial transaction record
      properties:
        id:
          type: integer
          format: int64
          description: Unique transaction ID
        memberId:
          type: integer
          format: int64
          description: Member ID
        amount:
          type: string
          description: Transaction amount
          example: "1.5"
        type:
          type: integer
          description: Transaction type
          enum: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
        symbol:
          type: string
          description: Cryptocurrency symbol
          example: "BTC"
        createTime:
          type: string
          format: date-time
          description: Transaction timestamp
        comment:
          type: string
          description: Transaction description
          example: "OTC trade settlement"
        fee:
          type: string
          description: Transaction fee
          example: "0.002"
      required:
        - id
        - memberId
        - amount
        - type
        - symbol

  # Internal Service Interfaces (not REST endpoints)
  # These represent the primary business service contracts provided by the core module
  
  x-internal-services:
    MemberService:
      description: Core member management business service
      methods:
        - name: "login"
          description: "Authenticate member with username/password"
          parameters:
            - name: username
              type: string
            - name: password
              type: string
          returns:
            type: Member
          throws:
            - AuthenticationException
            
        - name: "save"
          description: "Persist member entity changes"
          parameters:
            - name: member
              type: Member
          returns:
            type: Member
            
        - name: "findByEmail"
          description: "Locate member by email address"
          parameters:
            - name: email
              type: string
          returns:
            type: Member

    MemberWalletService:
      description: Cryptocurrency wallet management service
      methods:
        - name: "recharge"
          description: "Process cryptocurrency deposit to member wallet"
          parameters:
            - name: wallet
              type: MemberWallet
            - name: amount
              type: BigDecimal
          returns:
            type: MessageResult
            
        - name: "withdraw"
          description: "Process cryptocurrency withdrawal from member wallet"
          parameters:
            - name: wallet
              type: MemberWallet
            - name: amount
              type: BigDecimal
            - name: address
              type: string
          returns:
            type: MessageResult
            
        - name: "freezeBalance"
          description: "Lock wallet balance for trading orders"
          parameters:
            - name: wallet
              type: MemberWallet
            - name: amount
              type: BigDecimal
          returns:
            type: MessageResult
            
        - name: "thawBalance"
          description: "Unlock previously frozen wallet balance"
          parameters:
            - name: wallet
              type: MemberWallet
            - name: amount
              type: BigDecimal
          returns:
            type: MessageResult

    OrderService:
      description: OTC order processing and management service
      methods:
        - name: "createOrder"
          description: "Create new OTC trading order from advertisement"
          parameters:
            - name: advertise
              type: Advertise
            - name: customer
              type: Member
            - name: amount
              type: BigDecimal
          returns:
            type: Order
            
        - name: "cancelOrder"
          description: "Cancel existing order and release frozen funds"
          parameters:
            - name: orderSn
              type: string
          returns:
            type: MessageResult
            
        - name: "payOrder"
          description: "Mark order as paid by customer"
          parameters:
            - name: order
              type: Order
          returns:
            type: MessageResult
            
        - name: "releaseOrder"
          description: "Complete order and transfer cryptocurrency"
          parameters:
            - name: order
              type: Order
          returns:
            type: MessageResult
```