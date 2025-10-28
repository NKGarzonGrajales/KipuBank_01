// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title KipuBank
 * @author N.K.G.G.
 * @notice Este contrato permite a los usuarios depositar y retirar ETH de una bóveda personal.
 * @dev Incluye límite global de depósitos, límite máximo de retiro y buenas prácticas CEI.
 */

contract KipuBank {
    /* -------------------------------------------------------
       VARIABLES PRINCIPALES
    -------------------------------------------------------- */

    // Límite máximo de retiro por transacción (inmutable, se define una sola vez)
    uint256 public immutable WITHDRAW_CAP;

    // Límite global de depósitos permitidos (inmutable)
    uint256 public immutable BANK_CAP;

    // Total global de ETH depositados en el contrato
    uint256 public totalDeposited;

    // Guarda el saldo individual de cada usuario
    mapping(address => uint256) public balanceOf;

    // Contadores de operaciones
    uint256 public depositCount;
    uint256 public withdrawCount;

    /* -------------------------------------------------------
       EVENTOS
       (sirven para registrar acciones importantes en la blockchain)
    -------------------------------------------------------- */
    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    /* -------------------------------------------------------
       CONSTRUCTOR
       (se ejecuta una sola vez al desplegar el contrato)
    -------------------------------------------------------- */
    constructor(uint256 _bankCap, uint256 _withdrawCap) {
        require(_bankCap > 0, "El limite global no puede ser cero");
        require(_withdrawCap > 0, "El limite de retiro no puede ser cero");

        BANK_CAP = _bankCap;           // ej: 10000 wei
        WITHDRAW_CAP = _withdrawCap;   // ej: 100 wei
    }

    /* -------------------------------------------------------
       FUNCION PARA DEPOSITAR (EXTERNAL PAYABLE)
       payable = permite recibir ETH
    -------------------------------------------------------- */
    function deposit() public payable {
        // 1️⃣ CHECKS
        require(msg.value > 0, "Debes enviar ETH mayor que cero");
        require(
            totalDeposited + msg.value <= BANK_CAP,
            "Se alcanzo el limite global de depositos"
        );

        // 2️⃣ EFFECTS (actualizo variables internas)
        balanceOf[msg.sender] += msg.value;
        totalDeposited += msg.value;
        depositCount++;

        // 3️⃣ INTERACTIONS (registro el evento)
        emit Deposited(msg.sender, msg.value);
    }

    /* -------------------------------------------------------
       FUNCION PARA RETIRAR (EXTERNAL)
       Permite retirar ETH limitado por WITHDRAW_CAP
    -------------------------------------------------------- */
    function withdraw(uint256 amount) external {
        // 1️⃣ CHECKS
        require(amount > 0, "Monto invalido");
        require(amount <= WITHDRAW_CAP, "Excede el limite por retiro");
        require(balanceOf[msg.sender] >= amount , "Saldo insuficiente");

        // 2️⃣ EFFECTS
        balanceOf[msg.sender] -= amount;
        withdrawCount++;

        // 3️⃣ INTERACTIONS (envio ETH al usuario)
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Error en la transferencia");

        emit Withdrawn(msg.sender, amount);
    }

    /* -------------------------------------------------------
       FUNCION DE SOLO LECTURA (VIEW)
       Permite consultar el saldo del usuario
    -------------------------------------------------------- */
    function viewBalance() external view returns (uint256) {
        return balanceOf[msg.sender];
    }

    /* -------------------------------------------------------
       FUNCIONES PARA RECIBIR ETH DIRECTO
       Si alguien envia ETH sin llamar a deposit(), igual se cuenta
    -------------------------------------------------------- */
    receive() external payable {
        deposit(); // redirige al mismo proceso de deposito
    }

    fallback() external payable {
        deposit(); // si envian datos erroneos, tambien se deposita
    }
}


