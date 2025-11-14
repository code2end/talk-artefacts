# XRP Wallet Implementation Prompts

This directory contains 13 step-by-step implementation prompts for adding XRP wallet functionality to the Bizzan Cryptocurrency Exchange platform. Each prompt builds incrementally on the previous work to ensure safe, manageable implementation.

## Prompt Sequence

### Phase 1: Foundation & Structure
1. **[01-project-structure-maven-setup.md](01-project-structure-maven-setup.md)**
   - Create module directories and Maven POM configuration
   - Set up dependencies and build configuration

2. **[02-application-bootstrap-configuration.md](02-application-bootstrap-configuration.md)**
   - Create main Spring Boot application class
   - Implement basic configuration properties class

3. **[03-xrp-client-configuration.md](03-xrp-client-configuration.md)**
   - Configure XRP client beans
   - Set up coin configuration integration

### Phase 2: Core Infrastructure
4. **[04-entity-extensions.md](04-entity-extensions.md)**
   - Extend existing entities for XRP support
   - Add destination tag and memo fields

5. **[05-core-xrp-service.md](05-core-xrp-service.md)**
   - Implement core XRP service with balance and payment operations
   - Handle XRP Ledger interactions

6. **[06-account-management-service.md](06-account-management-service.md)**
   - Create account service for destination tag management
   - Implement MongoDB integration for XRP accounts

### Phase 3: API Layer
7. **[07-rest-controller-basic-endpoints.md](07-rest-controller-basic-endpoints.md)**
   - Create REST controller with basic endpoints
   - Implement height and balance query endpoints

8. **[08-address-generation-endpoint.md](08-address-generation-endpoint.md)**
   - Add address generation endpoint
   - Implement destination tag assignment logic

9. **[09-transaction-endpoints.md](09-transaction-endpoints.md)**
   - Complete transaction endpoints for withdrawals
   - Add parameter validation and error handling

### Phase 4: Monitoring & Integration
10. **[10-deposit-monitoring-watcher.md](10-deposit-monitoring-watcher.md)**
    - Implement deposit monitoring component
    - Add XRP Ledger scanning functionality

11. **[11-application-properties-configuration.md](11-application-properties-configuration.md)**
    - Create complete application configuration
    - Set up integration with external services

12. **[12-database-integration-coin-configuration.md](12-database-integration-coin-configuration.md)**
    - Add database configuration for XRP coin
    - Provide SQL setup and configuration documentation

13. **[13-final-integration-testing.md](13-final-integration-testing.md)**
    - Complete integration verification
    - Provide testing and deployment documentation

## Usage Instructions

1. **Sequential Implementation**: Execute prompts in order (01-13) as each builds on previous work
2. **Code Generation**: Each prompt is designed for use with code-generation LLMs
3. **Incremental Testing**: Test each step before proceeding to ensure stability
4. **Pattern Following**: All implementations follow existing architectural patterns in the codebase

## Key Features Implemented

- **Destination Tag Support**: Shared address model with unique destination tags per user
- **Standard API Contract**: Compatible with existing wallet service interfaces
- **Automatic Service Discovery**: Eureka integration for microservice architecture
- **MongoDB Integration**: Extended entities and collections for XRP-specific data
- **Deposit Monitoring**: Automated XRP Ledger scanning for deposit detection
- **Transaction Processing**: Complete withdraw/transfer functionality

## Prerequisites

- Existing Bizzan exchange platform codebase
- Java 8+ and Maven build environment
- Access to XRP Ledger (mainnet or testnet)
- MongoDB and Kafka infrastructure
- Eureka service registry

Each prompt contains detailed requirements, expected deliverables, and integration instructions to ensure successful implementation.
