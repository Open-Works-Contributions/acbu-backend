# ACBU API Specification

## Overview

The ACBU API provides programmatic access to minting, burning, reserve queries, rate queries, segment-based use cases (P2P, SME, international, salary, enterprise, savings, lending, gateway, bills), and webhook endpoints.

**Base URL:** `https://api.acbu.io/v1`  
**Authentication:** API Key (Bearer token) or JWT where noted  
**Content-Type:** `application/json`

For a single reference of **all API routes and smart contracts**, see [API and Contracts Reference](../../API_AND_CONTRACTS_REFERENCE.MD).

## Authentication

All API requests require authentication via API key in the Authorization header:

```
Authorization: Bearer YOUR_API_KEY
```

### API Key Management
- API keys can be generated in the dashboard
- Keys have different permission levels (read-only, full access)
- **Segment scopes:** For segment routes (e.g. `/v1/p2p`, `/v1/sme`, `/v1/savings`), the API key must include the required scope in its `permissions` array (e.g. `p2p:read`, `p2p:write`, `savings:read`, `savings:write`). See [API and Contracts Reference – Segment scopes](../../API_AND_CONTRACTS_REFERENCE.MD#3-segment-scopes-api-key-permissions).
- Keys can be revoked at any time

## Rate Limiting

- **Standard tier:** 100 requests/minute
- **Premium tier:** 1,000 requests/minute
- **Enterprise tier:** 10,000 requests/minute

Rate limit headers:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1640995200
```

## Endpoints

### 1. Mint ACBU from USDC

**POST** `/mint/usdc`

Mint ACBU tokens by depositing USDC.

**Request Body:**
```json
{
  "usdc_amount": "1000.00",
  "wallet_address": "GXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  "currency_preference": "auto"
}
```

**Response:**
```json
{
  "transaction_id": "tx_abc123",
  "acbu_amount": "1176.47",
  "usdc_amount": "1000.00",
  "fee": "3.53",
  "rate": {
    "acbu_usd": "0.85",
    "timestamp": "2026-01-26T12:00:00Z"
  },
  "status": "pending",
  "estimated_completion": "2026-01-26T12:00:05Z"
}
```

**Status Codes:**
- `200` - Success
- `400` - Invalid request
- `401` - Unauthorized
- `429` - Rate limit exceeded
- `500` - Server error

### 2. Burn ACBU for Fiat

**POST** `/burn/acbu`

Redeem ACBU tokens for local currency.

**Request Body:**
```json
{
  "acbu_amount": "1000.00",
  "currency": "NGN",
  "recipient_account": {
    "type": "bank",
    "account_number": "1234567890",
    "bank_code": "058",
    "account_name": "John Doe"
  }
}
```

**Response:**
```json
{
  "transaction_id": "tx_def456",
  "acbu_amount": "1000.00",
  "local_amount": "1000000.00",
  "currency": "NGN",
  "fee": "3.00",
  "rate": {
    "acbu_ngn": "1000.00",
    "timestamp": "2026-01-26T12:00:00Z"
  },
  "status": "processing",
  "estimated_completion": "2026-01-26T12:05:00Z"
}
```

### 3. Get Reserve Status

**GET** `/reserves`

Get current reserve status and composition.

**Response:**
```json
{
  "total_acbu_supply": "1000000.00",
  "total_reserve_value_usd": "850000.00",
  "overcollateralization_ratio": "105.00",
  "reserve_health": "healthy",
  "currencies": [
    {
      "currency": "NGN",
      "target_weight": "18.00",
      "actual_weight": "18.20",
      "reserve_amount": "153000000.00",
      "reserve_value_usd": "153000.00"
    },
    {
      "currency": "KES",
      "target_weight": "12.00",
      "actual_weight": "11.80",
      "reserve_amount": "8400000.00",
      "reserve_value_usd": "102000.00"
    }
  ],
  "last_updated": "2026-01-26T12:00:00Z",
  "last_audit": "2026-01-24T00:00:00Z"
}
```

### 4. Get Exchange Rates

**GET** `/rates`

Get current ACBU exchange rates.

**Query Parameters:**
- `currency` (optional): Filter by specific currency (NGN, KES, etc.)
- `base` (optional): Base currency for rates (default: USD)

**Response:**
```json
{
  "timestamp": "2026-01-26T12:00:00Z",
  "base": "USD",
  "rates": {
    "acbu_usd": "0.8542",
    "acbu_eur": "0.7821",
    "acbu_gbp": "0.6734",
    "acbu_ngn": "1003.45",
    "acbu_kes": "704.12",
    "acbu_zar": "15.23"
  },
  "change_24h": {
    "usd": "+0.3%",
    "eur": "+0.1%",
    "gbp": "-0.2%"
  }
}
```

### 5. Get Transaction Status

**GET** `/transactions/{transaction_id}`

Get status of a specific transaction.

**Response:**
```json
{
  "transaction_id": "tx_abc123",
  "type": "mint",
  "status": "completed",
  "created_at": "2026-01-26T12:00:00Z",
  "completed_at": "2026-01-26T12:00:05Z",
  "acbu_amount": "1176.47",
  "usdc_amount": "1000.00",
  "fee": "3.53",
  "blockchain_tx_hash": "0x1234...",
  "confirmations": 10
}
```

### 6. Webhook Endpoints

**POST** `/webhooks/flutterwave`

Receive webhooks from Flutterwave for deposit/withdrawal notifications.

**Webhook Payload:**
```json
{
  "event": "transfer.completed",
  "data": {
    "id": "12345",
    "account_number": "1234567890",
    "bank_code": "058",
    "amount": "1000000.00",
    "currency": "NGN",
    "status": "successful"
  }
}
```

## Error Handling

### Error Response Format

```json
{
  "error": {
    "code": "INSUFFICIENT_RESERVES",
    "message": "Insufficient NGN reserves for withdrawal",
    "details": {
      "currency": "NGN",
      "requested": "1000000.00",
      "available": "500000.00"
    }
  }
}
```

### Error Codes

- `INVALID_REQUEST` - Request validation failed
- `UNAUTHORIZED` - Invalid or missing API key
- `INSUFFICIENT_BALANCE` - User doesn't have enough ACBU
- `INSUFFICIENT_RESERVES` - System doesn't have enough reserves
- `RATE_LIMIT_EXCEEDED` - Too many requests
- `ORACLE_ERROR` - Oracle system unavailable
- `FINTECH_ERROR` - Fintech partner error
- `INTERNAL_ERROR` - Server error

## Webhooks

### Setting Up Webhooks

Configure webhook URLs in the dashboard to receive real-time notifications.

### Webhook Events

- `mint.completed` - ACBU minting completed
- `burn.completed` - ACBU redemption completed
- `burn.failed` - ACBU redemption failed
- `reserve.updated` - Reserve status updated
- `rate.updated` - Exchange rate updated

### Webhook Security

Webhooks are signed with HMAC-SHA256. Verify signatures:

```javascript
const crypto = require('crypto');

function verifyWebhook(payload, signature, secret) {
  const hash = crypto
    .createHmac('sha256', secret)
    .update(JSON.stringify(payload))
    .digest('hex');
  return hash === signature;
}
```

## SDKs and Libraries

### JavaScript/TypeScript
```bash
npm install @acbu/sdk
```

```javascript
import { ACBUClient } from '@acbu/sdk';

const client = new ACBUClient({
  apiKey: 'your-api-key',
  environment: 'production'
});

const result = await client.mint.fromUSDC({
  amount: '1000.00',
  walletAddress: 'GXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
});
```

### Python
```bash
pip install acbu-sdk
```

```python
from acbu import ACBUClient

client = ACBUClient(api_key='your-api-key')

result = client.mint.from_usdc(
    amount='1000.00',
    wallet_address='GXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
)
```

## Testing

### Sandbox Environment

Use the sandbox environment for testing:
- **Base URL:** `https://sandbox-api.acbu.io/v1`
- **Test API Key:** Available in dashboard
- **Test USDC:** Use testnet USDC

### Example Test Flow

1. Mint test ACBU with testnet USDC
2. Check transaction status
3. Burn ACBU for test fiat
4. Verify webhook received

---

**Related Documents:**
- [API and Contracts Reference](../../API_AND_CONTRACTS_REFERENCE.MD) – All routes and contracts in one place
- [Architecture Diagrams](ARCHITECTURE_DIAGRAMS.MD)
- [Smart Contract Spec](../../SMART_CONTRACT_SPEC.MD)
