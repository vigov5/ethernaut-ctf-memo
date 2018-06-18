pragma solidity ^0.4.23;

// A Locked Name Registrar
contract Locked {

    bool public unlocked = false;  // registrar locked, no name updates

    struct NameRecord { // map hashes to addresses
        bytes32 name; //
        address mappedAddress;
    }

    mapping(address => NameRecord) public registeredNameRecord; // records who registered names
    mapping(bytes32 => address) public resolve; // resolves hashes to addresses

    function register(bytes32 _name, address _mappedAddress) public {
        // set up the new NameRecord
        NameRecord newRecord;
        newRecord.name = _name;
        newRecord.mappedAddress = _mappedAddress;

        resolve[_name] = _mappedAddress;
        registeredNameRecord[msg.sender] = newRecord;

        require(unlocked); // only allow registrations if contract is unlocked
    }
}
/*

https://medium.com/loom-network/ethereum-solidity-memory-vs-storage-how-to-initialize-an-array-inside-a-struct-184baf6aa2eb

https://stackoverflow.com/questions/33839154/in-ethereum-solidity-what-is-the-purpose-of-the-memory-keyword/33839164#33839164

https://ethfiddle.com/Yn6fLiAjto


contract.register("0x1262126212621262126212621262126212621262126212621262126212621262", "0x396a91cf013970961abcedc1e3310323b0586460")

web3.eth.getStorageAt("0xf25186b5081ff5ce73482ad761db0eb0d25abfbf", 0, function(x, y) {console.log(y)})
=> 0x000000000000000000000000396a91cf013970961abcedc1e3310323b0586460

0x12621262126212621262126212621262126212621262126212621262126212621262126212621262126212621262126212621262126212621262126212621262
0x1262126212621262126212621262126212621262126212621262126212621262
0x1262126212621262126212621262126212621262126212621262126212621262
0x396a91cf013970961abcedc1e3310323b0586460
0x1262126212621262126212621262126212621262126212621262126212621262
0x000000000000000000000000396a91cf013970961abcedc1e3310323b0586460000000000000000000000000396a91cf013970961abcedc1e3310323b0586460
0x00000000000000000000000000000000000000000000000000000000000000001262126212621262126212621262126212621262126212621262126212621262
0x1262126212621262126212621262126212621262
*/
