const GradeContract = artifacts.require("GradeContract");

module.exports = function (deployer) {
  deployer.deploy(GradeContract);
};
