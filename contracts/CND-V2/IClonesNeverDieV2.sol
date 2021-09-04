// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

interface IClonesNeverDieV2 {
	function mint(address to) external;
	function totalSupply() external view returns (uint256);
}
