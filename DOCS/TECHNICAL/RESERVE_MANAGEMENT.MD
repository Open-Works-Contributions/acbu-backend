# Reserve Management

## Buffer Structure

**Total Reserves: 105% of Outstanding ACBU**

**Breakdown:**
- **100%:** Exact 1:1 backing (untouchable)
- **3%:** Operational buffer (daily rebalancing)
- **2%:** Emergency reserve (crisis situations)
- Regular audit to maintain overcollateralization

## Reserve Setup Mechanisms

### Option 1: Fintech Float Model
Fintechs like Flutterwave and Paystack maintain "float accounts" - pre-funded balances in local currencies across Africa for their payment operations.

**Approach:**
- Partner agreements where fintechs allocate a portion of their float as stablecoin reserves
- Fintechs already hold licenses to hold customer funds in each country
- Stablecoin backed by their obligated float, verified via API
- Settlement happens within their existing infrastructure

### Option 2: Escrow with Licensed Fintech Custodians
- Use fintechs that have e-money licenses (Chipper Cash, Wave, M-Pesa)
- They hold segregated reserve accounts on your behalf
- View-only API access for proof of reserves
- Smart contracts verify balances before minting

### Option 3: Hybrid Reserve Model (Recommended)

**Reserve Structure:**
```
├── 80% in Fintech Partner Float/Custody
│   └── Distributed across multiple fintechs per country
└── 20% in Liquid Crypto Assets (USDC/USDT)
    └── Emergency liquidity buffer for redemptions
```

## Reserve Verification System

- Real-time API integration with each fintech partner
- Merkle tree proofs published on-chain weekly
- Third-party attestation monthly (audit firm)
- Public dashboard showing reserve breakdown

## Geographic Distribution Model

Reserve distribution matches user base:

**Nigeria (40M users):**
- Primarily deposit NGN
- Primarily withdraw NGN
- Reserve naturally accumulates NGN
- Weight: 18% is appropriate

**Kenya (15M users):**
- Primarily deposit/withdraw KES
- Reserve accumulates KES
- Weight: 12% is appropriate

**Cross-border transactions (20% of volume):**
- These create natural rebalancing
- Nigerian in Ghana withdraws GHS
- Ghanaian in Nigeria withdraws NGN

## Monthly Flow Example

**Nigeria:**
- Deposits: 10B NGN
- Withdrawals: 9.5B NGN (local users)
- Cross-border withdrawals: 0.3B NGN (foreigners)
- Net: +0.2B NGN accumulation

**Ghana:**
- Deposits: 600M GHS
- Withdrawals: 580M GHS (local users)
- Cross-border withdrawals: 10M GHS (travelers)
- Net: +10M GHS accumulation

**Natural Balance:** ✓ Both reserves growing proportionally, no major rebalancing needed

## Reserve Health Monitoring

**Daily Checks:**
- Monitor reserve ratios (alert if < 102%)
- Track actual vs target weights
- Verify 1:1 backing ratio maintained

**Public Dashboard:**
- Total ACBU supply
- Total reserve value (USD equivalent)
- Overcollateralization ratio (target: 105%)
- Breakdown by currency
- Last updated timestamp

---

**Related Documents:**
- [Rebalancing](../TECHNICAL/REBALANCING.MD)
- [Architecture](../TECHNICAL/ARCHITECTURE.MD)
