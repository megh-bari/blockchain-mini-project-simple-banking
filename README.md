# Simple Banking DApp

**Student:** Megh Dipak Bari  
**Roll No:** 03

A small decentralized banking application built with Solidity, ethers.js, and MetaMask. The project runs on the Ethereum Sepolia test network and provides a clean browser interface for managing deposited ETH and transferable Bank Tokens.

## Project overview

The application demonstrates how a frontend can communicate with an Ethereum smart contract through MetaMask. Users connect their wallets, register with the bank, deposit or withdraw Sepolia ETH, transfer internal Bank Tokens, and inspect the bank's registered accounts and contract liquidity.

The smart contract keeps two balances separate:

- **ETH balance:** Real Sepolia ETH deposited by each registered user.
- **Bank Token balance:** Internal tokens used only for transfers between registered users.

Keeping these balances separate prevents the free registration tokens from being withdrawn as ETH.

## Features

- Connect a MetaMask wallet.
- Automatically request the Sepolia network.
- Register a new banking account.
- Receive 100 Bank Tokens after registration.
- Deposit Sepolia ETH into the contract.
- Withdraw previously deposited ETH.
- Transfer Bank Tokens to another registered account.
- View personal ETH and Bank Token balances.
- List every registered account.
- View the smart contract's total ETH reserve.
- Respond to wallet-account and network changes.
- Display transaction progress and contract error messages.
- Work across desktop and mobile screen sizes.

## Technologies

- **Solidity 0.8.20** for the smart contract.
- **Ethereum Sepolia** as the test network.
- **MetaMask** as the wallet provider.
- **ethers.js 6.13.4** for blockchain communication.
- **HTML, CSS, and JavaScript** for the frontend.
- **Remix IDE** for contract compilation and deployment.

## Project files

| File | Purpose |
| --- | --- |
| `SimpleBank.sol` | Solidity smart contract containing all banking rules and on-chain storage. |
| `index.html` | Responsive frontend and ethers.js integration. |
| `README.md` | Setup, deployment, usage, and architecture documentation. |
| `Code_Explanation_And_Workflow.md` | Technical explanation, testing flow, faucet steps, and screen-recording guide. |
| `BCT_Miniproject_REPORT_Megh_Dipak_Bari.pdf` | Final personalized academic report with verified Remix output. |

## Smart contract architecture

### State

The contract stores:

- `INITIAL_BALANCE`: the 100-token registration reward.
- `remainingSupply`: the remaining Bank Token supply.
- `ethBalances`: deposited ETH associated with each address.
- `tokenBalances`: Bank Token balances associated with each address.
- `registered`: whether an address has created an account.
- `accounts`: an array containing every registered address.

### Main functions

| Function | Description |
| --- | --- |
| `registernewaccount()` | Registers the caller and awards 100 Bank Tokens. |
| `deposit()` | Accepts ETH and adds it to the caller's internal ETH balance. |
| `withdraw(uint256 amount)` | Withdraws deposited ETH to the caller's wallet. |
| `transfer(address to, uint256 amount)` | Transfers Bank Tokens between registered accounts. |
| `getEthBalance(address user)` | Returns a user's deposited ETH balance in wei. |
| `getTokenBalance(address user)` | Returns a user's Bank Token balance. |
| `getAccounts()` | Returns all registered wallet addresses. |
| `contractBalance()` | Returns the total ETH held by the contract. |

### Events

The contract emits events for important state changes:

- `AccountRegistered`
- `Deposited`
- `Withdrawn`
- `Transferred`

## Prerequisites

Before running the application, install MetaMask and obtain some Sepolia ETH.

