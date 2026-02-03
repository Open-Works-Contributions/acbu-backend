# Oracle System Architecture

## Overview

The ACBU oracle system provides reliable, tamper-resistant price feeds for all basket currencies by aggregating multiple independent sources.

## Multi-Source Price Feeds

### Price Discovery Layers

#### Layer 1: Central Bank Official Rates
- **Source:** Each country's central bank
- **Update:** Daily (some real-time)
- **Weight:** 40% of final rate
- **Characteristics:** Most authoritative but sometimes delayed

#### Layer 2: Fintech Partner Transaction Rates
- **Source:** Flutterwave, Paystack, etc. actual transactions
- **Update:** Real-time
- **Weight:** 40% of final rate
- **Characteristics:** Reflects real market rates users experience

#### Layer 3: Forex Market Rates
- **Source:** Oanda, XE, Bloomberg
- **Update:** Real-time
- **Weight:** 20% of final rate
- **Characteristics:** International market perspective

### Aggregation Method

- **Median of all three sources**
- **Outlier detection:** If one source deviates >3%, flag for review
- **Fallback hierarchy:** If one source fails, use remaining two

## Technical Implementation

### Smart Contract Oracle System

**On Stellar:**
- Multi-sig oracle contract (5 validators)
- Each validator pulls from different sources
- Consensus mechanism: Median of 5 feeds
- Update frequency: Every 6 hours
- Emergency update: If any currency moves >5%

### Oracle Validators

- **2 nodes:** Internal technical team
- **2 nodes:** Independent third party (Chainlink-style)
- **1 node:** Fintech partner validator
- **Requirement:** All nodes must sign for rate to be accepted

### On-Chain Price Feed Format

```json
{
  "timestamp": "2026-01-08T12:00:00Z",
  "rates": {
    "NGN_USD": 0.000645,
    "ZAR_USD": 0.0547,
    "KES_USD": 0.0073,
    ...
  },
  "signatures": ["0x...", "0x...", "0x...", "0x...", "0x..."]
}
```

## Oracle Security Measures

### Protection Against Manipulation

#### 1. Deviation Limits
- Max 5% change per 6-hour update
- If larger move detected: require 3/5 oracle consensus
- Pause minting/redemption if >10% unexplained deviation

#### 2. Multiple Source Validation
- If sources disagree by >3%: trigger review
- Human oversight for anomalies
- Ability to pause oracle updates

#### 3. Time-Weighted Average
- Use 24-hour TWAP for redemptions (smooth volatility)
- Use spot rates for display purposes
- Prevents flash crash exploitation

#### 4. Circuit Breakers
- If any currency shows extreme volatility:
  - Temporarily use 48-hour average
  - Notify users of heightened volatility

## Update Frequency

- **Standard:** Every 6 hours
- **Emergency:** If any rate moves >5%
- **Smart Contract Updates:** Every 6 hours on weight and oracle
- **API Access:** Real-time for partners

## Price Feed Sources by Currency

### NGN (Nigerian Naira)
- Central Bank: CBN official rates
- Fintech: Flutterwave real-time rates
- Forex: Oanda, XE, Bloomberg

### KES (Kenyan Shilling)
- Central Bank: CBK official rates
- Fintech: Flutterwave, Chipper Cash rates
- Forex: Oanda, XE, Bloomberg

### RWF (Rwandan Franc)
- Central Bank: BNR official rates
- Fintech: Flutterwave, MTN MoMo rates
- Forex: Oanda, XE, Bloomberg

*(Similar structure for all 10 currencies)*

## Oracle Reliability

### Redundancy
- Multiple validators prevent single point of failure
- Multiple data sources ensure accuracy
- Fallback mechanisms for source failures

### Monitoring
- Real-time health checks on all validators
- Alert system for anomalies
- Automatic failover to backup sources

### Transparency
- All price feeds published on-chain
- Public dashboard showing current rates
- Historical rate data available

---

**Related Documents:**
- [Architecture](../TECHNICAL/ARCHITECTURE.MD)
- [Pricing Mechanism](../TECHNICAL/PRICING_MECHANISM.MD)
