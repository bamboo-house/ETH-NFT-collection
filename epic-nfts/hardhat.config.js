require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: "https://eth-goerli.g.alchemy.com/v2/nFWRmEaPlWel0Nmo8cXP5JQREJf3YGGU",
      accounts: ["c73706c8fdf6b4ffc9c146cc1fb0b5cc941096a1ee0b71c2366409f0b13072c1"],
    },
  },
};
