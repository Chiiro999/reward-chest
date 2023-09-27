// SPDX-License-Identifier: MIT 
pragma solidity 0.7.6;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";
import {ISupraRouter} from "./interfaces/ISupraRouter.sol";
import {Rewards} from "./Rewards.sol";

contract RewardChest is ERC1155, Ownable, Rewards {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    address public immutable supraAddr;

    address public immutable supraClientAddr;

    Counters.Counter _rewardChestCounter;

    struct rewardChestData {
        bool opened;
        uint256 randomReward;
    }

    enum Class {
        Common,
        Rare,
        Epic
    }
    uint256 constant NUM_CLASSES = 3;

    mapping(uint256 => rewardChestData) chestData;

    mapping(uint256 => uint256) randomNumToLootBox;

    uint256 constant private MAX_POSSIBLE_REWARDS = 1;

    constructor(address _vrfAddress) {
        supraAddr = _vrfAddress;
        supraClientAddr = msg.sender;
    }

    /// @dev Prevents sandwich / flash loan attacks & re-entrancy
    modifier defense {
        require(msg.sender == tx.origin, "Only EOA");
        _;
    }

    function _ownerOf(address account, uint256 tokenId) internal view returns (bool) {
        return balanceOf(account, tokenId) != 0;
    }

    function mintRewardChest(address account) public defense onlyOwner {
        uint256 tokenId = _rewardChestCounter.current();
        _rewardChestCounter.increment();
        _mint(account, tokenId, 1, "");
    }

    function openRewardChest(address account, uint256 tokenId) public defense onlyOwner {
        require(_ownerOf(account, tokenId) == true, "Not owner of Chest.");
        require(chestData[tokenId].opened == false, "Reward Chest already opened.");

        uint256 nonce = ISupraRouter(supraAddr).generateRequest("finishRewardChest(uint256,uint256[])", 1, 1, supraClientAddr);
        randomNumToLootBox[nonce] = tokenId;

        mintRewards(account, nonce);
    }

    function finishRewardChest(uint256 nonce, uint256[] calldata rngList) internal {
        require(msg.sender == supraAddr, "Only supra router can call this function");

        chestData[randomNumToLootBox[nonce]].opened = true;
        chestData[randomNumToLootBox[nonce]].randomReward = rngList[0] % 100;
    }

    function mintRewards(address account, uint256 nonce) internal {
        uint256 randomNum = chestData[randomNumToLootBox[nonce]].randomReward;

        for (uint256 i = 0; i < MAX_POSSIBLE_REWARDS; i++) {
            if (randomNum < epicDropRate) {
                mintWearable1(account, 1);
            } else if (randomNum < rareDropRate) {
                mintWearable2(account, 1);
            } else {
                mintWearable3(account, 1);
            }
        }
    }
}
