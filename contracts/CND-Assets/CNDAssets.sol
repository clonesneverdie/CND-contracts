// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./ContextMixin.sol";
import "../openzeppelin/contracts/utils/Strings.sol";
import "../openzeppelin/contracts/access/Ownable.sol";
import "../openzeppelin/contracts/security/Pausable.sol";
import "../openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

contract AccessToken is Ownable, Pausable, ERC1155Supply, ContextMixin {
	using Strings for uint256;

	string private baseURI;
	string public constant NAME = "AccessToken";
	string public constant SYMBOL = "AT";

	constructor(string memory _baseURI) ERC1155(_baseURI) {
		baseURI = _baseURI;
	}

	function name() external pure returns (string memory) {
		return NAME;
	}

	function symbol() external pure returns (string memory) {
		return SYMBOL;
	}

	function setURI(string memory newuri) public onlyOwner {
		_setURI(newuri);
		baseURI = newuri;
	}

	function uri(uint256 tokenId) public view virtual override returns (string memory) {
		require(exists(tokenId), "ERC1155Supply: URI query for nonexistent token");
		return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
	}

	/**
	 * Override isApprovedForAll to auto-approve OS's proxy contract
	 */
	function isApprovedForAll(address _owner, address _operator) public view override returns (bool isOperator) {
		// if OpenSea's ERC1155 Proxy Address is detected, auto-return true
		if (_operator == address(0x207Fa8Df3a17D96Ca7EA4f2893fcdCb78a304101)) {
			return true;
		}
		// otherwise, use the default ERC1155.isApprovedForAll()
		return ERC1155.isApprovedForAll(_owner, _operator);
	}

	/**
	 * This is used instead of msg.sender as transactions won't be sent by the original token owner, but by OpenSea.
	 */
	function _msgSender() internal view override returns (address sender) {
		return ContextMixin.msgSender();
	}

	function pause() public onlyOwner {
		_pause();
	}

	function unpause() public onlyOwner {
		_unpause();
	}

	function mint(
		address account,
		uint256 id,
		uint256 amount,
		bytes memory data
	) public onlyOwner {
		_mint(account, id, amount, data);
	}

	function mintBatch(
		address to,
		uint256[] memory ids,
		uint256[] memory amounts,
		bytes memory data
	) public onlyOwner {
		_mintBatch(to, ids, amounts, data);
	}

	function _beforeTokenTransfer(
		address operator,
		address from,
		address to,
		uint256[] memory ids,
		uint256[] memory amounts,
		bytes memory data
	) internal override whenNotPaused {
		super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
	}

	function burn(
		address account,
		uint256 id,
		uint256 value
	) public virtual {
		require(account == _msgSender() || isApprovedForAll(account, _msgSender()), "ERC1155: caller is not owner nor approved");

		_burn(account, id, value);
	}

	function burnBatch(
		address account,
		uint256[] memory ids,
		uint256[] memory values
	) public virtual {
		require(account == _msgSender() || isApprovedForAll(account, _msgSender()), "ERC1155: caller is not owner nor approved");

		_burnBatch(account, ids, values);
	}
}
