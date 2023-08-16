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
        address address_player;
        //Bid of a player in game
        uint256 bid;
    }

    struct InfoGame {
        //Maximum amount of players in each game
        uint256 max_amount_players;
        //Actual amount of players
        uint256 amount_players;
        //Minimum bid to join each game
        uint256 min_bid;
        //Sum of all bids made by players in this game
        uint256 sum_bids;
    }

    //Array which stores all games (ended and running)
    mapping(uint256 => InfoGame) public game;

    //Matrix which stores all the players in each game
    mapping(uint256 => mapping(uint256 => InfoPlayer)) public player;

    //Indexes of running games (might be infinity => uint256)
    uint256[] games;

    //Amount of games (might be infinity => uint256)
    uint256 gamesCount;

    //Initializing new game
    function initGame(uint256 _index_game, uint256 _max_amount_players, uint256 _min_bid) private {
        //Number of current games is equal to index of new game
        games.push(gamesCount);
        //Initializaing requirements and information about new game
        game[_index_game].max_amount_players = _max_amount_players;
        game[_index_game].amount_players = 1;
        game[_index_game].min_bid = _min_bid;
        game[_index_game].sum_bids += _min_bid;
    }
    //Initializing new player in game
    function initPlayer(uint256 _index_game, uint256 _index_player, uint256 _bid, address _address_player) private {
        //Initializing information about player in each game
        player[_index_game][_index_player].address_player = _address_player;
        player[_index_game][_index_player].bid = _bid;
    }

    //Requiring that bid is over 0
    modifier isBidOverNull(uint256 _bid) {
        require(_bid > 0, "You must bit at least something to join/start game");
        _;
    }

    //Requiring that there is no players overflow in game
    modifier isPlayersOverflow(uint256 _player, uint256 _max_players) {
        require(_player < _max_players, "The maximum number of players in the game has already been reached");
        _;
    }

    //Requiring that current bid is over minimal bid in this game
    modifier isOverMinBid(uint256 _bid, uint256 _min_bid) {
        require(_bid >= _min_bid, "Your bid must be at least equal to the minimum bid game in this game");
        _;
    }

    //Starting new game
    function newGame(uint256 _max_amount_players) public payable isBidOverNull(msg.value){
        initGame(gamesCount, _max_amount_players, msg.value);
        initPlayer(gamesCount, 0, msg.value, msg.sender);
        gamesCount++;
    }

    //Making bid
    function bid(uint256 _index_game) public payable isBidOverNull(msg.value) isPlayersOverflow(game[_index_game].amount_players, game[_index_game].max_amount_players) isOverMinBid(msg.value, game[_index_game].min_bid){
        initPlayer(_index_game, game[_index_game].amount_players, msg.value, msg.sender);
        game[_index_game].amount_players++;
        game[_index_game].sum_bids += msg.value;
    }

    //Transacting to winner
    function transactWinner(uint256 _index_game, uint256 amount_winners) public payable {
        payable(msg.sender).transfer(game[_index_game].sum_bids / amount_winners);
    }
}