# Diaspora Remittances

## Overview

$100B+ flows to Africa annually. ACBU provides a cheaper, faster alternative to traditional remittance services.

## Recommended Strategy: Multi-Channel

### Tier 1: Crypto-Native (Fastest, Launch First)

**Accept:**
- USDC (Stellar, Ethereum)
- USDT (if needed)
- USD Coin (Circle)

**Process:**
- Instant conversion to ACBU
- Smart contract handles it
- 0.3% fee (vs 3-5% traditional)

**Target:** Crypto-savvy diaspora, younger generation  
**Volume:** Potentially $10-20M Year 1

### Tier 2: Mobile Money (Largest Volume)

**Partner with:**
- MTN MoMo (17 countries)
- Orange Money (18 countries)
- Airtel Money (14 countries)

**Integration:**
- ACBU as backend settlement
- Users don't even know they're using ACBU
- Just see: "cheaper, faster transfers"

**Target:** Mainstream African diaspora  
**Volume:** Potentially $50-100M Year 2-3

## User Flows

### Option 1: USDC Direct Conversion (Recommended)

**User Flow:**
**Diaspora in USA:**
- Has: USD in US bank account
- Wants: Send money to Nigeria

**Step 1: Deposit USD**
- User sends USD to US partner account
- Or: Crypto wallet (USDC deposit)

**Step 2: Instant Conversion to ACBU**
- System converts USD → ACBU at spot rate
- Uses multi-currency reserves to absorb USD
- Mints ACBU immediately

**Step 3: Family in Nigeria withdraws NGN/ACBU**
- Family has ACBU in their wallet
- Withdraws to Nigerian mobile money/bank
- Receives: NGN instantly

### Option 2: MTN MoMo Partnership (For Non-Crypto Users)

**User Flow:**
**Step 1: Diaspora in UK**
- Has: GBP in UK bank
- Uses: MTN MoMo app (international version)
- Sends: GBP → converts to local currency

**Step 2: MTN Backend Integration**
- MTN receives GBP
- MTN API calls ACBU minting contract
- MTN deposits equivalent local currency to reserves
- ACBU minted to recipient's wallet

**Step 3: Recipient in Ghana**
- Receives: ACBU in wallet (linked to MoMo)
- Can: Withdraw GHS immediately
- Or: Keep ACBU for future use

## The Foreign Currency "Burn" Mechanism

### Technical Process

**When Diaspora Sends USD:**

**Step 1: USD Received**
- User sends: $1,000 USD
- Destination: US partner account (Stripe, Wyre)
- Or: USDC to smart contract

**Step 2: Calculate ACBU Amount**
- Current rate: 1 ACBU = $0.85 (basket value)
- Amount to mint: 1,176 ACBU
- Fee (0.3%): 3.5 ACBU
- User receives: 1,172.5 ACBU

**Step 3: Reserve Management**
- USD received: $1,000
- Sits in USD holding account temporarily
- System identifies: "Need to buy NGN/KES/GHS..."
- Daily batch: Convert USD → Basket currencies

**Step 4: Conversion Execution**
- Use Flutterwave/Paystack FX services
- $1,000 USD → ~620,000 NGN (18% allocation)
- $1,000 USD → ~16,000 ZAR (15% allocation)
- ... etc. for all basket currencies
- Execute over 24-48 hours to avoid slippage

### The "Burn" Concept

You're not literally burning USD:

**Instead:**
- USD arrives → Acts as temporary reserve
- Gradually converted to basket currencies
- USD "dissolves" into 10 African currencies
- Reserves remain balanced to basket weights

**Think of it as:**
- USD is the "input fuel"
- ACBU is the "output token"
- African currencies are the "actual reserves"

## Fastest Path: Start with USDC

### Why USDC First

✅ **No Banking License Needed (Initially)**
- Crypto-to-crypto transaction
- Avoid US money transmitter regulations early
- Easier regulatory compliance

✅ **Instant Settlement**
- 24/7 operations
- No bank holidays
- Sub-minute confirmations on Stellar

✅ **Large Existing User Base**
- Millions already hold USDC
- Easy to acquire (Coinbase, Binance)
- Familiar to crypto users

✅ **Interoperability**
- USDC exists on Stellar already
- Easy to bridge
- Strong liquidity

### Implementation

**Smart Contract on Stellar:**

```javascript
function mintFromUSDC(amount) {
    1. User sends USDC to contract
    2. Contract verifies USDC received
    3. Contract fetches ACBU/USD rate from oracle
    4. Contract mints equivalent ACBU
    5. Contract sends ACBU to user wallet
    6. Backend: Flag for USD → Basket conversion
}
```

### Then Add:
- Month 3: MTN MoMo integration
- Month 6: Bank transfer option (via Wise/Flutterwave)
- Month 9: Credit card deposits

## Partnership Structure

### With MTN Mobile Money (17 African countries)

**Integration:**
- ACBU as "payment rail" option in MoMo
- Users see: "Send as MoMo" vs "Send as ACBU"
- ACBU option: 50% cheaper fees

**Technical:**
- MTN provides: Fiat on/off ramps
- You provide: Cross-border settlement layer
- Settlement: Daily batching, net positions

### Similar Partnerships
- Orange Money (18 countries)
- Airtel Money (14 countries)
- Vodacom M-Pesa (7 countries)

---

**Related Documents:**
- [User Flows](../USER_EXPERIENCE/USER_FLOWS.MD)
- [Merchant Integration](../USER_EXPERIENCE/MERCHANT_INTEGRATION.MD)
