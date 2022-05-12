const NotificationContract = artifacts.require("NotificationContract");

module.exports = function (deployer) {
  deployer.deploy(NotificationContract);
};
