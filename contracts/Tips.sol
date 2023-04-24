// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

contract Tips {

    uint256 totalTips;
    address payable public owner;
    
    constructor() payable {
        owner = payable(msg.sender);

    }

    event Tip(address indexed from, uint256 amount);

    struct Tipper {
        address payable tipper;
        uint256 amount;
    }

    mapping(address => Tipper) public tipper;

    function tip() public payable {
        require(msg.value > 0, "You must send some Ether");
        tipper[msg.sender].tipper = payable(msg.sender);
        tipper[msg.sender].amount += msg.value;
        totalTips += msg.value;
        emit Tip(msg.sender, msg.value);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    function withdraw() public onlyOwner{
        uint256 amount = totalTips;
        totalTips = 0;
        (bool success, ) = owner.call{value: amount}("");
        require(success, "Failed to send Ether");
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getTipperBalance() public view returns (uint256) {
        return tipper[msg.sender].amount;
    }

    function getTipperAddress() public view returns (address) {
        return tipper[msg.sender].tipper;
    }

    function getTotalTips() public view returns (uint256) {
        return totalTips;
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function getContractAddress() public view returns (address) {
        return address(this);
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}