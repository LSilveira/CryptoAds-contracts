// contracts/CriptoEscudo.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Ads is ERC20 {

    constructor(uint256 initialSupply) ERC20("Ads token", "ADS") {
        _mint(msg.sender, initialSupply);
    }

}