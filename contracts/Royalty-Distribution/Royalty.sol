// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "../openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../openzeppelin/contracts/utils/Context.sol";
import "../openzeppelin/contracts/utils/math/SafeMath.sol";

contract Royalty is Context {
	using SafeMath for uint256;

	IERC20 public weth;
	address public contractAddress;
	address public C1;
	address public C2;
	address public C3;
	address public C4;

	modifier onlyCreator() {
		require(C1 == _msgSender() || C2 == _msgSender() || C3 == _msgSender() || C4 == _msgSender(), "onlyCreator: caller is not the creator");
		_;
	}

	modifier onlyC1() {
		require(C1 == _msgSender(), "only C1: caller is not the C1");
		_;
	}

	modifier onlyC2() {
		require(C2 == _msgSender(), "only C2: caller is not the C2");
		_;
	}

	modifier onlyC3() {
		require(C3 == _msgSender(), "only C3: caller is not the C3");
		_;
	}

	modifier onlyC4() {
		require(C4 == _msgSender(), "only C4: caller is not the C4");
		_;
	}

	constructor(
		address _ca,
		address _c1,
		address _c2,
		address _c3,
		address _c4
	) {
		weth = IERC20(_ca);
		contractAddress = address(this);
		C1 = _c1;
		C2 = _c2;
		C3 = _c3;
		C4 = _c4;
	}

	function withdrawWeth() public onlyCreator {
		uint256 balance = weth.balanceOf(contractAddress);
		uint256 transferBalance = SafeMath.div(balance, 100);
		weth.transfer(C1, transferBalance * 36);
		weth.transfer(C2, transferBalance * 34);
		weth.transfer(C3, transferBalance * 20);
		weth.transfer(C4, transferBalance * 10);
	}

	function setWeth(address _ca) public onlyC2 {
		weth = IERC20(_ca);
	}

	function setC1(address changeAddress) public onlyC1 {
		C1 = changeAddress;
	}

	function setC2(address changeAddress) public onlyC2 {
		C2 = changeAddress;
	}

	function setC3(address changeAddress) public onlyC3 {
		C3 = changeAddress;
	}

	function setC4(address changeAddress) public onlyC4 {
		C4 = changeAddress;
	}
}
