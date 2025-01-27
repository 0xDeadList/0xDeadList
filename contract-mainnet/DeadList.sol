// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract DeadList {
    event BuryAddress(uint256 indexed privateKey, address indexed buriedAddress);

    mapping(address => bool) private buriedAddresses;

    error AddressAlreadyBuried();
    error InvalidPrivateKeyRange();

    uint256 private constant CURVE_ORDER = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;
    bytes32 private constant Gx = bytes32(0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798);

    function isAddressDead(address addr) public view returns (bool) {
        return buriedAddresses[addr];
    }

    function buryAddress(uint256 privateKey) external {
        if (privateKey >= CURVE_ORDER || privateKey == 0) {
            revert InvalidPrivateKeyRange();
        }

        // The solution is based on: https://ethresear.ch/t/you-can-kinda-abuse-ecrecover-to-do-ecmul-in-secp256k1-today/2384
        address recoveredAddress = ecrecover(0, 27, Gx, bytes32(mulmod(uint256(Gx), privateKey, CURVE_ORDER)));

        if (buriedAddresses[recoveredAddress]) {
            revert AddressAlreadyBuried();
        }

        buriedAddresses[recoveredAddress] = true;

        emit BuryAddress(privateKey, recoveredAddress);
    }
}
