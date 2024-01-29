// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface TimeToken {
    // Assume there is an ERC-20 time token contract; the following is a simplified interface
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

interface TimeAuditCommittee {
    struct CommitteeMember {
        address memberAddress;
        string url;
    }

    function getCommitteeMember(uint256 index) external view returns (CommitteeMember memory);
}

contract TimeTokenProjectPlatform {
    address public timeAuditCommitteeAddress; // Address of the TimeAuditCommittee contract
    address public timeTokenAddress; // Address of the ERC-20 time token

    struct Project {
        address projectOwner;
        string hash;
        string url;
        uint256 amount;
        bool isApproved;
        uint256 approvalCount; // New field to keep track of approvals
    }

    mapping(address => Project) public projects;

    event ProjectPublished(address projectOwner, string hash, string url, uint256 amount);
    event ProjectDetailsUpdated(address projectOwner, string hash, string url, uint256 amount);
    event ProjectApproved(address projectOwner, string hash, string url, uint256 amount);

    constructor(address _timeAuditCommitteeAddress, address _timeTokenAddress) {
        timeAuditCommitteeAddress = _timeAuditCommitteeAddress;
        timeTokenAddress = _timeTokenAddress;
    }

    // Deposit time token and gain the right to publish a project
    function depositAndPublish(string memory hash, string memory url, uint256 amount) external payable {
        // Use the transfer function of ERC-20 time token to ensure the token is transferred from the caller's account to the contract
        TimeToken timeToken = TimeToken(timeTokenAddress);
        require(timeToken.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        // Publish the project
        projects[msg.sender] = Project({
            projectOwner: msg.sender,
            hash: hash,
            url: url,
            amount: amount,
            isApproved: false,
            approvalCount: 0 // Initialize approval count to zero
        });

        // Emit the event
        emit ProjectPublished(msg.sender, hash, url, amount);
    }

    // Update project details, only allowed by the project owner
    function updateProjectDetails(string memory hash, string memory url) external {
        require(msg.sender == projects[msg.sender].projectOwner, "Caller is not the project owner");

        // Update project details
        projects[msg.sender].hash = hash;
        projects[msg.sender].url = url;

        // Emit the event
        emit ProjectDetailsUpdated(msg.sender, hash, url, projects[msg.sender].amount);
    }

    // Get the balance of time token
    function getTimeTokenBalance() external view returns (uint256) {
        TimeToken timeToken = TimeToken(timeTokenAddress);
        return timeToken.balanceOf(address(this));
    }

    // Committee member approves a project
    function approveProject(address projectOwner) external {
        TimeAuditCommittee timeAuditCommittee = TimeAuditCommittee(timeAuditCommitteeAddress);

        Project storage project = projects[projectOwner];
        require(project.projectOwner != address(0), "Project does not exist");
        require(!project.isApproved, "Project has already been approved");

        // Verify if the caller is a committee member
        bool isCommitteeMember = false;
        for (uint256 i = 0; i < 10; i++) {
            TimeAuditCommittee.CommitteeMember memory committeeMember = timeAuditCommittee.getCommitteeMember(i);
            if (committeeMember.memberAddress == msg.sender) {
                isCommitteeMember = true;
                break;
            }
        }
        require(isCommitteeMember, "Caller is not a committee member");

        // Increase the approval count for the project
        project.approvalCount++;

        // Check if the project should be approved (at least 7 approvals)
        if (project.approvalCount > 6) {
            project.isApproved = true;

            // Emit the event
            emit ProjectApproved(projectOwner, project.hash, project.url, project.amount);
        }
    }
}
