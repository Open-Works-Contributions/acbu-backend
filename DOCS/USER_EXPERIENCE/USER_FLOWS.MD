# User Flows

## Scenario 1: Intra-African Travel/Business

### Nigerian Traveler Going to Ghana

**Step 1: Deposit in Nigeria**
- User: "I need money for Ghana trip"
- Deposits: 500,000 NGN via Flutterwave
- Receives: ~500 ACBU (stored in wallet)
- Fees: 0.3% = 1,500 NGN

**Step 2: Arrives in Ghana (3 days later)**
- User: "I need GHS now"
- Links Ghana mobile money/bank account
- Withdraws: 30,000 GHS via Paystack Ghana
- Fees: 0.3% = 90 GHS

**Total cost:** ~0.6% (vs 5-8% traditional remittance/forex)  
**Time:** Instant on both ends

**Why this solves the "single currency withdrawal" problem:**
- Users withdraw based on geographic need, not arbitrage
- Natural distribution: Nigerian users → NGN, Ghanaian users → GHS
- Withdrawal patterns match deposit patterns over time
- The reserves naturally balance geographically

## Scenario 2: Deposit Flow (USDC → ACBU)

1. User connects Stellar wallet (Freighter, Albedo)
2. User enters USDC amount
3. System shows ACBU equivalent
4. System displays fee breakdown (0.3%)
5. User confirms transaction
6. User signs with Stellar wallet
7. System shows pending → success status
8. User receives ACBU in wallet

## Scenario 3: Withdrawal Flow (ACBU → Local Currency)

1. User selects currency (NGN/KES/RWF or basket)
2. User enters ACBU amount to redeem
3. User enters local bank/mobile money details
4. System shows local currency equivalent
5. System displays fee breakdown (0.3%)
6. User confirms redemption
7. System shows processing status
8. User receives notification on completion (email/SMS)
9. Funds appear in user's account

## Scenario 4: Peer-to-Peer Transfer

1. User selects "Send ACBU"
2. User enters recipient Stellar address or scans QR code
3. User enters amount
4. User confirms transaction
5. Transfer is instant (3-5 seconds on Stellar)
6. Recipient receives ACBU
7. Both users see transaction in history

**Cost:** FREE (or 0.01% to cover blockchain fees)

## Scenario 5: Merchant Payment

1. Merchant displays QR code or payment link
2. User scans QR code or clicks link
3. User's wallet opens with payment details
4. User confirms payment amount
5. User approves transaction
6. Payment is instant
7. Merchant receives ACBU
8. Merchant can withdraw to local currency or keep ACBU

**Cost:** FREE for user, 0.2% for merchant (vs 2-3% card fees)

---

**Related Documents:**
- [Diaspora Remittances](../USER_EXPERIENCE/DIASPORA_REMITTANCES.MD)
- [Merchant Integration](../USER_EXPERIENCE/MERCHANT_INTEGRATION.MD)
