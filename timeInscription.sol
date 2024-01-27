// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract TimeProject is ERC721, AccessControl {
    struct TimeTucaoData {
        string timeTucao;
        uint256 id;
        uint256 tokenType;
        string tokenURI;
    }

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
    bytes32 public constant BATCH_OPERATOR_ROLE = keccak256("BATCH_OPERATOR_ROLE");

    IERC20 public rewardsToken;
    uint256 public erc20RewardAmount;
    uint256 public tokenCounter;
    uint256 public royaltyFee; // e.g., 10 for 10%
    address payable public royaltyRecipient;

    mapping(uint256 => TimeTucaoData) public timeTucaoData;

    constructor(
        address _rewardsToken,
        uint256 _erc20RewardAmount,
        address payable _royaltyRecipient
    ) ERC721("TimeProject", "TMP") {
        rewardsToken = IERC20(_rewardsToken);
        erc20RewardAmount = _erc20RewardAmount;
        royaltyRecipient = _royaltyRecipient;
        _setupRole(ADMIN_ROLE, _royaltyRecipient);
        _setupRole(OPERATOR_ROLE, msg.sender);
        _setupRole(BATCH_OPERATOR_ROLE, msg.sender);
        tokenCounter = 0;
        royaltyFee = 10; // Set initial royalty fee to 10%
    }

    function createTimeTucaoCollectible(string memory timeTucao, uint256 tokenType, string memory tokenURI) public returns (uint256) {
        uint256 newItemId = tokenCounter;
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        timeTucaoData[newItemId] = TimeTucaoData(timeTucao, newItemId, tokenType, tokenURI);

        require(rewardsToken.transfer(msg.sender, erc20RewardAmount), "ERC20 reward transfer failed");

        tokenCounter += 1;
        return newItemId;
    }

    function setTimeTucao(uint256 tokenId, string memory newTimeTucao) public {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "Caller is not owner nor approved");
        timeTucaoData[tokenId].timeTucao = newTimeTucao;
    }

    function transferWithReward(address to, uint256 tokenId) public {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "Caller is not owner nor approved");
        _transfer(_msgSender(), to, tokenId);
        require(rewardsToken.transfer(to, erc20RewardAmount), "ERC20 reward transfer failed");
    }

    function burnAndClaimReward(uint256 tokenId) public {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "Caller is not owner nor approved");
        _burn(tokenId);
        require(rewardsToken.transfer(_msgSender(), erc20RewardAmount), "ERC20 reward transfer failed");
    }

    function setRoyaltyFee(uint256 newFee) public {
        require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not an admin");
        require(newFee >= 0 && newFee <= 100, "Fee must be between 0 and 100");
        royaltyFee = newFee;
    }

    function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address receiver, uint256 royaltyAmount) {
        return (royaltyRecipient, (_salePrice * royaltyFee) / 100);
    }

    function getTimeTucaoData(uint256 tokenId) public view returns (TimeTucaoData memory) {
        return timeTucaoData[tokenId];
    }

    function batchApprove(address to, uint256[] memory tokenIds) public {
        require(hasRole(BATCH_OPERATOR_ROLE, msg.sender), "Caller is not a batch operator");

        for (uint256 i = 0; i < tokenIds.length; i++) {
            _approve(to, tokenIds[i]);
        }
    }

    function batchBurn(uint256[] memory tokenIds) public {
        require(hasRole(BATCH_OPERATOR_ROLE, msg.sender), "Caller is not a batch operator");

        for (uint256 i = 0; i < tokenIds.length; i++) {
            _burn(tokenIds[i]);
        }
    }
}

