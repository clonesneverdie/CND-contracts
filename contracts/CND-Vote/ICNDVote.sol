// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

interface ICNDVote {
	event Propose(uint256 indexed proposalId, address indexed proposer);
	event VoteFor(uint256 indexed proposalId, address indexed voter, address nft, uint256[] cloneIds);
	event VoteAgainst(uint256 indexed proposalId, address indexed voter, address nft, uint256[] cloneIds);
	event Cancel(uint256 indexed proposalId);
	event Execute(uint256 indexed proposalId);

	function VOTING() external view returns (uint8);

	function CANCELED() external view returns (uint8);

	function RESULT_FOR() external view returns (uint8);

	function RESULT_AGAINST() external view returns (uint8);

	function RESULT_SAME() external view returns (uint8);

	function propose(
		string calldata title,
		string calldata summary,
		string calldata content,
		string calldata note,
		uint256 votePeriod
	) external returns (uint256 proposalId);

	function proposals(uint256 proposalId)
		external
		returns (
			address proposer,
			string memory title,
			string memory summary,
			string memory content,
			string memory note,
			uint256 blockNumber,
			uint256 votePeriod,
			bool canceled,
			bool executed
		);


	function proposalCount() external view returns (uint256);

	function cloneVoted(
		uint256 proposalId,
		address nft,
		uint256 id
	) external view returns (bool);

	function voteFor(
		uint256 proposalId,
		address nft,
		uint256[] calldata cloneIds
	) external;

	function voteAgainst(
		uint256 proposalId,
		address nft,
		uint256[] calldata cloneIds
	) external;

	function result(uint256 proposalId) external view returns (uint8);
}
