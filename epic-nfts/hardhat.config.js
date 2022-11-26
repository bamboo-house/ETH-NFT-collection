require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: process.env.STAGEING_ALCHEMY_KEY,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
};
