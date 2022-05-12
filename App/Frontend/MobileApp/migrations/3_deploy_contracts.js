const PosterContract = artifacts.require("PosterContract");

module.exports = function (deployer) {
  deployer.deploy(PosterContract);
};
