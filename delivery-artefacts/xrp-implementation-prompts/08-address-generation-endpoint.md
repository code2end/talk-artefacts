# Step 8: Address Generation Endpoint

## Objective
Continue building the REST controller by implementing the address generation endpoint, which is a core requirement for the wallet service.

## Requirements

Please add to the existing `WalletController.java`:

1. **Address Generation Endpoint**:
   - `GET /rpc/address/{account}` endpoint that generates XRP addresses
   - Extracts user ID from account parameter (format: "U123456")
   - Generates unique destination tag using: `destinationTagStart + userId`
   - Returns `XrpAddressResult` with master address, destination tag, and memo
   - Saves the account mapping using the account service

2. **Integration Logic**:
   - The endpoint should use the master address from configuration
   - Generate destination tags starting from the configured offset
   - Save the account-to-destination-tag mapping for future reference
   - Return all necessary information for users to make deposits

The implementation should:
- Follow the existing pattern used by other wallet services
- Handle the account format validation properly
- Ensure destination tags are unique and properly tracked
- Use proper error handling for invalid account formats
- Log the address generation process for debugging

## Expected Deliverables
- Address generation endpoint in `WalletController.java`
- Integration with account service for mapping storage
- Proper validation and error handling
