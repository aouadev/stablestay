# StableStay

StableStay is a decentralized reservation and payment system built during the ETHGlobal hackathon.

The goal of the project is to allow users to reserve accommodation and pay securely using **USDC stablecoin** on the **Base Sepolia network**.

## Architecture

The project is divided into three parts:

```
frontend/       User interface
backend/        Backend services
smartcontract/  Solidity smart contract
```

## Smart Contract

The reservation logic is handled by the **StableStay smart contract**.

Network: Base Sepolia

Contract address:

```
0x9bFA44E8267623982C8E1df776A8E2e53d3FC1F2
```

Explorer:

https://sepolia.basescan.org/address/0x9bFA44E8267623982C8E1df776A8E2e53d3FC1F2

## Stablecoin Used

USDC (Base Sepolia test token)

```
0x036CbD53842c5426634e7929541eC2318f3dCF7e
```

## Tech Stack

- Solidity
- Hardhat
- OpenZeppelin
- Ethers.js
- Vue.js

## Smart Contract Deployment

Inside the `smartcontract` folder:

```
npx hardhat run scripts/deploy.js --network baseSepolia
```

## Environment Variables

Create a `.env` file in the `smartcontract` folder:

```
BASE_SEPOLIA_RPC=<rpc_url>
PRIVATE_KEY=<private_key>
```

## Hackathon

This project was developed during **ETHGlobal Cannes**.
