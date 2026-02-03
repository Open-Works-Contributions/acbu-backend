# Frontend Pages, Components & UI/UX Map

Map of backend endpoints and smart-contract flows to **frontend pages**, **components**, and **UI/UX ideas**. Use this to build the ACBU web app against the existing API and contracts.

**Backend base:** `GET/POST /v1/...` (see [API and Contracts Reference](PROJECT/API_AND_CONTRACTS_REFERENCE.MD)).  
**UI standards:** [Frontend & UI/UX Guide](FRONTEND_AND_UI.md).

---

## 1. Auth

| Backend | Frontend page(s) | Components | UI/UX ideas |
|--------|-------------------|------------|-------------|
| `POST /auth/signin` | **Sign in** | `SignInForm`, `EmailInput`, `PasswordInput`, `SubmitButton` | Single form: email + password. Clear “Forgot password?” link. Error inline under form. No clutter. |
| `POST /auth/signin/verify-2fa` | **Verify 2FA** (after signin when 2FA enabled) | `OtpInput`, `Verify2FAButton` | 6-digit OTP input with auto-focus next. Short copy: “Enter code from your app.” Resend code countdown. |
| `POST /auth/signout` | (No dedicated page) | — | Call on “Sign out” in header/settings. Optional confirmation for shared devices. |

**Flows:** Sign in → dashboard or 2FA step → dashboard. Sign out from header or Settings.

---

## 2. User management & profile

| Backend | Frontend page(s) | Components | UI/UX ideas |
|--------|-------------------|------------|-------------|
| `GET /users/me` | **Profile** (or **Account**) | `ProfileCard`, `Avatar`, `ProfileField` | Show name, email, Stellar address, KYC badge, tier. Clear hierarchy: identity first, then wallet/status. |
| `PATCH /users/me` | **Profile** (edit) | `ProfileForm`, `TextInput`, `SaveButton` | Inline or modal edit. Only editable fields (e.g. display name, phone). Success toast after save. |
| `DELETE /users/me` | **Settings** or **Account** | `DeleteAccountSection`, `ConfirmDialog` | “Delete account” in danger zone. Two-step: confirm password + type “DELETE”. Clear warning text. |

---

## 3. Settings (user)

| Backend | Frontend page(s) | Components | UI/UX ideas |
|--------|-------------------|------------|-------------|
| `GET /users/me/receive` | **Receive** (or under Settings/Wallet) | `ReceiveDetails`, `AddressDisplay`, `CopyButton` | Show Stellar address and optional memo. One-tap copy. Short explanation: “Share this to receive ACBU.” |
| `GET /users/me/receive/qrcode` | **Receive** | `QrCodeDisplay` | QR for address (and memo if used). Same page as receive details. |
| `POST /users/me/wallet/confirm` | **Wallet** or **Settings** | `ConfirmWalletButton`, `StatusBadge` | After first funding, user confirms wallet active. Button + short copy. |
| `GET/POST/DELETE /users/me/contacts` | **Contacts** (or **Settings → Contacts**) | `ContactList`, `ContactCard`, `AddContactForm`, `ContactRow` | List with search. Add: alias + Stellar (or resolve). Delete with row action + confirm. |
| `GET/POST/DELETE /users/me/guardians` | **Settings → Recovery** (or **Guardians**) | `GuardianList`, `AddGuardianForm`, `GuardianCard` | List guardians. Add: email or Stellar. Explain purpose (recovery). Delete with confirm. |

**Settings page idea:** Tabs or sections: Profile, Wallet & receive, Contacts, Guardians, Security (2FA), Danger zone (delete account). Each section uses the components above.

---

## 4. KYC

