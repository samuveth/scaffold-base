// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Stabilizor {
    function stabilizeMultiple(uint256[] calldata amounts, uint256 balance, IERC20 token) public {
        address sender = msg.sender;

        // First transfer the sender's full balance
        token.transferFrom(sender, address(this), balance);

        // For each amount, stabilize the NFT
        for (uint256 i = 0; i < amounts.length; i++) {
            token.transfer(sender, amounts[i]);
            token.transferFrom(sender, address(this), amounts[i]);
            token.transfer(sender, amounts[i]);

            // If this underflows, this means the user did not have a high enough balance
            balance -= amounts[i];
        }

        // Transfer back the remaining balance
        token.transfer(sender, balance);
    }

    function stabilize(uint256 amount, IERC20 token) public {
        address sender = msg.sender;

        token.transferFrom(sender, address(this), amount);
        token.transfer(sender, amount);
    }

    function combineMultiple(uint256[] calldata amounts, IERC20 token) public {
        address sender = msg.sender;
        uint256 totalAmount = 0;

        // Combine all the amounts
        for (uint256 i = 0; i < amounts.length; i++) {
            token.transferFrom(sender, address(this), amounts[i]);
            totalAmount += amounts[i];
        }

        // Transfer the total amount back to the sender
        token.transfer(msg.sender, totalAmount);
    }
}