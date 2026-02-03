# Frontend & UI/UX Guide

Documentation for the ACBU web application frontend: stack, structure, and **clean, excellent UI ideology** for designers and developers.

---

## 1. Scope and stack

- **Web app:** React (primary), TypeScript, TailwindCSS, Recharts (charts), Stellar SDK for wallet/chain.
- **Mobile (later):** React Native; same UI principles apply.
- **API:** Backend at `https://api.acbu.io/v1` (or env); segment routes (P2P, SME, savings, lending, etc.). See [API and Contracts Reference](PROJECT/API_AND_CONTRACTS_REFERENCE.MD).

This doc focuses on **UI/UX standards** so every screen feels consistent, clear, and trustworthy.

### What to build (pages, components, UI/UX)

A full map of **backend endpoints → frontend pages, components, and UI/UX ideas** is in **[Frontend Pages, Components & UI/UX Map](FRONTEND_PAGES_COMPONENTS_UX.md)**. It covers:

- **Auth** – Sign in, 2FA, sign out  
- **User management** – Profile (GET/PATCH/DELETE me)  
- **Settings** – Receive (address + QR), wallet confirm, contacts, guardians, delete account  
- **KYC** – Start application, list/detail, upload documents, patch documents; **Validator** – register, tasks, submit result, me  
- **Recovery** – Unlock account  
- **Reserves & rates** – Reserve status, track, rates, quote  
- **Mint & burn** – Mint from USDC, burn for fiat  
- **Transfers / P2P** – Send, history, detail, recipient resolve  
- **Transactions** – Transaction detail  
- **International** – Quote, mint, withdraw  
- **SME** – Transfers, statements  
- **Salary** – Disburse, schedule, batches  
- **Enterprise** – Bulk transfer, treasury  
- **Savings** – Deposit, withdraw, positions (acbu_savings_vault)  
- **Lending** – Deposit, withdraw, balance (acbu_lending_pool)  
- **Gateway** – Create charge, release/refund (acbu_escrow)  
- **Bills** – Catalog, pay  
- **Shared components** – Layout, nav, auth guard, amount/status/empty/loading/error, modals, forms  

Use that map as the single checklist for screens and components; apply the ideology below to how they look and behave.

---

## 2. UI/UX ideology: clean and excellent

We aim for **clean, excellent UI**—professional, calm, and easy to use. These principles guide all layout, components, and interactions.

### 2.1 Clarity over decoration

- **One primary action per context.** Avoid multiple competing CTAs in the same block.
- **Copy is clear and scannable.** Short labels, plain language, no jargon unless necessary (and then explain it).
- **Data and numbers are legible.** Enough contrast, sensible typography, and clear hierarchy (e.g. balance, amounts, status).

### 2.2 Consistency

- **Same patterns everywhere.** Buttons, forms, cards, and feedback (success/error) behave and look the same across the app.
- **Unified design tokens.** Colors, spacing, radius, and type scale come from a single system (e.g. Tailwind config or design tokens).
- **Predictable navigation.** Structure and labels don’t change between sections; back/exit behavior is obvious.

### 2.3 Visual hierarchy

- **Clear importance order.** Primary info (e.g. balance, next step) stands out; secondary info is visually subdued.
- **Typography scale.** One or two headline styles, one or two body styles, one caption/small style—used consistently.
- **Contrast and weight.** Use size and weight to show hierarchy, not only color.

### 2.4 Whitespace and rhythm

- **Generous whitespace.** Dense blocks of content are broken into logical groups with space between.
- **Rhythm.** Spacing follows a scale (e.g. 4/8/16/24/32 px) so layouts feel aligned and intentional.
- **Breathing room.** Buttons and touch targets have enough padding; lists and cards aren’t cramped.

### 2.5 Minimalism

- **Only what’s needed.** No decorative elements that don’t support understanding or action.
- **Progressive disclosure.** Advanced or rare options are secondary (e.g. “More options”, expandable sections).
- **Calm color palette.** Few core colors; accent used sparingly for emphasis and actions.

### 2.6 Trust and stability

- **Stable, professional tone.** Fintech demands trust; avoid playful or noisy UI.
- **Explicit states.** Loading, empty, and error states are designed and implemented everywhere.
- **Confirm destructive actions.** Burn, withdraw, delete, etc. use a clear confirmation step and plain language.

### 2.7 Accessibility (a11y)

