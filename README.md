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
