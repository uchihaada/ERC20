/** @type import('hardhat/config').HardhatUserConfig */
const { vars } = require("hardhat/config");
require("@nomicfoundation/hardhat-verify");
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-waffle");

const INFURA_API_KEY = "b5b4eb9d774e44178a95adfe30898e23";
const SEPOLIA_PRIVATE_KEY = "9e968f7682f1259f80285d029516452e985ee1bdef320072a3ccffebe2944d81";
const ETHERSCAN_API_KEY = vars.get("ETHERSCAN_API_KEY");
module.exports = {
  solidity: "0.8.20",

  networks: {
    sepolia: {
      url: `https://sepolia.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [`${SEPOLIA_PRIVATE_KEY}`],

    },
  },
  etherscan: {
    apiKey: {
      sepolia: ETHERSCAN_API_KEY,
    },
  },
};
