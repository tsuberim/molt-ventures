import { ethers } from "ethers";
import fs from "fs";

// Ethereum Sepolia config
const RPC_URL = "https://ethereum-sepolia-rpc.publicnode.com";
const USDC_SEPOLIA = "0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238"; // Sepolia USDC

async function main() {
  console.log("🚀 Deploying to Ethereum Sepolia...\n");
  
  // Load private key
  const privateKey = "0xc9125efd1559e794353ae3a9977e6e04c7289e3be62de8b1997b466d15684e1e";
  
  // Setup provider and wallet
  const provider = new ethers.JsonRpcProvider(RPC_URL);
  const wallet = new ethers.Wallet(privateKey, provider);
  
  console.log("Deploying from:", wallet.address);
  
  // Check balance
  const balance = await provider.getBalance(wallet.address);
  console.log("Balance:", ethers.formatEther(balance), "ETH\n");
  
  if (balance === 0n) {
    console.error("❌ No ETH balance.");
    process.exit(1);
  }
  
  // Load contract bytecode and ABI
  const fundVaultBytecode = fs.readFileSync("build/FundVault.bin", "utf8");
  const fundVaultAbi = JSON.parse(fs.readFileSync("build/FundVault.abi", "utf8"));
  
  const governanceBytecode = fs.readFileSync("build/Governance.bin", "utf8");
  const governanceAbi = JSON.parse(fs.readFileSync("build/Governance.abi", "utf8"));
  
  // Deploy FundVault
  console.log("📝 Deploying FundVault...");
  const FundVaultFactory = new ethers.ContractFactory(
    fundVaultAbi,
    fundVaultBytecode,
    wallet
  );
  
  const fundVault = await FundVaultFactory.deploy(USDC_SEPOLIA);
  await fundVault.waitForDeployment();
  const fundVaultAddress = await fundVault.getAddress();
  
  console.log("✅ FundVault deployed:", fundVaultAddress);
  
  // Get share token addresses
  const classAAddress = await fundVault.classA();
  const classBAddress = await fundVault.classB();
  
  console.log("  - Class A (MVLP-A):", classAAddress);
  console.log("  - Class B (MVLP-B):", classBAddress);
  
  // Deploy Governance
  console.log("\n📝 Deploying Governance...");
  const GovernanceFactory = new ethers.ContractFactory(
    governanceAbi,
    governanceBytecode,
    wallet
  );
  
  const governance = await GovernanceFactory.deploy(fundVaultAddress);
  await governance.waitForDeployment();
  const governanceAddress = await governance.getAddress();
  
  console.log("✅ Governance deployed:", governanceAddress);
  
  // Save deployment info
  const deployment = {
    network: "ethereum-sepolia",
    timestamp: new Date().toISOString(),
    deployer: wallet.address,
    contracts: {
      FundVault: fundVaultAddress,
      Governance: governanceAddress,
      ClassA: classAAddress,
      ClassB: classBAddress,
      USDC: USDC_SEPOLIA
    }
  };
  
  fs.mkdirSync("deployments", { recursive: true });
  fs.writeFileSync(
    "deployments/ethereum-sepolia.json",
    JSON.stringify(deployment, null, 2)
  );
  
  console.log("\n📄 Deployment info saved to deployments/ethereum-sepolia.json");
  
  console.log("\n✅ Deployment complete!");
  console.log("\n📋 Next steps:");
  console.log("1. Verify contracts on Etherscan");
  console.log("2. Get testnet USDC from faucet");
  console.log("3. Test deposit flow");
  console.log("\n🔗 Etherscan:");
  console.log("- FundVault:", `https://sepolia.etherscan.io/address/${fundVaultAddress}`);
  console.log("- Governance:", `https://sepolia.etherscan.io/address/${governanceAddress}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Deployment failed:", error);
    process.exit(1);
  });
