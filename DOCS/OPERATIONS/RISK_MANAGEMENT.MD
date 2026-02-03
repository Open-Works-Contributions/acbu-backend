# Risk Management

## Rebalancing & Withdrawal Problems

This is where most basket-backed stablecoins FAIL. ACBU addresses these proactively.

## Single Currency Withdrawal Pressure

### Problem Scenario
**Example:** NGN strengthens vs basket
- Day 1: NGN = 1,550/USD
- Day 30: NGN = 1,450/USD (strengthened 6.5%)

**Arbitrage opportunity:**
- Users deposit other weak currencies
- Withdraw only NGN (now stronger)
- Profit from the arbitrage
- NGN reserves depleted

### Solutions

#### Solution A: Dynamic Redemption Fees
**Real-time Fee Adjustment Algorithm:**

If NGN reserve level < 15% (target 18%):
- NGN withdrawal fee: 2.0% (vs normal 1.5%)
- NGN deposit bonus: -0.3% (incentivize deposits)
- Display warning: "NGN reserves low, higher fees"

If NGN reserve level > 21% (above target):
- NGN withdrawal fee: 1.0% (encourage withdrawals)
- NGN deposit fee: 1.2% (discourage deposits)
- Auto-rebalance excess to other currencies

#### Solution B: Withdrawal Limits Per Currency
**Daily Withdrawal Caps (Per Currency):**

**Individual Users:**
- Basket withdrawal: Unlimited
- Single currency: $10,000 equivalent/day
- Reset: 24-hour rolling window

**Institutional Users:**
- Basket withdrawal: Unlimited
- Single currency: $100,000/day with 24hr notice
- Larger amounts: 3-day advance notice required

**System-Wide Circuit Breakers:**
- If any currency reserve < 10% target:
  - Pause single-currency withdrawals for that currency
  - Basket withdrawals continue normally

#### Solution C: Market-Making Incentives
**Liquidity Provider Program:**

Offer incentives for users/institutions to:
- Deposit under-weight currencies (earn 0.5% bonus)
- Withdraw over-weight currencies (reduced fees)
- Provide standing orders for rebalancing

## Institutional Users Arbitraging Rising Currencies

### Problem
Sophisticated actors could:
1. Monitor currency trends
2. Mint ACBU with weak currencies
3. Immediately redeem for strong currencies
4. Drain specific reserves

### Solutions

#### Solution A: Time-Based Redemption Locks
**Minting Lockup Mechanism:**

New ACBU minted:
- Immediate use: Peer-to-peer transfers ✓
- Immediate use: Merchant payments ✓
- Basket redemption: Available immediately ✓
- Single currency redemption: 72-hour lockup ✗

After 72 hours: All redemption options available

**Rationale:** Prevents flash arbitrage while maintaining utility for genuine payments.

#### Solution B: Redemption Curves (Algorithmic Pricing)
**Bonding Curve for Single-Currency Redemptions:**

Small withdrawals: Lower fee  
Large withdrawals: Higher fee (exponential)

**Example (NGN withdrawal):**
- 0-1,000 ACBU: 1.5% fee
- 1,000-5,000 ACBU: 2.0% fee
- 5,000-10,000 ACBU: 2.5% fee
- 10,000+ ACBU: 3.0% fee + slippage

This makes large arbitrage unprofitable.

#### Solution C: KYC/AML Monitoring for Patterns
**Automated Monitoring System:**

Flag suspicious patterns:
- Mint → immediate single-currency redeem
- Multiple accounts, same beneficial owner
- Rapid cycling through multiple currencies
- Coordination with forex market movements

**Action:**
- Enhanced due diligence
- Require basket redemption only
- Temporary withdrawal limits
- Report to compliance team

## Crisis Scenarios

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
- [Rebalancing](../TECHNICAL/REBALANCING.MD)
- [Reserve Management](../TECHNICAL/RESERVE_MANAGEMENT.MD)
