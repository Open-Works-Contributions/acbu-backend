# ACBU Gap Analysis and Inconsistency Report

**Date:** January 26, 2026  
**Documents Analyzed:** MAIN.MD, STAGES.MD  
**Purpose:** Identify gaps, inconsistencies, and areas requiring clarification

---

## Executive Summary

This analysis compares MAIN.MD (business and technical specifications) with STAGES.MD (technical development roadmap) to identify inconsistencies, gaps, and areas requiring resolution before implementation.

**Key Findings:**
- ✅ **Aligned:** Core technical architecture (Stellar + Pi), blockchain choice, oracle frequency
- ⚠️ **Inconsistent:** Fee structures (two different models in MAIN.MD), currency weights (MVP vs full basket)
- ⚠️ **Gap:** Missing details on Pi Network bridge implementation timeline
- ⚠️ **Gap:** Incomplete specification of rebalancing automation in STAGES.MD

---

## 1. Fee Structure Inconsistencies

### 1.1 MAIN.MD Contains Two Conflicting Fee Models

**Model 1: Business Model Solution (Lines 520-534)**
```
MINTING FEES:
├── Basket deposit (deposit all 10 currencies): 0.5%
├── Single currency deposit: 1.0%
└── Fintech partner deposit (bulk): 0.3%

REDEMPTION FEES:
├── Basket withdrawal (proportional): 0.5%
├── Single currency withdrawal: 1.5%
├── Partial basket (3-5 currencies): 1.0%
└── Premium for high-demand currencies: +0.5%

TRANSFER FEES:
└── Peer-to-peer ACBU transfers: 0.1% (or free under $100)
```

**Model 2: Community-First Model (Lines 1142-1166)**
```
DEPOSITS (On-ramp):
├── Local currency → ACBU: 0.3%

WITHDRAWALS (Off-ramp):
├── ACBU → Local currency: 0.3%

PEER-TO-PEER TRANSFERS:
├── ACBU wallet to ACBU wallet: FREE
├── (or 0.01% to cover blockchain fees)

MERCHANT PAYMENTS:
├── Pay merchant in ACBU: FREE
├── Merchant accepts ACBU: 0.2% (vs 2-3% card fees)
```

### 1.2 STAGES.MD Fee References

STAGES.MD consistently mentions **0.3% fee** for both minting and burning (Lines 61, 71), aligning with Model 2 (Community-First).

### 1.3 Resolution Required

**Decision Needed:** Which fee model should be implemented?
- **Option A:** Start with Model 2 (0.3% flat) for MVP, evolve to Model 1 (tiered) as needed
- **Option B:** Implement Model 1 (tiered) from launch
- **Option C:** Hybrid approach (0.3% for MVP, add tiers in Stage 3)

**Recommendation:** Option A - Start simple, add complexity as needed.

---

## 2. Currency Basket Composition Inconsistencies

### 2.1 MAIN.MD: Full 10-Currency Basket Weights

```
Nigeria (NGN):        18%
South Africa (ZAR):   15%
Kenya (KES):          12%
Egypt (EGP):          11%
Ghana (GHS):           9%
Rwanda (RWF):          8%
Côte d'Ivoire (XOF):   8%
Morocco (MAD):         7%
Tanzania (TZS):        6%
Uganda (UGX):          6%
Total: 100%
```

### 2.2 STAGES.MD: MVP 3-Currency Weights

**Stage 1 MVP (Lines 332-334):**
```
NGN: 40% (~₦60M via Flutterwave)
KES: 35% (~KSh 50M via Flutterwave)
RWF: 25% (~FRw 150M via MTN MoMo)
```

**Stage 3 Expansion (Lines 404-410):**
```
NGN: 18% (down from 40%)
KES: 12% (down from 35%)
RWF: 8% (down from 25%)
ZAR: 15% (new)
GHS: 9% (new)
EGP: 11% (new)
MAD: 7% (new)
```

### 2.3 Analysis

**This is NOT an inconsistency** - it's a phased approach:
- **Stage 1 (MVP):** 3 currencies with simplified weights (40/35/25)
- **Stage 3:** Expands to 7 currencies, then 10 currencies with final weights

**Gap Identified:** MAIN.MD doesn't clearly document the MVP 3-currency phase weights. The transition from MVP weights to full basket weights needs explicit documentation.

**Resolution Required:**
- Document MVP phase weights in MAIN.MD
- Clarify transition strategy from MVP to full basket
- Ensure STAGES.MD final weights match MAIN.MD exactly