| Backend | Frontend page(s) | Components | UI/UX ideas |
|--------|-------------------|------------|-------------|
| `POST /kyc/applications` | **KYC – Start** | `KycStartForm`, `CountrySelect`, `ConsentCheckbox` | Minimal form: country, accept terms. Then redirect to “Upload documents”. |
| `GET /kyc/applications` | **KYC – My applications** | `KycApplicationList`, `KycStatusBadge`, `ApplicationCard` | List with status: pending, in_review, approved, rejected. Click → detail. |
| `GET /kyc/applications/:id` | **KYC – Application detail** | `KycApplicationDetail`, `DocumentStatusList`, `StatusTimeline` | Show status, submitted docs, and next steps (e.g. “Upload ID if missing”). |
| `GET /kyc/applications/upload-urls` | **KYC – Upload documents** | `DocumentUploadZone`, `UploadUrlRequestButton`, `FileInput` | Per doc type: get upload URL from backend, then upload file (or use pre-signed flow). Show “Upload ID”, “Upload proof of address” etc. |
| `PATCH /kyc/applications/:id/documents` | **KYC – Application detail** | `DocumentPatchForm`, `DocumentTypeSelect` | After upload, patch application with doc references. Inline or same page as upload. |

**KYC flow:** Start application → Upload documents (with upload-urls + patch) → View application status → Optional “Validator” path below.

**Validator (KYC reviewer):**

| Backend | Frontend page(s) | Components | UI/UX ideas |
|--------|-------------------|------------|-------------|
| `POST /kyc/validator/register` | **Become validator** (onboarding) | `ValidatorRegisterForm` | One-time: terms, identity. After approval, access task list. |
| `GET /kyc/validator/tasks` | **Validator – Tasks** | `ValidatorTaskList`, `TaskCard`, `TaskFilters` | Queue of applications to review. Status filters. Click → task detail. |
| `GET /kyc/validator/me` | **Validator – Profile** | `ValidatorProfileCard` | Stats, status, rewards (if shown). |
| `POST /kyc/validator/tasks/:id` | **Validator – Task detail** | `TaskReviewForm`, `ApproveRejectButtons`, `DocumentViewer` | View applicant docs, add notes, submit approve/reject. Clear CTA and confirmation. |

---

## 5. Account recovery

| Backend | Frontend page(s) | Components | UI/UX ideas |
|--------|-------------------|------------|-------------|
| `POST /recovery/unlock` | **Recovery / Unlock account** (no API key) | `RecoveryForm`, `GuardianCodeInput`, `UnlockButton` | User enters recovery code (from guardians). Simple form, clear success/error. Link from sign-in: “Locked out?” |

---

## 6. Reserves & rates (public / dashboard)

| Backend | Frontend page(s) | Components | UI/UX ideas |
|--------|-------------------|------------|-------------|
| `GET /reserves` | **Reserves** (public or dashboard) | `ReserveSummary`, `ReserveCurrencyList`, `ReserveHealthBadge` | Total supply, reserve value, health. Table or cards per currency (target vs actual weight). Calm, trust-oriented. |
| `POST /reserves/track` | **Reserves** (admin/ops) | `TriggerTrackButton` | Optional “Refresh” for manual run. Feedback: “Tracking started.” |
| `GET /rates` | **Rates** (dashboard or header) | `RatesTable`, `RateRow`, `RatesLastUpdated` | ACBU vs USD and basket currencies. Optional filter by currency. |
| `GET /rates/quote` | **Quote** (used in Mint/Burn/International) | `QuoteDisplay`, `QuoteInput` (amount + currency) | User enters amount (and optional currency); show equivalent. Reuse in mint/burn flows. |

---

## 7. Mint & burn (core)

| Backend | Frontend page(s) | Components | UI/UX ideas |
|--------|-------------------|------------|-------------|
| `POST /mint/usdc` | **Mint** (or **Add funds**) | `MintForm`, `AmountInput`, `WalletAddressInput`, `MintConfirmStep` | Step 1: amount (USDC) + wallet. Step 2: quote (from rates/quote) + confirm. Success: tx id + “ACBU will arrive shortly.” |
| `POST /burn/acbu` | **Burn** (or **Withdraw**) | `BurnForm`, `AmountInput`, `RecipientBankForm`, `BurnConfirmStep` | Amount + currency + recipient (account number, bank code, name). Quote + fee. Confirm step with clear summary. |

**Contract link:** Mint uses `acbu_minting`; burn uses `acbu_burning`. Backend handles contract calls; frontend only shows status and result.

