import {deployments, ethers} from "hardhat";
import {FreedomWorldAssets} from '../../types';
import {Account} from './types';

export const setupAccount = async (account: string, freedomWorldAssetsAddress: string): Promise<Account> => {

  await deployments.fixture(['FreedomWorldAssets']);

  const freedomWorldAssetsContract = await ethers.getContractAt("FreedomWorldAssets", freedomWorldAssetsAddress) as unknown as FreedomWorldAssets;

  // DEBUG
  //console.log("reward contract address: ", await freedomWorldAssetsContract.getAddress());

  return {
    address: account,
    freedomWorldAssets: freedomWorldAssetsContract,
  };
};
