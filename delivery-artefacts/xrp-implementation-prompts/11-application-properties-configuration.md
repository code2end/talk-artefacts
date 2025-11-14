# Step 11: Application Properties Configuration

## Objective
Create the application properties file that configures the XRP wallet service for deployment and integration with the existing infrastructure.

## Requirements

Please create `application.properties` for the XRP wallet service with:

1. **Service Configuration**:
   - Server port: 7004
   - Spring application name: "service-rpc-xrp"

2. **External Service Integration**:
   - Kafka bootstrap servers configuration
   - Kafka consumer group and producer settings
   - MongoDB connection URI for wallet database
   - Eureka service registry configuration

3. **XRP-Specific Configuration**:
   - XRP RPC endpoint (use Ripple's public endpoint)
   - Coin name and unit settings
   - Master address and secret placeholders
   - Destination tag starting number (10000)
   - Minimum collection amount and transaction fees

4. **Watcher Configuration**:
   - Initial block height for scanning
   - Confirmation requirements
   - Scanning intervals and step size

The configuration should:
- Use placeholder values for sensitive data (addresses, secrets, IPs)
- Follow the same pattern as other wallet service configurations
- Include all necessary settings for the service to start and register properly
- Be production-ready with appropriate defaults

## Expected Deliverables
- `application.properties` file with complete XRP wallet service configuration
- Proper integration settings for Kafka, MongoDB, and Eureka
- XRP-specific configuration parameters
