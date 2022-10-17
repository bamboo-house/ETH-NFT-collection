const main = async () => {
  // コンパイルし、artifactsディレクトの直下に必要なファイルが生成される
  const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
  // hardhatがローカルのethereumネットワークを作成します
  const nftContract = await nftContractFactory.deploy();
  // コントラクトがMintされ、ローカルのブロックチェーンにデプロイされるまで待ちます。
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);

  let txn = await nftContract.makeAnEpicNFT();
  await txn.wait();
  console.log("Minted NFT #1");
  
  txn = await nftContract.makeAnEpicNFT();
  await txn.wait();
  console.log("Minted NFT #2");
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();