- **Keyboard and focus.** All interactive elements are focusable; focus order and visible focus indicators are logical.
- **Screen readers.** Semantic HTML, ARIA where needed, and no information conveyed by color alone.
- **Contrast.** Text and interactive elements meet WCAG AA (or better) contrast ratios.
- **Motion.** Respect `prefers-reduced-motion`; avoid motion that is required to understand content.

### 2.8 Performance and feedback

- **Fast perceived performance.** Skeletons or clear loading states; avoid blank screens.
- **Immediate feedback.** Button press, form submit, and navigation give instant visual feedback.
- **Errors are actionable.** Error messages explain what went wrong and what the user can do next.

---

## 3. Design system mindset

- **Tokens first.** Define colors, spacing, radius, shadows, and typography in one place (e.g. `tailwind.config.js` or CSS variables).
- **Components second.** Buttons, inputs, cards, and modals use tokens only; no one-off values.
- **Document patterns.** Keep a small “kitchen sink” or Storybook for shared components so everyone uses the same variants (primary/secondary, sizes, states).

Suggested token categories:

- **Colors:** primary, secondary, neutral (background/surface/text), success, warning, error, info.
- **Spacing:** 0, 1, 2, 3, 4, 5, 6, 8, 10, 12, 16, 20, 24, 32 (e.g. in rem or px).
- **Typography:** font family, sizes (xs–xl), line heights, weights.
- **Radius:** none, sm, md, lg, full (e.g. 0, 4px, 8px, 12px, 9999px).
- **Shadows:** subtle (cards), medium (dropdowns), strong (modals).

---

## 4. Component and pattern guidelines

- **Buttons:** One primary style per section; secondary/ghost for less important actions. Disabled state clearly visible.
- **Forms:** Labels above or clearly associated; inline validation where helpful; one primary submit per form.
- **Cards:** Consistent padding and radius; clear separation between cards and background.
- **Tables/lists:** Header row distinct; rows easy to scan; actions (e.g. “View”) consistent and minimal.
- **Empty states:** Illustration or icon + short message + single CTA when relevant.
- **Errors:** Inline for fields; banner or modal for global/blocking errors. Always a way to dismiss or retry.

Avoid:

- Heavy gradients or decorative imagery that distract from data and actions.
- More than one primary CTA in a single block.
- Long walls of text without headings or bullets.
- Inconsistent spacing or alignment.

---

## 5. Responsive and touch

- **Mobile-first.** Layout and touch targets work on small screens first; then enhance for desktop.
- **Touch targets.** Buttons and links at least 44×44 px (or equivalent) on touch devices.
- **Readable text.** Minimum ~16px body on mobile to reduce zooming.
- **No hover-only info.** Critical information and actions are available without hover (e.g. use tap/click or visible labels).

---

## 6. Frontend structure (recommended)

When you create the app, a clear structure keeps UI consistent and maintainable:

```
frontend/
├── public/
├── src/
│   ├── components/       # Shared UI (Button, Input, Card, Modal, etc.)
│   │   ├── ui/           # Primitives from design system
│   │   └── layout/       # Header, Footer, Sidebar, PageLayout
│   ├── pages/            # Route-level views
│   ├── hooks/            # Shared logic (auth, API, form state)
│   ├── services/         # API client (calls to backend)
│   ├── store/            # State (e.g. Zustand/Redux) if needed
│   ├── styles/           # Global CSS, Tailwind entry, tokens
│   ├── utils/            # Helpers (formatting, validation)
│   └── types/            # Shared TypeScript types
├── tailwind.config.js
├── .env.example          # VITE_API_BASE_URL or similar
└── package.json
```

- **API base URL** from env; use segment routes and scopes as in the API reference.
- **Auth:** Store API key or JWT securely; send per backend spec (e.g. `Authorization: Bearer <key>`).

---

## 7. References

- **Pages, components, UI/UX (what to build):** [FRONTEND_PAGES_COMPONENTS_UX.md](FRONTEND_PAGES_COMPONENTS_UX.md)
- **API and contracts:** [API_AND_CONTRACTS_REFERENCE.MD](PROJECT/API_AND_CONTRACTS_REFERENCE.MD)
- **Technical stack:** [TECHNICAL_ROADMAP.MD](PROJECT/TECHNICAL_ROADMAP.MD)
- **User flows and UX:** [USER_FLOWS.MD](USER_EXPERIENCE/USER_FLOWS.MD), [MERCHANT_INTEGRATION.MD](USER_EXPERIENCE/MERCHANT_INTEGRATION.MD)

---

*This guide defines the bar for “clean and excellent” UI. All new screens and components should align with these principles and the design system.*
