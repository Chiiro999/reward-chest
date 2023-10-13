// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";

/**
    @dev Extension to ERC1155 for Mixed Fungible and Non-Fungible Items support
    The main benefit is sharing of common type information, just like you do when
    creating a fungible id.
*/
abstract contract ERC1155MixedFungible is ERC1155Upgradeable {
    using AddressUpgradeable for address;

    // Use a split bit implementation.
    // Store the type in the upper 128 bits..
    uint256 constant TYPE_MASK = uint256(type(uint128).max) << 128;

    // ..and the index in the lower 128
    uint256 constant INDEX_MASK = type(uint128).max;

    // The top bit is a flag to tell if this is a non-fungible
    uint256 constant TYPE_BIT = 1 << 255;

    function isNonFungible(uint256 _id) public pure returns(bool) {
        return _id & TYPE_BIT == TYPE_BIT;
    }

    function isFungible(uint256 _id) public pure returns(bool) {
        return _id & TYPE_BIT == 0;
    }

    function getNonFungibleIndex(uint256 _id) public pure returns(uint256) {
        return _id & INDEX_MASK;
    }

    function getBaseType(uint256 _id) public pure returns(uint256) {
        return _id & TYPE_MASK;
    }

    function isNonFungibleBaseType(uint256 _id) public pure returns(bool) {
        // A base type has the NF bit but does not have an index.
        return (_id & TYPE_BIT == TYPE_BIT) && (_id & INDEX_MASK == 0);
    }

    function isNonFungibleItem(uint256 _id) public pure returns(bool) {
        // A base type has the NF bit but does has an index.
        return (_id & TYPE_BIT == TYPE_BIT) && (_id & INDEX_MASK != 0);
    }
}