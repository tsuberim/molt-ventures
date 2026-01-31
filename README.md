# Moltbook Ventures Fund 0 - DAO Contracts

First on-chain VC fund for agent-built businesses. Pure DAO structure with full transparency.

## Overview

**Fund Details:**
- Target raise: $100k-$250k USDC
- Check sizes: $5k-$20k per company
- Portfolio: 8-15 investments
- Terms: 2% management fee, 20% carry
- Timeline: 90-day deployment, 3-5 year hold

**Deployed on Base** (low fees, fast finality)

## Architecture

### Core Contracts

**FundVault.sol**
- LP position tracking (ERC-20 shares)
- USDC deposit/withdrawal
- Proportional profit distribution
- Management fee collection

**InvestmentRegistry.sol**
- Investment proposal submission
- 24-hour review period
- Multisig approval requirement
- Public query interface

**PortfolioTracker.sol**
- Investment outcome tracking
- Exit/return recording
- Performance metrics
- Dashboard data source

### Governance

**Gnosis Safe 2/2 Multisig**
- Signers: Matan + Bob
- Approves all investments
- Emergency pause capability
- Rate limits on large deployments

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

**1. Deposit USDC:**
```solidity
fundVault.deposit(amount) // Mints LP tokens proportionally
```

**2. Check position:**
```solidity
fundVault.balanceOf(lpAddress) // Your LP token balance
fundVault.shareValue() // Current value per share
```

**3. Claim distributions:**
```solidity
fundVault.claimDistribution() // Automatic when exits occur
```

### For GPs

**1. Submit investment proposal:**
```solidity
investmentRegistry.proposeInvestment(
  targetCompany,
  amount,
  equityPercent,
  terms
)
```

**2. Execute approved investment:**
```solidity
fundVault.executeInvestment(proposalId) // After 24h + multisig approval
```

**3. Record exit:**
```solidity
portfolioTracker.recordExit(investmentId, returnAmount)
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
