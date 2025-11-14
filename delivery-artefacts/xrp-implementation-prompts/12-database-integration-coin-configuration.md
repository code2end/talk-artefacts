# Step 12: Database Integration and Coin Configuration

## Objective
Complete the XRP wallet implementation by adding the database configuration that registers XRP as a supported cryptocurrency in the exchange platform.

## Requirements

Please provide:

1. **SQL Insert Statement** for the `coin` table that:
   - Adds XRP with proper configuration values
   - Sets appropriate withdrawal and deposit limits
   - Enables all necessary features (RPC, withdraw, recharge, transfer, auto-withdraw)
   - Sets the account type to 1 (shared address model)
   - Includes the master address placeholder
   - Sets proper fee configuration and limits

2. **Configuration Parameters** that should be set:
   - Withdrawal thresholds and daily limits
   - Minimum and maximum amounts for various operations
   - Transaction fees (min and max)
   - Sort order for UI display
   - Enable flags for all wallet operations

3. **Documentation** explaining:
   - What each configuration parameter controls
   - How the shared address model works with destination tags
   - Integration points with the existing exchange system

The configuration should make XRP fully functional within the exchange platform with appropriate limits and settings for production use.

## Expected Deliverables
- SQL insert statement for coin table
- Complete configuration parameters explanation
- Documentation of shared address model implementation
