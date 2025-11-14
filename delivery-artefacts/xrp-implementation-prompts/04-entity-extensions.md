# Step 4: Entity Extensions for XRP Support

## Objective
Before implementing the core services, extend the existing common entities to support XRP-specific fields like destination tags and memos.

## Requirements

Please provide the code changes needed to extend:

1. The `Account` entity (in rpc-common module) to add:
   - `destinationTag` field (Long) for XRP destination tag support
   - Proper Lombok annotations to maintain existing functionality

2. The `Deposit` entity (in rpc-common module) to add:
   - `destinationTag` field (Long) for XRP destination tag
   - `memo` field (String) for XRP memo support
   - Proper Lombok annotations to maintain existing functionality

3. Create a new `XrpAddressResult` entity for XRP-specific address generation responses that includes:
   - `address` field for the master address
   - `destinationTag` field for the unique user identifier
   - `memo` field for the destination tag as string
   - Proper Lombok annotations

These entities should integrate seamlessly with existing MongoDB serialization and the Spring framework used throughout the application.

## Expected Deliverables
- Extended `Account` entity with destinationTag field
- Extended `Deposit` entity with destinationTag and memo fields
- New `XrpAddressResult` entity for address generation responses
