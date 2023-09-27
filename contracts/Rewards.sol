// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {ISupraRouter} from "./interfaces/ISupraRouter.sol";

contract Rewards is ERC1155, Ownable {

    // Token IDs for each semi-fungible wearable items
    uint256 public constant WEARABLE_1 = 1;
    uint256 public constant WEARABLE_2 = 2;
    uint256 public constant WEARABLE_3 = 3;
    
    // Variables to track minted semi-fungible tokens
    uint256 public wearable1Supply = 0;
    uint256 public wearable2Supply = 0;
    uint256 public wearable3Supply = 0;

    uint256 internal epicDropRate = 10; // Epic reward
    uint256 internal rareDropRate = 30; // Rare reward
    uint256 internal commonDropRate = 60; // Common reward
    
    constructor() ERC1155("https://metadata.json") { }

    function mintWearable1(address account, uint256 amount) internal returns (uint256) {
        wearable1Supply += amount;
        _mint(account, WEARABLE_1, amount, "");
        return WEARABLE_1;
    }

    function mintWearable2(address account, uint256 amount) internal returns (uint256) {
        wearable2Supply += amount;
        _mint(account, WEARABLE_2, amount, "");
        return WEARABLE_2;
    }

    function mintWearable3(address account, uint256 amount) internal returns (uint256) {
        wearable3Supply += amount;
        _mint(account, WEARABLE_3, amount, "");
        return WEARABLE_3;
    }

    function assignDropRates(
        uint256 common,
        uint256 rare,
        uint256 epic
    ) external onlyOwner {
        require((common + rare + epic == 100), "Drop rates must equal 100.");

        commonDropRate = common;
        rareDropRate = rare;
        epicDropRate = epic;
    }
}