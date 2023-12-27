// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenSwap {

    address public token1;

    address public token2;

    address public owner;

    event TokensSwapped(address indexed fromToken, address indexed toToken, address indexed trader, uint256 amount);

    constructor(address token_1, address token_2) {
        token1 = token_1;
        token2 = token_2;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function swapTokens(uint256 _amount, address from_Token, address to_Token) external {
        require(to_Token == token1 || to_Token == token2, "Invalid to token");

        require(from_Token != to_Token, "Tokens must be different");

        require(_amount > 0, "Amount must be greater than zero");

        IERC20 fromToken = IERC20(from_Token);

        IERC20 toToken = IERC20(to_Token);

        
        uint256 receivedAmount = _amount;

        // Transfer tokens from the trader
        require(fromToken.transferFrom(msg.sender, address(this), _amount), "Failed to transfer fromToken");

        // Transfer tokens to the trader
        require(toToken.transfer(msg.sender, receivedAmount), "Failed to transfer toToken");

        emit TokensSwapped(from_Token, to_Token, msg.sender, receivedAmount);
    }

    function setOwner(address _newOwner) external onlyOwner {
        owner = _newOwner;
    }
}
