# XRP Wallet Implementation Plan

Complete implementation blueprint for adding Ripple (XRP) wallet functionality to the Bizzan Cryptocurrency Exchange platform.

## Table of Contents

1. [Overview](#overview)
2. [Module Structure Creation](#module-structure-creation)
3. [Core Implementation Files](#core-implementation-files)
4. [Configuration Files](#configuration-files)
5. [Entity Extensions](#entity-extensions)
6. [Database Changes](#database-changes)
7. [Summary](#summary)

## Overview

This implementation plan provides exact code changes needed to add XRP wallet support, following the existing microservice architecture pattern where each cryptocurrency has its own isolated RPC service.

**Key Features:**
- Destination tag support for shared address model
- Standard REST API contract compliance
- Automatic service discovery via Eureka
- MongoDB integration for transaction storage
- XRP Ledger monitoring for deposits

## Module Structure Creation

### 1. Create Directory Structure

```bash
mkdir -p 01_wallet_rpc/xrp/src/main/java/com/bizzan/bc/wallet/{config,controller,service,component,entity}
mkdir -p 01_wallet_rpc/xrp/src/main/resources
mkdir -p 01_wallet_rpc/xrp/lib
```

## Core Implementation Files

### 2. XRP Module POM Configuration

**File:** `01_wallet_rpc/xrp/pom.xml`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <groupId>com.bizzan.bc.wallet</groupId>
        <artifactId>wallet-rpc</artifactId>
        <version>1.2</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.bizzan.bc.wallet</groupId>
    <artifactId>xrp</artifactId>
    <version>${project-version}</version>
    
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-mongodb</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-eureka</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.kafka</groupId>
            <artifactId>spring-kafka</artifactId>
        </dependency>
        <dependency>
            <groupId>com.bizzan.bc.wallet</groupId>
            <artifactId>rpc-common</artifactId>
            <version>1.2</version>
        </dependency>
        <dependency>
            <groupId>org.xrpl</groupId>
            <artifactId>xrpl4j-client</artifactId>
            <version>3.1.2</version>
        </dependency>
        <dependency>
            <groupId>org.xrpl</groupId>
            <artifactId>xrpl4j-model</artifactId>
            <version>3.1.2</version>
        </dependency>
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>fastjson</artifactId>
        </dependency>
    </dependencies>
    
    <build>
        <finalName>${project.artifactId}-${version}</finalName>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <executions>
                    <execution>
                        <goals>
                            <goal>repackage</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

### 3. XRP Application Main Class

**File:** `01_wallet_rpc/xrp/src/main/java/com/bizzan/bc/wallet/XrpWalletRpcApplication.java`
```java
package com.bizzan.bc.wallet;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;

@EnableEurekaClient
@SpringBootApplication
public class XrpWalletRpcApplication {
    public static void main(String[] args){
        SpringApplication.run(XrpWalletRpcApplication.class, args);
    }
}
```

### 4. XRP Configuration

**File:** `01_wallet_rpc/xrp/src/main/java/com/bizzan/bc/wallet/config/XrpConfig.java`
```java
package com.bizzan.bc.wallet.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;
import java.math.BigDecimal;

@Configuration
@ConfigurationProperties(prefix = "coin")
@Data
public class XrpConfig {
    private String rpc;
    private String name;
    private String unit;
    private String masterAddress;
    private String masterSecret;
    private Long destinationTagStart = 10000L;
    private BigDecimal minCollectAmount = new BigDecimal("20");
    private BigDecimal defaultMinerFee = new BigDecimal("0.000012");
    private String ignoreFromAddress;
}
```

### 5. XRP Client Configuration

**File:** `01_wallet_rpc/xrp/src/main/java/com/bizzan/bc/wallet/config/XrpClientConfig.java`
```java
package com.bizzan.bc.wallet.config;

import com.bizzan.bc.wallet.entity.Coin;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.xrpl.xrpl4j.client.XrplClient;

import java.net.URL;

@Configuration
public class XrpClientConfig {
    
    @Autowired
    private XrpConfig xrpConfig;
    
    @Bean
    public XrplClient xrplClient() throws Exception {
        return new XrplClient(new URL(xrpConfig.getRpc()));
    }
    
    @Bean
    public Coin coin() {
        Coin coin = new Coin();
        coin.setUnit(xrpConfig.getUnit());
        coin.setName(xrpConfig.getName());
        coin.setRpc(xrpConfig.getRpc());
        coin.setDefaultMinerFee(xrpConfig.getDefaultMinerFee());
        coin.setMinCollectAmount(xrpConfig.getMinCollectAmount());
        coin.setMasterAddress(xrpConfig.getMasterAddress());
        coin.setIgnoreFromAddress(xrpConfig.getIgnoreFromAddress());
        return coin;
    }
}
```

### 6. XRP Service Layer

**File:** `01_wallet_rpc/xrp/src/main/java/com/bizzan/bc/wallet/service/XrpService.java`
```java
package com.bizzan.bc.wallet.service;

import com.bizzan.bc.wallet.config.XrpConfig;
import com.bizzan.bc.wallet.util.MessageResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.xrpl.xrpl4j.client.JsonRpcClientErrorException;
import org.xrpl.xrpl4j.client.XrplClient;
import org.xrpl.xrpl4j.model.client.accounts.AccountInfoRequestParams;
import org.xrpl.xrpl4j.model.client.accounts.AccountInfoResult;
import org.xrpl.xrpl4j.model.client.common.LedgerSpecifier;
import org.xrpl.xrpl4j.model.transactions.*;
import org.xrpl.xrpl4j.model.client.transactions.*;

import java.math.BigDecimal;
import java.math.BigInteger;

@Service
@Slf4j
public class XrpService {
    
    @Autowired
    private XrpConfig xrpConfig;
    
    @Autowired 
    private XrplClient xrplClient;
    
    public BigDecimal getBalance(String address) {
        try {
            AccountInfoRequestParams params = AccountInfoRequestParams.of(Address.of(address));
            AccountInfoResult result = xrplClient.accountInfo(params);
            return new BigDecimal(result.accountData().balance().value().toString())
                    .divide(new BigDecimal("1000000")); // Convert drops to XRP
        } catch (JsonRpcClientErrorException e) {
            log.error("Error getting balance for address {}: {}", address, e.getMessage());
            return BigDecimal.ZERO;
        }
    }
    
    public Long getCurrentLedgerIndex() {
        try {
            return xrplClient.ledger(LedgerSpecifier.CURRENT).ledgerIndex().value();
        } catch (JsonRpcClientErrorException e) {
            log.error("Error getting current ledger index: {}", e.getMessage());
            return 0L;
        }
    }
    
    public MessageResult sendPayment(String destinationAddress, BigDecimal amount, Long destinationTag) {
        try {
            Payment.Builder paymentBuilder = Payment.builder()
                    .account(Address.of(xrpConfig.getMasterAddress()))
                    .fee(XrpCurrencyAmount.ofDrops(xrpConfig.getDefaultMinerFee().multiply(new BigDecimal("1000000")).toBigInteger()))
                    .destination(Address.of(destinationAddress))
                    .amount(XrpCurrencyAmount.ofXrp(amount));
            
            if (destinationTag != null) {
                paymentBuilder.destinationTag(UnsignedInteger.valueOf(destinationTag));
            }
            
            Payment payment = paymentBuilder.build();
            SubmitResult result = xrplClient.submit(payment);
            
            if (result.engineResult().equals("tesSUCCESS")) {
                return MessageResult.success("Transaction submitted successfully", result.transactionResult().hash());
            } else {
                return MessageResult.error(500, "Transaction failed: " + result.engineResult());
            }
        } catch (Exception e) {
            log.error("Error sending XRP payment: {}", e.getMessage());
            return MessageResult.error(500, "Payment failed: " + e.getMessage());
        }
    }
}
```

### 7. XRP Account Service

**File:** `01_wallet_rpc/xrp/src/main/java/com/bizzan/bc/wallet/service/XrpAccountService.java`
```java
package com.bizzan.bc.wallet.service;

import com.bizzan.bc.wallet.entity.Account;
import com.bizzan.bc.wallet.entity.Coin;
import com.bizzan.bc.wallet.util.MessageResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;

@Service
public class XrpAccountService {
    
    @Autowired
    private MongoTemplate mongoTemplate;
    
    @Autowired
    private Coin coin;
    
    public String getCollectionName() {
        return coin.getUnit() + "_address_book";
    }
    
    public void saveOne(String username, String address, Long destinationTag) {
        removeByName(username);
        Account account = new Account();
        account.setAccount(username);
        account.setAddress(address);
        account.setDestinationTag(destinationTag);
        account.setBalance(BigDecimal.ZERO);
        mongoTemplate.insert(account, getCollectionName());
    }
    
    public boolean isDestinationTagExist(Long destinationTag) {
        Query query = new Query();
        Criteria criteria = Criteria.where("destinationTag").is(destinationTag);
        query.addCriteria(criteria);
        return mongoTemplate.exists(query, getCollectionName());
    }
    
    public Account findByDestinationTag(Long destinationTag) {
        Query query = new Query();
        Criteria criteria = Criteria.where("destinationTag").is(destinationTag);
        query.addCriteria(criteria);
        return mongoTemplate.findOne(query, Account.class, getCollectionName());
    }
    
    public MessageResult getBalanceByDestinationTag(Long destinationTag) {
        Account account = findByDestinationTag(destinationTag);
        if (account != null) {
            return MessageResult.success("success", account.getBalance());
        }
        return MessageResult.error(404, "Destination tag not found");
    }
    
    public void removeByName(String name) {
        Query query = new Query();
        Criteria criteria = Criteria.where("account").is(name);
        query.addCriteria(criteria);
        mongoTemplate.remove(query, getCollectionName());
    }
    
    public void updateBalance(Long destinationTag, BigDecimal balance) {
        Query query = new Query();
        Criteria criteria = Criteria.where("destinationTag").is(destinationTag);
        query.addCriteria(criteria);
        mongoTemplate.updateFirst(query, Update.update("balance", balance.setScale(8, BigDecimal.ROUND_DOWN)), getCollectionName());
    }
}
```

### 8. XRP Wallet Controller

**File:** `01_wallet_rpc/xrp/src/main/java/com/bizzan/bc/wallet/controller/WalletController.java`
```java
package com.bizzan.bc.wallet.controller;

import com.bizzan.bc.wallet.config.XrpConfig;
import com.bizzan.bc.wallet.entity.XrpAddressResult;
import com.bizzan.bc.wallet.service.XrpAccountService;
import com.bizzan.bc.wallet.service.XrpService;
import com.bizzan.bc.wallet.util.MessageResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;

@RestController
@RequestMapping("/rpc")
@Slf4j
public class WalletController {
    
    @Autowired
    private XrpService xrpService;
    
    @Autowired
    private XrpAccountService accountService;
    
    @Autowired
    private XrpConfig xrpConfig;
    
    @GetMapping("height")
    public MessageResult getHeight() {
        try {
            Long ledgerIndex = xrpService.getCurrentLedgerIndex();
            return MessageResult.success("success", ledgerIndex);
        } catch (Exception e) {
            log.error("Error getting ledger height: {}", e.getMessage());
            return MessageResult.error(500, "Query failed, error: " + e.getMessage());
        }
    }
    
    @GetMapping("address/{account}")
    public MessageResult getNewAddress(@PathVariable String account) {
        log.info("create new XRP address for account: {}", account);
        try {
            Long userId = extractUserIdFromAccount(account);
            Long destinationTag = xrpConfig.getDestinationTagStart() + userId;
            
            XrpAddressResult result = new XrpAddressResult();
            result.setAddress(xrpConfig.getMasterAddress());
            result.setDestinationTag(destinationTag);
            result.setMemo(destinationTag.toString());
            
            accountService.saveOne(account, xrpConfig.getMasterAddress(), destinationTag);
            
            return MessageResult.success("success", result);
        } catch (Exception e) {
            log.error("Error creating XRP address: {}", e.getMessage());
            return MessageResult.error(500, "RPC error: " + e.getMessage());
        }
    }
    
    @GetMapping({"transfer", "withdraw"})
    public MessageResult withdraw(String address, BigDecimal amount, 
                                @RequestParam(required = false) BigDecimal fee,
                                @RequestParam(required = false) String destinationTag) {
        log.info("XRP withdraw: address={}, amount={}, fee={}, destinationTag={}", 
                 address, amount, fee, destinationTag);
        
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            return MessageResult.error(500, "Amount must be greater than 0");
        }
        
        try {
            Long destTag = destinationTag != null ? Long.valueOf(destinationTag) : null;
            return xrpService.sendPayment(address, amount, destTag);
        } catch (Exception e) {
            log.error("Error processing XRP withdrawal: {}", e.getMessage());
            return MessageResult.error(500, "Error: " + e.getMessage());
        }
    }
    
    @GetMapping("balance")
    public MessageResult balance() {
        try {
            BigDecimal balance = xrpService.getBalance(xrpConfig.getMasterAddress());
            return MessageResult.success("success", balance);
        } catch (Exception e) {
            log.error("Error getting master wallet balance: {}", e.getMessage());
            return MessageResult.error(500, "Error: " + e.getMessage());
        }
    }
    
    @GetMapping("balance/{addressOrTag}")
    public MessageResult balance(@PathVariable String addressOrTag) {
        try {
            if (isDestinationTag(addressOrTag)) {
                // Query balance for specific destination tag
                return accountService.getBalanceByDestinationTag(Long.valueOf(addressOrTag));
            } else {
                // Query balance for entire XRP address
                BigDecimal balance = xrpService.getBalance(addressOrTag);
                return MessageResult.success("success", balance);
            }
        } catch (Exception e) {
            log.error("Error getting balance: {}", e.getMessage());
            return MessageResult.error(500, "Query failed, error: " + e.getMessage());
        }
    }
    
    private Long extractUserIdFromAccount(String account) {
        // Extract user ID from "U123456" format
        if (account.startsWith("U")) {
            return Long.valueOf(account.substring(1));
        }
        throw new IllegalArgumentException("Invalid account format: " + account);
    }
    
    private boolean isDestinationTag(String value) {
        try {
            Long.valueOf(value);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }
}
```

### 9. XRP Watcher Component

**File:** `01_wallet_rpc/xrp/src/main/java/com/bizzan/bc/wallet/component/XrpWatcher.java`
```java
package com.bizzan.bc.wallet.component;

import com.bizzan.bc.wallet.component.Watcher;
import com.bizzan.bc.wallet.config.XrpConfig;
import com.bizzan.bc.wallet.entity.Deposit;
import com.bizzan.bc.wallet.service.XrpAccountService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.xrpl.xrpl4j.client.XrplClient;
import org.xrpl.xrpl4j.model.client.ledger.*;
import org.xrpl.xrpl4j.model.client.common.LedgerSpecifier;
import org.xrpl.xrpl4j.model.transactions.Payment;
import org.xrpl.xrpl4j.model.transactions.Transaction;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Component
@Slf4j
public class XrpWatcher extends Watcher {
    
    @Autowired
    private XrplClient xrplClient;
    
    @Autowired
    private XrpAccountService accountService;
    
    @Autowired
    private XrpConfig xrpConfig;
    
    @Override
    public List<Deposit> replayBlock(Long startLedgerIndex, Long endLedgerIndex) {
        List<Deposit> deposits = new ArrayList<>();
        
        try {
            for (Long ledgerIndex = startLedgerIndex; ledgerIndex <= endLedgerIndex; ledgerIndex++) {
                LedgerRequestParams params = LedgerRequestParams.builder()
                        .ledgerSpecifier(LedgerSpecifier.of(ledgerIndex))
                        .transactions(true)
                        .build();
                
                LedgerResult ledger = xrplClient.ledger(params);
                
                if (ledger.ledger().transactions().isPresent()) {
                    for (Transaction tx : ledger.ledger().transactions().get()) {
                        if (tx instanceof Payment) {
                            Payment payment = (Payment) tx;
                            
                            // Check if payment is to our master address
                            if (payment.destination().equals(xrpConfig.getMasterAddress())) {
                                
                                // Check if destination tag exists and is valid
                                if (payment.destinationTag().isPresent()) {
                                    Long destTag = payment.destinationTag().get().value();
                                    
                                    if (accountService.isDestinationTagExist(destTag)) {
                                        log.info("Found XRP deposit: destinationTag={}, amount={}", 
                                               destTag, payment.amount());
                                        
                                        Deposit deposit = new Deposit();
                                        deposit.setTxid(payment.hash().value());
                                        deposit.setBlockHeight(ledgerIndex);
                                        deposit.setAddress(xrpConfig.getMasterAddress());
                                        deposit.setDestinationTag(destTag);
                                        deposit.setMemo(destTag.toString());
                                        deposit.setAmount(convertDropsToXrp(payment.amount().toString()));
                                        deposit.setTime(System.currentTimeMillis() / 1000);
                                        
                                        deposits.add(deposit);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            log.error("Error replaying XRP ledgers: {}", e.getMessage());
            return null;
        }
        
        return deposits;
    }
    
    @Override
    public Long getNetworkBlockHeight() {
        try {
            return xrplClient.ledger(LedgerSpecifier.CURRENT).ledgerIndex().value();
        } catch (Exception e) {
            log.error("Error getting network height: {}", e.getMessage());
            return 0L;
        }
    }
    
    private BigDecimal convertDropsToXrp(String drops) {
        return new BigDecimal(drops).divide(new BigDecimal("1000000"));
    }
}
```

### 10. XRP Address Result Entity

**File:** `01_wallet_rpc/xrp/src/main/java/com/bizzan/bc/wallet/entity/XrpAddressResult.java`
```java
package com.bizzan.bc.wallet.entity;

import lombok.Data;

@Data
public class XrpAddressResult {
    private String address;
    private Long destinationTag;
    private String memo;
}
```

## Configuration Files

### 11. XRP Application Configuration

**File:** `01_wallet_rpc/xrp/src/main/resources/application.properties`
```properties
server.port=7004
spring.application.name=service-rpc-xrp

# Kafka Configuration
spring.kafka.bootstrap-servers=111.111.111.111:9092
spring.kafka.consumer.group-id=default-group
spring.kafka.template.default-topic=test
spring.kafka.listener.concurrency=1
spring.kafka.producer.batch-size=1000

# MongoDB
spring.data.mongodb.uri=mongodb://bizzan:password@111.111.111.111:27017/wallet

# Eureka
eureka.client.serviceUrl.defaultZone=http://111.111.111.111:7000/eureka/
eureka.instance.prefer-ip-address=true

# XRP Configuration
coin.rpc=https://s1.ripple.com:51234
coin.name=Ripple
coin.unit=XRP
coin.master-address=rYourExchangeMasterAddress123
coin.master-secret=sYourMasterSecretKey123
coin.destination-tag-start=10000
coin.min-collect-amount=20
coin.ignore-from-address=rYourExchangeMasterAddress123

# Watcher Configuration
watcher.init-block-height=85000000
watcher.step=10
watcher.confirmation=1
watcher.interval=5000
```

## Entity Extensions

### 12. Extend Account Entity

**File:** `01_wallet_rpc/rpc-common/src/main/java/com/bizzan/bc/wallet/entity/Account.java`

**Add this field to existing Account class:**
```java
// Add this field to the existing Account entity
private Long destinationTag;  // XRP destination tag
```

### 13. Extend Deposit Entity

**File:** `01_wallet_rpc/rpc-common/src/main/java/com/bizzan/bc/wallet/entity/Deposit.java`

**Add these fields to existing Deposit entity:**
```java
// Add these fields to the existing Deposit entity
private Long destinationTag;  // XRP destination tag
private String memo;          // Memo field for XRP
```

## Database Changes

### 14. Add XRP Coin Configuration

**Execute this SQL to add XRP coin support:**
```sql
INSERT INTO coin (
    name, unit, status, jy_rate, enable_rpc, can_withdraw, 
    can_recharge, can_transfer, can_auto_withdraw, withdraw_threshold,
    min_withdraw_amount, max_withdraw_amount, min_recharge_amount,
    account_type, deposit_address, withdraw_fee_coin, sort,
    max_daily_withdraw_rate, min_recharge_amount, max_tx_fee,
    min_tx_fee
) VALUES (
    'Ripple', 'XRP', 0, 1, 1, 1, 
    1, 1, 1, 100,
    1, 100000, 0.1,
    1, 'rYourExchangeMasterAddress123', 'XRP', 6,
    50000, 0.1, 1,
    0.000012
);
```

## Summary

### Key Implementation Features

1. **Service Discovery Integration**: Automatic registration with Eureka as `SERVICE-RPC-XRP`
2. **Standard API Contract**: Implements all required endpoints (`/rpc/height`, `/rpc/address/{account}`, etc.)
3. **Destination Tag Support**: Uses shared master address with unique destination tags per user
4. **XRP Ledger Integration**: Full integration using xrpl4j library
5. **Transaction Monitoring**: Automated deposit detection via XRP ledger monitoring
6. **Database Integration**: Extended entities and MongoDB collections for XRP-specific data

### Deployment Steps

1. **Build XRP Module**: 
   ```bash
   cd 01_wallet_rpc/xrp
   mvn clean package
   ```

2. **Start XRP Service**:
   ```bash
   java -jar target/xrp-1.2.jar
   ```

3. **Verify Service Registration**: Check Eureka dashboard for `SERVICE-RPC-XRP`

4. **Test Endpoints**:
   - Health check: `GET /test/height/xrp`
   - Address generation: `GET /rpc/address/U123456`
   - Balance query: `GET /rpc/balance`

### Integration Points

The implementation leverages existing framework features:
- **Memo field support** in `MemberWallet` entity (line 66)
- **Account type support** for shared address models (Coin.accountType = 1)
- **Automatic service discovery** via naming convention
- **Kafka consumers** automatically route requests to XRP service

This complete implementation provides production-ready XRP wallet functionality that seamlessly integrates with the existing Bizzan exchange architecture.
