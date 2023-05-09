// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NFTLendingContract.sol";

contract NFTBorrowingContract {
    struct BorrowRequest {
        address borrower;
        address lendingContractAddress;
        uint256 tokenId;
        uint256 amount;
        uint256 interest;
        uint256 startDate;
        uint256 endDate;
        bool active;
        bool approved;
        bool returned;
    }

    event NewBorrowRequest(
        address borrower,
        address lendingContractAddress,
        uint256 tokenId,
        uint256 amount,
        uint256 interest,
        uint256 startDate,
        uint256 endDate
    );
    event BorrowRequestApproved(address borrower, address lendingContractAddress, uint256 tokenId, uint256 amount);
    event NFTReturned(address borrower, address lendingContractAddress, uint256 tokenId);

    mapping(uint256 => BorrowRequest) public borrowRequests;
    uint256 public numBorrowRequests;

    function createBorrowRequest(
        address _lendingContractAddress,
        uint256 _tokenId,
        uint256 _amount,
        uint256 _interest,
        uint256 _endDate
    ) public returns (uint256) {
        // Check that the lending contract exists
        require(_lendingContractAddress != address(0), "Invalid lending contract address");

        // Check that the lending contract has the NFT
        NFTLendingContract lendingContract = NFTLendingContract(_lendingContractAddress);
        require(lendingContract.ownerOf(_tokenId) != address(0), "NFT not available for borrowing");

        // Check that the borrower has approved this contract to transfer the NFT
        require(
            lendingContract.getApproved(_tokenId) == address(this),
            "Borrowing contract not authorized to transfer NFT"
        );

        // Check that the borrower has enough collateral to cover the amount plus interest
        require(msg.value >= _amount + _interest, "Insufficient collateral");

        // Create a new borrow request
        uint256 startDate = block.timestamp;
        uint256 borrowRequestId = numBorrowRequests++;
        BorrowRequest storage request = borrowRequests[borrowRequestId];
        request.borrower = msg.sender;
        request.lendingContractAddress = _lendingContractAddress;
        request.tokenId = _tokenId;
        request.amount = _amount;
        request.interest = _interest;
        request.startDate = startDate;
        request.endDate = _endDate;
        request.active = true;
        request.approved = false;
        request.returned = false;

        // Transfer the collateral to the lending contract
        lendingContract.transferCollateral{value: msg.value}();

        // Emit a BorrowRequest event
        emit NewBorrowRequest(
            msg.sender,
            _lendingContractAddress,
            _tokenId,
            _amount,
            _interest,
            startDate,
            _endDate
        );

        return borrowRequestId;
    }

    function approveBorrowRequest(uint256 _borrowRequestId) public {
        // Check that the borrow request exists
        BorrowRequest storage request = borrowRequests[_borrowRequestId];
        require(request.active, "Borrow request not active");

        // Check that the borrower is the owner of the lending contract
        NFTLendingContract lendingContract = NFTLendingContract(request.lendingContractAddress);
        require(lendingContract.ownerOf(request.tokenId) == request.borrower, "Borrower not owner of NFT");

        // Approve the borrow request and transfer the NFT to the borrower
        request.approved = true;
        lendingContract.transferFrom(address(this), request.borrower, request.tokenId);

        // Emit a BorrowRequestApproved event
        emit BorrowRequestApproved(
            request.borrower,
            request.lendingContractAddress,
            request.tokenId,
            request.amount
        );
    }

    function returnNFT(uint256 _borrowRequestId) public {
        // Check that the borrow request exists
        BorrowRequest storage request = borrowRequests[_borrowRequestId];
        require(request.active && request.approved, "Borrow request not approved or not active");

        // Check that the borrower is the owner of the NFT
        NFTLendingContract lendingContract = NFTLendingContract(request.lendingContractAddress);
        require(lendingContract.ownerOf(request.tokenId) == request.borrower, "Borrower not owner of NFT");

        // Calculate the amount to be repaid
        uint256 amountToRepay = request.amount + request.interest;

        // Mark the borrow request as returned and transfer the collateral to the borrower
        request.returned = true;
        payable(request.borrower).transfer(amountToRepay);

        // Emit an NFTReturned event
        emit NFTReturned(request.borrower, request.lendingContractAddress, request.tokenId);
    }
}
