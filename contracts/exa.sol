import "hardhat/console.sol";

contract exa {
    uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
    mapping(address => bool) name;

    function show() public view returns (uint256) {
        uint256 total;
        unchecked {
            ++total;
        }
        console.log(total);
        console.log(_BITMASK_ADDRESS);
        return _BITMASK_ADDRESS;
    }
}
