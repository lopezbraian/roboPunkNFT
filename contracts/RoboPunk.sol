// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RoboPunksNFT is ERC721, Ownable {
    uint256 public mintPrice;
    uint256 public totalSuply;
    uint256 public maxSupply;
    uint256 public maxPerWallet;
    bool public isPublicMintEnabled;
    string internal baseTokenUri;
    address payable public withdrawAddress;
    mapping(address => uint256) public walletMint;

    constructor() payable ERC721("RoboPunks", "RP") {
        mintPrice = 0.02 ether;
        totalSuply = 0;
        maxSupply = 1000;
        maxPerWallet = 3;
    }

    function setIsPublicMintEnabled(bool _isPublicMintEnabled)
        external
        onlyOwner
    {
        isPublicMintEnabled = _isPublicMintEnabled;
    }

    function setBaseTokenUri(string calldata _baseTokenUri) external onlyOwner {
        baseTokenUri = _baseTokenUri;
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(_exists(_tokenId), "Token does not exist!");
        return
            string(
                abi.encodePacked(
                    baseTokenUri,
                    Strings.toString(_tokenId),
                    ".json"
                )
            );
    }

    function withdraw() external onlyOwner {
        (bool success, ) = withdrawAddress.call{value: address(this).balance}(
            ""
        );
        require(success, "Withdraw failed!");
    }

    function mint(uint256 _quantity) public payable {
        require(isPublicMintEnabled, "Public mint is disabled!");
        require(msg.value == _quantity * mintPrice, "Invalid mint price!");
        require(totalSuply + _quantity <= maxSupply, "Max supply reached!");
        require(
            walletMint[msg.sender] + _quantity <= maxPerWallet,
            "Max per wallet reached!"
        );
        for (uint256 i = 0; i < _quantity; i++) {
            uint256 newTokenId = totalSuply + i;
            totalSuply++;
            _safeMint(msg.sender, newTokenId);
        }
    }
}
