const Advertisements = artifacts.require("Advertisements");

module.exports = function (deployer) {
  deployer.deploy(Advertisements);
};
