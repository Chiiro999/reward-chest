# Freedom World Assets

_Written using solc 0.8.9_

## Usage

Development Commands

```
yarn install            # Install dependencies
yarn build              # Compile contracts and build all project artifacts
yarn compile            # Compile contracts
yarn export             # Generate ABI files
yarn clean              # Clear Hardhat cache
```

Test Commands

```
yarn test               # Run test suite after recompilation
yarn test:gas           # Run test suite with gas reporter
yarn test:fast          # Run test suite w/o compilation
```

Production Commands

```
yarn mainnet:deploy     # Run deploy scripts
yarn mainnet:sourcify   # Upload deployments to IPFS
yarn mainnet:run        # Run a given script, requires path argument
yarn mainnet:verify     # Verify a contract, requires script arguments
```