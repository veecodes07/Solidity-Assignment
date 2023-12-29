// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract TokenSale is Ownable {
    using SafeMath for uint256;

    // Token information
    string public tokenName;
    string public tokenSymbol;
    uint256 public tokenPrice; // Token price in USD (e.g., 1 USD = 100 tokens)

    // Event to log payment details
    event PaymentReceived(address indexed buyer, uint256 amountInUSD, uint256 numberOfTokens);

    // Struct to store payment details
    struct Payment {
        uint256 amountInUSD;
        uint256 numberOfTokens;
    }

    // Mapping to store payments made by users
    mapping(address => Payment) public payments;

    //Set initial paramaeters
    constructor(string memory _tokenName, string memory _tokenSymbol, uint256 _tokenPrice) public {
        tokenName = _tokenName;
        tokenSymbol = _tokenSymbol;
        tokenPrice = _tokenPrice;
    }

    //record payments
    function recordPayment(uint256 _amountInUSD) external returns (uint256 numberOfTokens) {
        require(_amountInUSD > 0, "Amount must be greater than zero");

        // Calculate the number of tokens based on  token price
        numberOfTokens = _amountInUSD.mul(1e18).div(tokenPrice);//CONVERSION TAKEN FROM THE NET

        // Record payment details
        payments[msg.sender] = Payment(_amountInUSD, numberOfTokens);

        
        //RETURNS ADDRESS, AMOUNT IN USD AND NUMBER OF TOKENS
        emit PaymentReceived(msg.sender, _amountInUSD, numberOfTokens);

        return numberOfTokens;
    }

    //update token price
    function updateTokenPrice(uint256 _newTokenPrice) external onlyOwner {
        require(_newTokenPrice > 0, "Token price must be greater than zero");
        tokenPrice = _newTokenPrice;
    }

    //retrieve payment for a user
    function getPaymentDetails(address _buyer) external view returns (uint256 amountInUSD, uint256 numberOfTokens) {
        Payment storage payment = payments[_buyer];
        return (payment.amountInUSD, payment.numberOfTokens);
    }
}