# African Currency Basket Unit (ACBU)

## Executive Summary

ACBU is a stablecoin backed by a basket of African currencies, designed to address currency stability, cross-border payments, and financial inclusion across the continent. Unlike USD-pegged stablecoins, ACBU's value is tied to a weighted basket of 10 African currencies, providing a "continental currency" for intra-African trade and remittances.

**Key Innovation:** ACBU is analogous to the IMF's SDR (Special Drawing Rights) but focused on Africa, debunking the myth that stablecoins must be pegged to the US dollar.

## Core Concept

**1 Stablecoin = 1 ACBU (African Currency Basket Unit)**

The ACBU value floats against USD, EUR, and other currencies but remains stable relative to the weighted African currency basket. This provides:
- Reduced single-currency risk for African businesses
- Lower conversion costs (0.6% vs 5-20% traditional)
- Natural hedge for pan-African operations
- Protection from isolated country crises

## Documentation Structure

This document serves as the entry point to ACBU documentation, organized into the following sections:

### Business Documentation
- **[Value Proposition](BUSINESS/VALUE_PROPOSITION.MD)** - Core value proposition and target users
- **[Use Cases](BUSINESS/USE_CASES.MD)** - Detailed use case scenarios
- **[Business Model](BUSINESS/BUSINESS_MODEL.MD)** - Fee structure and revenue model
- **[Revenue Streams](BUSINESS/REVENUE_STREAMS.MD)** - Detailed revenue breakdown

### Technical Documentation
- **[Architecture](TECHNICAL/ARCHITECTURE.MD)** - System architecture and blockchain choice
- **[Pricing Mechanism](TECHNICAL/PRICING_MECHANISM.MD)** - How ACBU value is calculated
- **[Reserve Management](TECHNICAL/RESERVE_MANAGEMENT.MD)** - Reserve structure and verification
- **[Rebalancing](TECHNICAL/REBALANCING.MD)** - Daily and quarterly rebalancing mechanisms
- **[Oracle System](TECHNICAL/ORACLE_SYSTEM.MD)** - Price feed architecture

### Operations Documentation
- **[Fintech Partnerships](OPERATIONS/FINTECH_PARTNERSHIPS.MD)** - Partner strategy and relationships
- **[Country Strategy](OPERATIONS/COUNTRY_STRATEGY.MD)** - 10-country rollout plan
- **[Regulatory](OPERATIONS/REGULATORY.MD)** - Legal framework and compliance
- **[Risk Management](OPERATIONS/RISK_MANAGEMENT.MD)** - Risk mitigation strategies

### User Experience Documentation
- **[Frontend & UI/UX Guide](FRONTEND_AND_UI.md)** - Frontend stack, structure, and clean/excellent UI ideology for designers and developers
- **[Frontend Pages, Components & UI/UX Map](FRONTEND_PAGES_COMPONENTS_UX.md)** - Backend endpoints mapped to frontend pages, components, and UI/UX ideas (auth, user, settings, KYC, transfers, mint/burn, segments)
- **[User Flows](USER_EXPERIENCE/USER_FLOWS.MD)** - Detailed user journey scenarios
- **[Diaspora Remittances](USER_EXPERIENCE/DIASPORA_REMITTANCES.MD)** - Remittance flows and strategies
- **[Merchant Integration](USER_EXPERIENCE/MERCHANT_INTEGRATION.MD)** - Merchant onboarding and integration

### Development Documentation
- **[Development Stages](STAGES.MD)** - Technical development roadmap
- **[Gap Analysis](GAP_ANALYSIS.MD)** - Document consistency analysis

### Additional Documentation
See the `DOCS/` directory for:
- API Specifications
- Architecture Diagrams
- Database Schema
- Smart Contract Specifications
- Implementation Plans
- Technical Roadmaps

See the `PROJECT/` directory for:
- Task Breakdown
- Milestones
- Resource Planning

## Quick Facts

### Currency Basket

**MVP Phase (Stage 1):**
- **3 currencies:** NGN (40%), KES (35%), RWF (25%)

**Full Implementation (Stage 3):**
- **10 currencies** representing diverse African economies
- **Weighted by GDP, trade volume, and liquidity**
- **Total allocation:** 100%
- See [MVP Phase Documentation](BUSINESS/MVP_PHASE.MD) for transition details

