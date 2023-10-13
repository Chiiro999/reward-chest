import {DeployFunction} from 'hardhat/types';
import {HardhatRuntimeEnvironment} from 'hardhat/types';
import {ethers, upgrades} from 'hardhat';

const deploy: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const {deployments, getNamedAccounts} = hre;
  const {deploy, log} = deployments;
  const {deployer} = await getNamedAccounts();

  const freedomWorldAssetsContract = await ethers.getContractFactory("FreedomWorldAssets");
  const instance = await upgrades.deployProxy(freedomWorldAssetsContract, ["https://metadata.json"]);

  log('Deployment - FreedomWorldAssets');

  await instance.waitForDeployment();

  console.log("FreedomWorldAssets contract deployed to: ", await instance.getAddress());
};

deploy.tags = ['Deployment', 'FreedomWorldAssets'];
deploy.dependencies = [];
export default deploy;