pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract TimeAuditCommittee is ERC20Upgradeable, OwnableUpgradeable, UUPSUpgradeable {
    struct CommitteeMember {
        address memberAddress;
        bytes32 url;
        uint256 timeBalance;
    }

    CommitteeMember[10] public committeeMembers;
    address public upgrader;

    event CommitteeMembersUpdated();

    function initialize(address _timeTokenAddress, address _owner, address _upgrader) initializer public {
        __Ownable_init();
        __UUPSUpgradeable_init();

        _setOwner(_owner);
        timeToken = IERC20(_timeTokenAddress);
        upgrader = _upgrader;
    }

    function setUpgrader(address newUpgrader) external onlyOwner {
        upgrader = newUpgrader;
    }

    function updateCommitteeMembers(address[10] memory addresses, bytes32[10] memory urls) external onlyOwner {
        for (uint256 i = 0; i < 10; i++) {
            committeeMembers[i] = CommitteeMember({
                memberAddress: addresses[i],
                url: urls[i],
                timeBalance: getTimeBalance(addresses[i])
            });
        }

        emit CommitteeMembersUpdated();
    }

    function getCommitteeMember(uint256 index) external view returns (CommitteeMember memory) {
        CommitteeMember memory member = committeeMembers[index];
        member.timeBalance = getTimeBalance(member.memberAddress);
        return member;
    }

    function getTimeBalance(address account) internal view returns (uint256) {
        return timeToken.balanceOf(account);
    }

    function _authorizeUpgrade(address) internal override {
        require(msg.sender == upgrader);
    }
}
