// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0; 

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract FundMe {

    mapping(address => uint256) public addressToAmountFunded;
    address [] funders;
    address public owner;
    uint256 public totalFundsRaised = address(this).balance;

    constructor() public {
        owner = msg.sender;
    }


    function fund() public payable {
        // Ex: $50
        uint256 minUSD = 50 * 10 **18;
        require(getConversionRate(msg.value) >= minUSD, "Currently not accepting donations valued below $50 USD");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
        totalFundsRaised += msg.value;
        // For conversion, what is ETH -> USD conversion rate?
    }

    function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 answer,,,)=priceFeed.latestRoundData();
        return uint256(answer * 10000000000); //Has 8 decimals fo USD, but want to convert to Wei standard
    }


    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _; //This line tells the program to run the rest of the code only if it meets the above requirements
    }


    function withdraw() payable onlyOwner public {
        payable(msg.sender).transfer(address(this).balance);
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }
}