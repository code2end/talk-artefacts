```yaml
openapi: 3.0.3
info:
  title: OTC Core Module API
  description: |
    OTC Core Module configuration and infrastructure services for Over-the-Counter trading.
    
    This module primarily provides internal configuration services and infrastructure support 
    rather than external REST APIs. The main interfaces are:
    
    - Session management configuration for multi-platform authentication
    - Redis cache configuration for OTC trading data
    - Kafka messaging configuration for asynchronous processing
    
    Public-facing OTC trading APIs are implemented in the otc-api module. This module serves 
    as the foundational configuration layer that enables secure, scalable OTC trading operations.
    
    **Key Infrastructure Services:**
    - Smart HTTP session strategy supporting browser and API token authentication
    - Redis-based distributed caching with JSON serialization
    - Kafka message processing for order notifications and system events
    
  version: 1.0.0
  contact:
    name: Bizzan OTC Team
    url: https://www.bizzan.com

servers:
  - url: /otc-core
    description: OTC Core configuration services (internal only)

tags:
  - name: Configuration
    description: Internal configuration services for OTC infrastructure
  - name: Session Management
    description: Distributed session handling for OTC applications
  - name: Cache Management
    description: Redis-based caching infrastructure
  - name: Message Processing
    description: Kafka-based asynchronous messaging

paths:
  /internal/session/strategy:
    get:
      tags:
        - Session Management
      summary: Get Smart HTTP Session Strategy Configuration
      description: |
        Internal endpoint that provides session strategy configuration details.
        The smart session strategy automatically detects client type (browser vs API)
        and applies appropriate authentication method.
      responses:
        '200':
          description: Session strategy configuration
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/SessionStrategyConfig'
              examples:
                browser_session:
                  summary: Browser-based session
                  value:
                    strategy_type: "cookie"
                    token_header: "x-auth-token"
                    cookie_config:
                      secure: true
                      http_only: true
                api_session:
                  summary: API token session
                  value:
                    strategy_type: "header"
                    token_header: "x-auth-token"
                    header_config:
                      token_validation: true

  /internal/cache/configuration:
    get:
      tags:
        - Cache Management
      summary: Get Redis Cache Configuration
      description: |
        Internal endpoint providing Redis cache configuration details including
        serialization settings, TTL configuration, and connection parameters.
      responses:
        '200':
          description: Cache configuration details
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CacheConfiguration'
              example:
                default_expiration: 1800
                serialization_type: "jackson_json"
                key_serializer: "string"
                value_serializer: "jackson2_json"
                object_mapper:
                  visibility: "ANY"
                  default_typing: "NON_FINAL"

  /internal/messaging/kafka/config:
    get:
      tags:
        - Message Processing
      summary: Get Kafka Configuration
      description: |
        Internal endpoint providing Kafka configuration details for OTC message processing.
        Includes topic configurations, consumer groups, and processing settings.
      responses:
        '200':
          description: Kafka configuration details
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/KafkaConfiguration'
              example:
                enabled: true
                topics:
                  - name: "otc.order.events"
                    description: "OTC order lifecycle events"
                  - name: "otc.advertisement.events"
                    description: "Advertisement updates and changes"
                  - name: "otc.payment.notifications"
                    description: "Payment confirmation events"
                consumer_groups:
                  - "otc-order-processor"
                  - "otc-notification-service"

  /internal/health/infrastructure:
    get:
      tags:
        - Configuration
      summary: Infrastructure Health Check
      description: |
        Internal health check for OTC Core infrastructure components.
        Validates Redis connectivity, Kafka availability, and configuration integrity.
      responses:
        '200':
          description: All infrastructure components healthy
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/HealthStatus'
              example:
                status: "UP"
                components:
                  redis:
                    status: "UP"
                    connection_pool: "AVAILABLE"
                  kafka:
                    status: "UP"
                    brokers_available: 3
                  session_management:
                    status: "UP"
                    strategy: "smart_http_session"
        '503':
          description: Infrastructure components unavailable
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/HealthStatus'
              example:
                status: "DOWN"
                components:
                  redis:
                    status: "DOWN"
                    error: "Connection timeout"

components:
  schemas:
    SessionStrategyConfig:
      type: object
      description: Configuration for smart HTTP session strategy
      properties:
        strategy_type:
          type: string
          enum: [cookie, header, smart]
          description: Type of session strategy being used
        token_header:
          type: string
          description: Header name for API token authentication
          example: "x-auth-token"
        cookie_config:
          type: object
          properties:
            secure:
              type: boolean
              description: Secure cookie flag
            http_only:
              type: boolean
              description: HTTP-only cookie flag
        header_config:
          type: object
          properties:
            token_validation:
              type: boolean
              description: Whether to validate API tokens
      required:
        - strategy_type
        - token_header

    CacheConfiguration:
      type: object
      description: Redis cache configuration settings
      properties:
        default_expiration:
          type: integer
          description: Default cache TTL in seconds
          example: 1800
        serialization_type:
          type: string
          description: Serialization method used for cache values
          example: "jackson_json"
        key_serializer:
          type: string
          description: Key serialization strategy
        value_serializer:
          type: string
          description: Value serialization strategy
        object_mapper:
          type: object
          description: Jackson ObjectMapper configuration
          properties:
            visibility:
              type: string
            default_typing:
              type: string
      required:
        - default_expiration
        - serialization_type

    KafkaConfiguration:
      type: object
      description: Kafka messaging configuration
      properties:
        enabled:
          type: boolean
          description: Whether Kafka messaging is enabled
        topics:
          type: array
          description: Configured Kafka topics
          items:
            type: object
            properties:
              name:
                type: string
                description: Topic name
              description:
                type: string
                description: Topic purpose description
        consumer_groups:
          type: array
          description: Consumer group identifiers
          items:
            type: string
      required:
        - enabled

    HealthStatus:
      type: object
      description: Infrastructure health status
      properties:
        status:
          type: string
          enum: [UP, DOWN, DEGRADED]
          description: Overall health status
        components:
          type: object
          description: Individual component health details
          additionalProperties:
            type: object
            properties:
              status:
                type: string
                enum: [UP, DOWN, DEGRADED]
              details:
                type: object
                description: Component-specific health details
      required:
        - status

  responses:
    InternalServiceError:
      description: Internal configuration service error
      content:
        application/json:
          schema:
            type: object
            properties:
              error:
                type: string
                description: Error description
              timestamp:
                type: string
                format: date-time
              path:
                type: string
                description: Request path that caused the error

  securitySchemes:
    InternalServiceAuth:
      type: http
      scheme: bearer
      description: |
        Internal service authentication for configuration endpoints.
        These endpoints are not exposed externally and require internal service credentials.

security:
  - InternalServiceAuth: []

# Note: This OpenAPI specification describes internal configuration interfaces
# that are not typically exposed as REST endpoints. The actual OTC Core module
# provides these services through Spring Bean configuration and dependency injection.
# Public OTC trading APIs are available in the otc-api module.

```