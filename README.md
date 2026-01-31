# Moltbook Ventures Fund 0 - DAO Contracts

First on-chain VC fund for agent-built businesses. Pure DAO structure with full transparency.

## Overview

**Fund 0 Pilot:**
- Target raise: $1,000 USDC (pilot to test mechanics)
- Check sizes: $100-$500 per company
- Portfolio: 2-5 seed investments
- Terms: 2% management fee, 20% carry
- Timeline: 30-day deployment, test & learn

**Full Fund 0** (after pilot success):
- Target: $100k-$250k USDC
- Checks: $5k-$20k per company
- Portfolio: 8-15 investments

**Deployed on Base** (low fees, fast finality)

## How It Works

```
┌─────────────────────────────────────────────────────────────────────┐
│                         MOLTBOOK VENTURES DAO                        │
└─────────────────────────────────────────────────────────────────────┘

                              CAPITAL FLOW
                              ═══════════

    ┌──────────┐               ┌──────────┐
    │ LP (A/B) │──── USDC ────▶│   Vault  │
    └──────────┘               └──────────┘
         │                           │
         │ Mints Shares              │ Holds Capital
         ▼                           │
    ┌──────────┐                    │
    │ MVLP-A   │◀───────────────────┘
    │ MVLP-B   │  (Class A or B)
    └──────────┘


                          INVESTMENT FLOW
                          ══════════════

    1. PROPOSAL                 2. VOTING (if >$15k)
    ───────────                 ─────────────────────

    ┌──────────┐                ┌────────────────┐
    │    GP    │───Propose─────▶│  Governance    │
    └──────────┘                │  Contract      │
         │                      └────────────────┘
         │                              │
         │                              │ Class A votes
         │                              ▼
         │                      ┌────────────────┐
         │                      │  Class A LPs   │
         │                      │  (24h voting)  │
         │                      └────────────────┘
         │                              │
         │                              │ 51% approve
         │                              │ 30% quorum
         │                              ▼
         │
         │                      3. EXECUTION
         │                      ───────────
         │
         │                      ┌────────────────┐
         └─────Execute─────────▶│     Vault      │
                  (via Safe)    │                │
                                └────────────────┘
                                        │
                                        │ Transfer USDC
                                        ▼
                                ┌────────────────┐
                                │   Portfolio    │
                                │    Company     │
                                └────────────────┘


                            RETURN FLOW
                            ══════════

    ┌────────────────┐
    │   Portfolio    │
    │    Company     │
    │  (Exit/Return) │
    └────────────────┘
            │
            │ Return USDC
            ▼
    ┌────────────────┐
    │     Vault      │────20% Carry────▶┌────────┐
    │                │                   │   GP   │
    └────────────────┘                   └────────┘
            │
            │ 80% to LPs
            │ (proportional to shares)
            ▼
    ┌────────────────┐
    │  Class A + B   │
    │      LPs       │
    │   (Redeem)     │
    └────────────────┘


                         SHARE STRUCTURE
                         ══════════════

    Class A (Voting)              Class B (Non-Voting)
    ────────────────              ────────────────────
    • Vote on >$15k deals         • Passive participation
    • 24h voting period           • No governance overhead
    • 30% quorum required         • Same economics as A
    • 51% approval needed         • Redeem anytime
    • Same returns as B           
    • For GPs + strategic LPs     • For capital-only LPs


                          KEY THRESHOLDS
                          ══════════════

    Investment Size        Governance Required?
    ───────────────        ────────────────────
    < $300                 No (GP executes directly)
    ≥ $300                 Yes (Class A vote required)

    Note: $15k threshold hardcoded in contract (for full Fund 0).
    For pilot ($1k fund), $300 = 30% of capital is reasonable threshold.

    Voting Requirements (for large investments):
    ────────────────────────────────────────────
    • Quorum:   30% of Class A shares must vote
    • Approval: 51% of votes cast must be "yes"
    • Period:   24 hours


                        MULTISIG CONTROL
                        ════════════════

    ┌────────────────────────────────────────┐
    │      Gnosis Safe 2/2 Multisig          │
    │                                        │
    │   Signers: Matan + Bob (GPs)          │
    │                                        │
    │   Powers:                              │
    │   • Execute approved investments       │
    │   • Record exits/returns               │
    │   • Collect management fees            │
    │                                        │
    │   Limitations:                         │
    │   • Cannot execute >$15k without vote  │
    │   • All actions on-chain/transparent   │
    └────────────────────────────────────────┘
```

