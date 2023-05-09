// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import the lending contract interface
import "./NFTLendingContract.sol";

// Import the collateral contract interface
import "./CollateralContract.sol";

contract NFTInterestContract {
    // Address of the lending contract
    address public lendingContract;

    // Mapping to store the start time of each NFT loan
    mapping(address => mapping(uint256 => uint256)) public loanStartTime;

    // Event emitted when interest is charged
    event InterestCharged(address borrower, uint256 tokenId, address tokenContract, uint256 interestAmount);

    constructor(address _lendingContract) {
        lendingContract = _lendingContract;
    }

    // Function to calculate the interest on a loan
    function calculateInterest(address borrower, uint256 tokenId, address tokenContract) public view returns (uint256) {
        // Get the start time of the loan
        uint256 startTime = loanStartTime[tokenContract][tokenId];

        // Check if the loan exists
        require(startTime != 0, "NFTInterestContract: loan does not exist");

        // Calculate the time elapsed since the loan start time
        uint256 timeElapsed = block.timestamp - startTime;

        // Calculate the interest amount based on the time elapsed and the interest rate (10% per year)
        uint256 interestAmount = timeElapsed * 10 * 1e16 / 365 days;

        // Return the interest amount
        return interestAmount;
    }

    // Function to charge interest on a loan
    function chargeInterest(address borrower, uint256 tokenId, address tokenContract) public {
        // Get the interest amount
        uint256 interestAmount = calculateInterest(borrower, tokenId, tokenContract);

        // Check if the interest amount is greater than zero
        require(interestAmount > 0, "NFTInterestContract: no interest to charge");

        // Get the address of the collateral contract
        CollateralContract collateralContract = CollateralContract(INFTLendingContract(lendingContract).collateralContract());

        // Get the collateral balance of the borrower for the NFT token contract
        uint256 collateralBalance = collateralContract.collateral(tokenContract, borrower);

        // Check if the borrower has sufficient collateral to pay the interest
        require(collateralBalance >= interestAmount, "NFTInterestContract: insufficient collateral to pay interest");

        // Transfer the interest amount from the borrower to the interest contract
        collateralContract.addCollateral(tokenContract, interestAmount);
        // Update the loan start time to the current time
        loanStartTime[tokenContract][tokenId] = block.timestamp;

        // Emit the InterestCharged event
        emit InterestCharged(borrower, tokenId, tokenContract, interestAmount);
    }
}
