# Technical Architecture

## Overview

ACBU is built on a multi-layer architecture combining blockchain technology, fintech partnerships, and traditional banking infrastructure to create a stablecoin backed by a basket of African currencies. The system is **smart-contract-first**: core business logic (mint, burn, savings, lending, escrow) lives on-chain; the backend invokes contracts and reacts to their events. The API is organized into **segments** (P2P, SME, international, salary, enterprise, savings, lending, gateway, bills), each protected by API key **segment scopes** (e.g. `p2p:read`, `savings:write`).

## Blockchain Choice

### Primary: Stellar Network

**Why Stellar:**
- Built for cross-border payments
- Low transaction costs ($0.00001)
- 3-5 second settlement
- Built-in DEX for potential secondary markets
- Already used by African fintechs (AZA Finance, Flutterwave, etc.)

### Secondary: Pi Network

**Why Pi Network:**
- Bridge stablecoin to Pi blockchain
- Access Pi's African user base (10M+ African pioneers)
- Community-focused distribution
- Mobile-first approach

**Technical Bridge:**
- Wrapped version on Pi Network
- 1:1 peg maintained via bridge contract
- Users can choose which chain based on preference

## Multi-Layer Architecture

### Layer 1 - Banking/Custody Partners

**Goal:** Avoid banks directly (goal is to eliminate centralized banking system)

**Partners:**
- Pan-African banks (Ecobank, MTN MoMo, Flutterwave, OPay, UBA)
- Segregated reserve accounts in each jurisdiction
- Hold actual fiat reserves

### Layer 2 - Payment Processors

**Role:** On/off-ramp facilitation

**On-ramp:** Users deposit local currency → processors notify to convert to stablecoin  
**Off-ramp:** Users redeem stablecoin → processors disburse local currency to reserve

**Partners:** Flutterwave, Paystack, MTN Mobile Money, Orange Money

### Layer 3 - Blockchain/Settlement

**Function:**
- Stablecoin lives on-chain for transfers
- Fast, low-cost peer-to-peer transfers
- Smart contracts for mint/burn operations

## Smart Contract Architecture

Contracts use canonical naming: **acbu_<domain>_<capability>** (e.g. acbu_minting, acbu_savings_vault). One backend service per contract (e.g. acbuMintingService, acbuSavingsVaultService).

### Core Components

#### 1. Minting Contract (acbu_minting)
- Verifies reserve deposit via oracle
- Mints equivalent stablecoin amount
- Rate calculation based on basket weights
- Applies 0.3% fee

#### 2. Burning Contract (acbu_burning)
- Burns stablecoin on redemption
- Triggers fiat withdrawal instruction
- Maintains 1:1 backing ratio
- Applies 0.3% fee

#### 3. Oracle (acbu_oracle) and Reserve Tracker (acbu_reserve_tracker)
- Oracle: aggregated rates, ACBU/USD; multi-validator feed
- Reserve tracker: reserve amounts per currency; min/target ratio
- Updates every 6 hours; public transparency dashboard

#### 4. Extended protocols (acbu_savings_vault, acbu_lending_pool, acbu_escrow)
- **Savings vault:** Lock ACBU, terms, yield; used by `/v1/savings` segment
- **Lending pool:** Deposits, borrows, collateral, liquidation; used by `/v1/lending`
- **Escrow:** Hold ACBU, release/refund; used by `/v1/gateway` (merchant gateway)

#### 5. Rebalancing (acbu_rebalancing – optional, Stage 3+)
- Quarterly adjustments to basket weights
- Handles currency substitutions
- Governed by DAO and multisig

**Note:** In MVP phase (Stage 1), rebalancing is primarily handled off-chain by backend services. On-chain rebalancing contract becomes more important in Stage 3.

## API segment layer

- Routes are grouped by use case: **P2P**, **SME**, **international**, **salary**, **enterprise**, **savings**, **lending**, **gateway**, **bills**.
- Segment routes require an API key with the right **segment scope** in `permissions` (e.g. `p2p:read`, `p2p:write`, `savings:read`, `savings:write`). Middleware `requireSegmentScope` enforces this.
- Users and organizations have **actorType** (retail, sme, enterprise, merchant) and **tier** (free, verified, sme, enterprise); `requireMinTier` can enforce tier for selected routes.
- See [API and Contracts Reference](../../API_AND_CONTRACTS_REFERENCE.MD) for the full route and scope list.

## Proof of Reserves

- Real-time API connections to custody accounts (Plaid-style banking APIs)
- Monthly third-party audits (Big 4 accounting firms)
- On-chain attestations
- Public dashboard showing reserve composition

## Integration Model Examples

### User (Ghana) Deposit Flow
```
User → Deposits GHS via Flutterwave 
  → Smart contract mints stablecoin 
  → GHS moves to reserve custody account 
  → User receives stablecoin in wallet
```

### User (Kenya) Withdrawal Flow
```
User → Redeems stablecoin 
  → Smart contract burns tokens 
  → Paystack disburses KES from reserve 
  → User receives KES in mobile money/bank
```

## Reserve Setup Mechanisms

### Option 1: Fintech Float Model
- Partner agreements where fintechs allocate portion of float as reserves
- Fintechs already hold licenses to hold customer funds
- Stablecoin backed by obligated float, verified via API
- Settlement within existing infrastructure

### Option 2: Escrow with Licensed Fintech Custodians
- Use fintechs with e-money licenses (Chipper Cash, Wave, M-Pesa)
- Segregated reserve accounts on behalf
- View-only API access for proof of reserves
- Smart contracts verify balances before minting

### Option 3: Hybrid Reserve Model (Recommended)
```
Reserve Structure:
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

---

**Related Documents:**
- [Pricing Mechanism](../TECHNICAL/PRICING_MECHANISM.MD)
- [Reserve Management](../TECHNICAL/RESERVE_MANAGEMENT.MD)
- [Oracle System](../TECHNICAL/ORACLE_SYSTEM.MD)
- [Rebalancing](../TECHNICAL/REBALANCING.MD)