---

## 8. Transfers (P2P)

| Backend | Frontend page(s) | Components | UI/UX ideas |
|--------|-------------------|------------|-------------|
| `POST /transfers` | **Send** (P2P) | `SendForm`, `RecipientPicker` (alias or Stellar), `AmountInput`, `SendConfirm` | Recipient (resolve via GET /recipient), amount, optional memo. Confirm step. Success: transfer id. |
| `GET /transfers` | **Transfer history** | `TransferList`, `TransferRow`, `TransferFilters`, `Pagination` | List with date, recipient, amount, status. Filter by direction/status. |
| `GET /transfers/:id` | **Transfer detail** | `TransferDetailCard`, `StatusTimeline` | Full details; link from list. |
| `GET /recipient` | (Used inside Send) | `RecipientResolver`, `RecipientSearch` | Resolve alias → Stellar. Autocomplete or search in Send form. |

Same endpoints are used by **P2P segment** (`POST /p2p/send`, `GET /p2p/history`, `GET /p2p/:id`). Same pages; optionally different nav (e.g. “P2P” vs “Transfers”).

---

## 9. Transactions

| Backend | Frontend page(s) | Components | UI/UX ideas |
|--------|-------------------|------------|-------------|
| `GET /transactions/:id` | **Transaction detail** (from list or notification) | `TransactionDetailCard`, `TransactionTypeBadge`, `TxStatusStepper` | Type (mint/burn/transfer), amount, status, timestamps, blockchain link if available. |

**Idea:** Global “Activity” or “Transactions” page that lists all (mint, burn, transfer) using transfers + transaction endpoints where applicable.

---

## 10. International (mint / burn / quote)

Same as **Mint & burn** and **Rates**, but under segment **International** (scope `international:read` / `international:write`).

| Backend | Frontend page(s) | Components | UI/UX ideas |
|--------|-------------------|------------|-------------|
| `GET /international/quote` | **International – Quote** | Same `QuoteDisplay` / `QuoteInput` | Dedicated “Get a quote” before mint/burn. |
| `POST /international/mint/usdc` | **International – Mint** | Same as Mint | Same flow; segment-specific nav/label. |
| `POST /international/burn/acbu` | **International – Withdraw** | Same as Burn | Same flow; segment-specific nav. |

**Page idea:** One “International” section: Quote, Mint, Withdraw (tabs or steps).

---

## 11. P2P segment

Same backend as **Transfers**; segment routes: `POST /p2p/send`, `GET /p2p/history`, `GET /p2p/:id`. Use same **Send** and **Transfer history** pages; label as “P2P” or “Send” in nav.

---

## 12. SME segment

| Backend | Frontend page(s) | Components | UI/UX ideas |
|--------|-------------------|------------|-------------|
| `POST /sme/transfers` | **SME – Send** | Same `SendForm` + `RecipientPicker`, `AmountInput` | Same as P2P send; SME branding/sidebar. |
| `GET /sme/transfers` | **SME – Transfers** | Same `TransferList`, `TransferRow` | List SME transfers. |
| `GET /sme/transfers/:id` | **SME – Transfer detail** | Same `TransferDetailCard` | Detail view. |
| `GET /sme/statements` | **SME – Statements** | `StatementList`, `StatementFilters`, `ExportButton` | Same data as transfers; present as “Statements” (e.g. date range, export). |

**Page idea:** SME dashboard: Send, Transfers, Statements (tabs or sidebar).

---

## 13. Salary segment

| Backend | Frontend page(s) | Components | UI/UX ideas |
|--------|-------------------|------------|-------------|
| `POST /salary/disburse` | **Salary – Disburse** | `DisburseForm`, `BatchRecipientsInput`, `AmountPerRecipient`, `DisburseConfirm` | Upload or paste recipients (e.g. Stellar + amount). Summary + confirm. (Backend may be stub.) |
| `POST /salary/schedule` | **Salary – Schedule** | `ScheduleForm`, `RecurrenceSelect`, `RecipientListSelect` | Set recurring batch (e.g. monthly). (Backend may be stub.) |
| `GET /salary/batches` | **Salary – Batches** | `BatchList`, `BatchCard`, `BatchStatusBadge` | List past and scheduled batches; click for detail. |

