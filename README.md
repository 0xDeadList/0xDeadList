# 0xDeadList

## Introduction

0xDeadList collects the "dead" address with leaked private key. Users are able to lock/bury wallet and get a [Burier NFT](https://opensea.io/collection/addressburier-v2) for reporting the leaked private key. Dapps are able to block those public accessible wallets with on/off-chain APIs.

The dead addresses are attached with [Tombstone SBT](https://opensea.io/collection/tombstone-v4). The full deadlist is periodically dumped into [deadlist.txt](./deadlist.txt).

## How does this work?

There are two kinds of "dead" address: private key that nobody knows and everyone knows. 0xDeadList program tries to collect a full list of the latter by saving private keys on chain so that everyone is able to access the dead list.

Users get NFT (called Burrier) when they successfully post dead address. At the same time, the contract attach SBT (called TombStone) to the dead address.

The program will reward users who hold Burrier NFT according to the value of dead address (e.g., consider the created time and consumed gas fee) in the future.

## Mint NFT in DeadList

Mint NFT in DeadList is quite easy. Just go to https://0xdeadlist.io, input the private key and follow the instructions. Remember do NOT input the private key of wallet you are currently using.

## Use DeadList in Dapp

Dapps should ban address in 0xDeadList to avoid malicious exploitation.

Currently 0xDeadList contract is depolyed on Polygon:

- DeadList Contract Address: [0x59451a98d772f2a53ca2241a884b1703f8c55218](https://polygonscan.com/address/0x59451a98d772f2a53ca2241a884b1703f8c55218)
- Burrier NFT Collection: [OpenSea](https://opensea.io/collection/addressburier-v3)
- TombStone SBT Collection: [OpenSea](https://opensea.io/collection/tombstone-zktgb9g35d)

**On-Chain API example:**

DeadList contract has pure function that check the status of wallet address:

``` solidity
function isAddressLockedOrDead(address addr) public view returns (bool);
```

**Off-Chain API example:**

``` js
const ethers = require('ethers');

const DEADLIST_ABI = require('./scripts/abi/dead_list_abi.json');
const DEADLIST_CONTRACT_ADDRESS = '0x59451a98d772f2a53ca2241a884b1703f8c55218';
const provider = new ethers.providers.InfuraProvider('matic', INFURA_KEY); // USE YOUR OWN KEY
const deadlistContract = new ethers.Contract(DEADLIST_CONTRACT_ADDRESS, DEADLIST_ABI, provider);

const targt_address = '0xE57bFE9F44b819898F47BF37E5AF72a0783e1141';

let isAddressLockedOrDead = await deadlistContract.isAddressLockedOrDead(targt_address);
console.log("isAddressLockedOrDead:", isAddressLockedOrDead);
```

## Resources

- Website: https://0xdeadlist.io
- Twitter: https://twitter.com/0xdeadlist
- Discord: https://discord.gg/vTbSCKau
- Github: https://github.com/0xDeadList

## Projects That Use 0xDeadList

- [MetaMail](https://metamail.ink)
- [EthSign](https://www.ethsign.xyz/)
