# Step 6: Account Management Service

## Objective
Building on the core XRP service, create an account management service that handles the mapping between users and XRP destination tags, since XRP uses a shared address model.

## Requirements

Please create `XrpAccountService.java` that implements:

1. **Account Management**:
   - `saveOne(String username, String address, Long destinationTag)` - save user account with destination tag
   - `removeByName(String name)` - remove account by username
   - `getCollectionName()` - return MongoDB collection name based on coin unit

2. **Destination Tag Operations**:
   - `isDestinationTagExist(Long destinationTag)` - check if tag is already used
   - `findByDestinationTag(Long destinationTag)` - find account by destination tag
   - `getBalanceByDestinationTag(Long destinationTag)` - get balance for specific tag

3. **Balance Management**:
   - `updateBalance(Long destinationTag, BigDecimal balance)` - update user balance

The service should:
- Use MongoDB with proper queries and updates
- Follow the collection naming pattern "{coin_unit}_address_book"
- Use the Coin bean for configuration
- Handle cases where destination tags don't exist
- Use proper error handling and return MessageResult objects where appropriate

## Expected Deliverables
- `XrpAccountService.java` - Account management service with destination tag handling
- MongoDB integration with proper queries and updates
- Balance management functionality for destination tags