**Page idea:** Payroll section: Disburse now, Schedule, Batch history.

---

## 14. Enterprise segment

| Backend | Frontend page(s) | Components | UI/UX ideas |
|--------|-------------------|------------|-------------|
| `POST /enterprise/bulk-transfer` | **Enterprise – Bulk transfer** | `BulkTransferForm`, `CsvUpload`, `BulkPreviewTable`, `ConfirmBulk` | Upload CSV (recipient, amount); preview; confirm. (Backend may be stub.) |
| `GET /enterprise/treasury` | **Enterprise – Treasury** | `TreasuryDashboard`, `TreasurySummary`, `BalanceByCurrency`, `RecentMovements` | High-level balances, positions, recent activity. (Backend may be stub.) |

**Page idea:** Enterprise dashboard: Treasury overview, Bulk transfer.

---

## 15. Savings (acbu_savings_vault)

| Backend | Frontend page(s) | Components | UI/UX ideas |
|--------|-------------------|------------|-------------|
| `POST /savings/deposit` | **Savings – Deposit** | `SavingsDepositForm`, `TermSelect`, `AmountInput`, `DepositConfirm` | Amount + term (e.g. 30/90/180 days). Show expected yield if API returns it. Confirm. |
| `POST /savings/withdraw` | **Savings – Withdraw** | `SavingsWithdrawForm`, `PositionSelect`, `WithdrawConfirm` | Choose position (or auto if one). Show early-withdrawal penalty if any. Confirm. |
| `GET /savings/positions` | **Savings – Positions** | `PositionsList`, `PositionCard`, `PositionProgress` | List positions: amount, term, maturity, accrued yield. Clear “Deposit” CTA. |

**Page idea:** Savings hub: Positions (default), Deposit, Withdraw. Contract: `acbu_savings_vault`.

---

## 16. Lending (acbu_lending_pool)

| Backend | Frontend page(s) | Components | UI/UX ideas |
|--------|-------------------|------------|-------------|
| `POST /lending/deposit` | **Lending – Deposit** | `LendingDepositForm`, `AmountInput`, `DepositConfirm` | Deposit ACBU into pool. Summary + confirm. |
| `POST /lending/withdraw` | **Lending – Withdraw** | `LendingWithdrawForm`, `AmountInput`, `WithdrawConfirm` | Withdraw from pool (subject to liquidity). |
| `GET /lending/balance` | **Lending – Dashboard** | `LenderBalanceCard`, `LendingStats`, `DepositWithdrawCtas` | Show lender balance and optional APY; CTAs for deposit/withdraw. |

**Page idea:** Lending section: Balance/dashboard, Deposit, Withdraw. Contract: `acbu_lending_pool`.

---

## 17. Gateway (merchant, acbu_escrow)

| Backend | Frontend page(s) | Components | UI/UX ideas |
|--------|-------------------|------------|-------------|
| `POST /gateway/charges` | **Gateway – Create charge** | `ChargeForm`, `AmountInput`, `ChargeMetadata`, `ChargeConfirm` | Create escrow charge (amount, reference, optional metadata). Return charge id / link for customer. |
| `POST /gateway/confirm` | **Gateway – Confirm** | `ConfirmForm`, `ChargeIdInput`, `ReleaseRefundChoice`, `ConfirmButton` | Release or refund an escrow. Merchant flow. |

**Page idea:** Merchant dashboard: Create charge, List charges (if backend adds later), Release/Refund. Contract: `acbu_escrow`.

---

## 18. Bills

| Backend | Frontend page(s) | Components | UI/UX ideas |
|--------|-------------------|------------|-------------|
| `GET /bills/catalog` | **Bills – Catalog** | `BillerList`, `BillerCard`, `BillerSearch` | List billers (e.g. utilities, airtime). Search/filter. (Backend may be stub.) |
| `POST /bills/pay` | **Bills – Pay** | `BillPayForm`, `BillerSelect`, `AccountRefInput`, `AmountInput`, `PayConfirm` | Select biller, enter customer ref, amount. Confirm. (Backend may be stub.) |

