import {deployments, ethers, getNamedAccounts} from 'hardhat';
import {setupAccount} from './setup';
import {Fixture} from './types';

export const setupDeploymentFixture = async (): Promise<Fixture> => {
  await deployments.fixture();
  const {alice, bob, deployer} = await getNamedAccounts();

  return {
    alice: await setupAccount(alice),
    bob: await setupAccount(bob),
    deployer: await setupAccount(deployer),
  };
};
