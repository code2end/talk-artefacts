# Wallet RPC Services Data Models

This document describes the core data models of the Wallet RPC Services and their relationships.

## Core Entities

### 1. Account

Represents a user account with associated wallet address and balance information for a specific cryptocurrency.

```java
public class Account {
    private String account;        // User account identifier
    private String address;        // Blockchain address for deposits
    private String walletFile;     // Private key path (for file-based wallets)
    private BigDecimal balance;    // Current balance (default: 0)
    private BigDecimal gas;        // Gas/fee balance for tokens (default: 0)
}
```

**Storage:** MongoDB collections per cryptocurrency following pattern `{COIN_UNIT}_address_book` (e.g., `BTC_address_book`, `ETH_address_book`)

### 2. Deposit

Represents a detected deposit transaction on the blockchain that credits a user account.

```java
public class Deposit {
    private String txid;           // Transaction hash
    private String blockHash;      // Block hash containing the transaction
    private Long blockHeight;      // Block number
    private Date time;            // Transaction timestamp
    private BigDecimal amount;     // Deposit amount
    private String address;        // Recipient address
    private int status;           // Processing status (default: 0)
}
```

**Processing States:**
- `0`: Detected, pending confirmation
- `1`: Confirmed and processed
- `2`: Failed/rejected

### 3. Coin

Configuration object defining cryptocurrency-specific parameters for wallet operations.

```java
public class Coin {
    private String name;                    // Full cryptocurrency name
    private String unit;                    // Currency symbol/unit (BTC, ETH, etc.)
    private String rpc;                     // RPC endpoint URL
    private String keystorePath;            // Keystore directory path
    private BigDecimal defaultMinerFee;     // Default transaction fee
    private String withdrawAddress;         // Hot wallet withdraw address
    private String withdrawWallet;          // Withdraw wallet file/identifier
    private String withdrawWalletPassword;  // Withdraw wallet password
    private BigDecimal minCollectAmount;    // Minimum amount for auto-collection
    private BigInteger gasLimit;           // Gas limit for Ethereum transactions
    private BigDecimal gasSpeedUp;         // Gas price multiplier (default: 1)
    private BigDecimal rechargeMinerFee;   // Recharge/deposit fee amount
    private String ignoreFromAddress;      // Address to ignore in deposits
    private String masterAddress;          // Master wallet address
}
```

### 4. Contract

Smart contract information for ERC-20 tokens and other contract-based cryptocurrencies.

```java
public class Contract {
    private String address;        // Contract address on blockchain
    private String name;          // Contract/token name
    private String symbol;        // Token symbol
    private int decimals;         // Token decimal places
    private String abi;           // Contract ABI (Application Binary Interface)
}
```

### 5. WatcherSetting

Configuration for blockchain monitoring and synchronization.

```java
public class WatcherSetting {
    private String coinName;           // Cryptocurrency name
    private Long currentBlockHeight;   // Current synchronized block height
    private int confirmation;          // Required confirmations
    private Long checkInterval;        // Sync interval in milliseconds
    private int step;                 // Blocks to process per batch
}
```

### 6. WatcherLog

Audit trail for blockchain synchronization operations.

```java
public class WatcherLog {
    private String coinName;      // Cryptocurrency name
    private Long blockHeight;     // Last processed block height
    private Date timestamp;       // Last update time
    private String status;        // Sync status
}
```

### 7. BalanceSum

Aggregated balance calculation result for reporting.

```java
public class BalanceSum {
    private BigDecimal totalBalance;  // Total balance across all addresses
    private String coinUnit;          // Currency unit
    private Date calculatedAt;        // Calculation timestamp
}
```

## Relationships

1. **Account to Coin**: **Many-to-One**
   - Each Account belongs to one specific Coin type
   - One Coin can have many associated Accounts
   - Relationship managed through MongoDB collection naming: `{coin.unit}_address_book`

2. **Deposit to Account**: **Many-to-One** 
   - Each Deposit is associated with one Account (via address matching)
   - One Account can have many Deposits over time
   - Relationship established through address lookup during deposit processing

3. **Coin to Contract**: **One-to-One** (for token-based cryptocurrencies)
   - ERC-20 tokens have an associated Contract entity
   - Native cryptocurrencies (BTC, ETH) do not have Contract associations
   - Relationship managed through service-level configuration

4. **WatcherSetting to Coin**: **One-to-One**
   - Each Coin has exactly one WatcherSetting for blockchain monitoring
   - Relationship established through coinName matching

5. **WatcherLog to Coin**: **Many-to-One**
   - Multiple WatcherLog entries per Coin for audit history
   - Relationship established through coinName matching

## Status Enumerations

### DepositStatus
- `0`: **PENDING** - Transaction detected but awaiting confirmations
- `1`: **CONFIRMED** - Transaction confirmed and balance credited
- `2`: **FAILED** - Transaction processing failed or rejected

### WatcherStatus  
- `ACTIVE`: Blockchain monitoring is running normally
- `SYNCING`: Currently synchronizing missed blocks
- `ERROR`: Monitoring encountered errors and needs attention
- `STOPPED`: Monitoring has been manually stopped

### TransactionType
- `DEPOSIT`: Incoming transaction to user address
- `WITHDRAWAL`: Outgoing transaction from hot wallet
- `TRANSFER`: Internal wallet-to-wallet transfer
- `COLLECTION`: Automatic collection to hot wallet

## Processing Flow

The typical processing flow involving these entities follows this sequence:

1. **Address Generation**: 
   - User requests new address → Account entity created with unique address
   - Account stored in cryptocurrency-specific MongoDB collection

2. **Deposit Detection**:
   - Watcher monitors blockchain → detects transaction to managed address
   - Deposit entity created with transaction details
   - Account balance updated after confirmation requirements met

3. **Balance Aggregation**:
   - Periodic calculation of BalanceSum across all Account entities
   - Used for hot wallet total balance reporting and reserve monitoring

4. **Withdrawal Processing**:
   - Withdrawal request → balance validation against Account entities
   - Transaction creation using Coin configuration parameters
   - Account balance updated after successful broadcast

5. **Blockchain Synchronization**:
   - WatcherSetting defines monitoring parameters per cryptocurrency
   - WatcherLog maintains audit trail of synchronization progress
   - Automatic recovery from synchronization gaps during service restarts

## Data Consistency Considerations

- **Eventual Consistency**: Balance updates are eventually consistent due to blockchain confirmation requirements
- **Idempotency**: Deposit processing is idempotent based on transaction ID to prevent duplicate credits
- **Atomic Operations**: Account balance updates use MongoDB atomic operations to prevent race conditions
- **Cross-Service Consistency**: No cross-cryptocurrency transactions ensure service independence and data isolation
