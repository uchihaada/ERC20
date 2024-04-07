// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract OpenSeaMarket is IERC721Receiver {
    IERC721 public nftContract;
    uint256 public listingFees;
    address public owner;

    constructor(address _nftContract, uint256 _listingFees) {
        owner = msg.sender;
        nftContract = IERC721(_nftContract);
        listingFees = _listingFees;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this fuction");
        _;
    }

    function setListingFees(uint256 _listingFees) external onlyOwner {
        listingFees = _listingFees;
    }

    mapping(uint256 => address) public author;

    struct listingDetails {
        uint256 tokenId;
        address seller;
        uint256 price;
        bool listed;
    }

    mapping(uint256 => listingDetails) public listings;

    function listNft(
        uint256 _tokenId,
        uint256 _price
    ) external payable returns (bool) {
        require(
            msg.sender == nftContract.ownerOf(_tokenId),
            "You dont have access"
        );
        require(msg.value == listingFees, "Incorrect listing fee");
        require(_price > 0, "Price of the nft cannot be zero");

        if (author[_tokenId] == address(0)) {
            author[_tokenId] = msg.sender;
        }

        listings[_tokenId] = listingDetails({
            tokenId: _tokenId,
            seller: msg.sender,
            price: _price,
            listed: true
        });

        payable(address(this)).transfer(msg.value);

        nftContract.safeTransferFrom(msg.sender, address(this), _tokenId);
        return true;
    }

    function buyNft(uint256 _tokenId) external payable returns (bool) {
        listingDetails storage detail = listings[_tokenId];
        require(detail.listed, "Nft is not for sale!");
        require(msg.value == detail.price, "Wrong Price");

        detail.listed = false;

        payable(detail.seller).transfer(detail.price);

        nftContract.safeTransferFrom(address(this), msg.sender, _tokenId);

        return true;
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {}
}
