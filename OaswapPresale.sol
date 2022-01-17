// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";


contract OaswapPresale is Ownable {
    using SafeMath for uint256;

    address[20] public winnerArray;

    mapping(address => uint256) public walletTotalSent;

    constructor() public {}

    /**
        @notice Add winner address list
        @param _list Array of winning addresses
     */
    function addWinnerList(address[20] memory _list) external onlyOwner() {
        winnerArray = _list;
    }

    /**
        @notice Check wallet address for winner
        @param _wallet Wallet address to check
     */
    function checkWinner(address _wallet) public view returns (bool) {
        for (uint256 i = 0; i < winnerArray.length; i++) {
            if (winnerArray[i] == _wallet) {
                return true;
            }
        }

        return false;
    }

    /**
        @notice Send ROSE
        @param _wallet Wallet address to check
     */
    function sendRose(address _wallet) payable external {
        require(checkWinner(_wallet), "Not winner");
        
        uint256 roseSent = msg.value;
        walletTotalSent[msg.sender] = walletTotalSent[msg.sender] + roseSent;
    }

    /**
        @notice View the contract's ROSE balance
     */
    function getRoseBalance() public view returns (uint256) {
        return address(this).balance;
    }

    /**
        @notice Withdraw the contract's ROSE by owner only
     */
    function withdrawRose() external onlyOwner() {
        uint256 contractBalance = getRoseBalance();
        msg.sender.transfer(contractBalance);
    }
}
