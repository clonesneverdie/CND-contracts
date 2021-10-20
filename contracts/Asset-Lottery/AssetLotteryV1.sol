// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "../CND-Asset/ICNDAsset.sol";
import "../Nectar/INectar.sol";
import "../openzeppelin/contracts/utils/Context.sol";
import "../openzeppelin/contracts/utils/math/SafeMath.sol";

contract AssetsLotteryV1 is Context {
	using SafeMath for uint256;

	INectar public Nectar;
	ICNDAsset public Asset;

	uint16 MAX_SALES_SUPPLY = 3;
	uint256 ASSETS_PRICE = 15000000000000000000000; // 15000 NECTAR
	uint256 currentSaleCount = 0;
	bool public isSale = false;
	address[] buyer;
	uint256[] randomNum;
	address devTeam;
	address contractAddress;

	mapping(uint256 => bool) indexOfAsset;

	modifier onlyDev() {
		require(_msgSender() == devTeam);
		_;
	}

	modifier enrollCondition() {
		require(isSale, "Sale is not start.");
		require(buyer.length < MAX_SALES_SUPPLY, "Sale End");
		_;
	}

	constructor() {
		devTeam = _msgSender();
		contractAddress = address(this);
	}

	function pullUp() public enrollCondition {
		uint256 balance = Nectar.balanceOf(_msgSender());
		require(balance >= ASSETS_PRICE, "Not enough Nectar");
		Nectar.transferFrom(_msgSender() ,contractAddress, ASSETS_PRICE);
		buyer.push(_msgSender());
		Asset.safeTransferFrom(address(this), _msgSender(), randomNum[currentSaleCount], 1, "");
		currentSaleCount++;
	}

	function withdrawAndBurnNectar() public onlyDev {
		uint256 balance = Nectar.balanceOf(contractAddress);
		uint256 transferBalance = SafeMath.div(balance, 2);
		Nectar.transfer(devTeam, transferBalance);
		Nectar.burn(transferBalance);
	}

	function setNectarCA(address _address) public onlyDev {
		Nectar = INectar(_address);
	}

	function setAssetsCA(address _address) public onlyDev {
		Asset = ICNDAsset(_address);
	}

	function reset() public onlyDev {
		delete buyer;
		delete randomNum;
		currentSaleCount = 0;
		setSale();
	}

	function setSale() public onlyDev {
		isSale = !isSale;
	}

	function setArr(uint256[] memory _arr) public onlyDev {
		randomNum = _arr;
	}
}
