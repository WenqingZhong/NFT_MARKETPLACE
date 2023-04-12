
const Market= artifacts.require("Market");
const NFT = artifacts.require("NFT");

module.exports = function(deployer) {
  deployer.deploy(Market);
  deployer.deploy(NFT);
};
