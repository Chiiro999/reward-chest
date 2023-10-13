import {deployments, ethers, getNamedAccounts} from 'hardhat';
import {setupAccount} from './setup';
import {Fixture} from './types';

export const setupDeploymentFixture = async (): Promise<Fixture> => {
  await deployments.fixture();
  const {alice, bob, deployer, freedomWorldAssetsAddress} = await getNamedAccounts();

  return {
    alice: await setupAccount(alice, freedomWorldAssetsAddress),
    bob: await setupAccount(bob, freedomWorldAssetsAddress),
    deployer: await setupAccount(deployer, freedomWorldAssetsAddress),
  };
};
