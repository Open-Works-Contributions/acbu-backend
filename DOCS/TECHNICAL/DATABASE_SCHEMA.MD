# Database Schema

## Overview

PRISMA ACCELERATE database schema for ACBU platform, including reserve tracking, transactions, user accounts, oracle rates, and audit trails.

## Core Tables

### 1. Users

```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    stellar_address VARCHAR(56) UNIQUE NOT NULL,
    kyc_status VARCHAR(20) DEFAULT 'pending',
    kyc_verified_at TIMESTAMP,
    country_code VARCHAR(3),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    INDEX idx_stellar_address (stellar_address),
    INDEX idx_email (email)
);
```

### 2. Transactions

```sql
CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    type VARCHAR(20) NOT NULL, -- 'mint', 'burn', 'transfer'
    status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'processing', 'completed', 'failed'
    
    -- Mint fields
    usdc_amount DECIMAL(20, 8),
    acbu_amount DECIMAL(20, 8),
    
    -- Burn fields
    acbu_amount_burned DECIMAL(20, 8),
    local_currency VARCHAR(3),
    local_amount DECIMAL(20, 2),
    recipient_account JSONB,
    
    -- Transfer fields
    recipient_address VARCHAR(56),
    
    fee DECIMAL(20, 8),
    rate_snapshot JSONB, -- Store rate at time of transaction
    blockchain_tx_hash VARCHAR(255),
    confirmations INTEGER DEFAULT 0,
    
    created_at TIMESTAMP DEFAULT NOW(),
    completed_at TIMESTAMP,
    
    INDEX idx_user_id (user_id),
    INDEX idx_type (type),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
);
```

### 3. Reserves

```sql
CREATE TABLE reserves (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    currency VARCHAR(3) NOT NULL,
    target_weight DECIMAL(5, 2) NOT NULL,
    actual_weight DECIMAL(5, 2) NOT NULL,
    reserve_amount DECIMAL(20, 2) NOT NULL,
    reserve_value_usd DECIMAL(20, 2) NOT NULL,
    timestamp TIMESTAMP DEFAULT NOW(),
    
    UNIQUE(currency, timestamp),
    INDEX idx_currency (currency),
    INDEX idx_timestamp (timestamp)
);
```

### 4. Reserve History

```sql
CREATE TABLE reserve_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    currency VARCHAR(3) NOT NULL,
    amount_change DECIMAL(20, 2) NOT NULL,
    reason VARCHAR(100), -- 'mint', 'burn', 'rebalance', 'conversion'
    transaction_id UUID REFERENCES transactions(id),
    previous_amount DECIMAL(20, 2),
    new_amount DECIMAL(20, 2),
    timestamp TIMESTAMP DEFAULT NOW(),
    
    INDEX idx_currency (currency),
    INDEX idx_timestamp (timestamp),
    INDEX idx_transaction_id (transaction_id)
);
```

### 5. Oracle Rates

```sql
CREATE TABLE oracle_rates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    currency VARCHAR(3) NOT NULL,
    rate_usd DECIMAL(20, 8) NOT NULL,
    
    -- Source rates
    central_bank_rate DECIMAL(20, 8),
    fintech_rate DECIMAL(20, 8),
    forex_rate DECIMAL(20, 8),
    
    -- Aggregated
    median_rate DECIMAL(20, 8) NOT NULL,
    twap_24h DECIMAL(20, 8), -- Time-weighted average
    
    validator_signatures JSONB, -- Array of validator signatures
    timestamp TIMESTAMP DEFAULT NOW(),
    
    UNIQUE(currency, timestamp),
    INDEX idx_currency (currency),
    INDEX idx_timestamp (timestamp)
);
```

### 6. ACBU Rates

```sql
CREATE TABLE acbu_rates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    acbu_usd DECIMAL(20, 8) NOT NULL,
    acbu_eur DECIMAL(20, 8),
    acbu_gbp DECIMAL(20, 8),
    
    -- Component rates
    acbu_ngn DECIMAL(20, 2),
    acbu_kes DECIMAL(20, 2),
    acbu_zar DECIMAL(20, 2),
    acbu_rwf DECIMAL(20, 2),
    acbu_ghs DECIMAL(20, 2),
    acbu_egp DECIMAL(20, 2),
    acbu_mad DECIMAL(20, 2),
    acbu_tzs DECIMAL(20, 2),
    acbu_ugx DECIMAL(20, 2),
    acbu_xof DECIMAL(20, 2),
    
    change_24h_usd DECIMAL(5, 2),
    timestamp TIMESTAMP DEFAULT NOW(),
    
    INDEX idx_timestamp (timestamp)
);
```

