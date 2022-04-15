// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Game.sol";

contract Bet {

	Game public game;
	// address public game;

	constructor(address _gameaddress) {
		game = Game(_gameaddress);
		// game = _gameaddress;
	}

	function getScoreDifference(Game.Teams _team) public view returns(int256) {
		int256 score_diff;
		if (_team == Game.Teams.Team1) {
			score_diff = game.team1Score() - game.team2Score();
		}
		if (_team == Game.Teams.Team2) {
			score_diff = game.team2Score() - game.team1Score();
		}
		return score_diff;
	}
	

	// calculates the payout of a bet based on the score difference between the two teams
	function calculatePayout(uint amount, int scoreDifference) private pure returns(uint) {
		uint abs = uint(scoreDifference > 0 ? scoreDifference : scoreDifference * -1);	
		uint odds = 2 ** abs;
		if(scoreDifference < 0) {
			return amount + amount / odds;
		}
		return amount + amount * odds;
	}


	function placeBet(Game.Teams _betchoice) external payable returns(uint256) {
		return calculatePayout(msg.value, getScoreDifference(_betchoice));
	}
	
}
