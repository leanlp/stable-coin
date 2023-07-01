// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "./AggregatorV3Interface.sol";

contract StableCoin is ERC20, Ownable {
    IERC20 public collateralToken;
    AggregatorV3Interface internal priceFeed;

    uint256 public collateralizationRate = 150; // Collateralization rate in percentage

    mapping(address => uint256) public collateral;
    mapping(address => uint256) public debt; // New: track each address's debt

    constructor(address _collateralToken, address _priceFeed) ERC20("StableCoin", "STB") {
        collateralToken = IERC20(_collateralToken);
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function getLatestPrice() public view returns (int) {
        (, int price,,,) = priceFeed.latestRoundData();
        return price;
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
        int latestPrice = getLatestPrice();
        uint256 stablecoinAmount = (collateralAmount * uint256(latestPrice)) / collateralizationRate;

        // Increase the user's debt by the minted amount
        debt[msg.sender] += stablecoinAmount; // New

        // Mint the stablecoins to the user
        _mint(msg.sender, stablecoinAmount);
    }

    function repay(uint256 stablecoinAmount) external { // New function for repaying borrowed stablecoins
        // Burn the user's stablecoins
        _burn(msg.sender, stablecoinAmount);

        // Decrease the user's debt
        debt[msg.sender] -= stablecoinAmount;
    }

    function withdrawCollateral() external {
        // Ensure the user has repaid their debt
        require(debt[msg.sender] == 0, "Debt must be repaid before withdrawing collateral.");

        // Calculate how much collateral to return
        // int latestPrice = getLatestPrice();
        // uint256 collateralAmount = (stablecoinAmount * collateralizationRate) / (uint256(latestPrice));

        // Decrease the collateral amount for the user
        // collateral[msg.sender] -= collateralAmount;
       uint collateralAmount = collateral[msg.sender];

        // Transfer the collateral tokens back to the user
        require(
            collateralToken.transfer(msg.sender, collateralAmount),
            "Collateral token transfer failed"
        );
    }
}