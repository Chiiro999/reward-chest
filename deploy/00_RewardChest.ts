import {DeployFunction} from 'hardhat-deploy/types';
import {HardhatRuntimeEnvironment} from 'hardhat/types';

const deploy: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const {deployments, getNamedAccounts} = hre;
  const {deploy, log} = deployments;
  const {deployer, supraRouter} = await getNamedAccounts();

  log('Deployment - RewardChest');

  const result = await deploy('RewardChest', {
    from: deployer,
    args: [supraRouter],
    log: true,
    skipIfAlreadyDeployed: true,
  });
};

deploy.tags = ['Deployment', 'RewardChest'];
deploy.dependencies = [];
export default deploy;