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

    Counters.Counter _chestIdCounter;

    uint256 constant private MAX_POSSIBLE_REWARDS = 1;

    uint256 private _CUMULATIVE_PROBABILITIES_TOTAL = 1000;

    struct ChestData {
        mapping (uint256 => uint256) rewardIdToDropRate;
        bool enabled;
    }

    struct UserRng {
        address addr;
        uint256 rng;
    }

    mapping(uint256 => ChestData) chests;

    mapping(uint256 => address) nonceToUser;

    mapping (address => uint256) userToRandomNumber;

    constructor(address _vrfAddress) {
        supraAddr = _vrfAddress;
        supraClientAddr = msg.sender;
    }

    /// @dev Prevents sandwich / flash loan attacks & re-entrancy
    modifier defense {
        require(msg.sender == tx.origin, "Only EOA");
        _;
    }

    /// @notice Adds a new chest type with its own loot table and drop chance per loot
    /// @param _rewardIds Array of existing collection name
    /// @param _cumulativeProbablities Array of cumulative probablities for each reward IDs
    function addChest(
        string[] memory _rewardIds,
        uint256[] memory _cumulativeProbablities
    ) external onlyOwner returns(uint256) {
        require(_rewardIds.length != 0, "Array length 0");
        require(rewardIds.length == _cumulativeProbablities.length, "rewardIds and cumulativeProbabilities not equal length");

        _chestIdCounter.increment();

        ChestData storage chest = chests[_chestIdCounter];

        for (uint64 i = 0; i < _rewardIds.length; i++) {
            chest.rewardNameToDropRate[_rewardIds] 
        }
        
    }

    function openRewardChest(address account) public defense onlyOwner {
        uint256 nonce = ISupraRouter(supraAddr).generateRequest("_finishRewardChest(uint256,uint256[])", 1, 1, supraClientAddr);
        nonceToUser[nonce] = account;

        mintRewards(account);
    }

    function _ownerOf(
        address account,
        uint256 tokenId
    ) internal view returns (bool) {
        return balanceOf(account, tokenId) != 0;
    }

    function _finishRewardChest(uint256 nonce, uint256[] calldata rngList) internal {
        require(msg.sender == supraAddr, "Only supra router can call this function");

        userToRandomNumber[nonceToUser[nonce]] = rngList[0] % _CUMULATIVE_PROBABILITIES_TOTAL;
    }

    function _mintRewards(address account) internal {
        uint256 randomNum = userToRandomNumber[account];

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
