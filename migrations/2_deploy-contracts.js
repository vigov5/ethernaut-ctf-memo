var King = artifacts.require("./King.sol");

module.exports = function(deployer) {
    deployer.deploy(King, {value: 1000000000000000000, overwrite: false});
};
