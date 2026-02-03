# Smart Contract Specification

## Overview

ACBU smart contracts are deployed on the Stellar network (Soroban). They implement minting, burning, oracle integration, reserve tracking, and extended protocols (savings, lending, escrow). Naming follows **canonical form:** `acbu_<domain>_<capability>` (e.g. `acbu_minting`, `acbu_savings_vault`).

## Contract Architecture

### Naming convention

| Crate / folder       | Purpose                    | Backend service (camelCase)   |
|----------------------|----------------------------|--------------------------------|
| acbu_minting         | Mint ACBU from USDC/fiat   | acbuMintingService             |
| acbu_burning         | Burn ACBU, trigger redemption | acbuBurningService          |
| acbu_oracle          | Aggregated rates, ACBU/USD | acbuOracleService             |
| acbu_reserve_tracker | Reserve amounts per currency | acbuReserveTrackerService   |
| acbu_savings_vault   | Lock ACBU, terms, yield    | acbuSavingsVaultService       |
| acbu_lending_pool    | Deposits, borrows, collateral | acbuLendingPoolService     |
| acbu_escrow          | Hold ACBU; release/refund  | acbuEscrowService             |

### 1. Minting Contract (acbu_minting)

**Purpose:** Mint ACBU tokens when users deposit USDC or local currency.

#### Interface

```rust
// Stellar Smart Contract (Rust-like syntax for illustration)
pub struct MintingContract {
    pub admin: Address,
    pub oracle: Address,
    pub reserve_tracker: Address,
    pub acbu_token: Address,
    pub usdc_token: Address,
    pub fee_rate: u64, // 0.3% = 300 (basis points)
}

impl MintingContract {
    // Mint ACBU from USDC
    pub fn mint_from_usdc(
        &mut self,
        usdc_amount: u64,
        recipient: Address
    ) -> Result<Transaction, Error>;
    
    // Mint ACBU from local currency (via fintech partner)
    pub fn mint_from_fiat(
        &mut self,
        currency: String,
        amount: u64,
        recipient: Address,
        fintech_tx_id: String
    ) -> Result<Transaction, Error>;
}
```

#### State Variables

- `admin`: Contract administrator address (multisig)
- `oracle`: Oracle contract address
- `reserve_tracker`: Reserve tracking contract address
- `acbu_token`: ACBU token address
- `usdc_token`: USDC token address
- `fee_rate`: Minting fee (300 = 0.3%)
- `min_mint_amount`: Minimum mint amount (e.g., 10 USDC)
- `max_mint_amount`: Maximum mint amount per transaction
- `paused`: Emergency pause flag

#### Events

```rust
pub struct MintEvent {
    pub transaction_id: String,
    pub user: Address,
    pub usdc_amount: u64,
    pub acbu_amount: u64,
    pub fee: u64,
    pub rate: u64,
    pub timestamp: u64,
}
```

#### Access Control

- **Minting:** Any user (with KYC verification)
- **Admin functions:** Multisig (3 of 5 signatures required)
- **Pause/Unpause:** Admin only
- **Fee updates:** Admin + governance vote

### 2. Burning Contract (acbu_burning)

**Purpose:** Burn ACBU tokens and trigger fiat withdrawal.

#### Interface

```rust
pub struct BurningContract {
    pub admin: Address,
    pub oracle: Address,
    pub reserve_tracker: Address,
    pub acbu_token: Address,
    pub withdrawal_processor: Address,
    pub fee_rate: u64, // 0.3% = 300
}

impl BurningContract {
    // Burn ACBU for single currency
    pub fn burn_for_currency(
        &mut self,
        acbu_amount: u64,
        currency: String,
        recipient_account: AccountDetails
    ) -> Result<Transaction, Error>;
    
    // Burn ACBU for basket (proportional)
    pub fn burn_for_basket(
        &mut self,
        acbu_amount: u64,
        recipient_accounts: Vec<AccountDetails>
    ) -> Result<Transaction, Error>;
}
```

#### State Variables

- `admin`: Contract administrator
- `oracle`: Oracle contract address
- `reserve_tracker`: Reserve tracking contract
- `acbu_token`: ACBU token address
- `withdrawal_processor`: Backend withdrawal processor address
- `fee_rate`: Burning fee (300 = 0.3%)
- `min_burn_amount`: Minimum burn amount
- `withdrawal_limits`: Per-currency withdrawal limits
- `paused`: Emergency pause flag

