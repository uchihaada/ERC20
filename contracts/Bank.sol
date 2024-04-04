// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// interface MyTokenERC20 {
//     function transferFrom(
//         address sender,
//         address recipient,
//         uint256 amount
//     ) external returns (bool);

//     function transfer(
//         address recipient,
//         uint256 amount
//     ) external returns (bool);

//     function balanceOf(address account) external view returns (uint256);
// }

contract TokenBank {
    IERC20 public token;

    struct Deposit {
        uint256 money;
        uint256 time;
    }

    mapping(address => uint256) public depositBalance;
    mapping(address => Deposit[]) public depositLog;
    uint256 private timeDelay = 20 seconds;

    constructor(address _tokenAddress) {
        token = IERC20(_tokenAddress);
    }

    function deposit(uint256 amount) external {
        require(amount > 0, "amount cannot be zero");
        require(getBalance(msg.sender) >= amount, "Insufficient Token");

        uint256 currentTime = block.timestamp + timeDelay;
        depositLog[msg.sender].push(Deposit(amount, currentTime));

        depositBalance[msg.sender] += amount;
        require(
            token.transferFrom(msg.sender, address(this), amount),
            "line20"
        );
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Withdrawal amount must be greater than 0");
        require(depositBalance[msg.sender] >= amount, "line 26");

        uint256 currentTime = block.timestamp;
        uint256 withdrawableMoney = 0;
        for (uint256 i = 0; i < depositLog[msg.sender].length; i++) {
            if (currentTime >= depositLog[msg.sender][i].time) {
                withdrawableMoney += depositLog[msg.sender][i].money;
            }
        }

        require(
            withdrawableMoney >= amount,
            "Not enough available to withdrwa"
        );
        depositBalance[msg.sender] -= amount;
        require(token.transfer(msg.sender, amount), "line29");
    }

    function getBalance(address person) public view returns (uint256) {
        return token.balanceOf(person);
    }
}

// Author : uchihaada
