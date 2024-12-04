// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.2;

// Joke - setup, punchline, creator, isDeleted - boolean (isAdmin, isPublic, isActive) - struct
// mapping - store all jokes
// mapping - balances - users - store rewards balance
// event- JokeCreated, jokeRewared, balanceWithdrawn
// constant - dynamic - tip - NFT auctions - fixed price - bidding process - for meme uploading - have voting for the most funny joke
// function - createJoke, rewardJoke, withdrawBalance, deleteJoke

contract Jokes {

    struct Joke {
        string setup;
        string punchline;
        address creatorAddress;
        bool isDeleted;
    }

    uint256 public numberOfJokes;

    mapping(uint256 => Joke) public jokes;
    mapping(address => uint256) public creatorBalances;
    mapping(address => uint256) public rewardAmounts;

    uint256 public constant CLASSIC_REWARD = 0.001 ether;
    uint256 public constant FUNNY_REWARD = 0.005 ether; // DEFINE IDs ON THE constructor

    // token distribution
    // - founder - 20%
    // - team - 20%
    // - community - 40%
    // - reserve - 10%
    // - marketing - 10%

    event JokeCreated(uint256 indexed jokeId, address indexed creatorAddress);
    event JokeRewarded(uint256 indexed jokeId, uint256 rewardType, uint256 rewardAmount);
    event BalanceWithdrawn(address indexed creatorAddress, uint256 amount);
    event JokeDeleted(uint256 indexed jokeId);

    constructor () {
        rewardAmounts[1] = CLASSIC_REWARD;
        rewardAmounts[2] = FUNNY_REWARD;
    }


    function createJoke(string memory _setup, string memory _punchline) public  {
        jokes[numberOfJokes] = Joke(_setup, _punchline, msg.sender, false);
        emit JokeCreated(numberOfJokes, msg.sender);
        numberOfJokes++; // Access DataBase - Auto generate ID - 1,2,3 - 5656, UUID
    }


    function getJokes() public view returns (Joke[] memory) {
        Joke[] memory allJokes = new Joke[](numberOfJokes);
        uint counter = 0;

        for (uint256 i = 0; i < numberOfJokes; i++) {
            if(!jokes[i].isDeleted) { // isSold
                allJokes[counter] = jokes[i]; // not deleted jokes
                counter++;
            }
        }

        if (counter == numberOfJokes) {
            // should display all the jokes plus the deleted
            return allJokes;
        } else {
            Joke[] memory filteredJokes = new Joke[](counter); // we have created a new array for non deleted jokes - non deleted products
            for (uint256 i = 0; i < counter; i++) { // index 0, 1, 2, 3
              filteredJokes[i] = allJokes[i];
            }

            return filteredJokes;
        }
    }

    function rewardJoke(uint256 _jokeId, uint256 _rewardType) public payable {
        require(_jokeId < numberOfJokes, "Invalid Joke ID OR Index!") ;
        require(!jokes[_jokeId].isDeleted, "Joke Removed!"); // logic ope || > == && < <= !
        require(_rewardType >= 1 && _rewardType <= 2, "Reward type must be between 1 and 2!");

        uint256 rewardAmount = rewardAmounts[_rewardType];
        require(msg.value == rewardAmount, "Incorrect reward amount!");

        creatorBalances[jokes[_jokeId].creatorAddress] += rewardAmount;
        emit JokeRewarded(_jokeId, _rewardType, rewardAmount);
    }


    function withdrawBalance() public {
        uint256 balance = creatorBalances[msg.sender];
        require(balance > 0, "No balance to withdraw!");

        // security - reentrancy, overflow and underflow
        creatorBalances[msg.sender] = 0;

        // .call
        (bool success, ) = payable(msg.sender).call{value: balance}(""); // transfer
        require(success, "Failed to withdraw Ether balance");

        emit BalanceWithdrawn(msg.sender, balance);
    }

    function deleteJoke(uint256 _jokeId) {
        require(_jokeId < numberOfJokes, "Invalid Joke ID OR Index!") ;
        require(jokes[_jokeId].creatorAddress == msg.sender, "Only the joke creator can delete the joke!"); //
        require(!jokes[_jokeId].isDeleted, "Joke Already Removed!"); 

        jokes[_jokeId] = Joke("", "", address(0), true);

        emit JokeDeleted(_jokeId);
    }
}