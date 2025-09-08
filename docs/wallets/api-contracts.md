```yaml
openapi: 3.0.3
info:
  title: Wallet RPC Services API
  description: |
    Multi-cryptocurrency wallet management API providing secure wallet operations,
    transaction processing, and blockchain monitoring for a cryptocurrency exchange platform.
    
    Each supported cryptocurrency (BTC, ETH, ERC-20 tokens, etc.) implements this
    standardized API contract with blockchain-specific implementations.
  version: 1.2.0
  contact:
    name: Bizzan Exchange Team
    
servers:
  - url: /rpc
    description: Standard wallet RPC endpoint prefix

tags:
  - name: Blockchain Info
    description: Operations for querying blockchain status and information
  - name: Address Management  
    description: Operations for generating and managing user deposit addresses
  - name: Balance Operations
    description: Operations for querying wallet and address balances
  - name: Transaction Operations
    description: Operations for processing withdrawals and transfers
  - name: Monitoring Operations
    description: Operations for blockchain synchronization and monitoring

paths:
  /height:
    get:
      tags:
        - Blockchain Info
      summary: Get current blockchain height
      description: |
        Returns the current blockchain height as seen by the wallet service.
        This represents the latest block that has been processed by the monitoring system.
      responses:
        '200':
          description: Current blockchain height retrieved successfully
          content:
            application/json:
              schema:
                allOf:
                  - $ref: '#/components/schemas/MessageResult'
                  - type: object
                    properties:
                      data:
                        type: integer
                        format: int64
                        example: 756432
                        description: Current block height
        '500':
          description: Error querying blockchain height
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResult'

  /address/{account}:
    get:
      tags:
        - Address Management
      summary: Generate new deposit address
      description: |
        Generates a new blockchain address for the specified user account.
        The address is automatically stored and monitored for incoming deposits.
      parameters:
        - name: account
          in: path
          required: true
          description: User account identifier
          schema:
            type: string
            example: "user123"
        - name: password
          in: query
          required: false
          description: Wallet password (required for some wallet types like Ethereum)
          schema:
            type: string
            default: ""
      responses:
        '200':
          description: Address generated successfully
          content:
            application/json:
              schema:
                allOf:
                  - $ref: '#/components/schemas/MessageResult'
                  - type: object
                    properties:
                      data:
                        type: string
                        example: "1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa"
                        description: Generated blockchain address
        '500':
          description: Error generating address
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResult'

  /balance:
    get:
      tags:
        - Balance Operations
      summary: Get hot wallet total balance
      description: |
        Returns the total balance across all addresses managed by this wallet service.
        This represents the sum of all user deposits held in the hot wallet.
      responses:
        '200':
          description: Total balance retrieved successfully
          content:
            application/json:
              schema:
                allOf:
                  - $ref: '#/components/schemas/MessageResult'
                  - type: object
                    properties:
                      data:
                        type: string
                        example: "15.75834920"
                        description: Total balance in cryptocurrency base units
        '500':
          description: Error querying balance
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResult'

  /balance/{address}:
    get:
      tags:
        - Balance Operations
      summary: Get individual address balance
      description: |
        Returns the balance for a specific address managed by this wallet service.
      parameters:
        - name: address
          in: path
          required: true
          description: Blockchain address to query
          schema:
            type: string
            example: "1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa"
      responses:
        '200':
          description: Address balance retrieved successfully
          content:
            application/json:
              schema:
                allOf:
                  - $ref: '#/components/schemas/MessageResult'
                  - type: object
                    properties:
                      data:
                        type: string
                        example: "0.25000000"
                        description: Address balance in cryptocurrency base units
        '500':
          description: Error querying address balance
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResult'

  /withdraw:
    get:
      tags:
        - Transaction Operations
      summary: Process withdrawal transaction
      description: |
        Creates and broadcasts a withdrawal transaction to the specified address.
        Supports both synchronous and asynchronous processing modes.
      parameters:
        - name: address
          in: query
          required: true
          description: Destination address for withdrawal
          schema:
            type: string
            example: "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh"
        - name: amount
          in: query
          required: true
          description: Withdrawal amount in cryptocurrency base units
          schema:
            type: string
            example: "0.50000000"
        - name: fee
          in: query
          required: false
          description: Transaction fee (calculated automatically if not provided)
          schema:
            type: string
            example: "0.00010000"
        - name: sync
          in: query
          required: false
          description: Whether to process synchronously (wait for broadcast confirmation)
          schema:
            type: boolean
            default: true
        - name: withdrawId
          in: query
          required: false
          description: Unique withdrawal request identifier for idempotency
          schema:
            type: string
            example: "wd_123456789"
      responses:
        '200':
          description: Withdrawal processed successfully
          content:
            application/json:
              schema:
                allOf:
                  - $ref: '#/components/schemas/MessageResult'
                  - type: object
                    properties:
                      data:
                        type: string
                        example: "txid_abc123def456"
                        description: Transaction hash of the withdrawal
        '500':
          description: Withdrawal processing error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResult'

  /transfer:
    get:
      tags:
        - Transaction Operations
      summary: Internal wallet transfer
      description: |
        Performs internal transfer operations, typically collecting funds from
        user addresses to hot wallet or between internal wallets.
      parameters:
        - name: address
          in: query
          required: true
          description: Destination address for transfer
          schema:
            type: string
            example: "0x742d35cc6ba7c5d3b64b8f5e3e8e1e2d4a5b6c7d"
        - name: amount
          in: query
          required: true
          description: Transfer amount in cryptocurrency base units
          schema:
            type: string
            example: "1.25000000"
        - name: fee
          in: query
          required: false
          description: Transaction fee
          schema:
            type: string
            example: "0.00050000"
      responses:
        '200':
          description: Transfer completed successfully
          content:
            application/json:
              schema:
                allOf:
                  - $ref: '#/components/schemas/MessageResult'
                  - type: object
                    properties:
                      data:
                        type: string
                        example: "txid_transfer_789"
                        description: Transaction hash of the transfer
        '500':
          description: Transfer processing error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResult'

  /transaction/{txid}:
    get:
      tags:
        - Blockchain Info
      summary: Get transaction details
      description: |
        Retrieves detailed information about a specific transaction from the blockchain.
        Available for supported wallet types (Ethereum-based wallets).
      parameters:
        - name: txid
          in: path
          required: true
          description: Transaction hash to query
          schema:
            type: string
            example: "0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef"
      responses:
        '200':
          description: Transaction details retrieved successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'
        '500':
          description: Error retrieving transaction details
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResult'

  /gas-price:
    get:
      tags:
        - Blockchain Info
      summary: Get current gas price
      description: |
        Returns current network gas price for fee estimation.
        Available for Ethereum-based wallets only.
      responses:
        '200':
          description: Gas price retrieved successfully
          content:
            application/json:
              schema:
                allOf:
                  - $ref: '#/components/schemas/MessageResult'
                  - type: object
                    properties:
                      data:
                        type: string
                        example: "25.5"
                        description: Gas price in Gwei
        '500':
          description: Error retrieving gas price
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResult'

  /sync-block:
    get:
      tags:
        - Monitoring Operations
      summary: Manual blockchain synchronization
      description: |
        Triggers manual synchronization of blockchain blocks for the specified range.
        Used for recovery operations and manual sync control.
      parameters:
        - name: startBlock
          in: query
          required: true
          description: Starting block height for synchronization
          schema:
            type: integer
            format: int64
            example: 750000
        - name: endBlock
          in: query
          required: true
          description: Ending block height for synchronization
          schema:
            type: integer
            format: int64
            example: 750100
      responses:
        '200':
          description: Synchronization initiated successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MessageResult'
        '500':
          description: Synchronization initiation failed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResult'

components:
  schemas:
    MessageResult:
      type: object
      description: Standard API response wrapper used across all wallet services
      properties:
        code:
          type: integer
          description: Response code (0 for success, non-zero for errors)
          example: 0
        message:
          type: string
          description: Human-readable response message
          example: "success"
        data:
          type: object
          description: Response payload (varies by endpoint)
          nullable: true
      required:
        - code
        - message

    ErrorResult:
      type: object
      description: Error response format
      properties:
        code:
          type: integer
          description: Error code (500 for server errors)
          example: 500
        message:
          type: string
          description: Error description
          example: "查询失败,error:Connection refused"
      required:
        - code
        - message

    Account:
      type: object
      description: User account with wallet address information
      properties:
        account:
          type: string
          description: User account identifier
          example: "user123"
        address:
          type: string
          description: Blockchain address for deposits
          example: "1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa"
        balance:
          type: string
          description: Current account balance
          example: "0.25000000"
        gas:
          type: string
          description: Gas/fee balance (for token wallets)
          example: "0.01000000"
      required:
        - account
        - address

    Deposit:
      type: object
      description: Detected deposit transaction
      properties:
        txid:
          type: string
          description: Transaction hash
          example: "abc123def456..."
        blockHash:
          type: string
          description: Block hash containing transaction
          example: "00000000000000000008b..."
        blockHeight:
          type: integer
          format: int64
          description: Block height
          example: 756432
        amount:
          type: string
          description: Deposit amount
          example: "0.50000000"
        address:
          type: string
          description: Recipient address
          example: "1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa"
        time:
          type: string
          format: date-time
          description: Transaction timestamp
        status:
          type: integer
          description: Processing status (0=pending, 1=confirmed, 2=failed)
          example: 1
      required:
        - txid
        - amount
        - address

security: []

# API Usage Examples and Implementation Notes
x-implementation-notes: |
  ## Implementation Variants by Wallet Type
  
  ### Bitcoin-based Wallets (BTC, BCH, BSV, LTC)
  - Use BitcoinRPCClient for blockchain interaction
  - Address generation through RPC getNewAddress() call
  - Transaction scanning via block/transaction RPC methods
  - Fee calculation based on transaction size and network congestion
  
  ### Ethereum-based Wallets (ETH, ERC-20 tokens)
  - Use Web3j library for blockchain interaction  
  - Keystore-based address generation and management
  - Event-based transaction monitoring with confirmation tracking
  - Gas-based fee calculation with dynamic gas price estimation
  - Additional endpoints: /gas-price, /transaction/{txid}
  
  ### Token Wallets (ERC-20, etc.)
  - Inherit Ethereum wallet behavior with contract-specific logic
  - Smart contract interaction for balance queries and transfers
  - Separate gas balance tracking for transaction fees
  - Token-specific decimal handling and amount conversion
  
  ## Service-Specific Variations
  
  Each wallet service runs on a different port and registers with Eureka using
  distinct service names (e.g., service-rpc-btc, service-rpc-eth).
  
  Configuration differences include:
  - RPC endpoint URLs
  - Blockchain-specific parameters (gas limits, confirmation counts)
  - Fee calculation strategies
  - Address format validation rules
```