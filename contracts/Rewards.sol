// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import {ISupraRouter} from "./interfaces/ISupraRouter.sol";

contract Rewards is ERC1155 {
    using Counters for Counters.Counter;

    // Counter for unique semi-fungible token IDs
    // Right now each reward token would have a unique ID which doesn't really
    // make them "semi-fungible". They would act more like erc-721 tokens
    // TODO: discuss with team and decide if each reward type should have the same tokenID per type 
    Counters.Counter _rewardsCounter;

    enum RewardId {
        digitalWearable1,
        digitalWearable2,
        digitalWearable3
    }
    uint256 constant NUM_REWARDS = 3;
    
    // Mappings to track minted semi-fungible tokens
    mapping(uint256 => uint256) public digitalWearable1Supply;
    mapping(uint256 => uint256) public digitalWearable2Supply;
    mapping(uint256 => uint256) public digitalWearable3Supply;

    //TODO: add functionality to change drop rate (should be onlyOwner)
    uint256 public constant digitalWearable1DropRate = 10;
    uint256 public constant digitalWearable2DropRate = 30;
    uint256 public constant digitalWearable3DropRate = 60;
    
    constructor() ERC1155("https://metadata.json") {

    }

    function mintSemiFungibleToken1(address account, uint256 amount) internal returns (uint256) {
        _rewardsCounter.increment();
        uint256 newTokenId = _rewardsCounter.current();
        digitalWearable1Supply[newTokenId] = amount;
        _mint(account, newTokenId, amount, "");
        return newTokenId;
    }

    function mintSemiFungibleToken2(address account, uint256 amount) internal returns (uint256) {
        _rewardsCounter.increment();
        uint256 newTokenId = _rewardsCounter.current();
        digitalWearable2Supply[newTokenId] = amount;
        _mint(account, newTokenId, amount, "");
        return newTokenId;
    }

    function mintSemiFungibleToken3(address account, uint256 amount) internal returns (uint256) {
        _rewardsCounter.increment();
        uint256 newTokenId = _rewardsCounter.current();
        digitalWearable3Supply[newTokenId] = amount;
        _mint(account, newTokenId, amount, "");
        return newTokenId;
    }
}