### Reserve Structure
- **105% overcollateralization** (100% backing + 3% operational + 2% emergency)
 

### Fee Structure (Community-First Model)
- **Deposits:** 0.3% (USDC or local currency)
- **Withdrawals:** 0.3% (single currency or basket)
- **P2P Transfers:** FREE (or 0.01% blockchain fee)
- **Merchant Payments:** 0.2% (vs 2-3% cards)

**Note:** This is the standardized fee model for MVP and initial launch. See [Business Model](BUSINESS/BUSINESS_MODEL.MD) for details.

### Cost Comparison
- **Traditional remittances:** 5-8% fees
- **ACBU model:** 0.6% total (0.3% in + 0.3% out)
- **Savings:** 88-93% cheaper

## Development Phases

### Stage 0: Technical Foundation (Months 1-2)
- Smart contract prototyping on Stellar testnet
- Oracle prototype
- Reserve tracking POC

### Stage 1: MVP Build (Months 3-6)
- Production smart contracts (3 currencies: NGN, KES, RWF)
- Oracle system (5 validators)
- Backend infrastructure
- Web application
- Security audit

### Stage 2: Launch (Months 7-9)
- Mainnet deployment
- Beta user testing
- Public launch
- Operations optimization

### Stage 3: Expansion (Months 10-18)
- Expand to 7 currencies (Months 10-12)
- Expand to 10 currencies (Months 13-15)
- Pi Network bridge (Months 16-18)
- Quarterly rebalancing automation
- Merchant payment SDK

### Stage 4: Ecosystem (Months 19-24)
- ACBU savings/staking
- ACBU lending protocol
- MTN/Orange Money integration
- Mobile apps (iOS/Android)
- Infrastructure scaling

## Key Differentiators

1. **Currency Sovereignty** - Value tied to African economic performance, not US monetary policy
2. **Diversification** - Basket approach reduces volatility vs single currencies
3. **Cost Efficiency** - 88-93% cheaper than traditional remittances
4. **Speed** - 3-5 second settlement vs days for traditional methods
5. **Transparency** - Public reserve dashboard, regular audits, on-chain attestations

## Target Markets

### Primary Users
- Pan-African e-commerce merchants
- Cross-border traders ($192B annually)
- SMEs doing regional business
- Diaspora remittances ($100B+ annually)

### Geographic Focus
- **MVP (Stage 1):** Rwanda, Kenya, Nigeria (3 currencies)
  - NGN: 40%, KES: 35%, RWF: 25%
- **Expansion (Stage 3A):** Add South Africa, Ghana, Egypt, Morocco (7 currencies)
  - Weights adjusted: NGN: 18%, KES: 12%, RWF: 8%, plus new currencies
- **Full (Stage 3B):** Add Tanzania, Uganda, Côte d'Ivoire (10 currencies)
  - Final weights: See [MVP Phase Documentation](BUSINESS/MVP_PHASE.MD)

## Success Metrics

### Stage 1 (MVP)
- 5,000+ registered users
- $1M+ total reserves
- 10,000+ transactions processed
- <1% technical failure rate
- Reserves maintained at 103-105%

### Stage 4 (Ecosystem)
- 100,000+ merchants accepting ACBU
- $50M+ in reserves
- Millions of transactions
- Mobile money partnerships live
- Full 10-currency basket operational

## Risk Disclosure

**ACBU is NOT pegged to USD or any single currency**

✓ ACBU maintains stable value relative to a basket of 10 African currencies

✓ Its USD/EUR value will fluctuate based on African currency performance

✓ Best for: African cross-border transactions, regional trade, diversified savings

✗ Not ideal for: Holding purely USD-denominated value

## Getting Started

1. **For Developers:** See [STAGES.MD](STAGES.MD) for technical roadmap
2. **For Business:** See [Business Model](BUSINESS/BUSINESS_MODEL.MD) for commercial details
3. **For Partners:** See [Fintech Partnerships](OPERATIONS/FINTECH_PARTNERSHIPS.MD) for partnership opportunities
4. **For Users:** See [User Flows](USER_EXPERIENCE/USER_FLOWS.MD) for how to use ACBU

---

**Last Updated:** January 26, 2026  
**Version:** 2.0  
**Status:** Planning & Development
