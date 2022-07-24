# 0xDeadList

## Introduction

0xDeadList collects the "dead" address with leaked private key. Users are able to lock/bury wallet and get a NFT for reporting the leaked private key. Dapps are able to block those public accessible wallets with on/off-chain APIs.

The dead addresses (with private keys) are periodically dumped into [deadlist.txt](./deadlist.txt).

## How does this work?

There are two kinds of "dead" address: private key that nobody knows and everyone knows. 0xDeadList program tries to collet a full list of the later by saving private keys on chain so that everyone are able to access the dead list.

Users get NFT (called Burrier) when they successfully post dead address. At the same time, the contract attach SBT (called TombStone) to the dead address.

The program will reward users who holds Burrier NFT according the value of dead address (e.g., consider the created time and consumed gas fee) in the future.

## Mint NFT in DeadList

Mint NFT in DeadList is quite easy. Just go to https://0xdeadlist.io, input the private key and follow the instructions. Remember do NOT input the private key of wallet you are currently using.

## Use DeadList in Dapp

Currently 0xDeadList contract is depolied on Polygon:

- DeadList Contract Address:
- Burrier NFT Contract Address:
- TombStone SBT Contract Address: 

DeadList contract has three pure functions that show the status of wallet address:

``` solidity
function isAddressDead(address addr) public view returns (bool);

function isAddressLocked(address addr) public view returns (bool);

function isAddressLockedOrDead(address addr) public view returns (bool);
```

**Off-Chain API example:**

``` js
const ethers = require('ethers');

const DEADLIST_ABI = require('./scripts/abi/dead_list_abi.json');
const DEADLIST_CONTRACT_ADDRESS = '0x458253AFEf490A949e177DF6E50d7E14cD86C6d9';
const provider = new ethers.providers.InfuraProvider('polygon', INFURA_KEY); // USE YOUR OWN KEY
const deadlistContract = new ethers.Contract(DEADLIST_CONTRACT_ADDRESS, DEADLIST_ABI, provider);

const targt_address = '0xE57bFE9F44b819898F47BF37E5AF72a0783e1141';

let isAddressDead = await deadlistContract.isAddressDead(targt_address);
console.log("isAddressDead:", isAddressDead);

let isAddressLocked = await deadlistContract.isAddressLocked(targt_address);
console.log("isAddressLocked:", isAddressLocked);

let isAddressLockedOrDead = await deadlistContract.isAddressLockedOrDead(targt_address);
console.log("isAddressLockedOrDead:", isAddressLockedOrDead);
```

**On-Chain API example:**

``` solidity

```

## Resources

- Website: https://0xdeadlist.io
- Twitter: https://twitter.com/0xdeadlist
- Discord: https://discord.gg/uHYgebcq
- Github: https://github.com/0xDeadList