// MyEpicNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract MyEpicNFT is ERC721URIStorage {

  // OpenZeppelin が tokenIds を簡単に追跡するために提供するライブラリを呼び出しています
  using Counters for Counters.Counter;

  // _tokenIdsを初期化(_tokenIds = 0)
  Counters.Counter private _tokenIds;

  // SVGコードを作成します。
  // 変更されるのは、表示される単語だけです。
  // すべてのNFTにSVGコードを適用するために、baseSvg変数を作成します。
  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  // 3つの配列 string[]に、それぞれランダムな単語を設定しましょう。
  string[] firstWords = ["apple", "trune", "nasi", "osusi", "sample", "edit"];
  string[] secondWords = ["thinkpad", "ammazon", "facebook", "twitter", "instagram", "tiktok"];
  string[] thirdWords = ["asana", "slack", "notion", "web3", "blockchain", "ethereum"];

  // NFT トークンの名前とそのシンボルを渡します。
  constructor() ERC721 ("SquareNFT", "SQUARE") {
    console.log("This is my NFT contract.");
  }

  // シードを作成する関数を作成します。
  function random(string memory input) internal pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(input)));
  }

  // 各配列からランダムに単語を選ぶ関数を3つ作成します
  // pickRandomFirstWord関数は、最初の単語を選びます。
  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    
    // pickRandomFirstWord 関数のシードとなるrandを作成します
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));

    console.log("rand seed: ", rand);

    // firstWords配列の長さを基準に、rand番目の単語を選びます。
    rand = rand % firstWords.length;

    // firstWords配列から何番目の単語が選ばれるかターミナルに出力する。
    console.log("rand first word: ", rand);
    return firstWords[rand];
  }

  // pickRandomSecondWord関数は、2番目に表示される単語を選びます。
  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  // ユーザーがNFTを取得するために実行する関数です。
  function makeAnEpicNFT() public {
    
    // 現在のtokenIdを取得します。tokenIdは0から始まります。
    uint256 newItemId = _tokenIds.current();

    // 3つの配列からそれぞれ1つの単語をランダムに取り出します。
    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);

    // 3つの単語を連結して、<text>タグと<svg>タグで閉じます。
    string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));

    // NFTに出力されるテキストをターミナルに出力します。
    console.log("\n-------------------");
    console.log(finalSvg);
    console.log("-------------------\n");

    // msg.sender を使って NFT を送信車に Mint します。
    _safeMint(msg.sender, newItemId);

    // NFT データを設定します。
    _setTokenURI(newItemId, "data:application/json;base64,ewogICJuYW1lIjogIkVwaWNOZnRDcmVhdG9yIiwKICAiZGVzY3JpcHRpb24iOiAiVGhlIGhpZ2hseSBhY2NsYWltZWQgc3F1YXJlIGNvbGxlY3Rpb24iLAogICJpbWFnZSI6ICJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJad29nSUhodGJHNXpQU0pvZEhSd09pOHZkM2QzTG5jekxtOXlaeTh5TURBd0wzTjJaeUlLSUNCd2NtVnpaWEoyWlVGemNHVmpkRkpoZEdsdlBTSjRUV2x1V1UxcGJpQnRaV1YwSWdvZ0lIWnBaWGRDYjNnOUlqQWdNQ0F6TlRBZ016VXdJZ28rQ2lBZ1BITjBlV3hsUGdvZ0lDQWdMbUpoYzJVZ2V3b2dJQ0FnSUNCbWFXeHNPaUIzYUdsMFpUc0tJQ0FnSUNBZ1ptOXVkQzFtWVcxcGJIazZJSE5sY21sbU93b2dJQ0FnSUNCbWIyNTBMWE5wZW1VNklERTBjSGc3Q2lBZ0lDQjlDaUFnUEM5emRIbHNaVDRLSUNBOGNtVmpkQ0IzYVdSMGFEMGlNVEF3SlNJZ2FHVnBaMmgwUFNJeE1EQWxJaUJtYVd4c1BTSmliR0ZqYXlJZ0x6NEtJQ0E4ZEdWNGRBb2dJQ0FnZUQwaU5UQWxJZ29nSUNBZ2VUMGlOVEFsSWdvZ0lDQWdZMnhoYzNNOUltSmhjMlVpQ2lBZ0lDQmtiMjFwYm1GdWRDMWlZWE5sYkdsdVpUMGliV2xrWkd4bElnb2dJQ0FnZEdWNGRDMWhibU5vYjNJOUltMXBaR1JzWlNJS0lDQStDaUFnSUNCRmNHbGpUbVowY21WaGRHOXlDaUFnUEM5MFpYaDBQZ284TDNOMlp6ND0KfQ==");

    // NFTがいつ誰に作成されたかを確認します。
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    // 次のNFTがMintされる時のカウンターをインクリメントする。
    _tokenIds.increment();
  }
}