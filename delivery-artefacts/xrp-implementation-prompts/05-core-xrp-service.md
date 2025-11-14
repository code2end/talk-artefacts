# Step 5: Core XRP Service Implementation

## Objective
Now implement the core XRP service layer that handles blockchain interactions. This service will provide the fundamental operations needed by the wallet system.

## Requirements

Please create `XrpService.java` that implements:

1. **Balance Operations**:
   - `getBalance(String address)` method that queries XRP Ledger and converts drops to XRP
   - Proper error handling with logging for failed requests

2. **Ledger Operations**:
   - `getCurrentLedgerIndex()` method to get the current ledger height
   - Error handling that returns 0L on failure

3. **Payment Operations**:
   - `sendPayment(String destinationAddress, BigDecimal amount, Long destinationTag)` method
   - Support for optional destination tags
   - Proper fee calculation converting XRP to drops
   - Return MessageResult with success/failure status and transaction hash

The service should:
- Use the injected XrplClient and XrpConfig
- Follow the existing logging patterns with @Slf4j
- Handle XRP's drop-based amounts (1 XRP = 1,000,000 drops)
- Use proper exception handling and return appropriate MessageResult objects

## Expected Deliverables
- `XrpService.java` - Core service class with balance, ledger, and payment operations
- Proper error handling and logging
- Integration with XRP Ledger through xrpl4j client
