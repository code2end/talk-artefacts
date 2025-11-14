# Step 1: Project Structure and Maven Setup

## Objective
Create the foundational structure for an XRP wallet microservice in a Java cryptocurrency exchange platform. The project follows a modular architecture where each cryptocurrency has its own RPC service module.

## Requirements

Please create:

1. The directory structure for the XRP wallet module at `01_wallet_rpc/xrp/`
2. A complete Maven POM file that:
   - Extends from parent `wallet-rpc` version 1.2
   - Has artifactId `xrp` 
   - Includes Spring Boot starter dependencies
   - Includes Spring Cloud Eureka client
   - Includes Spring Kafka and MongoDB dependencies
   - Includes the xrpl4j-client and xrpl4j-model dependencies (version 3.1.2)
   - Includes dependency on rpc-common module version 1.2
   - Has proper Spring Boot Maven plugin configuration

The structure should follow the existing pattern I can see in other wallet modules like `bitcoin`, `eth`, etc. Make sure the POM follows Maven best practices and properly inherits from the parent.

## Expected Deliverables
- Directory structure for XRP wallet module
- Complete `pom.xml` file with all required dependencies
- Proper Maven configuration for Spring Boot application
