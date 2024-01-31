# Time Token Project Platform

## Overview

The Time Token Project Platform is a decentralized platform built on the Ethereum blockchain for managing and executing time-based projects. The platform leverages ERC-20 time tokens for transactions and incorporates a committee-based approval system to ensure project integrity and fund allocation.

## Smart Contracts

### TimeToken

- Interface representing the ERC-20 time token contract.
- Functions:
  - `transferFrom`: Transfer time tokens from one address to another.
  - `balanceOf`: Get the balance of time tokens for a specific account.

### TimeAuditCommittee

- Interface defining the TimeAuditCommittee structure and functions.
- Functions:
  - `getCommitteeMember`: Retrieve information about a committee member by index.

### TimeTokenProjectPlatform

- Main smart contract managing the platform's functionality.
- Structs:
  - `Project`: Represents a project with various attributes such as owner, details, approval status, contractor, and pledged amount.
- Events:
  - `ProjectPublished`: Emitted when a project is published on the platform.
  - `ProjectDetailsUpdated`: Emitted when project details are updated by the owner.
  - `ProjectApproved`: Emitted when a project receives the required committee approvals.
  - `ProjectContractAccepted`: Emitted when a contractor accepts a project and pledges time tokens.
  - `FundsAllocated`: Emitted when funds are allocated to a contractor after committee approval.
- Functions:
  - `depositAndPublish`: Deposit time tokens and publish a new project.
  - `updateProjectDetails`: Update project details, allowed only by the project owner.
  - `getTimeTokenBalance`: Get the balance of time tokens held by the platform.
  - `approveProject`: Committee members can approve a project.
  - `acceptProject`: Contractors can accept a project and pledge time tokens.
  - `allocateFunds`: Committee members vote to allocate funds to a contractor.

## Workflow

1. **Project Publication:**
   - Owners deposit time tokens and publish projects.
   - Details can be updated by the owner.

2. **Committee Approval:**
   - Committee members review and approve projects.

3. **Contractor Acceptance:**
   - Approved projects are accepted by contractors.
   - Contractors pledge time tokens.

4. **Funds Allocation:**
   - Committee members vote to allocate funds.
   - Funds are transferred to the contractor upon approval.

## Usage

1. **Deploy Smart Contracts:**
   - Deploy the TimeToken, TimeAuditCommittee, and TimeTokenProjectPlatform contracts.

2. **Project Lifecycle:**
   - Users can deposit time tokens, publish projects, and update project details.
   - Committee members approve projects.
   - Contractors accept projects and pledge time tokens.

3. **Funds Allocation:**
   - Committee members vote to allocate funds to contractors.
   - Funds are transferred upon committee approval.

4. **Smart Contract Addresses:**
   - Configure the platform with the addresses of deployed contracts.





# TimeAuditCommittee Smart Contract

The `TimeAuditCommittee` smart contract is a crucial component within the TimeTokenProjectPlatform ecosystem, responsible for overseeing project audits and ensuring adherence to predefined standards. This committee plays a pivotal role in upholding project integrity before they are approved and executed.

## Overview

- **Smart Contract Name:** TimeAuditCommittee
- **Solidity Version:** ^0.8.7
- **License:** MIT

## Functionality

### 1. Committee Initialization

The committee is initialized with the address of the TIME token contract, and the contract owner is set to the deployer of the contract.

```solidity
constructor(address _timeTokenAddress)
```

### 2. Update Committee Members

The contract owner can update the committee members' information, including their addresses, URLs, and TIME token balances.

```solidity
function updateCommitteeMembers(address[10] memory addresses, string[10] memory urls) external onlyContractOwner
```

### 3. Get Committee Member Information

Any external party can query the information of a specific committee member, including their address, URL, and TIME token balance.

```solidity
function getCommitteeMember(uint256 index) external view returns (CommitteeMember memory)
```

### 4. Internal Function: Get TIME Token Balance

An internal function to retrieve the TIME token balance of a given account using the `balanceOf` method of the TIME token contract.

```solidity
function getTimeBalance(address account) internal view returns (uint256)
```

## Events

- `CommitteeMemberAdded`: Triggered when the contract owner updates the committee members' information.

```solidity
event CommitteeMemberAdded(address memberAddress, string url);
```

## Modifiers

- `onlyContractOwner`: Ensures that only the contract owner can perform certain actions.

```solidity
modifier onlyContractOwner()
```

## Dependencies

- [OpenZeppelin ERC20 Interface](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol)

## Contribution

Feel free to contribute, report issues, or suggest improvements. This smart contract is integral to the TimeTokenProjectPlatform ecosystem, promoting transparency and accountability in project management. Your engagement is highly valued.




## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

