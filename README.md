# Stacks Yield Vault (SYV)

## Overview

The Stacks Yield Vault (SYV) is a Clarity smart contract designed to provide a simple liquidity vault for users to deposit STX tokens and earn yield from a reward pool. Users can deposit STX into the vault and, upon withdrawal, receive their deposited amount plus a proportional share of the reward pool. The contract also allows an admin to fund the reward pool.

## Features

- **Deposit STX**: Users can deposit STX tokens into the vault to earn yield.
- **Withdraw STX**: Users can withdraw their deposited STX along with a share of the reward pool.
- **Fund Reward Pool**: The admin can add funds to the reward pool to increase the yield for users.

## Contract Details

- **Admin**: The contract uses a constant `ADMIN` to define the admin, which is set to the transaction sender (`tx-sender`).
- **Global State**:
  - `total-deposits`: Tracks the total amount of STX deposited in the vault.
  - `reward-pool`: Tracks the total amount of STX available in the reward pool.
  - `user-balances`: A map that stores the balance of each user.

## Functions

### Public Functions

- **`(deposit (amount uint))`**: Allows users to deposit a specified amount of STX into the vault. The function checks for a positive deposit amount and transfers STX from the sender to the contract.

- **`(withdraw (amount uint))`**: Allows users to withdraw a specified amount of STX from the vault. The function checks for a positive withdrawal amount and sufficient balance, calculates the user's reward share, and transfers the total amount back to the user.

- **`(fund-rewards (amount uint))`**: Allows the admin to fund the reward pool with a specified amount of STX. The function checks that the caller is the admin and that the amount is positive.

### Read-Only Functions

- **`(get-user-balance (user principal))`**: Returns the balance of a specified user.
- **`(get-total-deposits)`**: Returns the total amount of STX deposited in the vault.
- **`(get-reward-pool)`**: Returns the total amount of STX in the reward pool.

## Error Codes

- **`u100`**: Invalid deposit amount.
- **`u101`**: STX transfer failed.
- **`u102`**: Insufficient balance for withdrawal.
- **`u104`**: Unauthorized access (not admin).
- **`u107`**: Invalid withdrawal amount.
- **`u108`**: Invalid reward funding amount.

## Usage

To interact with the Stacks Yield Vault, users can call the `deposit` and `withdraw` functions to manage their STX deposits and withdrawals. The admin can call the `fund-rewards` function to add funds to the reward pool. Users can also query their balance, total deposits, and the reward pool using the read-only functions.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
