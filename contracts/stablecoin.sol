pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StableCoin is ERC20, Ownable {
    IERC20 public collateralToken;

    uint256 public collateralizationRate = 150; // Over-collateralization rate in percentage

    mapping(address => uint256) public collateral;

    constructor(address _collateralToken) ERC20("StableCoin", "STB") {
        collateralToken = IERC20(_collateralToken);
    }

    function depositCollateral(uint256 collateralAmount) external {
        // Transfer collateral tokens to this contract
        require(
            collateralToken.transferFrom(msg.sender, address(this), collateralAmount),
            "Collateral token transfer failed"
        );

        // Increase the collateral amount for the user
        collateral[msg.sender] += collateralAmount;

        // Calculate how many stablecoins to mint
        uint256 stablecoinAmount = (collateralAmount * 100) / collateralizationRate;

        // Mint the stablecoins to the user
        _mint(msg.sender, stablecoinAmount);
    }

    function withdrawCollateral(uint256 stablecoinAmount) external {
        // Burn the user's stablecoins
        _burn(msg.sender, stablecoinAmount);

        // Calculate how much collateral to return
        uint256 collateralAmount = (stablecoinAmount * collateralizationRate) / 100;

        // Decrease the collateral amount for the user
        collateral[msg.sender] -= collateralAmount;

        // Transfer the collateral tokens back to the user
        require(
            collateralToken.transfer(msg.sender, collateralAmount),
            "Collateral token transfer failed"
        );
    }
}
