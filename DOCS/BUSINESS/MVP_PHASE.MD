# MVP Phase Documentation

## Overview

ACBU launches with a simplified 3-currency basket before expanding to the full 10-currency basket. This phased approach reduces complexity, validates the model, and allows for learning before scaling.

## MVP Currency Basket

### Stage 1: 3-Currency MVP (Months 1-9)

**Currency Weights:**
- **NGN (Nigerian Naira):** 40%
- **KES (Kenyan Shilling):** 35%
- **RWF (Rwandan Franc):** 25%
- **Total:** 100%

### Rationale for MVP Selection

**Nigeria (NGN) - 40%:**
- Largest African economy by human capital
- Highest crypto adoption on continent
- Large market opportunity
- Strong fintech ecosystem

**Kenya (KES) - 35%:**
- Most mature fintech ecosystem in Africa
- M-Pesa = 96% financial inclusion
- Central Bank crypto sandbox program
- Large cross-border payment volumes

**Rwanda (RWF) - 25%:**
- Most crypto-friendly regulatory environment
- Government actively supports fintech
- Fast business registration
- Legal headquarters location

## Transition to Full Basket

### Stage 3A: 7-Currency Expansion (Months 10-12)

**New Currencies Added:**
- South Africa (ZAR): 15%
- Ghana (GHS): 9%
- Egypt (EGP): 11%
- Morocco (MAD): 7%

**Adjusted Weights:**
- NGN: 18% (down from 40%)
- KES: 12% (down from 35%)
- RWF: 8% (down from 25%)

### Stage 3B: 10-Currency Complete (Months 13-15)

**Final 3 Currencies Added:**
- Tanzania (TZS): 6%
- Uganda (UGX): 6%
- Côte d'Ivoire (XOF): 8%

**Final Weights:**
- NGN: 18%
- ZAR: 15%
- KES: 12%
- EGP: 11%
- GHS: 9%
- RWF: 8%
- XOF: 8%
- MAD: 7%
- TZS: 6%
- UGX: 6%

## MVP Reserve Allocation

### Initial Reserves (Stage 1)

**Target:** $100K-500K total reserves

**Breakdown:**
- NGN: 40% (~$40K-200K or ₦60M via Flutterwave)
- KES: 35% (~$35K-175K or KSh 50M via Flutterwave)
- RWF: 25% (~$25K-125K or FRw 150M via MTN MoMo)

### Reserve Growth Path

- **Stage 1:** $100K-500K (3 currencies)
- **Stage 3A:** $1M-5M (7 currencies)
- **Stage 3B:** $5M-20M (10 currencies)
- **Stage 4:** $20M-50M+ (full scale)

## MVP Fee Structure

**Standardized Fee Model (Community-First):**
- **Deposits:** 0.3% (USDC or local currency)
- **Withdrawals:** 0.3% (single currency or basket)
- **P2P Transfers:** FREE (or 0.01% blockchain fee)
- **Merchant Payments:** 0.2% (merchant fee)

**Total Cross-Border Cost:** 0.6% (0.3% in + 0.3% out)

## MVP Technical Architecture

### Smart Contracts
- Minting contract (USDC → ACBU)
- Burning contract (ACBU → Fiat)
- Oracle contract (3 currencies, 5 validators)

### Backend Services
- Reserve tracker (3 currencies)
- Rebalancing engine (daily, off-chain)
- USDC conversion worker
- Withdrawal processor

### Frontend
- Web application
- Wallet interface
- Deposit/withdrawal flows
- Public transparency dashboard

## MVP Success Criteria

### Technical
- ✅ Smart contracts audited and deployed
- ✅ Oracle system operational (3 currencies)
- ✅ Reserve tracking functional
- ✅ Rebalancing working
- ✅ <1% technical failure rate

### Business
- ✅ 5,000+ registered users (Month 9)
- ✅ $1M+ total reserves
- ✅ 10,000+ transactions processed
- ✅ Reserves maintained at 103-105%

### Operational
- ✅ Daily operations smooth
- ✅ Reserve management proven
- ✅ User support operational
- ✅ Monitoring and alerts functional

## Transition Strategy

### From MVP to 7-Currency

**Month 10:**
- Update smart contracts
- Add 4 new currency oracles
- Integrate new fintech partners
- Update all systems
- Test thoroughly

**Month 11:**
- Deploy to mainnet
- Beta testing with new currencies
- Reserve expansion

**Month 12:**
- Public launch of 7-currency basket
- User migration
- Monitor and optimize

### From 7-Currency to 10-Currency

**Months 13-15:**
- Similar process for final 3 currencies
- Final integrations
- Comprehensive testing
- Full basket launch

## Benefits of Phased Approach

1. **Reduced Complexity:** Start simple, learn, then scale
2. **Lower Risk:** Validate model before full commitment
3. **Faster Time to Market:** Launch sooner with 3 currencies
4. **Learning Opportunity:** Understand rebalancing costs and challenges
5. **Proven Track Record:** Build credibility before expansion

---

**Related Documents:**
- [Country Strategy](../OPERATIONS/COUNTRY_STRATEGY.MD)
- [Development Stages](../STAGES.MD)
- [Pricing Mechanism](../TECHNICAL/PRICING_MECHANISM.MD)
