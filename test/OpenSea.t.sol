// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19; 

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {Test} from "forge-std/Test.sol";
import {OpenSea} from "../src/OpenSea.sol";
import {NftToken} from "../src/NftToken.sol";

contract OpenSeaTest is Test {
    OpenSea public market;
    NftToken public token;
    bytes url =
        "https://i0.wp.com/picjumbo.com/wp-content/uploads/beautiful-green-field-scenery-free-photo.jpg?w=600&quality=80";
    address public changeOwner =
        address(0x46FC374d89D8FAb2dcbBACbDbD9Eb620D1A2AA8D);
    uint256 public tokenId;
    uint256 public beforeBalance;

    function setUp() public {
        token = new NftToken();
        market = new OpenSea(address(token));
        tokenId = token.mintNFT(address(this), string(url));
        token.approve(address(market), tokenId);
        deal(address(this), 1 ether);
        market.listNft{value: 3}(tokenId, 1);
        beforeBalance = address(this).balance;
        deal(changeOwner, 20 ether);
        vm.prank(address(market));
        token.approve(changeOwner, tokenId);
    }

    receive() external payable {}


    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }


    function test_DeploymentOwner() public view {
        assertEq(market.owner(), address(this), "Line 23");
    }


    function test_ListingFees() public view {
        assertEq(market.listingFees(), 3, "Line 27");
    }


    function testFuzz_SetListingFeesOwner(uint x) public {
        market.setListingFees(x);
        assertEq(market.listingFees(), x, "Line29");
    }


    function testFuzz_SetListingFeesChangeOwner(uint x) public {
        vm.prank(changeOwner);
        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedAccount.selector,
                changeOwner
            )
        );
        market.setListingFees(x);
    }


    function test_ListNft() public view {
        assertEq(market.getAuthor(tokenId), address(this), "Line42");
        assertEq(token.ownerOf(tokenId), address(market), "Line55");
        assertEq(address(market).balance, 3, "Line56");
    }


    function test_BuyNft() public {
        vm.startPrank(changeOwner);
        assertEq(changeOwner.balance, 20 ether, "Line76");
        market.buyNft{value: 1}(tokenId);
        vm.stopPrank();
        assertEq(changeOwner, token.ownerOf(tokenId), "Line81");
        assertEq(market.getPrice(tokenId), 1, "Line83");
        assertEq(beforeBalance + 1, address(this).balance, "Line88");
    }
}
