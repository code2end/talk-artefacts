# Wallet RPC Services Entity Relationship Diagram

```mermaid
classDiagram
    class Account {
        +String account
        +String address
        +String walletFile
        +BigDecimal balance
        +BigDecimal gas
        +getAccount() String
        +getAddress() String
        +updateBalance(BigDecimal) void
    }

    class Deposit {
        +String txid
        +String blockHash
        +Long blockHeight
        +Date time
        +BigDecimal amount
        +String address
        +int status
        +getTxid() String
        +getAmount() BigDecimal
        +isConfirmed() boolean
    }

    class Coin {
        +String name
        +String unit
        +String rpc
        +String keystorePath
        +BigDecimal defaultMinerFee
        +String withdrawAddress
        +String withdrawWallet
        +String withdrawWalletPassword
        +BigDecimal minCollectAmount
        +BigInteger gasLimit
        +BigDecimal gasSpeedUp
        +BigDecimal rechargeMinerFee
        +String ignoreFromAddress
        +String masterAddress
        +getName() String
        +getUnit() String
        +getRpc() String
    }

    class Contract {
        +String address
        +String name
        +String symbol
        +int decimals
        +String abi
        +getAddress() String
        +getSymbol() String
        +getDecimals() int
    }

    class WatcherSetting {
        +String coinName
        +Long currentBlockHeight
        +int confirmation
        +Long checkInterval
        +int step
        +getCoinName() String
        +getCurrentBlockHeight() Long
        +updateBlockHeight(Long) void
    }

    class WatcherLog {
        +String coinName
        +Long blockHeight
        +Date timestamp
        +String status
        +getCoinName() String
        +getBlockHeight() Long
        +getTimestamp() Date
    }

    class BalanceSum {
        +BigDecimal totalBalance
        +String coinUnit
        +Date calculatedAt
        +getTotalBalance() BigDecimal
        +getCoinUnit() String
    }

    class DepositEvent {
        +Deposit deposit
        +String coinName
        +EventType eventType
        +Date timestamp
        +getDeposit() Deposit
        +getCoinName() String
    }

    class Watcher {
        <<abstract>>
        +Logger logger
        +boolean stop
        +Long checkInterval
        +Long currentBlockHeight
        +int step
        +int confirmation
        +DepositEvent depositEvent
        +Coin coin
        +WatcherLogService watcherLogService
        +check() void
        +replayBlock(Long, Long)* List~Deposit~
        +getNetworkBlockHeight()* Long
        +run() void
    }

    class BitcoinWatcher {
        +BitcoinRPCClient rpcClient
        +AccountService accountService
        +replayBlock(Long, Long) List~Deposit~
        +getNetworkBlockHeight() Long
    }

    class EthWatcher {
        +Web3j web3j
        +EthService ethService
        +replayBlock(Long, Long) List~Deposit~
        +getNetworkBlockHeight() Long
    }

    class TokenWatcher {
        +Web3j web3j
        +Contract contract
        +EthService ethService
        +replayBlock(Long, Long) List~Deposit~
        +getNetworkBlockHeight() Long
    }

    %% Relationships
    Coin "1" ||--o{ "many" Account : manages
    Account "1" ||--o{ "many" Deposit : receives
    Coin "1" ||--|| "0..1" Contract : has
    Coin "1" ||--|| "1" WatcherSetting : configures
    Coin "1" ||--o{ "many" WatcherLog : tracks
    Account "many" ||--|| "1" BalanceSum : aggregates_to
    Deposit "1" ||--|| "1" DepositEvent : triggers
    
    %% Watcher Hierarchy
    Watcher <|-- BitcoinWatcher : extends
    Watcher <|-- EthWatcher : extends
    Watcher <|-- TokenWatcher : extends
    
    %% Watcher Dependencies
    Watcher "1" --> "1" Coin : monitors
    Watcher "1" --> "1" WatcherSetting : uses
    Watcher "1" --> "many" WatcherLog : creates
    Watcher "1" --> "many" DepositEvent : publishes
    
    %% Service Level Relationships
    BitcoinWatcher --> Account : queries
    EthWatcher --> Account : queries
    TokenWatcher --> Account : queries
    TokenWatcher --> Contract : uses
```

