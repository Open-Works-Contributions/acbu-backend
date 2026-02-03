# Pricing Mechanism: The African Currency Basket Unit (ACBU)

## Overview

ACBU is similar to the IMF's SDR (Special Drawing Rights) or the old ECU (European Currency Unit) before the Euro - it's a basket-weighted composite value.

## Base Principle

**1 Stablecoin = 1 ACBU (African Currency Basket Unit)**

The ACBU value floats against USD, EUR, and other currencies but remains stable relative to the weighted African currency basket.

## How the Price is Calculated

### Step 1: Define the Basket Composition

**MVP Phase (3 currencies - Stage 1):**
- NGN: 40% weight
- KES: 35% weight
- RWF: 25% weight

**7-Currency Basket (Stage 3A):**
- NGN: 18% weight (down from 40%)
- KES: 12% weight (down from 35%)
- RWF: 8% weight (down from 25%)
- ZAR: 15% weight (new)
- GHS: 9% weight (new)
- EGP: 11% weight (new)
- MAD: 7% weight (new)

**Full Basket (10 currencies - Stage 3B):**
- NGN: 18% weight
- ZAR: 15% weight  
- KES: 12% weight
- EGP: 11% weight
- GHS: 9% weight
- RWF: 8% weight
- XOF: 8% weight
- MAD: 7% weight
- TZS: 6% weight
- UGX: 6% weight

### Step 2: Calculate the Reference Amount for Each Currency

At launch (hypothetical initial values):
```
1 ACBU = 
  (0.18 × 1,000 NGN) +
  (0.15 × 100 ZAR) +
  (0.12 × 700 KES) +
  (0.11 × 200 EGP) +
  (0.09 × 60 GHS) +
  (0.08 × 1,500 RWF) +
  (0.08 × 3,500 XOF) +
  (0.07 × 55 MAD) +
  (0.06 × 1,800 TZS) +
  (0.06 × 2,000 UGX)
```

= Fixed basket at inception

These amounts are locked at launch and define what 1 stablecoin represents. This definition changes as more currencies get added per quarter and GDP changes happen.

### Step 3: Daily Valuation Against Any Currency

The stablecoin's value in ANY currency (USD, EUR, or any African currency) floats based on:

**Value in USD = Sum of (Weight × Currency Amount × FX Rate to USD)**

**Example calculation on Day 1:**
```
If NGN/USD = 0.0012
   ZAR/USD = 0.055
   KES/USD = 0.0073
   ... etc

1 ACBU in USD = (0.18 × 1000 × 0.0012) + (0.15 × 100 × 0.055) + ...
              = Resulting USD value (let's say ~$0.85)
```

**On Day 30, if currencies move:**
- If African currencies collectively strengthen vs USD → 1 ACBU might = $0.90
- If they weaken → 1 ACBU might = $0.80

## Stability Characteristics

### What IS Stable:
✅ 1 ACBU always = the same basket of African currencies
- 1 ACBU today = 180 NGN + 15 ZAR + 84 KES + ... (fixed amounts)
- 1 ACBU tomorrow = 180 NGN + 15 ZAR + 84 KES + ... (same amounts)

### What FLOATS:
- ACBU value against USD, EUR, GBP, CNY (floats based on collective African currency performance)
- Individual African currency values within the basket (but diversification smooths volatility)

## Practical Example: User Perspective

### Scenario: A Kenyan Merchant Using ACBU

**Day 1:**
- 1 ACBU = 700 KES
- Merchant sells goods worth 7,000 KES
- Receives: 10 ACBU stablecoins
- ACBU value in USD: $0.85

**Day 30 (KES weakens 5% vs basket):**
- 1 ACBU = 735 KES (because KES lost value relative to basket)
- Merchant still has: 10 ACBU
- ACBU value in USD: $0.87 (basket strengthened slightly vs USD)

**When merchant redeems:**
- Wants KES back → Gets 7,350 KES (more KES because KES weakened)
- OR wants NGN → Gets amount based on NGN/ACBU rate at that time
- OR wants USD → Gets ~$8.70

**The Key Insight:**
The merchant is protected from single-currency risk but exposed to basket performance. If they're doing business across multiple African countries, this is actually less volatile than holding any single currency.

## Comparison Scenarios

### Traditional USD Stablecoin (USDT):
- Day 1: 1 USDT = 1,550 NGN
- Day 30: 1 USDT = 1,620 NGN (NGN weakened)

**Nigerian user who held USDT:**
- Started with $100 = 155,000 NGN
- Ends with $100 = 162,000 NGN
- Gained NGN but exposed to USD strength

### Our African Stablecoin Basket (ACBU):
- Day 1: 1 ACBU = 1,000 NGN (18% weighted)
- Day 30: 1 ACBU = 1,015 NGN (NGN weakened slightly, but other basket currencies offset)

**Nigerian user who held ACBU:**
- Started with 100 ACBU = 100,000 NGN  
- Ends with 100 ACBU = 101,500 NGN
- More stable relative to their regional trading partners

## Volatility Reduction Through Diversification

### Single Currency Volatility (example: NGN):
- Annual volatility vs USD: ~15-20%

### Our Basket Volatility:
- Expected annual volatility vs USD: ~8-12% (diversification benefit)
- When NGN weakens, ZAR might strengthen
- When East African currencies dip, North African might rise
- Commodity price impacts (oil, gold, agriculture) affect currencies differently

## Price Discovery & Transparency

### Daily Reference Rate Publication
Every day at 12:00 UTC, calculate and publish:

**ACBU Dashboard (Public):**
```
Current ACBU Value:
├── In USD:  $0.8542 (+0.3% vs yesterday)
├── In EUR:  €0.7821 (+0.1%)
└── In GBP:  £0.6734 (-0.2%)

Component Currency Rates:
├── NGN: 1 ACBU = 1,003.45 NGN
├── ZAR: 1 ACBU = 15.23 ZAR  
├── KES: 1 ACBU = 704.12 KES
└── [... all currencies]

Reserve Health: 102.3% (over-collateralized)
Last Audit: 2 days ago ✓
```

### Oracle System
**Price Feed Sources:**
- Primary: Central Bank rates (official)
- Secondary: Fintech partner rates (actual transaction rates)
- Tertiary: Forex market rates
- Validation: Cross-check all three, use median

**Smart Contract Updates:** Every 6 hours on weight and oracle used to get deposit notifications and burn instructions to send fiat to user

**API Access:** Real-time for partners

## User Experience: How People Understand the Value

**For End Users (Simple Explanation):**
"1 ACBU represents a basket of Africa's currencies. It's like holding a diversified portfolio of African money. Its value in any single currency will change, but it's more stable than holding just one currency."

**Display in Wallets:**
```
Your Balance: 500 ACBU
Worth approximately:
├── 500,000 NGN (if you're in Nigeria)
├── 7,500 ZAR (if you're in South Africa)  
├── 350,000 KES (if you're in Kenya)
├── $427 USD
└── €391 EUR
```

## Risk Disclosure

**ACBU is NOT pegged to USD or any single currency**

✓ ACBU maintains stable value relative to a basket of 10 African currencies

✓ Its USD/EUR value will fluctuate based on African currency performance

✓ Best for: African cross-border transactions, regional trade, diversified savings

✗ Not ideal for: Holding purely USD-denominated value

---

**Related Documents:**
- [Oracle System](../TECHNICAL/ORACLE_SYSTEM.MD)
- [Rebalancing](../TECHNICAL/REBALANCING.MD)
