# Rebalancing Mechanism

## Overview

ACBU maintains basket weights through two types of rebalancing:
1. **Daily Operational Rebalancing** - Maintains target weights
2. **Quarterly Structural Rebalancing** - Adjusts weights based on economic indicators

## Daily Automated Rebalancing

**Schedule:** Every day at 00:00 UTC

### Process

1. **Calculate Drift**
   - Current NGN: 16.5% (target: 18%)
   - Current ZAR: 16.0% (target: 15%)
   - ... for all currencies

2. **Identify Rebalancing Needs**
   - NGN: Need +1.5% (buy NGN)
   - ZAR: Need -1.0% (sell ZAR)

3. **Execute via Fintech Partners**
   - Instruction to Flutterwave/Paystack:
     - Sell 1% ZAR → Buy 1% NGN
     - Sell 0.5% ZAR → Buy 0.5% NGN
   - Use operational buffer for execution

4. **Settle Within 24 Hours**
   - Fintech partners execute at best available rates

## Rebalancing Sources

### Source 1: Fee Revenue (Primary)
- Accumulate daily fees in all currencies
- Use to buy under-weight currencies
- Sell over-weight currencies

### Source 2: Operational Buffer (Secondary)
- 3% buffer always maintained
- Used for immediate rebalancing needs
- Replenished from fee revenue

### Source 3: Natural Flow Arbitrage (Tertiary)
- Users depositing under-weight currencies (incentivized)
- Users withdrawing over-weight currencies (incentivized)
- Market naturally balances through incentives

### Source 4: Strategic Partnerships (Backup)
- Credit lines with fintech partners
- Currency swap agreements
- Only for emergency situations

## Quarterly Rebalancing (Structural)

**Frequency:** Every Quarter (Q1, Q2, Q3, Q4)

### Month 1: Data Collection

**Week 1-2: Gather Metrics**

**GDP Data:**
- Each country's quarterly GDP growth
- Source: National statistics offices, World Bank
- Weight: 40% of rebalancing formula

**Trade Volume:**
- Intra-African trade flows
- Platform's transaction volumes per currency
- Source: AFREXIMBANK, Customs data, internal data
- Weight: 30% of rebalancing formula

**Currency Liquidity:**
- Daily trading volumes (on/off platform)
- Bid-ask spreads (lower is better)
- Fintech partner liquidity reports
- Weight: 30% of rebalancing formula

**Week 3: Calculate Proposed Weights**

**Formula:**
```
New Weight = (0.4 × GDP Score) + (0.3 × Trade Score) + (0.3 × Liquidity Score)
```

**Example Calculation for Nigeria:**
- GDP Score: 20 (40% of total basket)
- Trade Score: 22 (22% of platform activity)
- Liquidity Score: 18 (18% of total liquidity)
- New Weight = (0.4 × 20) + (0.3 × 22) + (0.3 × 18) = 20%

**Week 4: Publish Proposal**
- Detailed methodology
- Proposed new weights
- Rationale for each change
- Expected impact on ACBU value
- 30-day comment period begins

### Month 2: Review & Governance

**Week 1-2: Stakeholder Feedback**
- Large ACBU holders (>$100K)
- Fintech partners
- Government/regulatory advisors
- Community forum
- Academic/economic advisors

**Week 3: Governance Vote**

**Option A: Company Board (Early stage)**
- 5-7 board members vote
- Requires 60% approval
- Board includes regional representatives

**Option B: DAO Governance (Mature stage)**
- ACBU holders vote (1 ACBU = 1 vote, capped)
- Requires 51% approval
- Fintech partners have veto on extreme changes

**Option C: Hybrid**
- Board proposes
- Community provides consent
- Independent committee has veto for stability

**Week 4: Final Decision & Announce**
- Approved new weights
- Implementation timeline (next 30 days)
- Expected rebalancing trades
- FAQ and impact analysis

### Month 3: Implementation

**Days 1-30: Gradual Rebalancing**

**Daily Execution:**
- Day 1: Adjust 3.3% toward target
- Day 2: Adjust another 3.3%
- ...
- Day 30: Reach target weights

**Example (Nigeria 18% → 20%):**
- Current: 18% of $10M reserves = $1.8M in NGN
- Target: 20% of $10M reserves = $2.0M in NGN
- Daily: Buy $6,667 equivalent NGN (over 30 days)

**Sources:**
- Fee revenue in other currencies → convert to NGN
- Incentivize NGN deposits (reduced fees)
- Fintech partner currency swaps
- Operational buffer if needed

## Reserve Adjustment Mechanism

### How Existing ACBU Holders Are Affected

**Before Rebalancing:**
- 1 ACBU = 1,000 NGN + 15 ZAR + ... (old basket)
- User holds: 1,000 ACBU

**After Rebalancing:**
- 1 ACBU = 1,111 NGN + 14 ZAR + ... (new basket)
- User still holds: 1,000 ACBU
- New ACBU definition going forward

**User Impact:**
- ACBU quantity: Unchanged
- USD value: Minimal change (±0.5%, if any)
- Redemption: Gets new basket composition
- Transparent throughout process

## Crisis Scenarios & Buffers

### Scenario 1: Single Currency Collapse
**Example:** Egypt devalues EGP by 40% overnight

**Response:**
- Emergency reserve (2%) deploys to cover shortfall
- Temporarily reduce EGP weight from 11% → 8%
- Distribute loss across all ACBU holders (~0.3% impact)
- Communicate transparently to users
- Quarterly rebalance adjusts weight permanently

**User Impact:**
- 1,000 ACBU before: ~$854
- 1,000 ACBU after: ~$851 (-0.3%)
- Much better than holding 100% EGP (-40%)

### Scenario 2: Mass Withdrawal Event
**Example:** 30% of ACBU redeemed in 48 hours

**Response:**
- Use operational buffer (3%)
- Activate credit lines with fintech partners
- Implement withdrawal queuing (24-48hr delay)
- Maintain proportional reserves throughout
- Communicate status via dashboard

**Circuit Breakers:**
- If withdrawals > 20% daily: 24hr delay on new withdrawals
- If reserves < 102%: Pause new minting until replenished
- Never compromise the 1:1 backing ratio

### Scenario 3: Regional Currency Crisis
**Example:** 3 East African currencies weaken simultaneously

**Response:**
- Diversification benefit shows value
- North/West/South African currencies buffer impact
- Total ACBU impact: ~5-8% (vs 20%+ single currency)
- Continue normal operations
- Market validates basket approach

---

**Related Documents:**
- [Reserve Management](../TECHNICAL/RESERVE_MANAGEMENT.MD)
- [Oracle System](../TECHNICAL/ORACLE_SYSTEM.MD)
