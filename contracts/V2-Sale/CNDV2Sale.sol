// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "../openzeppelin/contracts/utils/Context.sol";
import "../openzeppelin/contracts/utils/math/SafeMath.sol";
import "../CND-V2/IClonesNeverDieV2.sol";

contract CNDV2Sale is Context {
	using SafeMath for uint256;

	IClonesNeverDieV2 public CNDV2Contract;
	uint16 MAX_CLONES_SUPPLY = 10000;
	uint256 CLONE_PRICE = 45000000000000000000; // 45 MATIC
	uint256 public constant maxClonePurchase = 20;
	bool public isSale = false;
	address public C1;
	address public C2;
	address public C3;

	modifier cloneMintRole(uint256 numberOfTokens) {
		require(isSale, "The sale has not started.");
		require(CNDV2Contract.totalSupply() < MAX_CLONES_SUPPLY, "Sale has already ended.");
		require(numberOfTokens <= maxClonePurchase, "Can only mint 20 Clones at a time");
		require(CNDV2Contract.totalSupply().add(numberOfTokens) <= MAX_CLONES_SUPPLY, "Purchase would exceed max supply of Clones");
		require(CLONE_PRICE.mul(numberOfTokens) <= msg.value, "MATIC value sent is not correct");
		_;
	}

	/*
        C1: Director, C2: Artist, C3: Developer
    */
	modifier onlyCreator() {
		require(C1 == _msgSender() || C2 == _msgSender() || C3 == _msgSender(), "onlyCreator: caller is not the creator");
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

	constructor(address v2Contract, address _C1, address _C2, address _C3) {
		CNDV2Contract = IClonesNeverDieV2(v2Contract);
		C1 = _C1;
		C2 = _C2;
		C3 = _C3;
	}

	function mintClone(uint256 numberOfTokens) public payable cloneMintRole(numberOfTokens) {
		for (uint256 i = 0; i < numberOfTokens; i++) {
			if (CNDV2Contract.totalSupply() < MAX_CLONES_SUPPLY) {
				CNDV2Contract.mint(_msgSender());
			}
		}
	}

	function preMintClone(uint256 numberOfTokens, address receiver) public onlyCreator {
		require(!isSale, "The sale has started. Can't call preMintClone");
		for (uint256 i = 0; i < numberOfTokens; i++) {
			if (CNDV2Contract.totalSupply() < MAX_CLONES_SUPPLY) {
				CNDV2Contract.mint(receiver);
			}
		}
	}

	function withdraw() public payable onlyCreator {
		uint256 contractBalance = address(this).balance;
		uint256 percentage = contractBalance / 100;

		require(payable(C1).send(percentage * 25));
		require(payable(C2).send(percentage * 38));
		require(payable(C3).send(percentage * 37));
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

	function setSale() public onlyCreator {
		isSale = !isSale;
	}
}
