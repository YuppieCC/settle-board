const Settle = artifacts.require("Settle");
const currency = "0xe19B95fB3bDE006E436c7C83DCb8018D55671490";

module.exports = function (deployer) {
  deployer.deploy(Settle, currency);
};
