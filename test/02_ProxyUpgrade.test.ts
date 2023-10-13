// import {expect} from 'chai';
// import {ethers, getNamedAccounts, upgrades} from 'hardhat';
// import {formatUnits, parseEther} from '@ethersproject/units'
// import {setupDeploymentFixture} from '../src/helpers/fixture';
// import {Fixture} from '../src/helpers/types';
// import {ERC1155Upgradeable} from '../types';

// describe('FreedomWorldAsset logic contract upgrade', function () {
//   let fixture: Fixture;
//   let freedomWorldAssetsToken: ERC1155Upgradeable;


//   before(async function () {
//     fixture = await setupDeploymentFixture();
//   });

//   it('Upgraded properly', async function () {
//     const {deployer} = fixture;
//     const {freedomWorldAssets} = deployer;

//     console.log("deployer address: %s, owner: %s", deployer.address, await freedomWorldAssets.owner());

//     expect(await freedomWorldAssets.owner()).to.eq(deployer.address);

//     const upgradeableFreedomWorldAssets = await ethers.getContractFactory("FreedomWorldAssetsV2ForTesting");

//     //const upgradedContract = await ethers.getContractFactory('FreedomWorldAssets');
//     const upgradedContract = await upgrades.upgradeProxy(freedomWorldAssets, upgradeableFreedomWorldAssets, {call: {fn: 'initialize', args:["https://metadata.json"]}});

//     console.log("Upgraded contract address: ", upgradedContract.getAddress());

//   });

//   it("Old contract cannnot mint NFTs", async function () {

//   });
// });
