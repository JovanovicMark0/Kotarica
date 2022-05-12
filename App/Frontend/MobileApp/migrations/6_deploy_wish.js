const WishContract = artifacts.require("WishContract");

module.exports = function (deployer) {
  deployer.deploy(WishContract);
};
