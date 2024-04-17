// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

//@custom:Importing required contracts from @openzeppelin
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

/// @title  A marketplace for trading ERC721 token (NFT)
/// @author Abhijit Das
///@notice You can tread NFT i.e you can buy and sell it
/// @dev   You have to reference a ERC721 token minting contract
/// @custom:experimental This is an experimental contract.
contract OpenSea is IERC721Receiver, Ownable {
    ///@notice Structure to store the details of any NFT to list
    ///@dev TokenId can be removed from the structure
    struct listingDetails {
        uint256 tokenId;
        address seller;
        uint256 price;
        bool listed;
    }

    ///@notice Referencing the interface of IRC721 contract
    IERC721 public nftContract;

    ///@notice Fees required for listing
    uint256 public listingFees;

    ///@notice Storing address of the first owner of a token
    mapping(uint256 => address) public author;

    ///@notice Mapping to store the listing details of token w.r.t tokenID
    mapping(uint256 => listingDetails) public listings;

    ///@notice Constructor is being initialized with the address of the ERC721 token contract
    ///@param _nftContract Address of ERC721 token contract
    ///@dev listing fees is set
    constructor(address _nftContract) Ownable(msg.sender) {
        nftContract = IERC721(_nftContract);
        listingFees = 3;
    }

    ///@notice Function to set the listing fees
    ///@param _listingFees New listing amount in wei
    function setListingFees(uint256 _listingFees) external onlyOwner {
        listingFees = _listingFees;
    }

    ///@notice Function to handle receive of ERC721 token transfers to this contract
    ///@return IERC721Receiver selector
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    ///@notice Function to get the first owner of the NFT
    ///@param _tokenId Id of the nft
    ///@return Address of the author of the NFT
    function getAuthor(uint _tokenId) public view returns (address) {
        return author[_tokenId];
    }

    ///@notice Function to get the selling price of the NFT
    ///@param _tokenId Id of the NFT
    ///@return Selling price of the NFT
    function getPrice(uint256 _tokenId) public view returns (uint256) {
        listingDetails storage detail = listings[_tokenId];
        return detail.price;
    }

    ///@notice Function to list NFT
    ///@param _tokenId TokenId of the NFT
    ///@param _price Selling price of the NFT
    ///@return True if the listing is successful without reverting
    function listNft(
        uint256 _tokenId,
        uint256 _price
    ) public payable returns (bool) {
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

        nftContract.safeTransferFrom(msg.sender, address(this), _tokenId);
        return true;
    }

    ///@notice Function to buy NFT
    ///@param _tokenId TokenId of the NFT
    ///@return True if the purchase of NFT is successful without reverting
    function buyNft(uint256 _tokenId) public payable returns (bool) {
        listingDetails storage detail = listings[_tokenId];
        require(detail.listed == true, "Nft is not for sale!");
        require(msg.value == detail.price, "Wrong Price");
        detail.listed = false;
        address payable sel = payable(detail.seller);
        sel.transfer(msg.value);
        nftContract.safeTransferFrom(address(this), msg.sender, _tokenId);
        return true;
    }
}
