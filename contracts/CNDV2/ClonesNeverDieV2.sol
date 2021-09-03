// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "../openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "../openzeppelin/contracts/utils/Context.sol";
import "../openzeppelin/contracts/utils/Counters.sol";
import "../openzeppelin/contracts/access/Ownable.sol";

contract ClonesNeverDieV2 is
    Context,
    ERC721,
    ERC721Enumerable,
    AccessControlEnumerable,
    Ownable
{
    using Counters for Counters.Counter;

    string TOKEN_NAME = "Clones Never Die V2";
    string TOKEN_SYMBOL = "CNDV2";
    uint256 MAX_CLONES_SUPPLY = 10000;
    string private _baseTokenURI;
    address minterContract;
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    Counters.Counter private _tokenIdTracker;

    modifier onlyMinter() {
        require(_msgSender() == minterContract);
        _;
    }

    constructor(string memory baseTokenURI) ERC721(TOKEN_NAME, TOKEN_SYMBOL) {
        _baseTokenURI = baseTokenURI;
    }

    function mint(address to) public virtual onlyMinter {
        require(totalSupply() < 10000, "Mint end.");
        _safeMint(to, _tokenIdTracker.current());
        _tokenIdTracker.increment();
    }

    function massMint(uint256 lv) external onlyOwner {
        require(totalSupply() < 1000, "Airdrop End");
        uint256 from = 100 * (lv - 1);
        uint256 to = 100 * lv;
        for (uint256 i = from; i < to; i += 1) {
            _safeMint(msg.sender, i);
        }
    }

    function setMinterContract(address saleContract) public onlyOwner {
        minterContract = saleContract;
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }

    function getBaseURI() public view returns (string memory) {
        return _baseURI();
    }

    /**
     * Override isApprovedForAll to auto-approve OS's proxy contract
     */
    function isApprovedForAll(address _owner, address _operator)
        public
        view
        override
        returns (bool isOperator)
    {
        // if OpenSea's ERC721 Proxy Address is detected, auto-return true
        if (_operator == address(0x58807baD0B376efc12F5AD86aAc70E78ed67deaE)) {
            return true;
        }

        // otherwise, use the default ERC721.isApprovedForAll()
        return ERC721.isApprovedForAll(_owner, _operator);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(AccessControlEnumerable, ERC721, ERC721Enumerable)
        returns (bool)
    {
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