#### Events

```rust
pub struct BurnEvent {
    pub transaction_id: String,
    pub user: Address,
    pub acbu_amount: u64,
    pub local_amount: u64,
    pub currency: String,
    pub fee: u64,
    pub rate: u64,
    pub timestamp: u64,
}
```

#### Access Control

- **Burning:** Any user (with KYC verification)
- **Admin functions:** Multisig
- **Withdrawal limits:** Admin + governance
- **Pause/Unpause:** Admin only

### 3. Oracle Contract (acbu_oracle)

**Purpose:** Aggregate and publish exchange rates from multiple validators.

#### Interface

```rust
pub struct OracleContract {
    pub validators: Vec<Address>, // 5 validators
    pub min_signatures: u8, // 3 of 5
    pub currencies: Vec<String>,
    pub rates: HashMap<String, RateData>,
}

impl OracleContract {
    // Update rate (requires validator signatures)
    pub fn update_rate(
        &mut self,
        currency: String,
        rate: u64,
        signatures: Vec<Signature>
    ) -> Result<(), Error>;
    
    // Get current rate
    pub fn get_rate(&self, currency: String) -> Result<u64, Error>;
    
    // Get ACBU/USD rate
    pub fn get_acbu_usd_rate(&self) -> Result<u64, Error>;
}
```

#### State Variables

- `validators`: Array of 5 validator addresses
- `min_signatures`: Minimum signatures required (3)
- `currencies`: Supported currencies
- `rates`: Current rates per currency
- `last_update`: Timestamp of last update
- `update_interval`: Minimum time between updates (6 hours)

#### Rate Data Structure

```rust
pub struct RateData {
    pub currency: String,
    pub rate_usd: u64,
    pub sources: RateSources,
    pub median_rate: u64,
    pub twap_24h: u64,
    pub timestamp: u64,
    pub validator_signatures: Vec<Signature>,
}

pub struct RateSources {
    pub central_bank: u64,
    pub fintech: u64,
    pub forex: u64,
}
```

#### Events

```rust
pub struct RateUpdateEvent {
    pub currency: String,
    pub rate: u64,
    pub timestamp: u64,
    pub validators: Vec<Address>,
}
```

#### Access Control

- **Update rates:** Validators only (multisig)
- **Read rates:** Public
- **Add/remove validators:** Admin + governance

### 4. Reserve Tracker Contract (acbu_reserve_tracker)

**Purpose:** Track reserve balances per currency (amount + value_usd); min/target ratio (basis points). Used by minting and burning to verify reserve health.

- **update_reserve(currency, amount, value_usd):** Admin-only; updates one currency’s reserve.
- **get_reserve_ratio(), get_reserves():** Read state for mint/burn and dashboards.

### 5. Savings Vault Contract (acbu_savings_vault)

**Purpose:** Lock ACBU for a term; accrue yield; withdraw after term or with penalty.

- **deposit(user, amount, term):** Lock ACBU in vault for a defined term.
- **withdraw(user, position_id):** Withdraw after term or early (with penalty).
- **get_position(user, position_id) / get_positions(user):** Read positions and balances.

Events feed backend queue **ACBU_SAVINGS_VAULT_EVENTS** for off-chain processing.

### 6. Lending Pool Contract (acbu_lending_pool)

**Purpose:** Accept ACBU deposits from lenders; allow borrows against collateral; liquidate undercollateralized positions.

- **deposit(lender, amount):** Add ACBU to pool.
- **withdraw(lender, amount):** Withdraw from pool (subject to liquidity).
- **borrow(borrower, amount, collateral):** Borrow against collateral.
- **repay(borrower, amount):** Repay loan.
- **liquidate(position_id):** Liquidate if collateral ratio below threshold.

Events feed backend queue **ACBU_LENDING_POOL_EVENTS**.

### 7. Escrow Contract (acbu_escrow)

**Purpose:** Hold ACBU until conditions are met; release to payee or refund to payer.

- **create_escrow(payer, payee, amount, conditions):** Create escrow.
- **release(escrow_id):** Release to payee when conditions satisfied.
- **refund(escrow_id):** Return to payer on cancel/timeout.

Events feed backend queue **ACBU_ESCROW_EVENTS**. Used by the merchant gateway segment.

### 8. Rebalancing Contract (acbu_rebalancing – optional, Stage 3+)

**Purpose:** Manage quarterly weight adjustments and emergency rebalancing.