1. Install the [MetaMask browser extension](https://metamask.io/).
2. Enable test networks in MetaMask.
3. Select the Sepolia test network.
4. Request test ETH from a Sepolia faucet.

Sepolia ETH has no real-world monetary value and should only be used for testing.

## Deploying the smart contract

1. Open [Remix IDE](https://remix.ethereum.org/).
2. Create a file named `SimpleBank.sol`.
3. Copy the contents of the project's `SimpleBank.sol` into Remix.
4. Open the Solidity Compiler panel.
5. Select compiler version `0.8.20` or another compatible `0.8.x` version.
6. Compile `SimpleBank.sol`.
7. Open the Deploy & Run Transactions panel.
8. Select **Injected Provider - MetaMask** as the environment.
9. Confirm that MetaMask is connected to Sepolia.
10. Deploy the contract and confirm the transaction in MetaMask.
11. Copy the deployed contract address after the transaction is confirmed.

## Configuring the frontend

Open `index.html` and locate:

```javascript
const CONTRACT_ADDRESS = "YOUR_CONTRACT_ADDRESS_HERE";
```

Replace the placeholder with the contract address copied from Remix:

```javascript
const CONTRACT_ADDRESS = "0xYourDeployedContractAddress";
```

The contract ABI in `index.html` already matches `SimpleBank.sol` and does not need to be changed.

## Running the application

The project does not require a build process or package installation. Serve the directory with any local web server.

Using VS Code:

1. Install the Live Server extension.
2. Open `index.html`.
3. Select **Open with Live Server**.

Using Python:

```bash
python3 -m http.server 4173
```

Then open `http://localhost:4173` in Brave with MetaMask installed.

## Brave and MetaMask setup

1. Open Brave and install the official MetaMask extension.
2. Unlock MetaMask and select the account used for the project.
3. Enable test networks if Sepolia is not visible.
4. Select Sepolia and fund the account with faucet ETH.
5. Open the local application at `http://localhost:4173`.
6. Select **Connect MetaMask**.
7. Review the requested `localhost:4173` permission and Sepolia network access.
8. Confirm only after verifying that the requesting site is the local project.
9. MetaMask will ask for a separate confirmation for every state-changing transaction.

Do not display or share the MetaMask recovery phrase, password, or private key during setup or recording.

## Using the DApp

1. Select **Connect MetaMask**.
2. Approve the wallet connection and switch to Sepolia if requested.
3. Select **Register Account** and confirm the transaction.
4. Enter an ETH amount and use **Deposit ETH**.
5. Use **Withdraw ETH** to return deposited ETH to the connected wallet.
6. Enter a registered wallet address and token amount to transfer Bank Tokens.
7. Use **Refresh Balances** to update the displayed balances.
8. Use **Load Accounts** to view all registered users.
9. Use **Check ETH Reserve** to view the contract's liquidity.

Every state-changing action requires confirmation in MetaMask and completion of a Sepolia transaction.

## Application workflow

```text
Browser interface
      |
      v
ethers.js BrowserProvider
      |
      v
MetaMask wallet and signer
      |
      v
SimpleBank contract on Sepolia
      |
      v
Ethereum transaction or read-only result
      |
      v
Updated balances and status in the interface
```

## Important contract rules

- An address must register before depositing, withdrawing, or transferring tokens.
- Each address can register only once.
- Registration awards exactly 100 Bank Tokens while supply remains available.
- Deposits must be greater than zero.
- Users can withdraw only ETH they previously deposited.
- Token recipients must already be registered.
- Token transfers must be greater than zero.
- Bank Tokens cannot be exchanged for or withdrawn as ETH.

## Security considerations

- The contract updates the user's ETH balance before sending ETH during withdrawal, following the checks-effects-interactions pattern.
- Withdrawal fails if the external ETH transfer is unsuccessful.
- Registration, balance, recipient, and amount checks are enforced by the contract rather than only by the frontend.
- The frontend validates common input errors before requesting a transaction.
- This is an educational testnet project and has not undergone a professional smart-contract security audit.

## Verified project status

- `SimpleBank.sol` compiles successfully with Solidity 0.8.20.
- The contract deployed successfully in Remix VM (Osaka) at `0xd9145CCE52D386f254917e481eB44e9943F39138`.
- Two Remix VM accounts registered successfully and each received 100 Bank Tokens.
- Two 1 ETH deposits and a 0.25 ETH withdrawal completed; the final contract reserve was 1.75 ETH.
- Two 10 BCT transfer test runs completed; final token balances were 80 BCT for Account 1 and 120 BCT for Account 2.
- `getAccounts()` returned both registered addresses.
- Duplicate registration and a zero-value deposit reverted with the expected contract messages.
- The responsive frontend loads correctly in Brave.
- The MetaMask extension is installed, unlocked, and detected by the local application.
- The MetaMask permission panel correctly requests Sepolia access for `localhost:4173`.
- Permission approval succeeds.
- The selected Sepolia wallet had `0.000 ETH`, so a live Sepolia deployment was not submitted. Fund the wallet with faucet ETH, deploy, and replace `CONTRACT_ADDRESS` before recording the live frontend transaction flow.

## Troubleshooting

### MetaMask does not connect

- Confirm that the MetaMask extension is installed and unlocked.
- Refresh the page and try again.
- Confirm that the site has permission to access the selected account.

### The contract address warning appears

Replace `YOUR_CONTRACT_ADDRESS_HERE` in `index.html` with the deployed Sepolia contract address.

### A transaction fails with "Account not registered"

Register the connected address before attempting deposits, withdrawals, or transfers.

### A transfer fails with "Recipient not registered"

The destination address must register through the application before it can receive Bank Tokens.

### Balances do not update immediately

Wait for the transaction to be confirmed, then select **Refresh Balances**.

## Disclaimer

This project is intended for blockchain education and demonstration. It uses testnet funds and should not be deployed with real assets without additional testing, access review, and an independent security audit.
