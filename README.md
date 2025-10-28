# 💰 KipuBank — Bóveda personal en ETH con límites seguros

Contrato inteligente en Solidity que permite a los usuarios **depositar y retirar ETH (tokens nativos)** en una bóveda personal, cumpliendo buenas prácticas del Módulo 2:
- Límite **global** de depósitos (`BANK_CAP`) definido en el constructor.
- Límite **máximo por retiro** (`WITHDRAW_CAP`) inmutable por transacción.
- **Eventos** en depósitos y retiros.
- **Contadores** de operaciones.
- Seguridad con patrón **Checks → Effects → Interactions**.
- Mensajes claros usando **`require()`** (versión básica sin errores personalizados).

---

## ✨ Funcionalidades
- `deposit()` (`public payable`): deposita ETH en tu cuenta dentro del contrato.
- `withdraw(uint256 amount)` (`external`): retira ETH (≤ `WITHDRAW_CAP` y ≤ tu saldo).
- `viewBalance()` (`external view`): consulta tu saldo interno.
- `receive()` / `fallback()` (`external payable`): si envías ETH directo, se trata como depósito.
- Contadores: `depositCount`, `withdrawCount`.
- Eventos: `Deposited(user, amount)`, `Withdrawn(user, amount)`.

---

## 🧩 Variables clave
- `BANK_CAP` (`immutable`): tope global de depósitos (en wei).
- `WITHDRAW_CAP` (`immutable`): tope por retiro (en wei).
- `balanceOf(address)`: mapping de saldos por usuario.
- `totalDeposited`: total global depositado.

---

## 🧱 Seguridad
- **CEI** en `withdraw`: primero validaciones (`require`), luego actualización de estado, y al final la interacción externa (envío de ETH).
- Envío nativo con `.call{value: amount}("")` + `require(success, "Error en la transferencia")`.
- Límites para evitar retiros grandes y tope de TVL (`BANK_CAP`).

---

## ⚙️ Deploy local (Remix VM)
1. Abre [Remix](https://remix.ethereum.org/).
2. Crea `contracts/KipuBank.sol` y pega el contrato.
3. Compila con **Solidity 0.8.24**, optimization ON (runs 200).
4. Deploy (Remix VM):
   - `_bankCap`: `10000` (wei)
   - `_withdrawCap`: `100` (wei)

### Pruebas rápidas
- **Depositar**: en `VALUE` escribe, p. ej., `50` (unidad **wei**) → `deposit()`.
- **Retirar**: 
  - `withdraw(80)` → OK si saldo ≥ 80 y cap=100.
  - `withdraw(120)` → falla (“Excede el limite por retiro”).
  - `withdraw(80)` sin haber depositado → falla (“Saldo insuficiente”).
- **Consultar**: `viewBalance()` y/o `balanceOf(<tuAddress>)`.

---

## 🌐 Deploy en Sepolia (testnet)
1. MetaMask en **Sepolia** con ETH de faucet.
2. En Remix → **Deploy & Run** → Environment: **Injected Provider – MetaMask**.
3. Constructor:
   - `_bankCap = 10000`
   - `_withdrawCap = 100`
4. Deploy y confirma en MetaMask.

### Verificación en Etherscan (Sepolia)
1. Abre tu contrato en `sepolia.etherscan.io`.
2. **Code → Verify and Publish**:
   - Compiler: **0.8.24**
   - License: **MIT**
   - Optimization: **Yes** (runs 200)
3. Opción Single file → pega `KipuBank.sol` → Verify.

---

## 🔗 Entregables (completa estos campos)
- **Dirección del contrato (Sepolia):** `<0x...>`
- **Código verificado:** `<https://sepolia.etherscan.io/address/0x...#code>`
- **Repositorio GitHub (público):** `<https://github.com/<tu-usuario>/kipu-bank>`

---

## 📁 Estructura del repo

