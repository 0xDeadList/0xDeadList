require('dotenv').config();
const providers = require('ethers').providers;
const ethers = require('ethers');
const fs = require('fs');

const infuraProvider = new providers.InfuraProvider('ropsten', process.env.PROVIDER_KEY);
const blockNumberFile = '../latestblock.txt';

async function updateLockLog(provider, startBlock, endBlock) {
    const filename = '../locklog.txt';
    const deadlistABI = require('./abi/deadlist_abi.json')
    const contract = new ethers.Contract(
        process.env.DEADLIST_CONTRACT_ADDRESS, deadlistABI, provider);

    const filter = contract.filters.Lock();
    let updates = [];
    for (let i = startBlock; i <= endBlock; i += 1024) {
        const _startBlock = i;
        const _endBlock = Math.min(i + 1024 - 1, endBlock);   
        const events = await contract.queryFilter(filter, _startBlock, _endBlock);
        updates = updates.concat(events.map(event =>
            [event.args.locked, event.args.lock_until]));
    }
    console.log("append " + updates.length + " locklog");
    if (updates.length == 0) return;
    let patchLines = updates.map(item => item.join(' ')).join('\n');
    fs.appendFileSync(filename, '\n' + patchLines);
}

async function updateDeadList(provider, startBlock, endBlock) {
    const filename ='../deadlist.txt';
    const sbtABI = require('./abi/nft_abi.json');
    const contract = new ethers.Contract(
        process.env.SBT_CONTRACT_ADDRESS, sbtABI, provider);
    const filter = contract.filters.Transfer();
    let updates = [];
    for (let i = startBlock; i <= endBlock; i += 1024) {
        const _startBlock = i;
        const _endBlock = Math.min(i + 1024 - 1, endBlock);   
        const events = await contract.queryFilter(filter, _startBlock, _endBlock);
        updates = updates.concat(events.map(event =>
            [event.args.to, ethers.utils.hexZeroPad(event.args.tokenId.toHexString(), 32)]));
    }
    console.log("append " + updates.length + " dead address");
    if (updates.length == 0) return;
    let patchLines = updates.map(item => item.join(' ')).join('\n');
    fs.appendFileSync(filename, '\n' + patchLines);
}

async function update() {
    const startBlock = parseInt(fs.readFileSync(blockNumberFile).toString()) + 1;
    const endBlock = await infuraProvider.getBlockNumber() - 16;
    console.log("update block range [" + startBlock + "," + endBlock + "]");
    if (startBlock > endBlock) {
        console.log("pass");
        return;
    }

    await updateLockLog(infuraProvider, startBlock, endBlock);
    await updateDeadList(infuraProvider, startBlock, endBlock);

    // write block height
    fs.writeFileSync(blockNumberFile, endBlock.toString());
}

update();