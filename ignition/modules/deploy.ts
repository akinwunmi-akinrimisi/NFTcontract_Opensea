import { ethers } from "hardhat";

async function main() {
  // // Get the deployer's address
  // const [deployer] = await ethers.getSigners();

  // console.log("Deploying contracts with the account:", deployer.address);

  // // Deploying the NFTMint contract
  // const NFTMintFactory = await ethers.getContractFactory("NFTMint");


  // Deploy the MintingNFT contract
  const MintingNFT = await ethers.getContractFactory("NFTMint");
  const mintingNFT = await MintingNFT.deploy("AKinola", "AK", 1000, "https://ipfs.io/ipfs/QmSkMJJ9pTi2yUkSpTPRBpzV2opFiqsmpQQBXo8d3TqJvX", 3); // Deploy the contract
  await mintingNFT.deploymentTransaction(); // Wait for the contract deployment to be mined
  console.log("MintingNFT deployed to:", mintingNFT.target); // Use `target` to access the contract address

  // Parameters for deployment
  // const nftName = "AKinola"; // Set NFT name
  // const nftSymbol = "AK"; // Set NFT symbol
  // const maxSupply = 1000; // Set max supply
  // const baseURI = "https://ipfs.io/ipfs/QmSkMJJ9pTi2yUkSpTPRBpzV2opFiqsmpQQBXo8d3TqJvX"; // Replace with your base URI
  // const mintingPeriodInWeeks = 3; // Set minting period (e.g., 3 weeks)

  // Deploy the contract with constructor arguments
  // const nftMint = await NFTMintFactory.deploy(nftName, nftSymbol, maxSupply, baseURI, mintingPeriodInWeeks) as any;


  // Wait until the contract is deployed
  // const deploymentReceipt = await nftMint.deployTransaction.wait();

  // console.log("Contract deployed in block:", deploymentReceipt.blockNumber);


  // console.log("NFTMint deployed to:", nftMint.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
  });



