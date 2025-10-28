
# 💰 KipuBank — Personal ETH Vault with Safe Limits

A Solidity smart contract that allows users to **deposit and withdraw ETH (native tokens)** into a personal vault while enforcing best security and design practices (Module 2).

---

## ✨ Features
- Global **deposit limit** (`BANK_CAP`) defined in the constructor.
- Maximum **withdraw limit per transaction** (`WITHDRAW_CAP`) defined as immutable.
- **Events** for deposits and withdrawals.
- **Operation counters** for deposits and withdrawals.
- Security implemented using the **Checks → Effects → Interactions (CEI)** pattern.
- Clear error messages using `require()` (basic version without custom errors).

---

## 🧩 Key Variables
- `BANK_CAP` (`immutable`): total global deposit limit (in wei).
- `WITHDRAW_CAP` (`immutable`): maximum withdraw amount per transaction (in wei).
- `balanceOf(address)`: mapping of user balances.
- `totalDeposited`: total global ETH deposited in the contract.

---

## ⚙️ Functions
- `deposit()` (`public payable`): deposit ETH into your account within the contract.
- `withdraw(uint256 amount)` (`external`): withdraw ETH (≤ `WITHDRAW_CAP` and ≤ your internal balance).
- `viewBalance()` (`external view`): check your own balance.
- `receive()` / `fallback()` (`external payable`): treat any direct ETH sent to the contract as a deposit.
- Counters: `depositCount`, `withdrawCount`.
- Events: `Deposited(address user, uint256 amount)` and `Withdrawn(address user, uint256 amount)`.

---

## 🧱 Security
- Implements **CEI** (Checks–Effects–Interactions) pattern in `withdraw`:
  1. Validate conditions (`require()`).
  2. Update internal state.
  3. Perform external ETH transfer.
- Uses `.call{value: amount}("")` + `require(success, "Transfer failed")` for safe transfers.
- Global and per-transaction limits prevent excessive withdrawals or large TVL exposure.

---

## 🧪 Local Deployment (Remix VM)
1. Open [Remix IDE](https://remix.ethereum.org/).
2. Create the file: `contracts/KipuBank.sol` and paste your contract code.
3. Compile with:
   - Compiler: **Solidity 0.8.24**
   - Optimization: **ON (200 runs)**
4. Deploy (Environment: Remix VM)
   - `_bankCap`: `10000` (wei)
   - `_withdrawCap`: `100` (wei)

### Quick Tests
- **Deposit:**  
  Set `VALUE = 50` (wei) → click `deposit()`.
- **Withdraw:**  
  - `withdraw(80)` → ✅ OK if balance ≥ 80 and cap = 100.  
  - `withdraw(120)` → ❌ fails (“Exceeds withdraw limit”).  
  - `withdraw(80)` without deposit → ❌ fails (“Insufficient balance”).
- **View balance:**  
  Run `viewBalance()` or `balanceOf(<yourAddress>)`.

---

## 🌐 Sepolia Deployment (Testnet)
1. Switch MetaMask to **Sepolia network** with faucet ETH.
2. In Remix → **Deploy & Run Transactions**, select:  
   Environment: **Injected Provider – MetaMask**.
3. Set constructor parameters:
   - `_bankCap = 10000`
   - `_withdrawCap = 100`
4. Click **Deploy** and confirm in MetaMask.

---

## ✅ Etherscan Verification
1. Go to your contract on [Sepolia Etherscan](https://sepolia.etherscan.io/).
2. Open **Code → Verify and Publish**.
3. Use the following settings:
   - Compiler: `v0.8.24+commit.e11b9ed9`
   - License: **MIT**
   - Optimization: **Yes (200 runs)**
4. Choose “Single file” and paste your full Solidity code.  
5. Paste constructor ABI-encoded values:
0000000000000000000000000000000000000000000000000000000000002710
0000000000000000000000000000000000000000000000000000000000000064


---

## 🔗 Deliverables
- **Contract Address (Sepolia):** `0x17deC92be5Bc201d81f57C40FAcff670362e3018`
- **Verified Source Code:**  
[View on Etherscan](https://sepolia.etherscan.io/address/0x17deC92be5Bc201d81f57C40FAcff670362e3018#code)
- **GitHub Repository:**  
[https://github.com/NKGarzonGrajales/KipuBank_02](https://github.com/NKGarzonGrajales/KipuBank_02)

---

## 🧱 Repository Structure

KipuBank_02/
│
├── contracts/
│ ├── 4_KipuBank.sol
│ ├── 1_Storage.sol
│ ├── 2_Owner.sol
│ ├── 3_Ballot.sol
│
├── scripts/
│ ├── deploy_with_web3.ts
│ ├── deploy_with_ethers.ts
│
├── tests/
│ ├── Ballot_test.sol
│ ├── storage_test.js
│
├── remix.config.json
├── .prettierrc.json
├── README.md
└── .gitignore


---

## 🧑‍💻 Author
**N.K.G.G. (Nidia Karina Garzón Grajales)**  
Full-Stack Developer | Solidity & Web3 Student  
📍 Colombia  
🪙 “Learning never stops — blockchain is the new internet.”

