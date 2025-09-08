# Getting Started

## Quick Start Guide

This guide will help you set up and run the Bizzan Cryptocurrency Exchange Platform locally for development or evaluation purposes.

## Prerequisites

Before you begin, ensure you have the following installed:

### Required Software

| Software | Version | Download Link | Purpose |
|----------|---------|---------------|---------|
| **Java Development Kit** | JDK 8+ | [Oracle JDK](https://www.oracle.com/java/technologies/downloads/) or [OpenJDK](https://adoptopenjdk.net/) | Runtime for backend services |
| **Maven** | 3.6+ | [Apache Maven](https://maven.apache.org/download.cgi) | Build tool and dependency management |
| **MySQL** | 8.0+ | [MySQL Community Server](https://dev.mysql.com/downloads/mysql/) | Primary database |
| **Redis** | 6.0+ | [Redis Download](https://redis.io/download) | Caching and session management |
| **MongoDB** | 4.4+ | [MongoDB Community Server](https://www.mongodb.com/try/download/community) | Time-series and analytics data |
| **Apache Kafka** | 2.8+ | [Kafka Download](https://kafka.apache.org/downloads) | Message streaming |
| **Node.js** | 14.x+ | [Node.js Download](https://nodejs.org/en/download/) | Frontend development |

### Hardware Requirements

#### Minimum Development Setup
- **CPU**: 4 cores
- **Memory**: 8GB RAM
- **Storage**: 50GB available disk space
- **Network**: Stable internet connection

#### Recommended Development Setup
- **CPU**: 8 cores
- **Memory**: 16GB RAM
- **Storage**: 100GB available disk space (SSD preferred)
- **Network**: High-speed internet connection

## Installation Steps

### 1. Clone the Repository

```bash
git clone <repository-url>
cd CoinExchange_CryptoExchange_Java
```

### 2. Database Setup

#### MySQL Configuration
```bash
# Start MySQL service
sudo systemctl start mysql  # Linux
brew services start mysql   # macOS

# Create database and user
mysql -u root -p
```

```sql
-- Create database
CREATE DATABASE bizzan CHARACTER SET utf8 COLLATE utf8_general_ci;

-- Create user and grant privileges
CREATE USER 'bizzan'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON bizzan.* TO 'bizzan'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

```bash
# Import database schema
mysql -u bizzan -p bizzan < 00_framework/sql/db_patch.sql
```

#### Redis Configuration
```bash
# Start Redis service
redis-server /usr/local/etc/redis.conf  # macOS
sudo systemctl start redis              # Linux

# Test Redis connection
redis-cli ping
# Should return: PONG
```

#### MongoDB Configuration
```bash
# Start MongoDB service
brew services start mongodb/brew/mongodb-community  # macOS
sudo systemctl start mongod                         # Linux

# Test MongoDB connection
mongo
# Should connect to MongoDB shell
```

### 3. Message Queue Setup

#### Apache Kafka Configuration
```bash
# Start Zookeeper
bin/zookeeper-server-start.sh config/zookeeper.properties

# Start Kafka server (in a new terminal)
bin/kafka-server-start.sh config/server.properties

# Create required topics
bin/kafka-topics.sh --create --topic exchange-order --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
bin/kafka-topics.sh --create --topic exchange-trade --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
bin/kafka-topics.sh --create --topic exchange-order-cancel --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
```

### 4. Backend Services Configuration

#### Update Configuration Files
Navigate to each service and update the configuration files:

**File**: `00_framework/*/src/main/resources/dev/application.properties`

```properties
# Database Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/bizzan?useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=GMT%2B8
spring.datasource.username=bizzan
spring.datasource.password=your_password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# Redis Configuration
spring.redis.host=localhost
spring.redis.port=6379
spring.redis.password=
spring.redis.database=0

# MongoDB Configuration
spring.data.mongodb.uri=mongodb://localhost:27017/bitrade

# Kafka Configuration
spring.kafka.bootstrap-servers=localhost:9092
spring.kafka.consumer.group-id=exchange-group
```

### 5. Build and Start Services

#### Build Framework Modules
```bash
cd 00_framework
mvn clean install -DskipTests
```

#### Start Core Services in Order

**Terminal 1 - Admin Service**:
```bash
cd 00_framework/admin
mvn spring-boot:run -Dspring.profiles.active=dev
```

**Terminal 2 - User Center API**:
```bash
cd 00_framework/ucenter-api
mvn spring-boot:run -Dspring.profiles.active=dev
```

**Terminal 3 - Exchange Engine**:
```bash
cd 00_framework/exchange
mvn spring-boot:run -Dspring.profiles.active=dev
```

**Terminal 4 - Market Service**:
```bash
cd 00_framework/market
mvn spring-boot:run -Dspring.profiles.active=dev
```

#### Verify Services
Check that all services are running:
- Admin Service: http://localhost:8010/admin/actuator/health
- User Center API: http://localhost:8001/uc/actuator/health  
- Exchange Engine: http://localhost:8002/exchange/actuator/health
- Market Service: http://localhost:8004/market/actuator/health

### 6. Frontend Applications

#### Web Admin Portal
```bash
cd 04_Web_Admin
npm install
npm run dev
```
Access at: http://localhost:8080

#### Web Frontend Portal
```bash
cd 05_Web_Front
npm install
npm run dev
```
Access at: http://localhost:8081

## Initial Setup

### 1. Admin Portal Access

1. Open http://localhost:8080
2. Default admin credentials:
   - Username: `admin`
   - Password: `123456`

### 2. System Configuration

#### Basic Exchange Settings
1. Navigate to **System Management > Exchange Coin**
2. Add trading pairs (e.g., BTC/USDT, ETH/USDT)
3. Configure trading fees and limits

#### Supported Cryptocurrencies
1. Go to **System Management > Coin**
2. Add supported coins with their properties:
   - Minimum deposit amounts
   - Withdrawal fees
   - Confirmation requirements

### 3. Test User Registration

1. Open the frontend portal: http://localhost:8081
2. Click "Register" and create a test account
3. Complete email verification
4. Submit KYC documents (can be test images)

### 4. Wallet RPC Services (Optional)

For full cryptocurrency functionality, set up wallet RPC services:

```bash
# Example: Bitcoin RPC
cd 01_wallet_rpc/bitcoin
mvn spring-boot:run -Dspring.profiles.active=dev
```

**Note**: Wallet RPC services require actual blockchain node connections or testnet configurations.

## Development Workflow

### 1. Code Changes
- Backend services support hot reload with Spring DevTools
- Frontend applications use webpack-dev-server with hot module replacement
- Database schema changes require migration scripts

### 2. Testing
```bash
# Run unit tests
mvn test

# Run integration tests
mvn verify -Pintegration-test
```

### 3. Building for Production
```bash
# Build all modules
mvn clean package -Pprod

# Build Docker images
docker build -t exchange-api:latest 00_framework/exchange/
docker build -t ucenter-api:latest 00_framework/ucenter-api/
```

## Troubleshooting

### Common Issues

#### Database Connection Errors
```
Error: "Access denied for user 'bizzan'@'localhost'"
```
**Solution**: Verify database credentials and user privileges.

#### Port Already in Use
```
Error: "Port 8001 is already in use"
```
**Solution**: 
```bash
# Find and kill process using the port
lsof -ti:8001 | xargs kill -9

# Or change port in application.properties
server.port=8011
```

#### Kafka Connection Issues
```
Error: "Connection to node -1 could not be established"
```
**Solution**: Ensure Zookeeper and Kafka are running and accessible.

#### Redis Connection Failed
```
Error: "Unable to connect to Redis"
```
**Solution**: 
```bash
# Check Redis status
redis-cli ping

# Start Redis if not running
redis-server
```

### Service Health Checks

Use Spring Boot Actuator endpoints to monitor service health:

```bash
# Check service health
curl http://localhost:8001/uc/actuator/health

# Check application info
curl http://localhost:8001/uc/actuator/info

# Check metrics
curl http://localhost:8001/uc/actuator/metrics
```

### Logging

Log files are located in the `logs/` directory of each service:
- Application logs: `logs/application.log`
- Error logs: `logs/error.log`
- SQL logs: `logs/sql.log` (if enabled)

### Performance Monitoring

#### JVM Monitoring
```bash
# Monitor JVM metrics
curl http://localhost:8001/uc/actuator/metrics/jvm.memory.used

# Monitor database connection pool
curl http://localhost:8001/uc/actuator/metrics/hikaricp.connections
```

#### Database Performance
```sql
-- Monitor MySQL performance
SHOW FULL PROCESSLIST;
SHOW ENGINE INNODB STATUS;

-- Monitor slow queries
SELECT * FROM mysql.slow_log ORDER BY start_time DESC LIMIT 10;
```

## Next Steps

After successfully setting up the platform:

1. **Explore the Documentation**: Read the [Technical Overview](technical-overview.md) and [Business Overview](business-overview.md)
2. **API Integration**: Review [API Reference](api-reference.md) for integration details
3. **Customization**: Modify business logic and UI components to fit your requirements
4. **Deployment**: Follow the [Deployment Guide](deployment-guide.md) for production setup
5. **Security**: Implement additional security measures from [Security Considerations](security-considerations.md)

## Getting Help

- **Documentation**: Complete technical documentation is available in this portal
- **GitHub Issues**: Report bugs and request features
- **Community**: Join discussions in project forums
- **Support**: Contact the development team for enterprise support

## Development Resources

### API Testing
- **Postman Collection**: Import API collections for testing
- **Swagger UI**: Available at `/swagger-ui.html` for each service
- **API Documentation**: Detailed endpoint documentation in [API Reference](api-reference.md)

### Database Tools
- **MySQL Workbench**: GUI for database management
- **Redis Desktop Manager**: Redis GUI client
- **MongoDB Compass**: MongoDB GUI client

### Development Tools
- **IntelliJ IDEA**: Recommended IDE with Spring Boot plugin
- **VS Code**: Lightweight editor with Java extensions
- **Git**: Version control with GitFlow workflow
- **Docker**: Containerization for consistent environments

---

You now have a fully functional Bizzan Cryptocurrency Exchange Platform running locally! 🎉
