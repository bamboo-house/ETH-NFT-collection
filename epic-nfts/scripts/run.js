const main = async () => {
  // artifactsに必要なファイルを追加
  const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
  // Hardhat がローカルの Ethereum ネットワークを作成する
  const nftContract = await nftContractFactory.deploy();
  // コントラクトが Mint され、ローカルのブロックチェーンにデプロイされるまで待つ
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);

  // makeAnEpicNFT 関数を呼び出す。NFTがMintされる。
  let txn = await nftContract.makeAnEpicNFT();
  // Minting が仮想マイナーにより、承認されるのを待つ。
  await txn.wait();
  // makeAnEpicNFT 関数をもう一度呼び出す。NFTがまたMintされる。
  txn = await nftContract.makeAnEpicNFT();
  // Minting が仮想マイナーにより、承認されるのを待つ。
  await txn.wait();
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