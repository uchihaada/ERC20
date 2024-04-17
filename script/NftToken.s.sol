// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/NftToken.sol";

contract MyScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        NftToken nft = new NftToken();
        vm.stopBroadcast();
    }
}

//  0xF1ECA900b8Bb3182307D2F3B9e7d4Be610182ba7

//  https://sepolia.etherscan.io/address/0xf1eca900b8bb3182307d2f3b9e7d4be610182ba7