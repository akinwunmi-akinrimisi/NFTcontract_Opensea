// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTMint is ERC721URIStorage {
    uint256 public tokenCounter;   // Keeps track of how many NFTs have been minted
    uint256 public maxSupply;      // The maximum number of NFTs that can be minted

    constructor(uint256 _maxSupply) ERC721("MyNFT", "MNFT") {
        tokenCounter = 0;
        maxSupply = _maxSupply;
    }

    // Mints a new NFT and uses the tokenCounter as the unique ID
    function mintNFT(address recipient, string memory tokenURI) public {
        require(tokenCounter < maxSupply, "Max supply reached, no more NFTs can be minted");

        // Increment the tokenCounter (to track how many NFTs have been minted)
        tokenCounter++;

        // Mint the NFT using the tokenCounter as the unique on-chain ID
        _safeMint(recipient, tokenCounter);

        // Set the tokenURI (metadata link) for the newly minted token
        _setTokenURI(tokenCounter, tokenURI);
    }
}
