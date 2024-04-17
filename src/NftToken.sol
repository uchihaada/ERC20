// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 < 0.9.0; 

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NftToken is ERC721URIStorage {
    uint256 private _nextTokenId;

    constructor() ERC721("abhijit", "ADA") {}

    function mintNFT(
        address recipient,
        string memory tokenURI
    ) public returns (uint256) {
        uint256 tokenId = _nextTokenId++;
        _safeMint(recipient, tokenId);
        _setTokenURI(tokenId, tokenURI);
        return tokenId;
    }
}
