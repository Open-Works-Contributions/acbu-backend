# ACBU Project Structure & Infrastructure

This document describes the ACBU (African Currency Basket Unit) repository: folders, files, their contents, and how the infrastructure is organized.

---

## 1. Repository Overview

**ACBU** is a stablecoin backed by a basket of African currencies. The value is tied to a weighted basket of up to 10 African currencies (NGN, ZAR, KES, EGP, GHS, RWF, XOF, MAD, TZS, UGX). The project consists of:

- **Backend** – Node.js/Express API, PostgreSQL, MongoDB, RabbitMQ, Stellar integration; segment routes (P2P, SME, international, salary, enterprise, savings, lending, gateway, bills)
- **Contracts** – Soroban (Stellar) smart contracts (Rust): acbu_minting, acbu_burning, acbu_oracle, acbu_reserve_tracker, acbu_savings_vault, acbu_lending_pool, acbu_escrow
- **DOCS** – Business, technical, operations, and project management documentation

---

## 2. Root-Level Files

| File | Purpose |
|------|---------|
| **README.MD** | Project overview, documentation index, quick start for developers/stakeholders/partners, key features, development phases |
| **LICENSE** | Apache License 2.0 |

---

## 3. Backend (`backend/`)

Node.js/TypeScript API server that orchestrates users, KYC, mint/burn flows, reserves, oracle updates, rebalancing, and fintech integrations.

### 3.1 Top-Level Backend Files

| File | Purpose |
|------|---------|
| **package.json** | Dependencies: Express, Prisma, MongoDB, RabbitMQ (amqplib), Stellar SDK, JWT, bcrypt, Swagger, Winston, Zod; scripts for dev, build, test, Prisma |
| **tsconfig.json** | TypeScript compiler options |
| **jest.config.js** | Jest test configuration |
| **nodemon.json** | Nodemon config for dev auto-reload |
| **docker-compose.yml** | Local stack: **PostgreSQL 16**, **MongoDB 7**, **RabbitMQ 3** (management UI on 15672) with healthchecks and named volumes |
| **ENV_VARS.md** | List and description of all environment variables (DB, JWT, fintech, Stellar, KYC, notifications, webhooks) |
| **.gitignore** | Ignores node_modules, dist, .env, etc. |

### 3.2 Backend Source (`backend/src/`)

#### Entry Point: `index.ts`

- Creates Express app, applies **Helmet**, **CORS**, **express.json()**.
- Mounts **webhook routes** under `/{apiVersion}/webhooks` with **raw body** for signature verification, then parses JSON for handlers.
- Mounts main API routes under `/{apiVersion}`.
- Serves **Swagger UI** at `/api-docs`.
- **Startup sequence:** connect MongoDB → connect RabbitMQ → start all job consumers/schedulers → start HTTP server.
- **Jobs started:** KYC processing consumer, wallet activation consumer, notification consumer, webhook consumer, oracle update scheduler (6h), reserve tracking scheduler (6h), rebalancing scheduler (00:00 UTC), **proposed basket weights scheduler** (metrics → proposed weights, e.g. monthly), USDC conversion consumer, withdrawal processing consumer, Mint/Burn event listeners, Stellar event listener.
- **Graceful shutdown:** on SIGTERM/SIGINT, disconnects MongoDB and RabbitMQ, then exits.

#### Config (`backend/src/config/`)

| File | Purpose |
|------|---------|
| **env.ts** | Loads `dotenv`, exports `config` (port, apiVersion, DATABASE_URL, MONGODB_URI, RABBITMQ_URL, JWT, rate limits, log level, fintech keys, Stellar network/horizon/secret/min XLM, **oracle** 40/40/20 forex + central-bank URLs, reserve/KYC/notification/webhook/CORS). Validates required env vars. |
| **basket.ts** | Defines `BASKET_CURRENCIES` (10 codes), `BASKET_WEIGHTS`, `BasketCurrency` type; used as fallback/seed when DB has no active basket (runtime source of truth is `BasketConfig` in DB). |
| **contracts.ts** | Contract IDs (from env): Oracle, Reserve Tracker, Minting, Burning; optional: Savings Vault, Lending Pool, Escrow. |
| **database.ts** | Prisma client singleton and DB connection. |
| **mongodb.ts** | MongoDB connection (for cache/session/queues if used). |
| **rabbitmq.ts** | RabbitMQ connection and channel helpers; queue names include USDC_CONVERSION, WITHDRAWAL_PROCESSING, ACBU_SAVINGS_VAULT_EVENTS, ACBU_LENDING_POOL_EVENTS, ACBU_ESCROW_EVENTS. |
| **logger.ts** | Winston logger. |
| **swagger.ts** | Swagger/OpenAPI spec (e.g. JSDoc-driven) for `/api-docs`. |

