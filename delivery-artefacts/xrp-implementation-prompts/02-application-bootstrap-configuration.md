# Step 2: Application Bootstrap and Basic Configuration

## Objective
Building on the XRP wallet module structure created in the previous step, create the main application class and basic configuration infrastructure.

## Requirements

Please create:

1. The main Spring Boot application class `XrpWalletRpcApplication.java` that:
   - Is properly annotated for Spring Boot and Eureka client
   - Follows the naming pattern of other wallet applications
   - Is located in the correct package structure

2. A basic XRP configuration class `XrpConfig.java` that:
   - Uses `@ConfigurationProperties` with prefix "coin"
   - Includes properties for: rpc endpoint, coin name/unit, master address/secret
   - Includes XRP-specific properties: destinationTagStart, minCollectAmount, defaultMinerFee
   - Uses Lombok annotations for clean code
   - Follows the configuration pattern used by other wallet modules

Make sure the package structure follows `com.bizzan.bc.wallet` convention and all classes are properly annotated.

## Expected Deliverables
- `XrpWalletRpcApplication.java` - Main Spring Boot application class
- `XrpConfig.java` - Configuration properties class
- Proper package structure and annotations
