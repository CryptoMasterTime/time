// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface TimeToken {
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
    address public timeAuditCommitteeAddress;
    address public timeTokenAddress;

    struct Project {
        address projectOwner;
        string hash;
        string url;
        uint256 amount;
        bool isApproved;
        uint256 approvalCount;
        address projectContractor;
        bool isContractAccepted;
        uint256 pledgeAmount;
        uint256 fundsAllocationCount;
    }

    mapping(address => Project) public projects;

    event ProjectPublished(address projectOwner, string hash, string url, uint256 amount);
    event ProjectDetailsUpdated(address projectOwner, string hash, string url, uint256 amount);
    event ProjectApproved(address projectOwner, string hash, string url, uint256 amount);
    event ProjectContractAccepted(address projectContractor, string hash, string url, uint256 amount, uint256 pledgeAmount);
    event FundsAllocated(address projectContractor, uint256 allocationAmount);

    constructor(address _timeAuditCommitteeAddress, address _timeTokenAddress) {
        timeAuditCommitteeAddress = _timeAuditCommitteeAddress;
        timeTokenAddress = _timeTokenAddress;
    }

    function depositAndPublish(string memory hash, string memory url, uint256 amount) external payable {
        TimeToken timeToken = TimeToken(timeTokenAddress);
        require(timeToken.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        projects[msg.sender] = Project({
            projectOwner: msg.sender,
            hash: hash,
            url: url,
            amount: amount,
            isApproved: false,
            approvalCount: 0,
            projectContractor: address(0),
            isContractAccepted: false,
            pledgeAmount: 0,
            fundsAllocationCount: 0
        });

        emit ProjectPublished(msg.sender, hash, url, amount);
    }

    function updateProjectDetails(string memory hash, string memory url) external {
        require(msg.sender == projects[msg.sender].projectOwner, "Caller is not the project owner");

        projects[msg.sender].hash = hash;
        projects[msg.sender].url = url;

        emit ProjectDetailsUpdated(msg.sender, hash, url, projects[msg.sender].amount);
    }

    function getTimeTokenBalance() external view returns (uint256) {
        TimeToken timeToken = TimeToken(timeTokenAddress);
        return timeToken.balanceOf(address(this));
    }

    function approveProject(address projectOwner) external {
        TimeAuditCommittee timeAuditCommittee = TimeAuditCommittee(timeAuditCommitteeAddress);

        Project storage project = projects[projectOwner];
        require(project.projectOwner != address(0), "Project does not exist");
        require(!project.isApproved, "Project has already been approved");

        bool isCommitteeMember = false;
        for (uint256 i = 0; i < 10; i++) {
            TimeAuditCommittee.CommitteeMember memory committeeMember = timeAuditCommittee.getCommitteeMember(i);
            if (committeeMember.memberAddress == msg.sender) {
                isCommitteeMember = true;
                break;
            }
        }
        require(isCommitteeMember, "Caller is not a committee member");

        project.approvalCount++;

        if (project.approvalCount > 6) {
            project.isApproved = true;

            emit ProjectApproved(projectOwner, project.hash, project.url, project.amount);
        }
    }

    function acceptProject(address projectOwner, uint256 pledgeAmount) external {
        Project storage project = projects[projectOwner];
        require(project.projectOwner != address(0), "Project does not exist");
        require(project.isApproved, "Project is not approved");
        require(project.projectContractor == address(0), "Project already accepted by a contractor");
        require(msg.sender != project.projectOwner, "Contractor cannot be the project owner");
        require(pledgeAmount >= 1000, "Pledge amount must be at least 1000");

        TimeToken timeToken = TimeToken(timeTokenAddress);
        require(timeToken.transferFrom(msg.sender, address(this), pledgeAmount), "Pledge transfer failed");

        project.projectContractor = msg.sender;
        project.isContractAccepted = true;
        project.pledgeAmount = pledgeAmount;

        emit ProjectContractAccepted(msg.sender, project.hash, project.url, project.amount, pledgeAmount);
    }

    function allocateFunds(address projectOwner, uint256 allocationAmount) external {
        TimeAuditCommittee timeAuditCommittee = TimeAuditCommittee(timeAuditCommitteeAddress);

        Project storage project = projects[projectOwner];
        require(project.projectOwner != address(0), "Project does not exist");
        require(project.isApproved, "Project is not approved");
        require(project.isContractAccepted, "Contractor has not accepted the project");
        require(allocationAmount > 0, "Allocation amount must be greater than zero");

        bool isCommitteeMember = false;
        for (uint256 i = 0; i < 10; i++) {
            TimeAuditCommittee.CommitteeMember memory committeeMember = timeAuditCommittee.getCommitteeMember(i);
            if (committeeMember.memberAddress == msg.sender) {
                isCommitteeMember = true;
                break;
            }
        }
        require(isCommitteeMember, "Caller is not a committee member");

        project.fundsAllocationCount++;

        if (project.fundsAllocationCount > 6) {
            TimeToken timeToken = TimeToken(timeTokenAddress);
            require(timeToken.transfer(project.projectContractor, allocationAmount), "Funds allocation failed");

            project.fundsAllocationCount = 0;

            emit FundsAllocated(project.projectContractor, allocationAmount);
        }
    }
}
