// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "../openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../openzeppelin/contracts/access/Ownable.sol";
import "../openzeppelin/contracts/utils/math/SafeMath.sol";
import "./ICNDVote.sol";

contract CNDVote is Ownable, ICNDVote {
	using SafeMath for uint256;

	uint8 public constant override VOTING = 0;
	uint8 public constant override CANCELED = 1;
	uint8 public constant override RESULT_SAME = 2;
	uint8 public constant override RESULT_FOR = 3;
	uint8 public constant override RESULT_AGAINST = 4;

	mapping(address => bool) public nftAllowed;
	uint256 public minProposePeriod = 86400;
	uint256 public maxProposePeriod = 604800;

	struct Proposal {
		address proposer;
		string title;
		string summary;
		string content;
		string note;
		uint256 blockNumber;
		uint256 votePeriod;
		bool canceled;
		bool executed;
	}
	Proposal[] public override proposals;

	mapping(uint256 => uint256) public forVotes;
	mapping(uint256 => uint256) public againstVotes;
	mapping(uint256 => mapping(address => mapping(uint256 => bool))) public override cloneVoted;

	function allownft(address nft) external onlyOwner {
		nftAllowed[nft] = true;
	}

	function disallownft(address nft) external onlyOwner {
		nftAllowed[nft] = false;
	}

	function setMinProposePeriod(uint256 period) external onlyOwner {
		minProposePeriod = period;
	}

	function setMaxProposePeriod(uint256 period) external onlyOwner {
		maxProposePeriod = period;
	}

	function propose(
		string calldata title,
		string calldata summary,
		string calldata content,
		string calldata note,
		uint256 votePeriod
	) external override onlyOwner returns (uint256 proposalId) {
		require(minProposePeriod <= votePeriod && votePeriod <= maxProposePeriod);

		proposalId = proposals.length;
		proposals.push(
			Proposal({
				proposer: msg.sender,
				title: title,
				summary: summary,
				content: content,
				note: note,
				blockNumber: block.number,
				votePeriod: votePeriod,
				canceled: false,
				executed: false
			})
		);

		emit Propose(proposalId, msg.sender);
	}

	function proposalCount() external view override returns (uint256) {
		return proposals.length;
	}

	modifier onlyVoting(uint256 proposalId) {
		Proposal memory proposal = proposals[proposalId];
		require(proposal.canceled != true && proposal.executed != true && proposal.blockNumber.add(proposal.votePeriod) >= block.number);
		_;
	}

	function voteClone(
		uint256 proposalId,
		address _nft,
		uint256[] memory cloneIds
	) internal {
		require(nftAllowed[_nft] == true);

		mapping(uint256 => bool) storage voted = cloneVoted[proposalId][_nft];
		ERC721Enumerable nft = ERC721Enumerable(_nft);

		uint256 length = cloneIds.length;
		for (uint256 index = 0; index < length; index = index.add(1)) {
			uint256 id = cloneIds[index];
			require(nft.ownerOf(id) == msg.sender && voted[id] != true);
			voted[id] = true;
		}
	}

	function voteFor(
		uint256 proposalId,
		address nft,
		uint256[] calldata cloneIds
	) external override onlyVoting(proposalId) {
		voteClone(proposalId, nft, cloneIds);
		forVotes[proposalId] = forVotes[proposalId].add(cloneIds.length);
		emit VoteFor(proposalId, msg.sender, nft, cloneIds);
	}

	function voteAgainst(
		uint256 proposalId,
		address nft,
		uint256[] calldata cloneIds
	) external override onlyVoting(proposalId) {
		voteClone(proposalId, nft, cloneIds);
		againstVotes[proposalId] = againstVotes[proposalId].add(cloneIds.length);
		emit VoteAgainst(proposalId, msg.sender, nft, cloneIds);
	}

	function cancel(uint256 proposalId) external onlyOwner {
		Proposal memory proposal = proposals[proposalId];
		require(proposal.blockNumber.add(proposal.votePeriod) >= block.number);
		proposals[proposalId].canceled = true;
		emit Cancel(proposalId);
	}

	function execute(uint256 proposalId) external onlyOwner {
		require(result(proposalId) == RESULT_FOR);
		proposals[proposalId].executed = true;
		emit Execute(proposalId);
	}

	function result(uint256 proposalId) public view override returns (uint8) {
		Proposal memory proposal = proposals[proposalId];
		uint256 _for = forVotes[proposalId];
		uint256 _against = againstVotes[proposalId];
		if (proposal.canceled == true) {
			return CANCELED;
		} else if (proposal.blockNumber.add(proposal.votePeriod) >= block.number) {
			return VOTING;
		} else if (_for == _against) {
			return RESULT_SAME;
		} else if (_for > _against) {
			return RESULT_FOR;
		} else {
			return RESULT_AGAINST;
		}
	}
}