#### Routes (`backend/src/routes/`)

| File | Purpose |
|------|---------|
| **index.ts** | Main router: `GET /health`, `GET /health/metrics`, and mounts: `/auth`, `/reserves`, `/kyc`, `/recipient`, `/transfers`, `/users`, `/recovery`, `/mint`, `/burn`, `/rates`, `/transactions`, and **segment routes**: `/p2p`, `/sme`, `/international`, `/salary`, `/enterprise`, `/savings`, `/lending`, `/gateway`, `/bills`. Webhooks on separate path with raw body. |
| **p2pRoutes.ts**, **smeRoutes.ts**, **internationalRoutes.ts**, **salaryRoutes.ts**, **enterpriseRoutes.ts**, **savingsRoutes.ts**, **lendingRoutes.ts**, **gatewayRoutes.ts**, **billsRoutes.ts** | Segment routes; require API key + segment scope (e.g. `p2p:read`, `savings:write`) via `requireSegmentScope`. |
| **authRoutes.ts** | Auth (login, register, refresh, logout, etc.). |
| **reserveRoutes.ts** | Reserve status and history. |
| **kycRoutes.ts** | KYC application submit, status, documents. |
| **recipientRoutes.ts** | Recipient resolution (e.g. bank/momo accounts). |
| **transferRoutes.ts** | P2P transfers. |
| **userRoutes.ts** | User profile, settings. |
| **recoveryRoutes.ts** | Account recovery (e.g. guardians). |
| **mintRoutes.ts** | Mint (USDC → ACBU) initiation/status. |
| **burnRoutes.ts** | Burn (ACBU → local currency) initiation/status. |
| **ratesRoutes.ts** | ACBU and forex rates; **GET /rates/quote** (amount, equivalent in USD + basket currencies). |
| **transactionRoutes.ts** | Transaction history. |
| **webhookRoutes.ts** | Incoming webhooks (e.g. fintech callbacks); uses raw body for verification. |

#### Controllers (`backend/src/controllers/`)

One controller per route area: **authController**, **burnController**, **kycController**, **mintController**, **ratesController**, **recipientController**, **recoveryController**, **reserveController**, **transactionController**, **transferController**, **userController**, **webhookController**. They parse requests, call services, and send HTTP responses.

#### Services (`backend/src/services/`)

