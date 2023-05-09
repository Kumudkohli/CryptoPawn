// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import the NFT lending contract interface
import "./NFTLendingContract.sol";

// Import the NFT borrowing contract interface
import "./NFTBorrowingContract.sol";

// Import the NFT collateral contract interface
import "./CollateralContract.sol";

// Import the NFT interest contract interface
import "./NFTInterestContract.sol";

contract MainContract {
    // Address of the NFT lending contract
    address public lendingContract;

    // Address of the NFT borrowing contract
    address public borrowingContract;

    // Address of the NFT collateral contract
    address public collateralContract;

    // Address of the NFT interest contract
    address public interestContract;

    constructor() {
        // Create a new instance of the NFT collateral contract
        CollateralContract _collateralContract = new CollateralContract();
        collateralContract = address(_collateralContract);

        // Create a new instance of the NFT lending contract
        NFTLendingContract _lendingContract = new NFTLendingContract(collateralContract);
        lendingContract = address(_lendingContract);

        // Create a new instance of the NFT borrowing contract
        NFTBorrowingContract _borrowingContract = new NFTBorrowingContract(lendingContract);
        borrowingContract = address(_borrowingContract);

        // Create a new instance of the NFT interest contract
        NFTInterestContract _interestContract = new NFTInterestContract(lendingContract);
        interestContract = address(_interestContract);
    }
}
