const NFTLendingContract = artifacts.require("NFTLendingContract");
const NFTBorrowingContract = artifacts.require("NFTBorrowingContract");

contract("NFTLendingContract and NFTBorrowingContract", async accounts => {
  it("should allow lending an NFT and borrowing it back", async () => {
    const lendingContract = await NFTLendingContract.new("My NFT", "MNFT", { from: accounts[0] });
    const borrowingContract = await NFTBorrowingContract.new({ from: accounts[1] });

    // Lend an NFT to the lending contract
    const tokenId = 1;
    await lendingContract.mintNFT(accounts[0], tokenId);
    await lendingContract.approve(borrowingContract.address, tokenId);
    await lendingContract.lendNFT(tokenId, web3.utils.toWei("1"), { from: accounts[0] });

    // Borrow the NFT from the borrowing contract
    await borrowingContract.createBorrowRequest(lendingContract.address, tokenId, web3.utils.toWei("0.5"), 0, 0, { value: web3.utils.toWei("1.5"), from: accounts[1] });
    const borrowRequestId = 0;
    await borrowingContract.approveBorrowRequest(borrowRequestId, { from: accounts[0] });

    // Return the NFT to the lending contract
    await lendingContract.returnNFT(tokenId, { from: accounts[1] });

    // Check that the borrower now owns the NFT
    const owner = await lendingContract.ownerOf(tokenId);
    assert.equal(owner, accounts[1], "Borrower does not own NFT");
  });

  it("should not allow borrowing an NFT that is not available", async () => {
    const lendingContract = await NFTLendingContract.new("My NFT", "MNFT", { from: accounts[0] });
    const borrowingContract = await NFTBorrowingContract.new({ from: accounts[1] });

    // Try to borrow an NFT that doesn't exist
    const tokenId = 1;
    await borrowingContract.createBorrowRequest(lendingContract.address, tokenId, web3.utils.toWei("0.5"), 0, 0, { value: web3.utils.toWei("1"), from: accounts[1] });
    const borrowRequestId = 0;
    try {
      await borrowingContract.approveBorrowRequest(borrowRequestId, { from: accounts[0] });
    } catch (error) {
      assert.equal(error.reason, "NFT not available for borrowing", "Incorrect error message");
    }
  });

  it("should not allow borrowing an NFT without sufficient collateral", async () => 
  {
        const lendingContract = await NFTLendingContract.new("My NFT", "MNFT", { from: accounts[0] });
        const borrowingContract = await NFTBorrowingContract.new({ from: accounts[1] });

        // Lend an NFT to the lending contract
        const tokenId = 1;
        await lendingContract.mintNFT(accounts[0], tokenId);
        await lendingContract.approve(borrowingContract.address, tokenId);
        await lendingContract.lendNFT(tokenId, web3.utils.toWei("1"), { from: accounts[0] });

        // Try to borrow the NFT without enough collateral
        await borrowingContract.createBorrowRequest(lendingContract.address, tokenId, web3.utils.toWei("0.5"), 0, 0, { value: web3.utils.toWei("0.5"), from: accounts[1] });
        const borrowRequestId = 0;
        try {
            await borrowingContract.approveBorrowRequest(borrowRequestId, { from: accounts[0] });
        } catch (error) {
            assert.equal(error.reason, "Insufficient collateral", "Incorrect error message");
        }
    });

    it("should not allow borrowing an NFT with insufficient time left", async () => {
        const lendingContract = await NFTLendingContract.new("My NFT", "MNFT", { from: accounts[0] });
        const borrowingContract = await NFTBorrowingContract.new({ from: accounts[1] });

        // Lend an NFT to the lending contract
        const tokenId = 1;
        await lendingContract.mintNFT(accounts[0], tokenId);
        await lendingContract.approve(borrowingContract.address, tokenId);
        await lendingContract.lendNFT(tokenId, web3.utils.toWei("1"), { from: accounts[0] });

        // Borrow the NFT from the borrowing contract
        await borrowingContract.createBorrowRequest(lendingContract.address, tokenId, web3.utils.toWei("0.5"), 0, 1, { value: web3.utils.toWei("1"), from: accounts[1] });
        const borrowRequestId = 0;
        await borrowingContract.approveBorrowRequest(borrowRequestId, { from: accounts[0] });

        // Wait for the borrowing time to expire
        await new Promise(resolve => setTimeout(resolve, 1000));

        // Try to return the NFT after the borrowing time has expired
        try {
            await lendingContract.returnNFT(tokenId, { from: accounts[1] });
        } catch (error) {
            assert.equal(error.reason, "Borrowing time has expired", "Incorrect error message");
        }
    });
});




