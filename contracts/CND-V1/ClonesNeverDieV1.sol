// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "../openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "../openzeppelin/contracts/utils/Context.sol";
import "../openzeppelin/contracts/utils/Counters.sol";
import "../openzeppelin/contracts/access/Ownable.sol";

contract ClonesNeverDieV1 is Context, ERC721, ERC721Enumerable, AccessControlEnumerable, Ownable {
	using Counters for Counters.Counter;

	string TOKEN_NAME = "Clones Never Die V1";
	string TOKEN_SYMBOL = "CNDV1";
	uint256 MAX_CLONES_SUPPLY = 100;
	string private _baseTokenURI;
	address public devAddress;
	address public openseaContract;

	Counters.Counter private _tokenIdTracker;

	modifier onlyDev() {
		require(_msgSender() == devAddress);
		_;
	}

	constructor(string memory baseTokenURI, address _devAddress, address _openseaCA) ERC721(TOKEN_NAME, TOKEN_SYMBOL) {
		_baseTokenURI = baseTokenURI;
    setDevAddress(_devAddress);
    setOpenseaContract(_openseaCA);
    mint(msg.sender);
	}

  function mint(address to) internal {
    require(totalSupply() <= MAX_CLONES_SUPPLY, "Mint end.");
    for (uint256 i = 1; i <= MAX_CLONES_SUPPLY; i++) {
      _mint(to, i);
    }
  }

	function massTransferFrom(
		address from,
		address to,
		uint256[] memory _myTokensId
	) public {
		require(_myTokensId.length <= 100, "Can only transfer 100 Clones at a time");
		for (uint256 i = 0; i < _myTokensId.length; i++) {
			transferFrom(from, to, _myTokensId[i]);
		}
	}

  function listAirdrip(
		address from,
		address[] memory user,
		uint256[] memory tokenId
	) public onlyOwner {
		for (uint256 i = 0; i < user.length; i++) {
			address reciever = user[i];
			transferFrom(from, reciever, tokenId[i]);
		}
	}

	function setBaseURI(string memory baseURI) public onlyDev {
		_baseTokenURI = baseURI;
	}

	function getBaseURI() public view returns (string memory) {
		return _baseURI();
	}

	function setDevAddress(address _devAddress) public onlyOwner {
		devAddress = _devAddress;
	}

	function setOpenseaContract(address _opensea) public onlyDev {
		openseaContract = address(_opensea);
	}

	/**
	 * Override isApprovedForAll to auto-approve OS's proxy contract
	 */
	function isApprovedForAll(address _owner, address _operator) public view override returns (bool isOperator) {
		// if OpenSea's ERC721 Proxy Address is detected, auto-return true
		if (_operator == openseaContract) {
			return true;
		}

		// otherwise, use the default ERC721.isApprovedForAll()
		return ERC721.isApprovedForAll(_owner, _operator);
	}

	function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControlEnumerable, ERC721, ERC721Enumerable) returns (bool) {
		return super.supportsInterface(interfaceId);
	}

	function _baseURI() internal view virtual override returns (string memory) {
		return _baseTokenURI;
	}

	function _beforeTokenTransfer(
		address from,
		address to,
		uint256 tokenId
	) internal virtual override(ERC721, ERC721Enumerable) {
		super._beforeTokenTransfer(from, to, tokenId);
	}
}
