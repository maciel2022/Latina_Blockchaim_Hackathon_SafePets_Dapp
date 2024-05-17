const TSPContract = artifacts.require("TSPContract");

module.exports = function (deployer) {
    deployer.deploy(TSPContract);
}