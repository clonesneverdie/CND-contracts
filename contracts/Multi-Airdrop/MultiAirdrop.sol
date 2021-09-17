// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "../CND-V2/IClonesNeverDieV2.sol";

contract MultiAirdrop {
	IClonesNeverDieV2 public V2;
	address public owner;

	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}

	constructor(address _v2) {
		V2 = IClonesNeverDieV2(_v2);
		owner = msg.sender;
	}

	function listAirdrip(
		address from,
		address[] memory user,
		uint256[] memory tokenId
	) public onlyOwner {
		for (uint256 i = 0; i < user.length; i++) {
			address reciever = user[i];
			V2.transferFrom(from, reciever, tokenId[i]);
		}
	}
}
