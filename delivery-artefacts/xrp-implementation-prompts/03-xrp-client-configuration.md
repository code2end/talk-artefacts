# Step 3: XRP Client Configuration and Coin Bean Setup

## Objective
Continue building the XRP wallet service by creating the client configuration layer that will handle XRP Ledger connectivity and coin configuration.

## Requirements

Please create:

1. `XrpClientConfig.java` configuration class that:
   - Creates an `XrplClient` bean using the RPC endpoint from XrpConfig
   - Creates a `Coin` bean populated with configuration values from XrpConfig
   - Properly handles URL creation and exception handling
   - Uses proper Spring annotations for configuration and dependency injection

2. The configuration should integrate with the existing `Coin` entity from the rpc-common module and populate all the standard fields that other wallet services use.

Make sure the XrplClient bean is properly configured to connect to the XRP Ledger and the Coin bean contains all the necessary metadata for the exchange platform to recognize this as a valid cryptocurrency service.

## Expected Deliverables
- `XrpClientConfig.java` - Configuration class for XRP client and coin beans
- Proper Spring configuration with dependency injection
- Integration with existing Coin entity from rpc-common module
