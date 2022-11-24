import { ethers } from "ethers";
import myEpicNft from "./utils/MyEpicNFT.json";
import './styles/App.css';
import twitterLogo from './assets/twitter-logo.svg';
import React, {useEffect, useState} from "react";

// Constantsを宣言する: constとは値書き換えを禁止した変数を宣言する方法です。
const TWITTER_HANDLE = 'あなたのTwitterのハンドルネームを貼り付けてください';
const TWITTER_LINK = `https://twitter.com/${TWITTER_HANDLE}`;
const OPENSEA_LINK = '';
const TOTAL_MINT_COUNT = 50;

const App = () => {
  const [currentAccount, setCurrentAccount] = useState("");
  console.log("currentAccount: ", currentAccount);

  const checkIfWalletIsConnected = async() => {
    
    const { ethereum } = window;
    if (!ethereum) {
      console.log("Make sure you have MetaMask!");
      return;
    } else {
      console.log("We have the ethereum object", ethereum);
    }
    
    const accounts = await ethereum.request({ method: "eth_accounts" });

    if (accounts.length !== 0) {
      const account = accounts[0];
      console.log("Found an authorized account:", account);
      setCurrentAccount(account);
    } else {
      console.log("No authorized account found");
    }
  };

  const connectWallet = async () => {
    try {
      const { ethereum } = window;
      if (!ethereum) {
        alert("Get MetaMask!");
        return;
      }
      /*
       * ウォレットアドレスに対してアクセスをリクエストしています。
       */
      const accounts = await ethereum.request({
        method: "eth_requestAccounts",
      });
      console.log("Connected", accounts[0]);
      /*
       * ウォレットアドレスを currentAccount に紐付けます。
       */
      setCurrentAccount(accounts[0]);
    } catch (error) {
      console.log(error);
    }
  };

  const askContractToMintNft = async () => {
    const CONTRACT_ADDRESS = "0x3732b2fdC54561cf04362880a87DFEe0b33dC780"
    try {
      const { ethereum } = window;
      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const connectedContract = new ethers.Contract(
          CONTRACT_ADDRESS,
          myEpicNft.abi,
          signer
        );
        console.log("Going to pop wallet now to pay gas...");
        let nftTxn = await connectedContract.makeAnEpicNFT();
        console.log("Mining...please wait.");
        await nftTxn.wait();

        console.log(`Mined, see transaction: https://goerli.etherscan.io/tx/${nftTxn.hash}`);
      } else {
        console.log("Ethereum object dosn't exist!");
      }
    } catch (error) {
      console.log(error);
    }
  };

  const renderNotConnectedContainer = () => (
    <button onClick={connectWallet} className="cta-button connect-wallet-button">
      Connect to Wallet
    </button>
  );

  useEffect(() => {
    checkIfWalletIsConnected();
  }, []);

  return (
    <div className="App">
      <div className="container">
        <div className="header-container">
          <p className="header gradient-text">My NFT Collection</p>
          <p className="sub-text">
            あなただけの特別な NFT を Mint しよう💫
          </p>
          {currentAccount === "" ? (
            renderNotConnectedContainer()
          ) : (
            <button onClick={askContractToMintNft} className="cta-button connect-wallet-button">
              Mint NFT
            </button>
          )}
        </div>
        <div className="footer-container">
          <img alt="Twitter Logo" className="twitter-logo" src={twitterLogo} />
          <a
            className="footer-text"
            href={TWITTER_LINK}
            target="_blank"
            rel="noreferrer"
          >{`built on @${TWITTER_HANDLE}`}</a>
        </div>
      </div>
    </div>
  );
};

export default App;