---

## 3. Reserve Allocation Percentages

### 3.1 MAIN.MD Reserve Basket Summary

Lists 10 currencies with specific percentages (18%, 15%, 12%, etc.) totaling 100%.

### 3.2 STAGES.MD Reserve Allocations

**Stage 1 MVP:** 3 currencies (40%, 35%, 25%) = 100%  
**Stage 3A:** 7 currencies with adjusted weights  
**Stage 3B:** 10 currencies with final weights

### 3.3 Consistency Check

✅ **Aligned:** Final 10-currency weights in STAGES.MD match MAIN.MD  
⚠️ **Gap:** MVP phase weights not documented in MAIN.MD business model section

---

## 4. Technical Architecture Alignment

### 4.1 Blockchain Choice

**MAIN.MD (Line 82):** "Blockchain Choice: Stellar and pi"  
**STAGES.MD (Line 14):** "Set up Stellar testnet environment"

✅ **Aligned:** Both specify Stellar as primary blockchain

### 4.2 Pi Network Integration

**MAIN.MD (Lines 297-305):** Detailed Pi Network bridge strategy  
**STAGES.MD (Lines 455-463):** Pi Network bridge in Stage 3C (Months 16-18)

✅ **Aligned:** Both documents include Pi Network, but STAGES.MD has specific timeline

**Gap:** MAIN.MD doesn't specify when Pi Network integration occurs in the roadmap

---

## 5. Oracle System Specifications

### 5.1 Update Frequency

**MAIN.MD (Line 452):** "Smart Contract Updates: Every 6 hours on weight and oracle"  
**STAGES.MD (Line 91):** "Update frequency: Standard: Every 6 hours"

✅ **Aligned:** Both specify 6-hour update frequency

### 5.2 Oracle Architecture

**MAIN.MD (Lines 811-886):** Detailed oracle architecture with 3 layers (Central Bank 40%, Fintech 40%, Forex 20%)  
**STAGES.MD (Lines 74-99):** Oracle system with 5 validators, 3 sources per currency

✅ **Aligned:** Both specify multi-source oracle with validation

---

## 6. Rebalancing Mechanisms

### 6.1 Rebalancing Frequency

**MAIN.MD:**
- Daily rebalancing (Lines 702-721): Automated daily at 00:00 UTC
- Quarterly rebalancing (Lines 743-767): Structural weight adjustments every quarter

**STAGES.MD:**
- Daily rebalancing mentioned in backend services (Line 143)
- Quarterly rebalancing automation in Stage 3C (Lines 465-478)

✅ **Aligned:** Both specify daily operational + quarterly structural rebalancing

**Gap:** STAGES.MD doesn't detail the daily rebalancing algorithm in Stage 1

---

## 7. Smart Contract Specifications

### 7.1 Contract Components

**MAIN.MD (Lines 89-109):** Lists 4 core components:
1. Minting Contract
2. Burning Contract
3. Reserve Oracle
4. Rebalancing Contract

**STAGES.MD (Lines 54-72):** Details Minting and Burning contracts for MVP

⚠️ **Gap:** STAGES.MD doesn't explicitly mention Rebalancing Contract in Stage 1, though rebalancing engine is in backend (Line 142)

**Resolution:** Clarify if rebalancing is on-chain (contract) or off-chain (backend) in MVP phase

---

## 8. Reserve Buffer Structure

### 8.1 MAIN.MD Buffer Specification

**Lines 694-701:**
```
Total Reserves: 105% of Outstanding ACBU
├── 100%: Exact 1:1 backing (untouchable)
├── 3%: Operational buffer (daily rebalancing)
└── 2%: Emergency reserve (crisis situations)
```

### 8.2 STAGES.MD Buffer References

**Line 140:** "Alert if reserves < 102%"  
**Line 241:** "Overcollateralization ratio (target: 105%)"

✅ **Aligned:** Both specify 105% target with 102% minimum threshold

---

## 9. User On-Ramp Methods

### 9.1 MAIN.MD On-Ramp Options

**Primary (Lines 1268-1288):** USDC bridge (crypto-to-crypto)  
**Secondary (Lines 1290-1322):** MTN MoMo partnership  
**Tier 1 (Lines 1324-1336):** Crypto-native (USDC, USDT)  
**Tier 2 (Lines 1337-1349):** Mobile Money (MTN, Orange, Airtel)

### 9.2 STAGES.MD On-Ramp Implementation

