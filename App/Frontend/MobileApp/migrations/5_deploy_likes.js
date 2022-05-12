const LikesContract = artifacts.require("LikesContract");

module.exports = function (deployer) {
  deployer.deploy(LikesContract);
};
