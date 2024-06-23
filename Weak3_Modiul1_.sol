// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Voting_Machine {
    

    struct Voting_Session { 
        //  A new struct called VotingSession, which will be used to store information about each voting session.
        string title; 
        uint256 startTime; 
        uint256 endTime; 
        uint256 totalVotes; 
        
        mapping(address => bool) voters;  
        // Mapping of addresses to booleans, which will be used to track which addresses have voted.
        string[] options;  
        // Array of strings, representing the options available for voting.
        mapping(string => uint256) optionVotes;  
        // Mapping of option strings to vote counts.
    }

    address private owner; 
    // Private address variable to store the owner of the contract.
    mapping(uint256 => Voting_Session) public votingSessions; 
    // Public mapping of uint256 to VotingSession, which will be used to store all voting sessions.
    uint256 public sessionCount; 
    // Public uint256 variable to store the total number of voting sessions.

    constructor() {
        owner = msg.sender; 
        // owner of the contract to the address that deployed it.
        sessionCount = 0; 
    }

    function create_Voting_Session(string memory Title, uint256 StartTime, uint256 EndTime, string[] memory Options) public {
        
        require(msg.sender == owner, "Only the legitimate owner can create a voting session.");
        require(StartTime < EndTime, "Start time must be before end time.");

        Voting_Session storage newSession = votingSessions[sessionCount];
        // new VotingSession and stores it in the votingSessions mapping.
        newSession.title = Title; 
        newSession.startTime = StartTime; 
        newSession.endTime = EndTime; 
        newSession.totalVotes = 0; 
        newSession.options = Options; 

        for (uint256 i = 0; i < Options.length; i++) {
            // This line starts a loop to initialize the optionVotes mapping.
            newSession.optionVotes[Options[i]] = 0; 
            // This line initializes the vote count for each option to 0.
        }

        sessionCount++; 
        // increments the sessionCount variable.
    }

    function vote(uint256 sessionId, uint256 option) public {

        require(sessionId < sessionCount, "Invalid session ID, please recheck again.");
        Voting_Session storage session = votingSessions[sessionId];
        require(block.timestamp >= session.startTime || block.timestamp <= session.endTime, "Voting is not open, try again.");
        require(!session.voters[msg.sender], "You have already voted, you can't vote again.");
        // This line checks that the voter has not already voted.
        string memory optionString = session.options[option]; 
        require(option < session.options.length, "Invalid option");

        session.voters[msg.sender] = true; 
        // This line marks the voter as having voted.
        session.totalVotes++; 
        session.optionVotes[optionString]++; 

        emit VoteCast(sessionId, optionString, msg.sender);
        // emits an event to notify that a vote has been cast.
    }

    function getVoting_Session(uint256 _sessionId) public view returns (string memory, uint256, uint256, uint256) {
        Voting_Session storage session = votingSessions[_sessionId];
        // This line retrieves the voting session from the mapping.
        return (session.title, session.startTime, session.endTime, session.totalVotes);
    }

    function getVoting_Options(uint256 _sessionId) public view returns (string[] memory, uint256[] memory) {
        Voting_Session storage session = votingSessions[_sessionId];
        string[] memory options = session.options;
        uint256[] memory votes = new uint256[](options.length);

        for (uint256 i = 0; i < options.length; i++) {
            // a loop to retrieve the vote counts for each option.
            votes[i] = session.optionVotes[options[i]];
            // This line retrieves the vote count for each option.
        }

        return (options, votes);

    }

    event VoteCast(uint256 sessionId, string option, address voter);
    // event to notify that a vote has been cast.
}
