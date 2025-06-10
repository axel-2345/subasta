// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Subasta {
    address owner;
    uint expires;
    uint mayorOferta;
    address ganador;

    struct Oferta {
        address oferente;
        uint monto;
    }

    mapping(address => uint) depositos;
    Oferta[] historial;

    event nuevaOferta(address indexed oferente, uint monto);
    event subastaFinalizada(address ganador, uint monto);

    modifier antesDeExpire() {
        require(block.timestamp < expires, "La subasta ya finalizo");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Solo el propietario puede ejecutar esta funcion.");
        _;
    }

    constructor(uint256 _duracionSegundos) {
        owner = msg.sender;
        expires = block.timestamp + _duracionSegundos;
    }

    function ofertar() external payable antesDeExpire {
        uint minOferta = mayorOferta + (mayorOferta * 5) / 100;
        if (mayorOferta == 0) {
            minOferta = 10 wei;
        }
        require(msg.value >= minOferta, "La oferta debe ser al menos 5% mayor");

        mayorOferta = msg.value;
        ganador = msg.sender;
        historial.push(Oferta(msg.sender, msg.value));
        depositos[msg.sender] += msg.value;

        if (expires - block.timestamp < 10 minutes) {
            expires += 10 minutes;
        }

        emit nuevaOferta(msg.sender, msg.value);
    }

    function mostrarGanador() external view returns (address, uint) {
        return (ganador, mayorOferta);
    }

    function mostrarOfertas() external view returns (Oferta[] memory) {
        return historial;
    }

    function claimOferta() external payable {
        require(block.timestamp >= expires, "La subasta no ha finalizado");
        require(msg.sender != ganador, "El ganador no puede retirar");
        uint deposito = depositos[msg.sender];
        require(deposito > 0, "No hay deposito para retirar");

        uint reembolso = (deposito * 98) / 100;
        depositos[msg.sender] = 0;
        payable(msg.sender).transfer(reembolso);
    }

    function finalizarSubasta() external onlyOwner {
        require(block.timestamp >= expires, "La subasta no ha finalizado");
        emit subastaFinalizada(ganador, mayorOferta);
        payable(owner).transfer(mayorOferta);
    }

    /**function claimParcial() external payable antesDeExpire {
    require(msg.sender != ganador, "El ganador no puede retirar durante la subasta");
    uint deposito = depositos[msg.sender];
    require(deposito > 0, "No hay deposito para retirar");

    uint reembolso = (deposito * 98) / 100;
    depositos[msg.sender] = 0;
    payable(msg.sender).transfer(reembolso);
    }*/
}
