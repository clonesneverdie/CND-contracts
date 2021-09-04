// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "../openzeppelin/contracts/utils/Context.sol";
import "../openzeppelin/contracts/access/Ownable.sol";
import "../openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "../openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol";
import "../openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "../openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";

contract Nectar is Context, ERC20, ERC20Burnable, ERC20Snapshot, Ownable, ERC20Permit, ERC20Votes {
	string TOKEN_NAME = "Nectar";
	string TOKEN_SYMBOL = "NECTAR";
	address staking_contract;

	modifier onlyStakingContract() {
		require(staking_contract == _msgSender());
		_;
	}

	constructor() ERC20(TOKEN_NAME, TOKEN_SYMBOL) ERC20Permit(TOKEN_SYMBOL) {}

	function setStakingContract(address stakingContract) public onlyOwner {
		staking_contract = stakingContract;
	}

	function snapshot() public onlyOwner {
		_snapshot();
	}

	function mint(address to, uint256 amount) external onlyStakingContract {
		_mint(to, amount);
	}

	// The following functions are overrides required by Solidity.

	function _beforeTokenTransfer(
		address from,
		address to,
		uint256 amount
	) internal override(ERC20, ERC20Snapshot) {
		super._beforeTokenTransfer(from, to, amount);
	}

	function _afterTokenTransfer(
		address from,
		address to,
		uint256 amount
	) internal override(ERC20, ERC20Votes) {
		super._afterTokenTransfer(from, to, amount);
	}

	function _mint(address to, uint256 amount) internal override(ERC20, ERC20Votes) {
		super._mint(to, amount);
	}

	function _burn(address account, uint256 amount) internal override(ERC20, ERC20Votes) {
		super._burn(account, amount);
	}
}
