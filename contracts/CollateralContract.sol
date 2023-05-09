// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Interface for the lending contract
interface INFTLendingContract {
    // Checks if the NFT is available for lending
    function isAvailableForLending(uint256 tokenId, address tokenContract) external view returns (bool);
    // Lends the NFT to the borrower
    function lendNFT(address borrower, uint256 tokenId, address tokenContract) external;
    // Releases the NFT from the lending contract back to the borrower
    function releaseNFT(address borrower, uint256 tokenId, address tokenContract) external;
}

// Interface for the borrowing contract
interface INFTBorrowingContract {
    // Borrows the NFT from the lending contract
    function borrowNFT(uint256 tokenId, address tokenContract, uint256 collateralAmount) external;
}

contract CollateralContract {
    address public lendingContract;
    address public borrowingContract;

    // Mapping to store the collateral balance of each user
    mapping(address => mapping(uint256 => uint256)) public collateral;

    constructor(address _lendingContract, address _borrowingContract) {
        lendingContract = _lendingContract;
        borrowingContract = _borrowingContract;
    }

    // Function to add collateral
    function addCollateral(address token, uint256 amount) external {
        // Transfer the collateral tokens from the user to the collateral contract
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        // Update the collateral balance of the user
        collateral[token][msg.sender] += amount;
    }

    // Function to remove collateral
    function removeCollateral(address token, uint256 amount) external {
        // Check if the user has sufficient collateral balance
        require(collateral[token][msg.sender] >= amount, "CollateralContract: insufficient collateral balance");
        // Update the collateral balance of the user
        collateral[token][msg.sender] -= amount;
        // Transfer the collateral tokens back to the user
        IERC20(token).transfer(msg.sender, amount);
    }

    // Function to borrow NFT
    function borrowNFT(uint256 tokenId, address tokenContract, uint256 collateralAmount) external {
        // Check if the user has sufficient collateral
        require(collateral[tokenContract][msg.sender] >= collateralAmount, "CollateralContract: insufficient collateral");

        // Call the lendNFT function from the lending contract to lend the NFT to the borrower
        INFTLendingContract(lendingContract).lendNFT(msg.sender, tokenId, tokenContract);

        // Call the borrowNFT function from the borrowing contract to borrow the NFT from the lending contract
        INFTBorrowingContract(borrowingContract).borrowNFT(tokenId, tokenContract, collateralAmount);

        // Update the collateral balance of the user
        collateral[tokenContract][msg.sender] -= collateralAmount;
    }

    // Function to return NFT
    function returnNFT(uint256 tokenId, address tokenContract) external {
        // Call the releaseNFT function from the lending contract to release the NFT back to the borrower
        INFTLendingContract(lendingContract).releaseNFT(msg.sender, tokenId, tokenContract);
    }
}
