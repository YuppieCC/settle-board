DEPLOY_CONTRACT ?=
DEPLOYED_CONTRACT_ADDRESS ?=
CONSTRUCTOR_ARGS ?=
VERITY_CONSTRUCTOR_ARGS ?=
VERIFY_CONTRACT ?=
GUID ?=
include .env

test:
	forge test --fork-url ${NETWORK_RPC_URL}

report:
	forge test --fork-url ${NETWORK_RPC_URL} --gas-report

build:
	forge build

# deploy the contract
deploy-contract:
	forge create --rpc-url ${NETWORK_RPC_URL} \
		--private-key ${PRIVATE_KEY} \
		src/$(DEPLOY_CONTRACT).sol:$(DEPLOY_CONTRACT) \
		--gas-price ${GAS_PRICE}

# verify the contract
verify-contract:
	forge verify-contract --chain-id ${CHAIN_ID} \
		--num-of-optimizations 200 \
		--compiler-version ${COMPILER_VERSION} $(DEPLOYED_CONTRACT_ADDRESS) \
		src/$(VERIFY_CONTRACT).sol:$(VERIFY_CONTRACT) \
		${ETHERSCAN_KEY}

verify-check:
	forge verify-check --chain-id ${CHAIN_ID} $(GUID) ${ETHERSCAN_KEY}

# deploy contracts and verify them
scripting:
	forge script script/Deploy.s.sol:DeployScript --rpc-url ${NETWORK_RPC_URL} \
		--broadcast \
		--verify \
		--etherscan-api-key ${ETHERSCAN_KEY} \
		--private-key ${PRIVATE_KEY} \
		-vvvv