## Entity Relationship Description

This class diagram illustrates the key entities in the Wallet RPC Services and their relationships:

### 1. Core Entities

#### Domain Models
- **Account**: Represents user wallet addresses with balance information for specific cryptocurrencies
- **Deposit**: Captures detected blockchain transactions that credit user accounts
- **Coin**: Configuration entity defining cryptocurrency-specific parameters and settings
- **Contract**: Smart contract definitions for token-based cryptocurrencies (ERC-20, etc.)

#### Monitoring & Configuration
- **WatcherSetting**: Configuration parameters for blockchain monitoring per cryptocurrency
- **WatcherLog**: Audit trail of blockchain synchronization operations
- **BalanceSum**: Aggregated balance calculations for reporting and monitoring

#### Event Processing
- **DepositEvent**: Event objects published when deposits are confirmed
- **Watcher**: Abstract base class for blockchain monitoring implementations

### 2. Key Relationships

#### Primary Associations
- **Coin to Account (1:many)**: Each cryptocurrency type manages multiple user accounts, organized in dedicated MongoDB collections following the pattern `{coin.unit}_address_book`
- **Account to Deposit (1:many)**: User accounts receive multiple deposit transactions over time, linked through address matching
- **Coin to Contract (1:0..1)**: Token-based cryptocurrencies have associated smart contract definitions, while native cryptocurrencies do not

#### Monitoring Configuration
- **Coin to WatcherSetting (1:1)**: Each cryptocurrency has exactly one monitoring configuration defining sync parameters
- **Coin to WatcherLog (1:many)**: Multiple audit log entries track synchronization history per cryptocurrency
- **Account to BalanceSum (many:1)**: Multiple accounts aggregate into summary balance calculations

#### Event Flow
- **Deposit to DepositEvent (1:1)**: Each confirmed deposit triggers exactly one event publication
- **Watcher to DepositEvent (1:many)**: Watcher implementations publish multiple deposit events as transactions are detected

### 3. Inheritance Hierarchy

#### Watcher Implementations
- **Watcher (Abstract)**: Base class defining common blockchain monitoring behavior
  - **BitcoinWatcher**: Bitcoin-specific implementation using BitcoinRPCClient
  - **EthWatcher**: Ethereum-specific implementation using Web3j library
  - **TokenWatcher**: ERC-20 token implementation extending Ethereum functionality

### 4. Data Storage Patterns

#### MongoDB Collections
- **Account Collections**: Dynamically named collections per cryptocurrency (e.g., `BTC_address_book`, `ETH_address_book`)
- **Configuration Storage**: Coin and WatcherSetting entities stored in shared configuration collections
- **Audit Logging**: WatcherLog entries maintain synchronization history across all wallet types

#### Cross-Service Data Isolation
- Each wallet service (bitcoin, eth, erc-token, etc.) operates on isolated data sets
- No direct foreign key relationships exist across different cryptocurrency types
- Service-to-service communication handles cross-wallet operations

### 5. Processing Flow Integration

#### Deposit Detection Flow
1. **Watcher** monitors blockchain using **WatcherSetting** parameters
2. Detected transactions create **Deposit** entities linked to **Account** records
3. Confirmed deposits trigger **DepositEvent** publication via Kafka
4. **WatcherLog** entries track synchronization progress and audit trail

#### Balance Management Flow
1. **Account** entities maintain real-time balance updates from confirmed deposits
2. **BalanceSum** aggregations provide hot wallet totals for operational monitoring
3. Balance calculations respect cryptocurrency-specific decimal precision requirements

### 6. Scalability Considerations

#### Horizontal Scaling
- Each cryptocurrency service scales independently based on transaction volume
- MongoDB collections partition naturally by cryptocurrency type
- Event publishing through Kafka enables decoupled processing of deposit notifications

#### Performance Optimization
- Account lookups optimized through MongoDB indexing on address fields
- Batch processing of blockchain synchronization reduces RPC call overhead
- Configurable confirmation requirements balance security with processing speed

This diagram provides a comprehensive view of the data model relationships that enable secure, scalable multi-cryptocurrency wallet operations within the exchange platform.