**Page idea:** Bills: Catalog, Pay bill.

---

## 19. Health (optional for frontend)

| Backend | Frontend page(s) | Components | UI/UX ideas |
|--------|-------------------|------------|-------------|
| `GET /health` | (Ops / status page) | — | Optional public status widget. |
| `GET /health/metrics` | (Ops dashboard) | `ReserveRatioBadge` | Optional internal dashboard. |

---

## 20. Shared components (cross-cutting)

Use these across the pages above.

| Component | Purpose | UI/UX |
|-----------|---------|--------|
| **Layout** | `AppLayout`, `Sidebar`, `Header`, `Footer` | Consistent nav; user menu (profile, settings, sign out). |
| **Navigation** | `NavItem`, `SegmentNav` (P2P, SME, International, etc.) | Segment routes gated by scope; hide nav user can’t access. |
| **Auth guard** | Wrapper that checks auth and redirects to sign-in | Use on all authenticated routes. |
| **Amount display** | `Amount`, `CurrencyLabel` | Format ACBU and fiat consistently; optional tooltip for full precision. |
| **Status** | `StatusBadge`, `StatusPill` | pending, completed, failed, etc. One style across transfers, transactions, KYC. |
| **Empty state** | `EmptyState`, `EmptyIllustration` | Icon + message + optional CTA (e.g. “No transfers yet” → “Send”). |
| **Loading** | `PageSkeleton`, `ButtonSpinner`, `InlineLoader` | Skeletons for lists/detail; spinner in buttons during submit. |
| **Errors** | `InlineError`, `ToastError`, `ErrorBanner` | Inline for fields; toast or banner for global errors. |
| **Modals** | `ConfirmModal`, `FormModal` | Confirm destructive actions; small forms (e.g. add contact). |
| **Forms** | `Input`, `Select`, `Checkbox`, `RadioGroup` | From design tokens; consistent validation and error display. |

---

## 21. Suggested app structure (routes / nav)

- **Public:** Sign in, Recovery unlock, (optional) Reserves/Rates.
- **Authenticated:**  
  - **Home/Dashboard:** Summary (balance, recent activity), quick actions (Send, Mint, Burn).  
  - **Profile:** GET/PATCH /users/me.  
  - **Settings:** Receive, Wallet confirm, Contacts, Guardians, Delete account.  
  - **KYC:** Start, My applications, Application detail, Upload documents.  
  - **Validator:** (if user is validator) Tasks, Task detail, Me.  
  - **Transfers / P2P:** Send, History, Transfer detail.  
  - **Transactions:** List (mint/burn/transfer), Transaction detail.  
  - **Mint / Burn:** Mint, Burn (or under “Funds” / “International”).  
  - **Rates / Reserves:** Rates, Reserves.  
  - **SME:** Send, Transfers, Statements.  
  - **International:** Quote, Mint, Withdraw.  
  - **Salary:** Disburse, Schedule, Batches.  
  - **Enterprise:** Treasury, Bulk transfer.  
  - **Savings:** Positions, Deposit, Withdraw.  
  - **Lending:** Balance, Deposit, Withdraw.  
  - **Gateway:** Create charge, Confirm (release/refund).  
  - **Bills:** Catalog, Pay.

Nav can be role/tier-based: show only segments the user’s API key (or role) can access.

---

## 22. API usage summary

- **Auth:** Store token/API key securely; send `Authorization: Bearer <key>` (or header per backend).
- **Segment routes:** Require scope (e.g. `p2p:read`). Backend returns 403 if missing; frontend can hide nav for segments user can’t access.
- **Errors:** Use backend error shape (code, message, details) for inline and toast messages.
- **Lists:** Use query params for filters/pagination if backend supports them; otherwise client-side filter.

This map is the single source for “what to build” for the frontend; implementation should follow the [Frontend & UI/UX Guide](FRONTEND_AND_UI.md) for look and feel.