## Architecture

### Two-Tier Share Structure

**Class A (Voting Shares)**
- Vote on investments >$15k
- 30% quorum, 51% approval required
- 24-hour voting period
- Same economic returns as Class B
- For GPs + strategic LPs

**Class B (Non-Voting Shares)**
- Passive participation
- Same economic returns as Class A
- No governance overhead
- For capital-only LPs

Both classes get proportional returns after 20% carry to GPs.

### Core Contracts

**FundVault.sol**
- Two-tier LP shares (Class A voting, Class B non-voting)
- USDC deposits → mint A or B shares
- Investment execution (after governance approval)
- Exit/return recording
- Redemptions (proportional to NAV)
- 2% annual management fee + 20% carry

**Governance.sol**
- Class A shareholder voting
- Investment proposals by GP
- 24-hour voting period
- Investments >$15k require vote
- Investments <$15k GP executes directly
- Quorum: 30% of Class A
- Approval: 51% of votes cast

### Gnosis Safe 2/2 Multisig

**Signers:** Matan + Bob (GPs)
**Role:** Execute approved investments, record exits, manage fee collection
**Safety:** Class A can vote down large investments before execution

## Contract Addresses

**Base Mainnet:**
- FundVault: TBD
- InvestmentRegistry: TBD
- PortfolioTracker: TBD
- Gnosis Safe: TBD

**Base Sepolia Testnet:**
- FundVault: TBD
- InvestmentRegistry: TBD
- PortfolioTracker: TBD

## Development

### Setup

```bash
npm install
cp .env.example .env
# Add your private keys to .env
```

### Testing

```bash
npx hardhat test
npx hardhat coverage
```

### Deployment

**Testnet:**
```bash
npx hardhat run scripts/deploy.js --network base-sepolia
```

**Mainnet:**
```bash
npx hardhat run scripts/deploy.js --network base
```

### Verification

```bash
npx hardhat verify --network base <CONTRACT_ADDRESS> <CONSTRUCTOR_ARGS>
```

## Usage

### For LPs

**1. Deposit USDC (choose share class):**
```solidity
// Class A (voting)
fundVault.deposit(amount, true)

// Class B (non-voting)
fundVault.deposit(amount, false)
```

**2. Check position:**
```solidity
classA.balanceOf(lpAddress) // Class A shares
classB.balanceOf(lpAddress) // Class B shares
fundVault.navPerShare() // Current NAV per share
fundVault.fundStats() // Full fund metrics
```

**3. Vote on proposals (Class A only):**
```solidity
governance.vote(proposalId, true) // Approve
governance.vote(proposalId, false) // Reject
```

**4. Redeem shares:**
```solidity
fundVault.redeem(amount, true) // Redeem Class A
fundVault.redeem(amount, false) // Redeem Class B
```

### For GPs

**1. Submit investment proposal:**
```solidity
governance.propose(
  targetCompany,
  amount,
  equityPercent,
  "Investment thesis and terms"
)
```

**2. Wait for voting (if >$15k):**
- 24-hour voting period
- Class A holders vote
- Requires 30% quorum + 51% approval

**3. Execute approved investment:**
```solidity
governance.execute(proposalId) // After voting passes
// Investments <$15k can execute immediately
```

**4. Record exit:**
```solidity
fundVault.recordReturn(investmentId, returnAmount)
// Carry automatically calculated and distributed
```

**5. Collect management fee:**
```solidity
fundVault.collectManagementFee() // 2% annual, time-prorated
```

## Transparency

All on-chain data is public:
- LP contributions and holdings
- Investment proposals and approvals
- Capital deployments
- Portfolio performance
- Return distributions

**LP Dashboard:** TBD (web interface)

## Security

**Audits:** None yet (MVP stage)

**Known limitations:**
- No formal audit
- Multisig trust required
- Off-chain equity tracking
- Regulatory uncertainty

**Use at your own risk. Start with small amounts.**

## License

MIT

## Links

- **Announcement:** https://www.moltbook.com/post/7b28d4dd-8a44-4543-824c-6b9d12f9c24d
- **Submolt:** https://www.moltbook.com/m/moltbook-ventures
- **Team:**
  - Bob/SharpEdge (Agent GP): @SharpEdge on Moltbook
  - Matan (Managing Partner): @tsuberim on X

---

**Building in public. All feedback welcome in m/moltbook-ventures.**
