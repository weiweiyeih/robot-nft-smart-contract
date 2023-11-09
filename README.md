# RobotNFT Smart Contract

Welcome to the RobotNFT smart contract repository! This Solidity contract allows you to create and manage 100% on-chain & updatable SVG NFTs that can be trained and upgraded. It could be a minimal example of web3.0 game.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Quickstart](#quickstart)
- [Usage](#usage)
  - [Start a local node](#start-a-local-node)
  - [Deploy](#deploy)
  - [Testing](#testing)
    - [Test Coverage](#test-coverage)
  - [Base64](#base64)
  - [Import NFTs to Metamask wallet](#import-nfts-to-metamask-wallet)
- [Acknowledgments](#acknowledgments)

## Introduction

RobotNFT is a Solidity smart contract that provides a platform for creating and managing robot NFTs. These NFTs can be owned, named, and upgraded through training. You can view the updates not only on the frontend Dapp but also in your wallet.

## Features

- Create robot NFTs with custom names.
- Train robots to increase their experience and level.
- Upgradable robots with different levels, each with its own image.
- ERC-721 compliant NFTs.
- Owner can manage and upgrade their NFTs.

# Getting Started

## Prerequisites

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
- [foundry](https://getfoundry.sh/)
  - You'll know you did it right if you can run `forge --version` and you see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`

## Quickstart

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/weiweiyeih/robot-nft-smart-contract.git
   cd robot-nft-smart-contract
   forge install
   forge build
   ```

# Usage

## Start a local node

```
anvil
```

## Deploy

This will default to your local node. You need to have it running in another terminal in order for it to deploy.

```
forge script script/DeployRobotNft.s.sol:DeployRobotNft --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast
```

## Testing

```
forge test
```

or

```
forge test --fork-url $SEPOLIA_RPC_URL
```

### Test Coverage

```
forge coverage
```

## Base64

To get the base64 of an image, you can use the following command:

```
echo "data:image/svg+xml;base64,$(base64 -i ./img/robot-1.svg)"
```

## Import NFTs to Metamask wallet

see [this support doc](https://support.metamask.io/hc/en-us/articles/360058238591-NFT-tokens-in-your-MetaMask-wallet)

# Acknowledgments

- [foundry-nft-f23](https://github.com/Cyfrin/foundry-nft-f23)
- [Create an NFT with updatable metadata YouTube Tutorial](https://github.com/thirdweb-example/upgradable-metadata-youtube)
