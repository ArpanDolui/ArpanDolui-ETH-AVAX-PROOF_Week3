pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT

contract Token {
    address private owner;
    mapping (address => uint256) public balance;

    constructor() {
        owner = msg.sender;
    }

    modifier only_Owner() {
        require(msg.sender == owner, "Only the contract owner can mint tokens");
        _;
    }

    function mint(address recipient, uint256 amount) public only_Owner {
        balance[recipient] += amount;
    }

    function transfer(address recipient, uint256 amount) public {
        require(balance[msg.sender] >= amount, "Insufficient balance");
        balance[msg.sender] -= amount;
        balance[recipient] += amount;
    }

    function burn(uint256 amount) public {
        require(balance[msg.sender] >= amount, "Insufficient balance");
        balance[msg.sender] -= amount;
    }
}
