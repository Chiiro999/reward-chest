import {RewardChest} from '../../types';

export interface Fixture {
  deployer: Account;
  alice: Account;
  bob: Account;
}

export interface Account {
  address: string;
  rewardChest: RewardChest,
}
