import {expect} from 'chai';
import {ethers, getNamedAccounts} from 'hardhat';
import {BigNumber} from 'ethers';
import {setupDeploymentFixture} from '../src/helpers/fixture';
import {Fixture} from '../src/helpers/types';
import {ERC1155} from '../types';

describe('RewardChest', function () {
  let fixture: Fixture;
  let rewardChestToken: ERC1155;

  before(async function () {
    fixture = await setupDeploymentFixture();
    const {alice, bob, deployer} = fixture;

    // mint 1 reward chest, transfer to Alice
    await deployer.rewardChest.mintRewardChest(deployer.address);
    await deployer.rewardChest.safeTransferFrom(deployer.address, alice.address, 0, 1, []);

    // mint 1 reward chest, transfer to Bob
    await deployer.rewardChest.mintRewardChest(deployer.address);
    await deployer.rewardChest.safeTransferFrom(deployer.address, bob.address, 1, 1, []);

    // approve RewardChest to spend token for alice and bob
    await alice.rewardChest.setApprovalForAll(deployer.rewardChest.address, true);
    await bob.rewardChest.setApprovalForAll(deployer.rewardChest.address, true);
  });

  it('deployed1', async function () {
    const {deployer} = fixture;
    const {rewardChest} = deployer;
    const {supraRouter} = await getNamedAccounts();
    expect(await rewardChest.supraAddr()).to.eq(supraRouter);
    expect(await rewardChest.owner()).to.eq(deployer.address);
  });

  it('minted reward chest', async function () {
    const {alice, bob, deployer} = fixture;

    expect(await deployer.rewardChest.balanceOf(alice.address, 0)).to.be.eq(1);
    expect(await deployer.rewardChest.balanceOf(bob.address, 1)).to.be.eq(1);
  });

  it('opened a reward chest', async function () {
    // const {alice, bob, deployer} = fixture;
    // const {rewardChest} =  deployer;

    // await rewardChest.openRewardChest(alice.address, 0);
  });
});
