import {expect} from 'chai';
import {ethers, getNamedAccounts} from 'hardhat';
import {formatUnits, parseEther} from '@ethersproject/units'
import {setupDeploymentFixture} from '../src/helpers/fixture';
import {Fixture} from '../src/helpers/types';
import {ERC1155Upgradeable} from '../types';

describe('FreedomWorldAssets', function () {
  let fixture: Fixture;
  let freedomWorldAssetsToken: ERC1155Upgradeable;

  const typeNfBit = BigInt(1) << BigInt(255);
  const _chestType = (BigInt(1) << BigInt(128)) | typeNfBit;
  const _bootsType = (BigInt(2) << BigInt(128)) | typeNfBit;
  const _macbookType = (BigInt(3) << BigInt(128)) | typeNfBit;
  const _gem1Type = (BigInt(4) << BigInt(128));
  const _gem2Type = (BigInt(5) << BigInt(128));

  before(async function () {
    fixture = await setupDeploymentFixture();
  });

  it('Deployed', async function () {
    const {deployer} = fixture;
    const {freedomWorldAssets} = deployer;

    console.log("deployer address: ", deployer.address);

    expect(await freedomWorldAssets.owner()).to.eq(deployer.address);
  });

  it('Creates asset types', async function () {
    const {deployer} = fixture;
    const {freedomWorldAssets} = deployer;

    // create some Asset types
    await deployer.freedomWorldAssets.createAssetType("https://metadata.json", "Chest", 0, true);
    await deployer.freedomWorldAssets.createAssetType("https://metadata1.json", "Boots", 0, true);
    await deployer.freedomWorldAssets.createAssetType("https://metadata2.json", "MacbookPro", 10, true);
    await deployer.freedomWorldAssets.createAssetType("https://metadata3.json", "Gem1", 0, false);
    await deployer.freedomWorldAssets.createAssetType("https://metadata4.json", "Gem2", 0, false);

    // Check that types generated are correct
    const chestType = await freedomWorldAssets.getAssetType("Chest");
    expect(_chestType).to.equal(chestType);

    const bootsType = await freedomWorldAssets.getAssetType("Boots");
    expect(_bootsType).to.equal(bootsType);
    
    const macbookType = await freedomWorldAssets.getAssetType("MacbookPro");
    expect(_macbookType).to.equal(macbookType);
    
    const gem1Type = await freedomWorldAssets.getAssetType("Gem1");
    expect(_gem1Type).to.equal(gem1Type);
    
    const gem2Type = await freedomWorldAssets.getAssetType("Gem2");
    expect(_gem2Type).to.equal(gem2Type);
  });

  it('Minted assets', async function () {
    const {alice, bob, deployer} = fixture;
    const {freedomWorldAssets} =  deployer;

    // Minting Chest wearable to Alice and checking balance
    const chestTokenId = _chestType | BigInt(1);
    console.log("Minting Chest for Alice...");
    await freedomWorldAssets.mintNonFungible(_chestType, [alice.address]);
    let balance = await freedomWorldAssets.balanceOf(alice.address, chestTokenId);
    console.log("Alice balance for that Chest is: ", balance.toString());

    // Minting Boots wearable to Alice and checking balance
    let bootsTokenId = _bootsType | BigInt(1);
    console.log("Minting Boots for Alice...");
    await freedomWorldAssets.mintNonFungible(_bootsType, [alice.address]);
    balance = await freedomWorldAssets.balanceOf(alice.address, bootsTokenId);
    console.log("Alice balance for those Boots is: ", balance.toString());

    // Minting another pair of Boots to Alice and checking balance
    bootsTokenId = _bootsType | BigInt(2);
    console.log("Minting another pair of Boots for Alice...");
    await freedomWorldAssets.mintNonFungible(_bootsType, [alice.address]);
    balance = await freedomWorldAssets.balanceOf(alice.address, bootsTokenId);
    console.log("Alice balance for those other Boots is: ", balance.toString());
  });

  it('Tests max supply reached', async function () {
    
  });
});
