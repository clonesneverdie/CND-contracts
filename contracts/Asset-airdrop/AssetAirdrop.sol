// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "../CND-Asset/ICNDAsset.sol";

contract AssetAirdrop {
	ICNDAsset public Asset;
	address public contractAddress;
	address public devTeam;
	address public assetStoredAddress;

	modifier onlyDev() {
		require(msg.sender == devTeam);
		_;
	}

	constructor(address _assetStoredAddress, address _assetContractAddress) {
		devTeam = msg.sender;
		contractAddress = address(this);
		Asset = ICNDAsset(_assetContractAddress);
		assetStoredAddress = _assetStoredAddress;
	}

	function partsAirdrop(uint256 tokenId, address[] memory user) public onlyDev {
		for (uint256 i = 0; i < user.length; i++) {
			address reciever = user[i];
			Asset.safeTransferFrom(assetStoredAddress, reciever, tokenId, 1, "");
		}
	}
}
