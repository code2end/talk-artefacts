# Step 9: Transaction Endpoints (Withdraw/Transfer)

## Objective
Complete the REST controller by implementing the transaction endpoints for withdrawals and transfers.

## Requirements

Please add to the existing `WalletController.java`:

1. **Withdrawal/Transfer Endpoint**:
   - `GET /rpc/transfer` and `GET /rpc/withdraw` endpoints (both map to same method)
   - Accept parameters: `address` (required), `amount` (required), `fee` (optional), `destinationTag` (optional)
   - Validate amount is greater than 0
   - Parse optional destination tag from string to Long
   - Call XrpService.sendPayment with proper parameters

2. **Parameter Validation**:
   - Ensure required parameters are provided
   - Validate amount is positive
   - Handle optional destination tag conversion
   - Provide meaningful error messages for validation failures

3. **Response Handling**:
   - Return the result from XrpService.sendPayment directly
   - Log withdrawal attempts with all parameters
   - Handle exceptions gracefully with proper error responses

The implementation should maintain consistency with other wallet services and provide the standard withdrawal functionality expected by the exchange platform.

## Expected Deliverables
- Withdrawal/transfer endpoints in `WalletController.java`
- Parameter validation and error handling
- Integration with XrpService for transaction processing
