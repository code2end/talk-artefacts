# Step 7: REST Controller - Basic Endpoints

## Objective
Now create the REST controller that exposes the standard wallet API endpoints. This controller needs to implement the same contract that other wallet services provide.

## Requirements

Please create `WalletController.java` with these initial endpoints:

1. **Network Information**:
   - `GET /rpc/height` - returns current ledger height
   - Follows the standard MessageResult response pattern

2. **Balance Endpoints**:
   - `GET /rpc/balance` - returns master wallet balance
   - `GET /rpc/balance/{addressOrTag}` - returns balance for address or destination tag
   - Should detect if parameter is a destination tag (numeric) vs address

3. **Helper Methods**:
   - `extractUserIdFromAccount(String account)` - extract user ID from "U123456" format
   - `isDestinationTag(String value)` - determine if string is a numeric destination tag

The controller should:
- Use proper Spring annotations (@RestController, @RequestMapping("/rpc"))
- Inject and use XrpService and XrpAccountService
- Follow existing error handling patterns
- Use @Slf4j for logging
- Return consistent MessageResult responses matching other wallet services

## Expected Deliverables
- `WalletController.java` - REST controller with height and balance endpoints
- Proper Spring MVC annotations and dependency injection
- Standard MessageResult response patterns
