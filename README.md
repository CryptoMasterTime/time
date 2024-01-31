# TimeAuditCommittee: A Dynamic Committee Management on Ethereum

`TimeAuditCommittee` is a smart contract that brings the concept of a dynamic committee to the Ethereum blockchain. Crafted with Solidity 0.8.7, this contract serves as a registry for a group of 10 committee members, each holding a balance of TIME tokens.

## Features

1. **Contract Ownership:** The contract is owned by the Ethereum address that deploys it. The owner has exclusive rights to modify the committee members.

2. **TIME Token Interaction:** The contract is designed to interact with a separate ERC20 token contract, known as the TIME token. The contract address of the TIME token is supplied during the contract's deployment.

3. **Committee Management:** The contract maintains a list of 10 committee members. Each member is represented by a struct that includes the member's Ethereum address, a URL (possibly a link to their profile or website), and the amount of TIME tokens they hold.

## Core Functions

- **Constructor:** The constructor function sets the contract owner as the deploying address and initializes the TIME token contract using the provided address.

- **updateCommitteeMembers:** This function, accessible only by the contract owner, allows updating the committee members. It accepts two arrays - an array of Ethereum addresses and an array of URLs, updating each committee member's details and TIME token balance, and fires an event for each newly added member.

- **getCommitteeMember:** This function enables anyone to fetch the details of a committee member, given their index. It returns the member's Ethereum address, URL, and up-to-date TIME token balance.

- **getTimeBalance:** This internal function interfaces with the TIME token contract to fetch the balance of a given Ethereum address.

## Events

- **CommitteeMemberAdded:** This event is triggered every time a new committee member is added, logging the member's Ethereum address and URL.

## Modifiers

- **onlyContractOwner:** This modifier ensures that certain functions can only be called by the contract owner.

`TimeAuditCommittee` smart contract offers an innovative approach to managing a committee of TIME token holders on the Ethereum blockchain.







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

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