### 7. Rebalancing Events

```sql
CREATE TABLE rebalancing_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type VARCHAR(20) NOT NULL, -- 'daily', 'quarterly', 'emergency'
    status VARCHAR(20) DEFAULT 'pending',
    
    -- Rebalancing details
    adjustments JSONB, -- Array of {currency, from_weight, to_weight, amount}
    
    started_at TIMESTAMP DEFAULT NOW(),
    completed_at TIMESTAMP,
    
    INDEX idx_type (type),
    INDEX idx_status (status),
    INDEX idx_started_at (started_at)
);
```

### 8. Audit Trail

```sql
CREATE TABLE audit_trail (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_type VARCHAR(50) NOT NULL,
    entity_type VARCHAR(50), -- 'reserve', 'transaction', 'user'
    entity_id UUID,
    
    action VARCHAR(50) NOT NULL,
    old_value JSONB,
    new_value JSONB,
    
    performed_by UUID, -- User or system
    timestamp TIMESTAMP DEFAULT NOW(),
    
    INDEX idx_event_type (event_type),
    INDEX idx_entity_type (entity_type),
    INDEX idx_entity_id (entity_id),
    INDEX idx_timestamp (timestamp)
);
```

### 9. Webhooks

```sql
CREATE TABLE webhooks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    transaction_id UUID REFERENCES transactions(id),
    event_type VARCHAR(50) NOT NULL,
    payload JSONB NOT NULL,
    signature VARCHAR(255),
    status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'sent', 'failed'
    attempts INTEGER DEFAULT 0,
    last_attempt_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    
    INDEX idx_transaction_id (transaction_id),
    INDEX idx_status (status)
);
```

### 10. API Keys

```sql
CREATE TABLE api_keys (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    key_hash VARCHAR(255) UNIQUE NOT NULL,
    permissions JSONB, -- Array of permissions
    rate_limit INTEGER DEFAULT 100,
    last_used_at TIMESTAMP,
    expires_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    revoked_at TIMESTAMP,
    
    INDEX idx_user_id (user_id),
    INDEX idx_key_hash (key_hash)
);
```

## Views

### Reserve Status View

```sql
CREATE VIEW reserve_status AS
SELECT 
    r.currency,
    r.target_weight,
    r.actual_weight,
    r.reserve_amount,
    r.reserve_value_usd,
    (r.actual_weight - r.target_weight) as weight_drift,
    r.timestamp
FROM reserves r
WHERE r.timestamp = (
    SELECT MAX(timestamp) 
    FROM reserves 
    WHERE currency = r.currency
);
```

### Transaction Summary View

```sql
CREATE VIEW transaction_summary AS
SELECT 
    DATE(created_at) as date,
    type,
    status,
    COUNT(*) as count,
    SUM(acbu_amount) as total_acbu,
    SUM(fee) as total_fees
FROM transactions
GROUP BY DATE(created_at), type, status;
```

## Indexes

Additional performance indexes:

```sql
-- Composite indexes for common queries
CREATE INDEX idx_transactions_user_type ON transactions(user_id, type);
CREATE INDEX idx_transactions_status_created ON transactions(status, created_at);
CREATE INDEX idx_reserves_currency_timestamp ON reserves(currency, timestamp DESC);
```

## Data Retention

### Archival Strategy

- **Oracle Rates:** Keep 1 year of hourly data, archive older
- **Reserve History:** Keep 2 years, archive older
- **Transactions:** Keep 7 years (compliance requirement)
- **Audit Trail:** Keep 7 years (compliance requirement)

### Partitioning

For high-volume tables, use PostgreSQL partitioning:

```sql
-- Partition transactions by month
CREATE TABLE transactions_2026_01 PARTITION OF transactions
    FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');
```

---

**Related Documents:**
- [API Specification](API_SPECIFICATION.MD)
- [Architecture Diagrams](ARCHITECTURE_DIAGRAMS.MD)
