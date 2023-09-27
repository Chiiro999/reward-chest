import {network, run} from 'hardhat';
import {DeployResult} from 'hardhat-deploy/types';

export const verify = async (result: DeployResult) => {
  if (result.newlyDeployed && network.live) {
    console.log('Starting Contract Verification for:', result.address);
    await run('verify:verify', {
      address: result.address,
      constructorArguments: result.args ? [...result.args] : [],
    });
  }
};
