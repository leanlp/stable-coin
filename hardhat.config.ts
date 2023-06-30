// require("@nomicfoundation/hardhat-toolbox");
// require('@typechain/hardhat')
// require('@nomicfoundation/hardhat-ethers')
// require('@nomicfoundation/hardhat-chai-matchers')
import "@nomicfoundation/hardhat-toolbox"
import '@typechain/hardhat'
import '@nomicfoundation/hardhat-ethers'
import '@nomicfoundation/hardhat-chai-matchers'
import { HardhatConfig } from "hardhat/types";

module.exports = {
  solidity: "0.8.17",
  paths: {test: "test"},
  typechain: {
    outDir: 'src/types',
    target: 'ethers-v6',
    alwaysGenerateOverloads: false, // should overloads with full signatures like deposit(uint256) be generated always, even if there are no overloads?
    externalArtifacts: ['externalArtifacts/*.json'], // optional array of glob patterns with external artifacts to process (for example external libs from node_modules)
    dontOverrideCompile: false // defaults to false
  }
};
