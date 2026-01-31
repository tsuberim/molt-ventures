// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title FundVault
 * @notice Core vault contract for Moltbook Ventures Fund 0
 * @dev Manages LP positions, USDC deposits, and profit distributions
 */
contract FundVault is ERC20, Ownable, ReentrancyGuard {
    IERC20 public immutable usdc;
    
    uint256 public constant MANAGEMENT_FEE_BPS = 200; // 2% annual
    uint256 public constant CARRY_BPS = 2000; // 20%
    uint256 public constant SECONDS_PER_YEAR = 365 days;
    
    uint256 public lastFeeCollection;
    uint256 public totalReturns;
    uint256 public totalDistributed;
    
    mapping(address => uint256) public lpClaims; // Unclaimed distributions per LP
    
    event Deposited(address indexed lp, uint256 usdcAmount, uint256 sharesIssued);
    event InvestmentExecuted(uint256 indexed proposalId, address target, uint256 amount);
    event ReturnRecorded(uint256 indexed investmentId, uint256 returnAmount);
    event DistributionClaimed(address indexed lp, uint256 amount);
    event ManagementFeeCollected(uint256 amount);
    
    constructor(address _usdc) ERC20("Moltbook Ventures LP", "MVLP") {
        usdc = IERC20(_usdc);
        lastFeeCollection = block.timestamp;
    }
    
    /**
     * @notice Deposit USDC to receive LP tokens
     * @param amount USDC amount to deposit
     */
    function deposit(uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be > 0");
        
        uint256 totalUSDC = usdc.balanceOf(address(this));
        uint256 totalShares = totalSupply();
        
        uint256 sharesToMint;
        if (totalShares == 0) {
            sharesToMint = amount; // 1:1 for first deposit
        } else {
            sharesToMint = (amount * totalShares) / totalUSDC;
        }
        
        require(usdc.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        _mint(msg.sender, sharesToMint);
        
        emit Deposited(msg.sender, amount, sharesToMint);
    }
    
    /**
     * @notice Execute an approved investment
     * @param target Company wallet address
     * @param amount USDC to invest
     * @param proposalId Registry proposal ID
     */
    function executeInvestment(
        address target,
        uint256 amount,
        uint256 proposalId
    ) external onlyOwner nonReentrant {
        require(usdc.balanceOf(address(this)) >= amount, "Insufficient balance");
        require(usdc.transfer(target, amount), "Transfer failed");
        
        emit InvestmentExecuted(proposalId, target, amount);
    }
    
    /**
     * @notice Record returns from an exit
     * @param investmentId Investment identifier
     * @param returnAmount USDC returned
     */
    function recordReturn(
        uint256 investmentId,
        uint256 returnAmount
    ) external onlyOwner {
        totalReturns += returnAmount;
        
        // Calculate carry
        uint256 carry = (returnAmount * CARRY_BPS) / 10000;
        uint256 lpReturn = returnAmount - carry;
        
        // Distribute proportionally to all LPs
        uint256 totalShares = totalSupply();
        uint256 returnPerShare = (lpReturn * 1e18) / totalShares;
        
        // Track unclaimed distributions
        // (In production, use a merkle tree or similar for gas efficiency)
        
        emit ReturnRecorded(investmentId, returnAmount);
    }
    
    /**
     * @notice Collect management fee (2% annual)
     */
    function collectManagementFee() external onlyOwner {
        uint256 timeElapsed = block.timestamp - lastFeeCollection;
        uint256 aum = usdc.balanceOf(address(this));
        
        uint256 feeAmount = (aum * MANAGEMENT_FEE_BPS * timeElapsed) / (10000 * SECONDS_PER_YEAR);
        
        if (feeAmount > 0) {
            require(usdc.transfer(owner(), feeAmount), "Fee transfer failed");
            lastFeeCollection = block.timestamp;
            emit ManagementFeeCollected(feeAmount);
        }
    }
    
    /**
     * @notice Get current share value in USDC
     * @return USDC value per share (18 decimals)
     */
    function shareValue() external view returns (uint256) {
        uint256 totalShares = totalSupply();
        if (totalShares == 0) return 1e18; // 1:1 initially
        
        uint256 totalUSDC = usdc.balanceOf(address(this));
        return (totalUSDC * 1e18) / totalShares;
    }
}
