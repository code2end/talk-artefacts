```yaml
openapi: 3.0.3
info:
  title: ucenter-api API
  description: User Center API for cryptocurrency exchange platform providing authentication, user management, wallet operations, withdrawal processing, and promotional activities
  version: 1.0.0
  contact:
    name: Development Team
servers:
  - url: /uc
    description: Default API server

tags:
  - name: Authentication
    description: User login and session management operations
  - name: Registration
    description: User registration and account creation
  - name: Members
    description: User profile and account management
  - name: Assets
    description: Wallet operations and transaction management
  - name: Withdrawals
    description: Cryptocurrency withdrawal processing
  - name: Promotions
    description: Referral system and promotional campaigns
  - name: Utilities
    description: System utilities and supporting operations

paths:
  /login:
    post:
      tags:
        - Authentication
      summary: User login
      description: Authenticate user with username/password and optional CAPTCHA verification
      parameters:
        - name: username
          in: query
          required: true
          schema:
            type: string
          description: Username or email or phone number
        - name: password
          in: query
          required: true
          schema:
            type: string
          description: User password
        - name: geetest_challenge
          in: query
          required: false
          schema:
            type: string
          description: Geetest CAPTCHA challenge
        - name: geetest_validate
          in: query
          required: false
          schema:
            type: string
          description: Geetest CAPTCHA validate
        - name: geetest_seccode
          in: query
          required: false
          schema:
            type: string
          description: Geetest CAPTCHA seccode
      responses:
        '200':
          description: Login successful
          content:
            application/json:
              schema:
                allOf:
                  - $ref: '#/components/schemas/MessageResult'
                  - type: object
                    properties:
                      data:
                        $ref: '#/components/schemas/LoginInfo'
        '400':
          description: Login failed or invalid credentials

  /loginout:
    post:
      tags:
        - Authentication
      summary: User logout
      description: End user session and clear authentication token
      responses:
        '200':
          description: Logout successful
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

  /check/login:
    get:
      tags:
        - Authentication
      summary: Check login status
      description: Verify if user is currently authenticated
      responses:
        '200':
          description: Login status check result
          content:
            application/json:
              schema:
                allOf:
                  - $ref: '#/components/schemas/MessageResult'
                  - type: object
                    properties:
                      data:
                        type: boolean
                        description: True if user is logged in

  /register/phone:
    post:
      tags:
        - Registration
      summary: Register with phone number
      description: Create new user account using phone number verification
      requestBody:
        required: true
        content:
          application/x-www-form-urlencoded:
            schema:
              $ref: '#/components/schemas/LoginByPhone'
      responses:
        '200':
          description: Registration successful
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'
        '400':
          description: Registration failed or validation error

  /register/for_phone:
    post:
      tags:
        - Registration
      summary: Mobile app registration
      description: Register new user account from mobile application
      requestBody:
        required: true
        content:
          application/x-www-form-urlencoded:
            schema:
              $ref: '#/components/schemas/LoginByPhone'
      responses:
        '200':
          description: Registration successful
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

  /register/check/username:
    post:
      tags:
        - Registration
      summary: Check username availability
      description: Verify if username is available for registration
      parameters:
        - name: username
          in: query
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Username availability result
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

  /support/country:
    post:
      tags:
        - Registration
      summary: Get supported countries
      description: Retrieve list of countries supported for registration
      responses:
        '200':
          description: List of supported countries
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
                          $ref: '#/components/schemas/Country'

  /member/sign-in:
    post:
      tags:
        - Members
      summary: Daily sign-in
      description: Perform daily sign-in to earn rewards
      security:
        - sessionAuth: []
      responses:
        '200':
          description: Sign-in successful
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'
        '401':
          description: Authentication required

  /member/my-info:
    post:
      tags:
        - Members
      summary: Get user information
      description: Retrieve current user's profile and account information
      security:
        - sessionAuth: []
      responses:
        '200':
          description: User information retrieved
          content:
            application/json:
              schema:
                allOf:
                  - $ref: '#/components/schemas/MessageResult'
                  - type: object
                    properties:
                      data:
                        $ref: '#/components/schemas/LoginInfo'

  /asset/wallet:
    get:
      tags:
        - Assets
      summary: Get user wallets
      description: Retrieve all cryptocurrency wallets for the authenticated user
      security:
        - sessionAuth: []
      responses:
        '200':
          description: User wallets retrieved
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
                          $ref: '#/components/schemas/MemberWallet'

  /asset/wallet/{symbol}:
    get:
      tags:
        - Assets
      summary: Get wallet by symbol
      description: Retrieve specific cryptocurrency wallet by symbol
      security:
        - sessionAuth: []
      parameters:
        - name: symbol
          in: path
          required: true
          schema:
            type: string
          description: Cryptocurrency symbol (e.g., BTC, ETH)
      responses:
        '200':
          description: Wallet information retrieved
          content:
            application/json:
              schema:
                allOf:
                  - $ref: '#/components/schemas/MessageResult'
                  - type: object
                    properties:
                      data:
                        $ref: '#/components/schemas/MemberWallet'

  /asset/transaction:
    get:
      tags:
        - Assets
      summary: Get transactions by type
      description: Retrieve user transaction history filtered by transaction type
      security:
        - sessionAuth: []
      parameters:
        - name: pageNo
          in: query
          required: true
          schema:
            type: integer
        - name: pageSize
          in: query
          required: true
          schema:
            type: integer
        - name: type
          in: query
          required: true
          schema:
            $ref: '#/components/schemas/TransactionType'
      responses:
        '200':
          description: Transaction history retrieved
          content:
            application/json:
              schema:
                allOf:
                  - $ref: '#/components/schemas/MessageResult'
                  - type: object
                    properties:
                      data:
                        type: object
                        properties:
                          content:
                            type: array
                            items:
                              $ref: '#/components/schemas/MemberTransaction'

  /asset/transaction/all:
    get:
      tags:
        - Assets
      summary: Get all transactions
      description: Retrieve complete user transaction history with optional filtering
      security:
        - sessionAuth: []
      parameters:
        - name: pageNo
          in: query
          required: true
          schema:
            type: integer
        - name: pageSize
          in: query
          required: true
          schema:
            type: integer
        - name: startTime
          in: query
          required: false
          schema:
            type: string
            format: date-time
        - name: endTime
          in: query
          required: false
          schema:
            type: string
            format: date-time
        - name: symbol
          in: query
          required: false
          schema:
            type: string
        - name: type
          in: query
          required: false
          schema:
            type: string
      responses:
        '200':
          description: Complete transaction history retrieved
          content:
            application/json:
              schema:
                allOf:
                  - $ref: '#/components/schemas/MessageResult'
                  - type: object
                    properties:
                      data:
                        type: object

  /withdraw/address/add:
    post:
      tags:
        - Withdrawals
      summary: Add withdrawal address
      description: Add new cryptocurrency address for withdrawals with verification
      security:
        - sessionAuth: []
      parameters:
        - name: address
          in: query
          required: true
          schema:
            type: string
        - name: unit
          in: query
          required: true
          schema:
            type: string
        - name: remark
          in: query
          required: true
          schema:
            type: string
        - name: code
          in: query
          required: true
          schema:
            type: string
        - name: aims
          in: query
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Address added successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

  /withdraw/address/delete:
    post:
      tags:
        - Withdrawals
      summary: Delete withdrawal address
      description: Remove cryptocurrency address from withdrawal whitelist
      security:
        - sessionAuth: []
      parameters:
        - name: id
          in: query
          required: true
          schema:
            type: integer
            format: int64
      responses:
        '200':
          description: Address deleted successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

  /withdraw/address/page:
    post:
      tags:
        - Withdrawals
      summary: Get withdrawal addresses
      description: Retrieve paginated list of user's withdrawal addresses
      security:
        - sessionAuth: []
      parameters:
        - name: pageNo
          in: query
          required: true
          schema:
            type: integer
        - name: pageSize
          in: query
          required: true
          schema:
            type: integer
        - name: unit
          in: query
          required: false
          schema:
            type: string
      responses:
        '200':
          description: Withdrawal addresses retrieved
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

  /withdraw/support/coin:
    post:
      tags:
        - Withdrawals
      summary: Get supported withdrawal coins
      description: Retrieve list of cryptocurrencies available for withdrawal
      responses:
        '200':
          description: Supported coins list
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

  /withdraw/support/coin/info:
    post:
      tags:
        - Withdrawals
      summary: Get withdrawal coin details
      description: Retrieve detailed information about withdrawable cryptocurrencies
      security:
        - sessionAuth: []
      responses:
        '200':
          description: Withdrawal coin information
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
                          $ref: '#/components/schemas/WithdrawWalletInfo'

  /withdraw/apply/code:
    post:
      tags:
        - Withdrawals
      summary: Submit withdrawal request with verification
      description: Submit cryptocurrency withdrawal request with SMS/email verification
      security:
        - sessionAuth: []
      parameters:
        - name: unit
          in: query
          required: true
          schema:
            type: string
        - name: address
          in: query
          required: true
          schema:
            type: string
        - name: amount
          in: query
          required: true
          schema:
            type: number
            format: decimal
        - name: fee
          in: query
          required: true
          schema:
            type: number
            format: decimal
        - name: remark
          in: query
          required: false
          schema:
            type: string
        - name: jyPassword
          in: query
          required: true
          schema:
            type: string
        - name: code
          in: query
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Withdrawal request submitted successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

  /withdraw/record:
    get:
      tags:
        - Withdrawals
      summary: Get withdrawal history
      description: Retrieve user's withdrawal request history
      security:
        - sessionAuth: []
      parameters:
        - name: page
          in: query
          required: true
          schema:
            type: integer
        - name: pageSize
          in: query
          required: true
          schema:
            type: integer
      responses:
        '200':
          description: Withdrawal history retrieved
          content:
            application/json:
              schema:
                allOf:
                  - $ref: '#/components/schemas/MessageResult'
                  - type: object
                    properties:
                      data:
                        type: object

  /promotion/mypromotion:
    post:
      tags:
        - Promotions
      summary: Get promotion statistics
      description: Retrieve user's promotion statistics and referral data
      security:
        - sessionAuth: []
      responses:
        '200':
          description: Promotion statistics retrieved
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

  /promotion/toprank:
    post:
      tags:
        - Promotions
      summary: Get promotion rankings
      description: Retrieve top referral rankings and statistics
      parameters:
        - name: top
          in: query
          required: false
          schema:
            type: integer
            default: 20
      responses:
        '200':
          description: Top promotion rankings
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

  /promotion/record:
    post:
      tags:
        - Promotions
      summary: Get promotion records
      description: Retrieve user's referral records with pagination
      security:
        - sessionAuth: []
      parameters:
        - name: pageNo
          in: query
          required: false
          schema:
            type: integer
            default: 1
        - name: pageSize
          in: query
          required: false
          schema:
            type: integer
            default: 10
      responses:
        '200':
          description: Promotion records retrieved
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

  /promotion/reward/record:
    post:
      tags:
        - Promotions
      summary: Get reward records
      description: Retrieve user's promotion reward history
      security:
        - sessionAuth: []
      parameters:
        - name: pageNo
          in: query
          required: false
          schema:
            type: integer
            default: 1
        - name: pageSize
          in: query
          required: false
          schema:
            type: integer
            default: 10
      responses:
        '200':
          description: Reward records retrieved
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

  /promotion/promotioncard/getfreecard:
    post:
      tags:
        - Promotions
      summary: Get free promotion card
      description: Claim free promotional card (one-time per user)
      security:
        - sessionAuth: []
      responses:
        '200':
          description: Free card claimed successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

  /promotion/promotioncard/exchangecard:
    post:
      tags:
        - Promotions
      summary: Exchange promotion card
      description: Redeem promotional card with unique code
      security:
        - sessionAuth: []
      parameters:
        - name: cardNo
          in: query
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Card exchanged successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'

components:
  schemas:
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
          description: Response data payload

    LoginInfo:
      type: object
      properties:
        username:
          type: string
        id:
          type: integer
          format: int64
        token:
          type: string
        realName:
          type: string
        avatar:
          type: string
        promotionCode:
          type: string
        loginCount:
          type: integer
        superPartner:
          type: string
        promotionPrefix:
          type: string
        signInAbility:
          type: boolean
        signInActivity:
          type: boolean
        firstLevel:
          type: integer
        secondLevel:
          type: integer
        thirdLevel:
          type: integer
        memberLevel:
          $ref: '#/components/schemas/MemberLevelEnum'
        location:
          $ref: '#/components/schemas/Location'
        country:
          $ref: '#/components/schemas/Country'

    LoginByPhone:
      type: object
      required:
        - phone
        - password
        - username
        - country
        - code
      properties:
        phone:
          type: string
          description: Mobile phone number
        password:
          type: string
          minLength: 6
          maxLength: 20
        username:
          type: string
          minLength: 3
          maxLength: 20
        country:
          type: string
        code:
          type: string
          description: SMS verification code
        promotion:
          type: string
          description: Referral code (optional)
        superPartner:
          type: string
          description: Partner level indicator
        ticket:
          type: string
          description: Anti-bot verification ticket
        randStr:
          type: string
          description: Anti-bot random string

    MemberWallet:
      type: object
      properties:
        id:
          type: integer
          format: int64
        memberId:
          type: integer
          format: int64
        balance:
          type: number
          format: decimal
        frozenBalance:
          type: number
          format: decimal
        toReleased:
          type: number
          format: decimal
        address:
          type: string
        memo:
          type: string
        isLock:
          $ref: '#/components/schemas/BooleanEnum'
        coin:
          $ref: '#/components/schemas/Coin'

    Coin:
      type: object
      properties:
        name:
          type: string
        nameCn:
          type: string
        unit:
          type: string
        status:
          $ref: '#/components/schemas/CommonStatus'
        minTxFee:
          type: number
        maxTxFee:
          type: number
        cnyRate:
          type: number
        usdRate:
          type: number
        canWithdraw:
          $ref: '#/components/schemas/BooleanEnum'
        canRecharge:
          $ref: '#/components/schemas/BooleanEnum'
        canTransfer:
          $ref: '#/components/schemas/BooleanEnum'
        canAutoWithdraw:
          $ref: '#/components/schemas/BooleanEnum'
        withdrawThreshold:
          type: number
          format: decimal
        minWithdrawAmount:
          type: number
          format: decimal
        maxWithdrawAmount:
          type: number
          format: decimal
        minRechargeAmount:
          type: number
          format: decimal
        isPlatformCoin:
          $ref: '#/components/schemas/BooleanEnum'
        hasLegal:
          type: boolean
        withdrawScale:
          type: integer
        accountType:
          type: integer

    MemberTransaction:
      type: object
      properties:
        id:
          type: integer
          format: int64
        memberId:
          type: integer
          format: int64
        amount:
          type: number
          format: decimal
        createTime:
          type: string
          format: date-time
        type:
          $ref: '#/components/schemas/TransactionType'
        symbol:
          type: string
        address:
          type: string
        fee:
          type: number
          format: decimal
        flag:
          type: integer

    WithdrawWalletInfo:
      type: object
      properties:
        balance:
          type: number
          format: decimal
        withdrawScale:
          type: integer
        maxTxFee:
          type: number
        minTxFee:
          type: number
        minAmount:
          type: number
          format: decimal
        maxAmount:
          type: number
          format: decimal
        name:
          type: string
        nameCn:
          type: string
        threshold:
          type: number
          format: decimal
        unit:
          type: string
        accountType:
          type: integer
        canAutoWithdraw:
          $ref: '#/components/schemas/BooleanEnum'
        addresses:
          type: array
          items:
            type: object

    Country:
      type: object
      properties:
        zhName:
          type: string
        enName:
          type: string
        areaCode:
          type: string
        language:
          type: string
        localCurrency:
          type: string

    Location:
      type: object
      properties:
        country:
          type: string
        province:
          type: string
        city:
          type: string
        district:
          type: string

    # Enums
    MemberLevelEnum:
      type: string
      enum:
        - GENERAL
        - REALNAME
        - AUTHENTICATED

    CommonStatus:
      type: string
      enum:
        - NORMAL
        - ILLEGAL

    BooleanEnum:
      type: string
      enum:
        - IS_FALSE
        - IS_TRUE

    TransactionType:
      type: string
      enum:
        - RECHARGE
        - WITHDRAW
        - TRANSFER_ACCOUNTS
        - EXCHANGE
        - WITHDRAW_PROMOTE_REWARD
        - DEPOSIT_PROMOTE_REWARD
        - ADMIN_RECHARGE
        - ADMIN_WITHDRAW
        - MATCH

  securitySchemes:
    sessionAuth:
      type: apiKey
      in: header
      name: JSESSIONID
      description: Session-based authentication using HTTP sessions
```