# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```


The number of stablecoins minted is the amount of collateral tokens deposited divided by the collateralization rate.

The withdrawCollateral function allows a user to burn stablecoins and receive back their collateral. The amount of collateral returned is the amount of stablecoins burned multiplied by the collateralization rate.

Please note that this is a simplified example and does not include important features that you would need in a production-grade stablecoin, such as:

A mechanism to handle the case where the value of the collateral drops and becomes less than the value of the stablecoins issued (like MakerDAO's liquidation process).
An oracle to get the price of the collateral token in order to adjust the collateralization ratio dynamically.
A governance system to manage parameters like the collateralization ratio.
An interest rate model for borrowers and lenders.
Risk management features such as pausing the contract or adjusting parameters in emergencies.