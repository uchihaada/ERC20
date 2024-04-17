// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/OpenSea.sol";

contract OpenScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address nft = address(0xF1ECA900b8Bb3182307D2F3B9e7d4Be610182ba7);
        vm.startBroadcast(deployerPrivateKey);
        OpenSea market = new OpenSea(nft);
        vm.stopBroadcast();
    }
}


//  0x3e9e81b267A3978f299A29aeA0325Fa48303B0F2

//  https://sepolia.etherscan.io/address/0x3e9e81b267a3978f299a29aea0325fa48303b0f2