# Step 10: Deposit Monitoring Watcher Component

## Objective
Implement the deposit monitoring component that watches the XRP Ledger for incoming transactions and identifies deposits to tracked destination tags.

## Requirements

Please create `XrpWatcher.java` that extends the existing `Watcher` class:

1. **Ledger Monitoring**:
   - `replayBlock(Long startLedgerIndex, Long endLedgerIndex)` method that scans ledger ranges
   - Iterate through ledger indices and fetch transaction data
   - Filter for Payment transactions to the master address

2. **Deposit Detection**:
   - Check payments for valid destination tags
   - Verify destination tags exist in the account database
   - Convert XRP amounts from drops to standard XRP units
   - Create Deposit entities with all required fields (txid, amount, address, etc.)

3. **Network Height**:
   - `getNetworkBlockHeight()` method that returns current ledger index
   - Proper error handling returning 0L on failure

4. **Utility Methods**:
   - `convertDropsToXrp(String drops)` helper method

The watcher should:
- Use the XrplClient to interact with the XRP Ledger
- Use XrpAccountService to validate destination tags
- Follow the existing Watcher pattern used by other wallet services
- Handle XRP-specific transaction formats and validation
- Return null on errors to trigger retry logic

## Expected Deliverables
- `XrpWatcher.java` - Watcher component extending base Watcher class
- Deposit detection and validation logic
- Integration with XRP Ledger and account service
