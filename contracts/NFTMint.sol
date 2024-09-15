// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; // Importing Ownable for owner restriction

contract NFTMint is ERC721URIStorage, Ownable(msg.sender) {
    uint256 public tokenCounter;   // Keeps track of how many NFTs have been minted
    uint256 public maxSupply;      // The maximum number of NFTs that can be minted
    string public baseTokenURI;    // Base URI for all NFTs
    string public NFTsymbol;
    string public NFTname;

    mapping(address => bool) public hasMinted; // Tracks if an address has minted

    uint256 public mintingStartTime;   // Timestamp of when the minting starts
    uint256 public mintingEndTime;     // Timestamp of when the minting ends

    constructor(
        string memory _NFTname,
        string memory _NFTsymbol,
        uint256 _maxSupply, 
        string memory _baseTokenURI, 
        uint256 mintingPeriodInWeeks
    ) 
        ERC721("_NFTname", "_NFTsymbol") {
        
        NFTsymbol = _NFTsymbol;
        NFTname = _NFTname;
        tokenCounter = 0;
        maxSupply = _maxSupply;
        baseTokenURI = _baseTokenURI;  // Set the base URI from constructor

        // Calculate the minting start time and end time based on the current block timestamp
        mintingStartTime = block.timestamp;
        mintingEndTime = mintingStartTime + (mintingPeriodInWeeks * 1 weeks); // Minting ends after the specified number of weeks
    }

    // Mints a new NFT and auto-generates the tokenURI using base URI + tokenCounter
    function mintNFT(address recipient) public {
        require(tokenCounter < maxSupply, "Max supply reached, no more NFTs can be minted");
        require(!hasMinted[recipient], "You have already minted an NFT");
        require(recipient != address(0), "Minting to the zero address is not allowed");
        require(block.timestamp > mintingStartTime, "minting yet to start");
        require(block.timestamp < mintingEndTime, "minting ended");

        // Increment the tokenCounter (to track how many NFTs have been minted)
        tokenCounter++;

        // Generate the tokenURI by appending tokenCounter to baseTokenURI
        string memory tokenURI = generateTokenURI(tokenCounter);

        // Use _safeMint which checks if the recipient is a contract and requires it to handle ERC721 tokens
        _safeMint(recipient, tokenCounter);

        // Set the tokenURI (metadata link) for the newly minted token
        _setTokenURI(tokenCounter, tokenURI);

        // Mark this address as having minted
        hasMinted[recipient] = true;
    }

    // Function to update the max supply (can only be called if 90% of maxSupply is reached)
    function updateMaxSupply(uint256 _newMaxSupply) public onlyOwner {
        require(tokenCounter >= (maxSupply * 9) / 10, "Cannot increase max supply until 90% is minted");
        require(_newMaxSupply > maxSupply, "New max supply must be greater than current max supply");

        // Update the max supply
        maxSupply = _newMaxSupply;
    }

    // Function to concatenate the base URI with the token ID
    function generateTokenURI(uint256 tokenId) internal view returns (string memory) {
        return string(abi.encodePacked(baseTokenURI, uint2str(tokenId), ".json"));  // Appends token ID and .json
    }

    // Helper function to convert uint256 to string for customTokenID (MyNFT + tokenCounter)
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
