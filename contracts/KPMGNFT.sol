// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Web3Builders is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;

    uint256 public maxSupply = 10000;
    Counters.Counter private _tokenIdCounter;

    uint256[] private allTokens;

    mapping(uint256 => uint256) private _allTokensIndex;

    constructor() ERC721("Web3Builders", "W3B") {
        
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmYMaghmV1rFpZb6FeoNKWdMG9a358axzr4L7oq7eyMbAE/";
    }

    function totalSupply() public view virtual override returns(uint256) {
        return allTokens.length;
    }

    function safeMint() public payable {
        require(msg.value >= 0.01 ether, "Not enough ether");
        require(totalSupply() <= maxSupply, "All the NFTs have been minted");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
    }

    function withdraw(address _addr) external onlyOwner {
        uint256 balance = address (this).balance;
        payable(_addr).transfer(balance);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
    }

}