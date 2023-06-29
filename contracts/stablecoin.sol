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
        // You will need to adjust this calculation to take into account the decimals of the price feed
        
        int latestPrice = getLatestPrice();
        uint256 stablecoinAmount = (collateralAmount * uint256(latestPrice) * 1e18) / collateralizationRate;

        // Mint the stablecoins to the user
        _mint(msg.sender, stablecoinAmount);
    }

    function withdrawCollateral(uint256 stablecoinAmount) external {
        // Burn the user's stablecoins
        _burn(msg.sender, stablecoinAmount);

        // Calculate how much collateral to return
        int latestPrice = getLatestPrice();
        uint256 collateralAmount = (stablecoinAmount * collateralizationRate) / (uint256(latestPrice) * 1e18);

        // Decrease the collateral amount for the user
        collateral[msg.sender] -= collateralAmount;

        // Transfer the collateral tokens back to the user
        require(
            collateralToken.transfer(msg.sender, collateralAmount),
            "Collateral token transfer failed"
        );
    }
}