**Stage 1 (Line 55):** "Accept USDC deposits (primary on-ramp)"  
**Stage 4 (Lines 523-531):** MTN/Orange Money integration

✅ **Aligned:** Both prioritize USDC first, mobile money later

**Gap:** Timeline for adding other on-ramp methods (bank transfers, credit cards) mentioned in MAIN.MD (Lines 1419-1421) not in STAGES.MD

---

## 10. Missing Information Gaps

### 10.1 Gaps in MAIN.MD

1. **MVP Phase Details:** No explicit documentation of 3-currency MVP phase
2. **Timeline References:** Business model doesn't reference development stages
3. **Pi Network Timeline:** Bridge implementation timeline not specified
4. **Team Structure:** No team composition details (covered in STAGES.MD)

### 10.2 Gaps in STAGES.MD

1. **Business Model:** No detailed revenue model or fee structure discussion
2. **Legal Framework:** No regulatory/licensing details (covered in MAIN.MD)
3. **Country Strategy:** No detailed country-by-country analysis (covered in MAIN.MD)
4. **User Flows:** No detailed user journey documentation (covered in MAIN.MD)
5. **Diaspora Strategy:** No detailed remittance flow documentation (covered in MAIN.MD)

---

## 11. Critical Inconsistencies Requiring Resolution

### Priority 1: Fee Structure
- **Issue:** Two conflicting fee models in MAIN.MD
- **Impact:** High - affects business model and user experience
- **Action:** Decide on fee model and standardize across documents

### Priority 2: MVP Currency Weights
- **Issue:** MVP weights (40/35/25) not documented in MAIN.MD business model
- **Impact:** Medium - affects initial reserve planning
- **Action:** Add MVP phase documentation to MAIN.MD

### Priority 3: Rebalancing Contract Location
- **Issue:** Unclear if rebalancing is on-chain or off-chain in MVP
- **Impact:** Medium - affects smart contract architecture
- **Action:** Clarify in both documents

### Priority 4: Additional On-Ramp Timeline
- **Issue:** Bank transfers and credit cards mentioned but not in roadmap
- **Impact:** Low - future enhancement
- **Action:** Add to STAGES.MD or remove from MAIN.MD timeline references

---

## 12. Recommendations

### 12.1 Immediate Actions

1. **Standardize Fee Model:** Choose community-first model (0.3%) for MVP, document evolution path
2. **Document MVP Phase:** Add explicit 3-currency MVP section to MAIN.MD
3. **Clarify Rebalancing:** Specify on-chain vs off-chain approach for MVP
4. **Cross-Reference:** Add references between MAIN.MD and STAGES.MD sections

### 12.2 Documentation Improvements

1. **Create Transition Matrix:** Document how MVP (3 currencies) evolves to full basket (10 currencies)
2. **Add Timeline References:** Link business model sections to development stages
3. **Unify Terminology:** Ensure consistent use of terms (e.g., "minting" vs "deposit")

### 12.3 Future Enhancements

1. **Version Control:** Consider versioning documents (v1.0, v2.0) as project evolves
2. **Change Log:** Maintain change log for significant updates
3. **Decision Register:** Document key decisions and rationale

---

## 13. Consistency Scorecard

| Category | Status | Notes |
|----------|--------|-------|
| Blockchain Choice | ✅ Aligned | Both specify Stellar + Pi |
| Oracle Frequency | ✅ Aligned | Both specify 6-hour updates |
| Reserve Buffer | ✅ Aligned | Both specify 105% target |
| Final Currency Weights | ✅ Aligned | 10-currency weights match |
| Fee Structure | ⚠️ Inconsistent | Two models in MAIN.MD |
| MVP Currency Weights | ⚠️ Gap | Not in MAIN.MD business model |
| Rebalancing Location | ⚠️ Unclear | On-chain vs off-chain |
| On-Ramp Timeline | ⚠️ Partial | Some methods not in roadmap |
| Pi Network Timeline | ✅ Aligned | Both specify Stage 3C |
| Team Structure | ✅ Complementary | STAGES.MD has details |

**Overall Alignment:** 70% aligned, 30% requires resolution

---

## 14. Next Steps

1. Review this analysis with project stakeholders
2. Make decisions on Priority 1-4 inconsistencies
3. Update MAIN.MD and STAGES.MD with resolutions
4. Create cross-reference index between documents
5. Establish documentation maintenance process

---

**Document Status:** Draft for Review  
**Last Updated:** January 26, 2026  
**Next Review:** After stakeholder feedback
