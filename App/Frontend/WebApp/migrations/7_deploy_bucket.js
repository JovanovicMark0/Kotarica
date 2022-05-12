const BucketContract = artifacts.require("BucketContract");

module.exports = function (deployer) {
  deployer.deploy(BucketContract);
};
