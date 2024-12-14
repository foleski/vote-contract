// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract Voting {
    address owner;
    mapping (address => bool) condidates;
    address[] public condidatesArray;
    mapping (address => uint) voters;
    mapping (address => uint) votes;
    bool active = true;
    address public winner;

    event AnnouncementWinner(address indexed winner, uint indexed votesAmount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(owner == msg.sender, "You are not an owner!");
        _;
    }

    function candidatesRegistration(address condidate) external onlyOwner {
        condidates[condidate] = true;
        condidatesArray.push(condidate);
    }

    function registerToVoting() external {
        voters[msg.sender] = 1;
    }

    function vote(address condidate) external {
        if (voters[msg.sender] == 1 && condidates[condidate] && active) {
            votes[condidate] += 1;
            voters[msg.sender] += 1;
        } else {
            revert("You have already voted or You hadn't registred or There's no such candidate on the list!");
        }
    }

    function result() external onlyOwner{
        address winnerHere;
        uint maxVotes;

        for (uint i; i < condidatesArray.length; i++) {
            if (votes[condidatesArray[i]] > maxVotes) {
                maxVotes = votes[condidatesArray[i]];
                winnerHere = condidatesArray[i];
            }
        }

        winner = winnerHere;
        active = false;

        emit AnnouncementWinner(winnerHere, votes[winnerHere]);
    }
}