// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface ILotusStaking {
	event Transfer(address indexed from, address indexed to, uint256 amount);
	event Approval(address indexed owner, address indexed spender, uint256 amount);
	event GoLotus(address indexed owner, uint256 indexed lotusId, uint256 power);
	event OutLotus(address indexed owner, uint256 indexed lotusId);
	event Mine(address indexed owner, uint256 indexed lotusId, uint256 subsidy);

	function name() external view returns (string memory);

	function lotusCount() external view returns (uint256);

	function subsidyAt(uint256 blockNumber) external view returns (uint256);

	function goLotus(uint256[] memory myTokensId) external returns (uint256);

	function outLotus(uint256 lotusId) external;

	function powerOf(uint256 lotusId) external view returns (uint256);

	function subsidyOf(uint256 lotusId) external view returns (uint256);

	function mine(uint256 lotusId) external returns (uint256);
}
