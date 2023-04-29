require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */

module.exports = {
  solidity: "0.8.9",
  networks: {
    goerli: {
      url: "https://eth-goerli.g.alchemy.com/v2/A39keG-qm_w5PORbL47Ld8SsS9PZs_77",
      accounts: [
        "7d03b3075faf80c40116d59e428eca7e00e5e3618c7799f7a69232aea2c702f2",
      ],
    },
  },
};