#### Interface

```rust
pub struct RebalancingContract {
    pub admin: Address,
    pub reserve_tracker: Address,
    pub basket_weights: HashMap<String, u64>,
    pub rebalancing_status: RebalancingStatus,
}

impl RebalancingContract {
    // Propose quarterly weight adjustment
    pub fn propose_weight_adjustment(
        &mut self,
        adjustments: Vec<WeightAdjustment>,
        proposal_id: String
    ) -> Result<(), Error>;
    
    // Execute approved weight adjustment
    pub fn execute_weight_adjustment(
        &mut self,
        proposal_id: String
    ) -> Result<(), Error>;
    
    // Emergency rebalancing (single currency crisis)
    pub fn emergency_rebalance(
        &mut self,
        currency: String,
        new_weight: u64
    ) -> Result<(), Error>;
}
```

#### State Variables

- `admin`: Contract administrator
- `reserve_tracker`: Reserve tracking contract
- `basket_weights`: Current currency weights
- `rebalancing_status`: Current rebalancing state
- `proposals`: Pending weight adjustment proposals
- `governance_threshold`: Votes required for approval

#### Events

```rust
pub struct WeightAdjustmentProposal {
    pub proposal_id: String,
    pub adjustments: Vec<WeightAdjustment>,
    pub proposed_by: Address,
    pub timestamp: u64,
}

pub struct WeightAdjustmentExecuted {
    pub proposal_id: String,
    pub adjustments: Vec<WeightAdjustment>,
    pub executed_at: u64,
}
```

#### Access Control

- **Propose adjustments:** Governance (DAO or board)
- **Execute adjustments:** Admin + governance approval
- **Emergency rebalance:** Admin only (with time lock)

## Security Features

### 1. Multisig Administration

All admin functions require multisig (3 of 5 signatures):
- Pause/unpause contracts
- Update fees
- Add/remove validators
- Emergency rebalancing

### 2. Rate Limits

- Maximum mint amount per transaction
- Maximum burn amount per transaction
- Daily withdrawal limits per currency
- Rate update frequency limits (6 hours minimum)

### 3. Circuit Breakers

- Pause minting if reserves < 102%
- Pause burning if currency reserves < 10% target
- Pause if oracle deviation > 10%
- Pause if suspicious activity detected

### 4. Time Locks

- Weight adjustments: 30-day implementation period
- Fee changes: 7-day notice period
- Emergency functions: 24-hour time lock

## Integration Points

### Backend Integration

Contracts emit events that backend event listeners consume and enqueue:

| Contract           | Event listener job                        | Queue / consumer                         |
|--------------------|-------------------------------------------|-----------------------------------------|
| acbu_minting       | acbu_minting_event_listener.ts            | USDC_CONVERSION                         |
| acbu_burning       | acbu_burning_event_listener.ts            | WITHDRAWAL_PROCESSING                   |
| acbu_savings_vault | acbu_savings_vault_event_listener.ts      | ACBU_SAVINGS_VAULT_EVENTS               |
| acbu_lending_pool  | acbu_lending_pool_event_listener.ts      | ACBU_LENDING_POOL_EVENTS                |
| acbu_escrow        | acbu_escrow_event_listener.ts             | ACBU_ESCROW_EVENTS                      |

```rust
// Events emitted by contracts
MintEvent -> Backend processes USD conversion
BurnEvent -> Backend triggers fiat withdrawal
RateUpdateEvent -> Backend updates dashboard
WeightAdjustmentExecuted -> Backend updates reserves (when rebalancing contract used)
Savings/Lending/Escrow events -> Backend queues for segment-specific processing
```

### Oracle Integration

```rust
// Oracle contract provides rates to other contracts
MintingContract.get_rate("NGN_USD") -> OracleContract
BurningContract.get_rate("NGN_USD") -> OracleContract
```

## Testing

### Unit Tests

- Minting logic with various rates
- Burning logic with fee calculations
- Oracle aggregation and validation
- Rebalancing calculations

### Integration Tests

- End-to-end mint flow
- End-to-end burn flow
- Oracle update flow
- Rebalancing execution

### Security Tests

- Multisig validation
- Access control enforcement
- Rate limit enforcement
- Circuit breaker activation

---

**Related Documents:**
- [Architecture Diagrams](ARCHITECTURE_DIAGRAMS.MD)
- [Technical Roadmap](TECHNICAL_ROADMAP.MD)
