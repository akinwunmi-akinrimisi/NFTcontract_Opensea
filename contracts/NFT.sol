// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTMint is ERC721URIStorage {
    uint256 public tokenCounter;   // Keeps track of how many NFTs have been minted
    uint256 public maxSupply;      // The maximum number of NFTs that can be minted
    string public baseTokenURI;    // Base URI for all NFTs
    uint256 public mintingStartTime;
    uint256 public mintingEndTime;

    mapping(address=>bool) public hasMinted;

    constructor(uint256 _maxSupply, string memory _baseTokenURI, uint256 mintingPeriodinHours) ERC721("MyNFT", "MNFT") {
        
        require(mintingPeriodinHours>0, "enter valid duration");
        require(_maxSupply>0, "supply cannot be zero");

        tokenCounter = 0;
        maxSupply = _maxSupply;
        baseTokenURI = _baseTokenURI;  // Set the base URI from constructor
        mintingStartTime = block.timestamp;
        mintingEndTime = mintingStartTime + (mintingPeriodinHours * 1 hours);
    }

    // Mints a new NFT and auto-generates the tokenURI using base URI + tokenCounter
    function mintNFT(address recipient) public {
        require(tokenCounter < maxSupply, "Max supply reached, no more NFTs can be minted");
        require(!hasMinted[recipient], "cannot mint twice");
        require(recipient != address(0), "address zero cannot mint");
        require(block.timestamp > mintingStartTime, "minting yet to start");
        require(block.timestamp < mintingEndTime, "minting ended");

        // Increment the tokenCounter (to track how many NFTs have been minted)
        tokenCounter++;

        // Generate the tokenURI by appending tokenCounter to baseTokenURI
        string memory tokenURI = generateTokenURI(tokenCounter);

        // Mint the NFT using the tokenCounter as the unique on-chain ID
        _safeMint(recipient, tokenCounter);

        // Set the tokenURI (metadata link) for the newly minted token
        _setTokenURI(tokenCounter, tokenURI);

        // marks a user to have minted
        hasMinted[recipient] = true;
    }

    // Function to concatenate the base URI with the token ID
    function generateTokenURI(uint256 tokenId) internal view returns (string memory) {
        return string(abi.encodePacked(baseTokenURI, uint2str(tokenId), ".json"));  // Appends token ID and .json
    }

    // Helper function to convert uint256 to string
    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint256 temp = _i;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (_i != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(_i % 10)));
            _i /= 10;
        }
        return string(buffer);
    }
}
