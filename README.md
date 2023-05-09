# CryptoPawn - NFT based Lending and Borrowing System

## About
This is a decentralized system for lending and borrowing Non-Fungible Tokens (NFTs) on the Ethereum blockchain using smart contracts. The system consists of five smart contracts:

  - NFTLendingContract:    This contract is used to lend an NFT to a borrower for a specified duration and interest rate.It would hold the NFTs that are available    for lending. Borrowers could use this contract to see which NFTs are available for borrowing and what the interest rate is for each one. Lenders could deposit    their NFTs into this contract to make them available for lending.
  
  - NFTBorrowingContract:  This contract is used to borrow an NFT by providing collateral in the form of Ether. When a borrower wants to borrow an NFT, they would    interact with this smart contract. They would specify which NFT they want to borrow and for how long. The contract would then calculate the interest rate based    on the duration of the loan and the value of the NFT.
  
  - NFTCollateralContract: This contract is used to hold the collateral provided by the borrower.To secure the loan, the borrower would need to deposit collateral    into this contract. The collateral could be in the form of ETH or another ERC-20 token. The amount of collateral required would be based on the value of the      NFT and the duration of the loan.
  
  - NFTInterestContract: This contract is used to calculate and withdraw the interest accrued on the borrowed NFT.This contract would calculate and collect the       interest payments from the borrower. The interest rate would be based on the duration of the loan and would accrue daily.
  
  - Main Contract: This smart contract would connect all of the other contracts and manage the overall flow of the lending process. It would interact with the NFT    Lending Contract to check for available NFTs, the Borrowing Contract to initiate loans, the Collateral Contract to handle collateral deposits, and the Interest     Contract to collect interest payments.
  
Overall, this DeFi protocol would enable lenders to earn passive income by lending their NFTs, while borrowers could use the NFTs for various purposes without having to purchase them outright. The interest rate mechanism would incentivize borrowers to return the NFTs quickly, which would also help ensure that the lenders' NFTs are not tied up for extended periods.

## Getting Started
To use this system, you will need an Ethereum wallet with Ether to provide collateral for borrowing an NFT. You can use any Ethereum wallet that supports interacting with smart contracts, such as MetaMask or MyEtherWallet.

To deploy the smart contracts, you will need to have a development environment set up with the following tools:
* [Node.js](https://nodejs.org/)
* [Truffle](https://truffleframework.com/)
* [Ganache](https://truffleframework.com/ganache/)
* [MetaMask](https://metamask.io/)

## Deploying the Contracts

To deploy the smart contracts to a local development network, follow these steps:

1. Clone the repository and navigate to the project directory:
    - git clone https://github.com/Kumudkohli/CryptoPawn.git
    - cd nft-lending-borrowing
  
2. Install the dependencies:
    - npm install
  
3. Start the Ganache development network:
    - ganache-cli
  
4. Compile and deploy the smart contracts:
    - truffle migrate --reset
 
 ## Running the Tests
To run the test cases for the smart contracts, use the following command:
   - truffle test

## Usage
To use the NFT lending and borrowing system, follow these steps:

1. Deploy the smart contracts to a blockchain network.

2. Mint an NFT and transfer it to the lending contract:
   - lendingContract.mintNFT(borrower, tokenId);
   - lendingContract.transferNFT(lendingContract, collateralContract, tokenId);

3. Lend the NFT to a borrower for a specified duration and interest rate:
   - lendingContract.lendNFT(tokenId, duration, interestRate);
  
4. Borrow the NFT by providing collateral in the form of Ether:
   - borrowingContract.borrowNFT{value: collateralAmount}(tokenId);

5. Use the borrowed NFT as required.

6. Return the NFT and retrieve the collateral:
    - borrowingContract.returnNFT(tokenId);
    
7. Calculate and withdraw the interest accrued on the borrowed NFT:
   - interestContract.calculateInterest(tokenId);
   - interestContract.withdrawInterest(tokenId);
## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
This project is licensed under the MIT License.

# Author

    Kumud Kohli - kumud.kohli01@gmail.com
        Email - kumud.kohli01@gmail.com
        LinkedIn -https://www.linkedin.com/in/kumud-kohli/

# Acknowledgments

    York University - Professor Mahmoud Alkhraishi
    Freecodecamp.org - https://www.youtube.com/watch?v=gyMwXuJrbJQ&t=352s
    Web3University: https://www.web3.university/tracks/create-a-smart-contract/integrate-your-smart-contract-with-a-frontend
    w3schools - https://www.w3schools.com/js/
