require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config({ path: ".env" });

// create a .env file in your root folder and replace these values 
// with your own to deploy easily.
API_KEY_URL = process.env.API_KEY;
PRIVATE_KEY = process.env.PRIVATE_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
  networks: {
    goerli: {
      url: API_KEY_URL,
      accounts: [PRIVATE_KEY]
    }
  }
};