| Area | Files | Purpose |
|------|--------|---------|
| **auth** | authService, index | Login, JWT, registration, session. |
| **audit** | auditService, index | Audit trail writing. |
| **basket** | basketService, index | Basket composition from DB (BasketConfig); used by reserve/oracle/rebalancing. |
| **metrics** | metricsService, worldBankClient, index | **Data-driven weights:** World Bank GDP, platform trade volume, liquidity placeholder; normalize scores, compute proposed weights; store BasketMetrics, create BasketConfig proposed. |
| **contracts** | burning.Service, minting.Service, oracle.Service, reserveTracker.Service, index | Stellar/Soroban contract invocation (mint, burn, oracle update, reserve update). |
| **fintech** | router, router.test, types, index | Routes per-currency to correct provider (Paystack, Flutterwave, MTN MoMo); clients in **paystack/**, **flutterwave/**, **mtn-momo/**. |
| **kyc** | applicationService, feeVerification, machineLayer, quality, rewardService, storage, types, validatorPool, index | Pi-style two-layer KYC: machine layer (optional), validator pool, fee in ACBU, rewards. |
| **notification** | notificationService, index | OTP and general notifications (email/SMS via SendGrid, SES, Twilio, Africa’s Talking, or log). |
| **oracle** | integrationService, index, **forexClient**, **centralBankClient** | **40/40/20:** Layer 1 central bank (configurable URLs), Layer 2 fintech, Layer 3 forex (ExchangeRate-API). Outlier detection, deviation limit, circuit breaker. Fetches/aggregates rates, derives reference amounts from weights+rates, populates AcbuRate per-currency, pushes to Oracle contract. |
| **recipient** | recipientResolver, types, index | Resolves recipient to bank/momo details per country. |
| **recovery** | recoveryService, index | Guardian-based account recovery. |
| **reserve** | ReserveTracker.ts, RebalancingEngine.ts, ReserveTracker.test | Reserve ratio calculation, rebalancing logic, tests. |
| **stellar** | client, contractClient, eventListener | Horizon client, contract calls, Stellar event subscription (Mint/Burn). |
| **transfer** | transferService, types, index | P2P ACBU transfers. |
| **wallet** | walletService, walletActivationService, index | Stellar account creation, activation (send XLM). |
| **webhook** | webhookService, index | Outbound webhook delivery (HMAC-SHA256). |

#### Jobs (`backend/src/jobs/`)

| File | Purpose |
|------|---------|
| **kycProcessingJob** | RabbitMQ consumer: process KYC applications (machine + validators). |
| **walletActivationJob** | Consumer: when KYC fee is paid, send XLM to user wallet. |
| **notificationConsumer** | Consumer: send OTP/notifications (email/SMS). |
| **webhookConsumer** | Consumer: deliver outbound webhooks with signature. |
| **oracleUpdateJob** | Scheduler: every 6h, fetch rates (40/40/20) and update Oracle contract. |
| **proposedWeightsJob** | Scheduler: e.g. monthly; ingest metrics (World Bank GDP, platform trade), compute proposed weights (0.4×GDP + 0.3×Trade + 0.3×Liquidity), create BasketConfig **proposed**; admin approves to move to active. |
| **reserveTrackingJob** | Scheduler: every 6h, sync reserve state with Reserve Tracker contract. |
| **rebalancingJob** | Scheduler: daily at 00:00 UTC, run rebalancing. |
| **usdcConversionJob** | Consumer: on MintEvent, trigger USD → basket allocation. |
| **withdrawalProcessingJob** | Consumer: on BurnEvent, trigger fintech disbursement. |
| **acbu_minting_event_listener.ts** | Listens for Mint events from acbu_minting contract, enqueues USDC conversion. |
| **acbu_burning_event_listener.ts** | Listens for Burn events from acbu_burning contract, enqueues withdrawal processing. |
| **acbu_savings_vault_event_listener.ts**, **acbu_lending_pool_event_listener.ts**, **acbu_escrow_event_listener.ts** | Listen for events from respective contracts; enqueue to ACBU_SAVINGS_VAULT_EVENTS, ACBU_LENDING_POOL_EVENTS, ACBU_ESCROW_EVENTS. |

#### Middleware (`backend/src/middleware/`)

**auth** (JWT/API key), **segmentGuard** (requireSegmentScope, requireMinTier for segment routes), **cors**, **errorHandler**, **logger**, **rateLimiter**, **validator** (e.g. Zod).

#### Utils (`backend/src/utils/`)

**cache**, **jwt**, **sanitize** – helpers for caching, JWT, and input sanitization.

### 3.3 Prisma (`backend/prisma/`)

| File | Purpose |
|------|---------|
| **schema.prisma** | PostgreSQL schema: **User** (Stellar, KYC, 2FA, guardians, contacts, actorType, tier, organizationId), **Organization** (name, kycStatus, actorType), **ApiKey** (optional organizationId, permissions for segment scopes), **Transaction**, **Reserve**, **ReserveHistory**, **OracleRate**, **AcbuRate**, **BasketMetrics**, **BasketConfig**, **RebalancingEvent**, **AuditTrail**, **Webhook**, **UserPasskey**, **Guardian**, **UserContact**, **OtpChallenge**, **KycApplication**, **KycDocument**, **KycValidator**, **KycValidation**, **KycValidatorReward**. |
| **seed.ts** | Seeds DB (e.g. basket config, test data). |
| **migration_lock.toml** | Prisma migration lock. |

### 3.4 Tests (`backend/tests/`)

**setup.ts** – global test setup. Unit/integration tests also live next to modules (e.g. **reserveController.test.ts**, **ReserveTracker.test.ts**, **router.test.ts**).

### 3.5 CI (`backend/.github/workflows/`)

**ci.yml** – runs lint/test (and optionally build) on push/PR.

---

## 4. Contracts (`acbu-smart-contract/` or `contracts/`)

Rust workspace for **Soroban** (Stellar) smart contracts. Built as WASM for `wasm32-unknown-unknown`. Naming: **acbu_<domain>_<capability>** (e.g. acbu_minting, acbu_savings_vault).

### 4.1 Workspace (`Cargo.toml`)

- **members:** `acbu_minting`, `acbu_burning`, `acbu_oracle`, `acbu_reserve_tracker`, `acbu_savings_vault`, `acbu_lending_pool`, `acbu_escrow`, `shared` (if present).
- **profiles:** `release` (size-optimized, LTO, strip), `release-with-logs` (same with debug).

### 4.2 Shared (`contracts/shared/`)

**src/lib.rs** – Shared types and constants used by all contracts:

- **Types:** `CurrencyCode`, `RateData`, `ReserveData`, `AccountDetails`, `MintEvent`, `BurnEvent`, `RateUpdateEvent`, `ContractError`.
- **Constants:** `BASIS_POINTS`, `DECIMALS`, `MIN_MINT_AMOUNT`, `MAX_MINT_AMOUNT`, `MIN_BURN_AMOUNT`, `UPDATE_INTERVAL_SECONDS`, `EMERGENCY_THRESHOLD_BPS`, `OUTLIER_THRESHOLD_BPS`.
- **Helpers:** `calculate_fee`, `calculate_amount_after_fee`, `median`, `calculate_deviation`.

### 4.3 Minting Contract (`acbu_minting/`)

- **Purpose:** USDC → ACBU with fee; emits `MintEvent`.
- **DataKey:** admin, oracle, reserve_tracker, acbu_token, usdc_token, fee_rate, paused, min/max mint amount.
- **initialize(admin, oracle, reserve_tracker, acbu_token, usdc_token, fee_rate_bps):** one-time setup.
- **mint(user, usdc_amount):** checks oracle rate, reserve tracker, applies fee, mints ACBU, transfers USDC from user, emits event.
- **Cargo.toml** – depends on `shared`; uses `soroban_sdk`; no_std.
- **tests/test.rs** – unit tests for minting.

### 4.4 Burning Contract (`acbu_burning/`)

- **Purpose:** ACBU → burn for local currency; emits `BurnEvent` with `AccountDetails`.
- **DataKey:** admin, oracle, reserve_tracker, acbu_token, withdrawal_processor, fee_rate, paused, min_burn_amount.
- **initialize(admin, oracle, reserve_tracker, acbu_token, withdrawal_processor, fee_rate_bps):** one-time setup.
- **burn(user, acbu_amount, account_details):** validates, burns ACBU, applies fee, emits BurnEvent for backend to process disbursement.
- **Cargo.toml**, **README.md** – same pattern as minting.

### 4.5 Oracle Contract (`acbu_oracle/`)

- **Purpose:** Multi-validator rate feed; median rate per currency; basket weights.
- **DataKey:** admin, validators, min_signatures, currencies, rates, last_update, update_interval, basket_weights.
- **initialize(admin, validators, min_signatures, currencies, basket_weights):** one-time setup.
- **submit_rates(validator, rates):** validator submits rates; when enough signatures, median is stored and `RateUpdateEvent` emitted.
- **get_rate(currency), get_rates():** read current rates.
- **tests/test.rs** – oracle tests.

### 4.6 Reserve Tracker Contract (`acbu_reserve_tracker/`)

- **Purpose:** Tracks reserve balances per currency (amount + value_usd); min/target ratio (basis points).
- **DataKey:** admin, acbu_token, reserves, min_ratio, target_ratio.
- **initialize(admin, acbu_token, min_ratio_bps, target_ratio_bps):** one-time setup.
- **update_reserve(currency, amount, value_usd):** admin-only; updates one currency’s reserve.
- **get_reserve_ratio(), get_reserves():** read state for mint/burn and backend dashboards.
- **Cargo.toml**, **README.md** – same style.

### 4.7 Scripts (`contracts/scripts/`)

- **deploy.sh** – generic deploy script.
- **deploy_testnet.sh** – deploy to Stellar testnet.
- **deploy_mainnet.sh** – deploy to Stellar mainnet.

### 4.9 Contract Docs

- **README.md** – build, test, deploy; project structure; security notes.
- **DEPLOYMENT.md**, **INTEGRATION.md**, **QUICKSTART.md** – deployment and integration instructions.

### 4.10 Build Output (`target/`)

Rust build artifacts; `wasm32-unknown-unknown/release/*.wasm` used for deployment and for token contract import in minting/burning.

---

## 5. Documentation (`DOCS/`)

### 5.1 Root `DOCS/` (Technical Specs)

| File | Purpose |
|------|---------|
| **API_AND_CONTRACTS_REFERENCE.MD** | Single reference: all API routes, segment scopes, smart contracts, env vars, event queues. |
| **API_SPECIFICATION.MD** | REST API endpoints, request/response shapes (see also API_AND_CONTRACTS_REFERENCE). |
| **ARCHITECTURE_DIAGRAMS.MD** | Mermaid diagrams: system overview, mint flow, burn flow, reserve/oracle/fintech. |
| **DATABASE_SCHEMA.MD** | Database tables and relationships (aligns with Prisma schema). |
| **IMPLEMENTATION_PLAN.MD** | Phase-by-phase implementation plan. |
| **KYC_LAYER.md** | KYC design (two-layer, validators, fees, rewards). |
| **SMART_CONTRACT_SPEC.MD** | Smart contract interfaces and behavior. |
| **TECHNICAL_ROADMAP.MD** | Tech stack (Stellar, Node/Express, PostgreSQL, MongoDB, RabbitMQ, React), infra stages, third-party integrations, security audit schedule. |
| **PROJECT_STRUCTURE.MD** | This file. |

### 5.2 DOCS/MD (Business & Operations)

- **MAIN.MD** – Executive summary and doc index.
- **STAGES.MD** – Development stages (0–4) and timelines.
- **GAP_ANALYSIS.MD** – Document/requirement consistency.

**DOCS/MD/BUSINESS/**  
**BUSINESS_MODEL.MD**, **MVP_PHASE.MD**, **REVENUE_STREAMS.MD**, **USE_CASES.MD**, **VALUE_PROPOSITION.MD** – business model, MVP scope, revenue, use cases, value proposition.

**DOCS/MD/OPERATIONS/**  
**COUNTRY_STRATEGY.MD**, **FINTECH_PARTNERSHIPS.MD**, **REGULATORY.MD**, **RISK_MANAGEMENT.MD** – country rollout, fintech partners, regulation, risk.

**DOCS/MD/TECHNICAL/**  
**ARCHITECTURE.MD**, **ORACLE_SYSTEM.MD**, **PRICING_MECHANISM.MD**, **REBALANCING.MD**, **RESERVE_MANAGEMENT.MD** – architecture, oracle, pricing, rebalancing, reserves.

**DOCS/MD/USER_EXPERIENCE/**  
**DIASPORA_REMITTANCES.MD**, **MERCHANT_INTEGRATION.MD**, **USER_FLOWS.MD** – remittances, merchants, user flows.

### 5.3 DOCS/PROJECT (Project Management)

| File | Purpose |
|------|---------|
| **BACKEND_TODO.MD** | Backend task list and status. |
| **MILESTONES.MD** | Key milestones and acceptance criteria. |
| **RESOURCE_PLAN.MD** | Team and resource allocation. |
| **TASK_BREAKDOWN.MD** | Detailed task breakdown per stage. |

---

## 6. General Infrastructure (Current State)

### 6.1 Application Layer

- **Single backend process** (Node.js): HTTP API + all RabbitMQ consumers + Stellar event listeners + cron-like schedulers (oracle, reserve, rebalancing).
- **API:** versioned under `/{apiVersion}` (e.g. `/v1`); webhooks on `/{apiVersion}/webhooks` with raw body; Swagger at `/api-docs`.
- **Auth:** JWT and/or API keys; middleware on protected routes.

### 6.2 Data & Messaging

- **PostgreSQL:** Primary store (Prisma); users, transactions, reserves, oracle rates, basket config, KYC, webhooks, audit.
- **MongoDB:** Used for cache/session (see config); connection at startup.
- **RabbitMQ:** Queues for KYC processing, wallet activation, notifications, webhooks, USDC conversion, withdrawal processing; backend runs consumers for each.

### 6.3 Blockchain

- **Stellar (Soroban):** Minting, Burning, Oracle, Reserve Tracker contracts; backend holds Stellar secret for contract calls and listens to Mint/Burn events to trigger conversion and withdrawals.
- **Horizon:** Configurable base URL (testnet/mainnet).

### 6.4 External Integrations

- **Fintech:** Flutterwave, Paystack, MTN MoMo – currency-to-provider mapping in config (e.g. NGN→Paystack, RWF→MTN MoMo, others→Flutterwave).
- **Notifications:** Email (SendGrid/SES/log), SMS (Twilio/Africa’s Talking/log).
- **KYC:** Optional machine layer (e.g. OpenAI/Textract); validator pool; document storage (e.g. S3-compatible).

### 6.5 Local Development

- **docker-compose.yml** in backend: Postgres, MongoDB, RabbitMQ.
- **Backend:** `pnpm install`, `.env` (see ENV_VARS.md), `prisma migrate`, `pnpm dev`.
- **Contracts:** `cargo build --target wasm32-unknown-unknown --release`; deploy with scripts in `contracts/scripts/`.

### 6.6 What Is Not in Repo (or Placeholder)

- **Frontend/mobile:** Referenced in docs (React, React Native) but no app code in this repo.
- **Production hosting:** Docs mention AWS/GCP, multi-AZ; no IaC or deployment config in repo.
- **CI:** Backend has `.github/workflows/ci.yml`; contract CI not shown.

---

## 7. Quick Reference: Where Things Live

| Concern | Location |
|--------|----------|
| API entry, server start, job wiring | `backend/src/index.ts` |
| Route mounting | `backend/src/routes/index.ts` |
| Env and app config | `backend/src/config/env.ts`, `basket.ts`, `contracts.ts` |
| DB schema | `backend/prisma/schema.prisma` |
| Mint/Burn/Oracle/Reserve/Savings/Lending/Escrow on-chain | `acbu_minting`, `acbu_burning`, `acbu_oracle`, `acbu_reserve_tracker`, `acbu_savings_vault`, `acbu_lending_pool`, `acbu_escrow` |
| Shared contract types/constants | `shared/src/lib.rs` (if present) |
| Fintech routing | `backend/src/services/fintech/router.ts` + paystack/flutterwave/mtn-momo clients |
| KYC flow | `backend/src/services/kyc/`, `backend/src/jobs/kycProcessingJob.ts` |
| Reserve & rebalancing | `backend/src/services/reserve/`, `backend/src/jobs/reserveTrackingJob.ts`, `rebalancingJob.ts` |
| Stellar events → backend | `backend/src/jobs/acbu_minting_event_listener.ts`, `acbu_burning_event_listener.ts`, `acbu_savings_vault_event_listener.ts`, etc.; `backend/src/services/stellar/eventListener.ts` |
| API docs | `DOCS/API_AND_CONTRACTS_REFERENCE.MD`, `DOCS/API_SPECIFICATION.MD`, Swagger in `backend/src/config/swagger.ts` |
| Architecture diagrams | `DOCS/ARCHITECTURE_DIAGRAMS.MD` |
| Tech stack & roadmap | `DOCS/TECHNICAL_ROADMAP.MD` |

---

*Last updated to reflect repository state as of January 2026.*
