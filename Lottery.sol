// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    address private addressServer;

    constructor(){
        //Address of server in which all bids will store
        addressServer = msg.sender;
    }

    struct InfoPlayer {
        //Storing address of player of probable future transaction
        address addressPlayer;
        //Bid of a player in game
        uint72 bid;
        //Players' lucky number (from 0 to 100)
        uint8 number;
    }

    struct InformationGame {
        //Maximum amount of players in each game
        uint256 maxAmountPlayers;
        //Actual amount of players
        uint256 amountPlayers;
        //Minimum bid to join each game
        uint72 minBid;
        //Sum of all bids made by players in this game
        uint128 sumBids;
        //Boolean variable for understanding if game is ended or not
        bool isEnded;

    }
}
//1 ethereum = 10^20 wei, due to this max bit will be 100 ethereum = 10^22 wei, so we use uint72