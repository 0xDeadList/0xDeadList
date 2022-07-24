require('dotenv').config();
const providers = require('ethers').providers;
const ethers = require('ethers');
const fs = require('fs');

const infuraProvider = new providers.InfuraProvider('ropsten', process.env.PROVIDER_KEY);
const blockNumberFile = '../latestblock';

async function updateLockLog(provider, startBlock, endBlock) {
    const filename = '../locklog.txt';
    const deadlistABI = require('./abi/deadlist_abi.json')
    const contract = new ethers.Contract(
        process.env.DEADLIST_CONTRACT_ADDRESS, deadlistABI, provider);

    const filter = contract.filters.Lock();
    let updates = [];
    for (let i = startBlock; i <= endBlock; i += 1024) {
        const _startBlock = i + 1;
        const _endBlock = i + 1024;   
        const events = await contract.queryFilter(filter, _startBlock, _endBlock);
        updates = updates.concat(events.map(event =>
            [event.args.locked, event.args.lock_until]));
    }
    console.log("append " + updates.length + " locklog");
    if (updates.length == 0) return;
    let patchLines = updates.map(item => item.join(' ')).join('\n');
    fs.appendFileSync(filename, patchLines + '\n');
}

async function updateDeadList(provider, startBlock, endBlock) {
    const filename ='../deadlist.txt';
    const sbtABI = require('./abi/nft_abi.json');
    const contract = new ethers.Contract(
        process.env.SBT_CONTRACT_ADDRESS, sbtABI, provider);
    const filter = contract.filters.Transfer();
    let updates = [];
    for (let i = startBlock; i <= endBlock; i += 1024) {
        const _startBlock = i + 1;
        const _endBlock = i + 1024;   
        const events = await contract.queryFilter(filter, _startBlock, _endBlock);
        updates = updates.concat(events.map(event =>
            [event.args.to, ethers.utils.hexZeroPad(event.args.tokenId.toHexString(), 32)]));
    }
    console.log("append " + updates.length + " dead address");
    if (updates.length == 0) return;
    let patchLines = updates.map(item => item.join(' ')).join('\n');
    fs.appendFileSync(filename, patchLines + '\n');
}

async function update() {
    const blockHeight = await infuraProvider.getBlockNumber() - 32;
    const lastUpdateBlock = parseInt(fs.readFileSync(blockNumberFile).toString());
    console.log("update block range (" + lastUpdateBlock + "," + blockHeight + "]");

    await updateLockLog(infuraProvider, lastUpdateBlock, blockHeight);
    await updateDeadList(infuraProvider, lastUpdateBlock, blockHeight);

    // write block height
    fs.writeFileSync(blockNumberFile, blockHeight.toString());
}

update();