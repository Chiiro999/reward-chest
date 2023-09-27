import {deployments, ethers} from "hardhat";
import {RewardChest} from '../../types';
import {Account} from './types';

export const setupAccount = async (account: string): Promise<Account> => {
  //const signer = await ethers.getSigner(account);

  await deployments.fixture(['RewardChest']);

  const rewardChestContract = await deployments.get("RewardChest");

  const rewardChest = (await ethers.getContractAt(rewardChestContract.abi, rewardChestContract.address)) as RewardChest;

  //const rewardChest = (await ethers.getContract('RewardChest', signer)) as RewardChest;

  return {
    address: account,
    rewardChest,
  };
};
