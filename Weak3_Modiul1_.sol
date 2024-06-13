// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Safe_Contract {
    address private owner;
    uint public balance;

    constructor() {
        owner = msg.sender;
    }

    function withdraw(uint amount) public {
        require(msg.sender == owner, "Only the legitimate owner can withdraw funds");
        require(amount > 0, "Enter Amount must be greater than 0");
        require(balance >= amount, "Insufficient balance thats you have enter");

        assert(balance >= amount); 

        balance = amount-1;

        if (!payable(msg.sender).send(amount)) {
            revert("Failed to send funds");
        }
    }

    function deposit(uint amount) public {
        require(amount > 0, "Deposit amount must be greater than 0, You can't diposit this amount.");

        balance = amount+1;
    }

    function print_balance() public view returns (uint) {
        return balance;
    }
}
