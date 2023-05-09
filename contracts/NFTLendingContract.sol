// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Define interface for the NFT lending contract
interface INFTLendingContract {
    function isAvailableForLending(uint256 tokenId, address tokenContract) external view returns (bool);
    function borrowNFT(uint256 tokenId, address tokenContract, uint256 collateralAmount) external;
}

// Define the NFT borrowing contract
contract NFTBorrowingContract {
    // Declare a variable to hold the NFT lending contract address
    INFTLendingContract public nftLendingContract;

    // Constructor to initialize the NFT lending contract address
    constructor(address _nftLendingContract) {
        nftLendingContract = INFTLendingContract(_nftLendingContract);
    }

    // Function to borrow an NFT
    function borrowNFT(uint256 tokenId, address tokenContract, uint256 collateralAmount) external {
        // Check if the NFT is available for lending
        require(nftLendingContract.isAvailableForLending(tokenId, tokenContract), "NFTBorrowingContract: NFT is not available for lending");

        // Call the borrowNFT function on the NFT lending contract
        nftLendingContract.borrowNFT(tokenId, tokenContract, collateralAmount);

        // Transfer the borrowed NFT to the borrower
        require(IERC721(tokenContract).transfer(msg.sender, tokenId), "NFTBorrowingContract: NFT transfer failed");
    }
}

