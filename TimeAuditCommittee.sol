// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; // Import ERC20 interface

contract TimeAuditCommittee {
    address public contractOwner;
    IERC20 public timeToken; // TIME token contract

    struct CommitteeMember {
        address memberAddress;
        string url;
        uint256 timeBalance; // TIME balance
    }

    CommitteeMember[10] public committeeMembers;

    event CommitteeMemberAdded(address memberAddress, string url);

    modifier onlyContractOwner() {
        require(msg.sender == contractOwner, "Only contract owner can perform this action");
        _;
    }

    constructor(address _timeTokenAddress) {
        contractOwner = msg.sender;
        timeToken = IERC20(_timeTokenAddress);
    }

    function updateCommitteeMembers(address[10] memory addresses, string[10] memory urls) external onlyContractOwner {
        require(addresses.length == 10 && urls.length == 10, "Invalid input length");

        for (uint256 i = 0; i < 10; i++) {
            committeeMembers[i] = CommitteeMember({
                memberAddress: addresses[i],
                url: urls[i],
                timeBalance: getTimeBalance(addresses[i])
            });

            emit CommitteeMemberAdded(addresses[i], urls[i]);
        }
    }

    function getCommitteeMember(uint256 index) external view returns (CommitteeMember memory) {
        CommitteeMember memory member = committeeMembers[index];
        member.timeBalance = getTimeBalance(member.memberAddress);
        return member;
    }

    function getTimeBalance(address account) internal view returns (uint256) {
        // Use the balanceOf method of the TIME token contract to get the balance
        return timeToken.balanceOf(account);
    }
}

