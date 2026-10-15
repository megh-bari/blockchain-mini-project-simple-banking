// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleBank {
    // Initial tokens given to each new account
    uint256 public constant INITIAL_BALANCE = 100;
    uint256 public remainingSupply = 1000000;

    // Option A Architecture: Separate ETH balances and BANK token balances
    mapping(address => uint256) private ethBalances;
    mapping(address => uint256) private tokenBalances;

    // Check whether an address has registered
    mapping(address => bool) public registered;

    // Store all registered accounts
    address[] public accounts;

    // Events
    event AccountRegistered(address indexed user, uint256 tokenBonus);
    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event Transferred(address indexed from, address indexed to, uint256 amount);

    modifier onlyRegistered() {
        require(registered[msg.sender], "Account not registered");
        _;
    }

    // -----------------------------------
    // Register New Account
    // -----------------------------------
    function registernewaccount() external {
        require(!registered[msg.sender], "Account already registered");
        require(remainingSupply >= INITIAL_BALANCE, "Supply exhausted");

        registered[msg.sender] = true;
        
        // Give 100 tokens to the new account
        tokenBalances[msg.sender] = INITIAL_BALANCE;
        remainingSupply -= INITIAL_BALANCE;
        accounts.push(msg.sender);

        emit AccountRegistered(msg.sender, INITIAL_BALANCE);
    }

    // -----------------------------------
    // Deposit ETH
    // -----------------------------------
    function deposit() external payable onlyRegistered {
        require(msg.value > 0, "Deposit must be greater than 0");

        // Add deposited ETH amount to internal ETH balance
        ethBalances[msg.sender] += msg.value;

        emit Deposited(msg.sender, msg.value);
    }

    // -----------------------------------
    // Withdraw ETH
    // -----------------------------------
    function withdraw(uint256 amount) external onlyRegistered {
        require(amount > 0, "Amount must be greater than 0");
        require(ethBalances[msg.sender] >= amount, "Insufficient ETH balance");

        // Update balance BEFORE sending ETH
        ethBalances[msg.sender] -= amount;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "ETH transfer failed");

        emit Withdrawn(msg.sender, amount);
    }

    // -----------------------------------
    // Transfer Tokens (Bank Tokens)
    // -----------------------------------
    function transfer(address to, uint256 amount) external onlyRegistered {
        require(to != address(0), "Invalid recipient");
        require(registered[to], "Recipient not registered");
        require(amount > 0, "Amount must be greater than 0");
        require(tokenBalances[msg.sender] >= amount, "Insufficient token balance");

        // Deduct from sender
        tokenBalances[msg.sender] -= amount;

        // Add to recipient
        tokenBalances[to] += amount;

        emit Transferred(msg.sender, to, amount);
    }

    // -----------------------------------
    // Check Balances
    // -----------------------------------
    function getEthBalance(address user) external view returns (uint256) {
        return ethBalances[user];
    }

    function getTokenBalance(address user) external view returns (uint256) {
        return tokenBalances[user];
    }

    // -----------------------------------
    // Get All Registered Accounts
    // -----------------------------------
    function getAccounts() external view returns (address[] memory) {
        return accounts;
    }

    // -----------------------------------
    // Contract ETH Balance
    // -----------------------------------
    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
