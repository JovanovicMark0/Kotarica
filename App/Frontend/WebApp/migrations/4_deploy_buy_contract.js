const BuyContract = artifacts.require("BuyContract");

module.exports = function (deployer) {
  deployer.deploy(BuyContract);
};
