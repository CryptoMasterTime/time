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







# TimeTokenProjectPlatform

## Overview

The TimeTokenProjectPlatform contract is a decentralized platform built on the Ethereum blockchain, facilitating the management and approval of projects using a custom ERC-20 token known as "Time Token." The platform incorporates a governance model through a time audit committee, allowing for transparent and decentralized decision-making.

## Smart Contract Components

### Interfaces

1. **TimeToken Interface:**
   - `transferFrom`: Allows the contract to transfer Time Tokens between addresses.
   - `balanceOf`: Retrieves the balance of Time Tokens for a specified account.

2. **TimeAuditCommittee Interface:**
   - `getCommitteeMember`: Fetches details of a committee member based on the provided index.

### Contract Structure

- **Project Structure:**
  - `projectOwner`: Address of the project owner.
  - `hash`: Unique identifier for the project.
  - `url`: URL associated with the project.
  - `amount`: Funding amount in Time Tokens.
  - `isApproved`: Boolean indicating project approval status.
  - `approvalCount`: Count of committee approvals.

- **Events:**
  - `ProjectPublished`: Triggered when a project is published on the platform.
  - `ProjectDetailsUpdated`: Triggered when project details are updated.
  - `ProjectApproved`: Triggered when a project receives sufficient committee approvals.

### Contract Functions

1. **depositAndPublish:**
   - Allows users to deposit Time Tokens and publish a project on the platform.

2. **updateProjectDetails:**
   - Permits the project owner to update project details.

3. **getTimeTokenBalance:**
   - Retrieves the current balance of Time Tokens held by the contract.

4. **approveProject:**
   - Enables committee members to vote and approve a project.

## Getting Started

### Prerequisites

- Install [Solidity Compiler](https://soliditylang.org/).

### Deployment

1. Deploy the `TimeToken` and `TimeAuditCommittee` contracts.
2. Deploy the `TimeTokenProjectPlatform` contract, providing the addresses of the deployed time token and audit committee contracts.

### Usage

- Use the `depositAndPublish` function to publish a project by depositing Time Tokens.
- Update project details using the `updateProjectDetails` function.
- Committee members can approve projects through the `approveProject` function.

## Security Considerations

- Ensure a secure deployment environment.
- Perform a comprehensive security audit before deploying in a production environment.

## Governance Model

The platform relies on a decentralized governance model where committee members collectively approve projects.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

