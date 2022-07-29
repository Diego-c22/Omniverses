// SPDX-License-Identifier: Mit

pragma solidity ^0.8.4;

import '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';
import "./ERC721-upgradeable/ERC721AUpgradeable.sol";

/** @author Diego Cortes **/
/** @title Omniverse */
contract Omniverse is ERC721AUpgradeable, OwnableUpgradeable {
  uint256 private _maxPerAddressDuringMint;
  uint256 private _amountForFree;
  uint256 private _amountForPreSale;
  uint256 private _amountForPublicSale;

  function initialize(
    uint256 maxBatchSize,
    uint256 collectionSize,
    uint256 amountForFree,
    uint256 amountForPresale,
    uint256 amountForPublicSale
  ) initializerERC721A initializer public {
    __ERC721A_init('Omniverses', 'OMS', maxBatchSize, collectionSize);
    __Ownable_init();
    _maxPerAddressDuringMint = maxBatchSize;
    _amountForFree = amountForFree;
    _amountForPreSale = amountForPresale;
    _amountForPublicSale = amountForPublicSale;
  }

  function preSaleMint(uint256 quantity) external payable {
    _mint(msg.sender, quantity);
  }

  function publicSaleMint(uint256 quantity) external payable {
    _mint(msg.sender, quantity);
  }

  function adminMint(uint256 quantity) external payable onlyOwner {
    uint256 startTokenId = ERC721AStorage.layout()._currentIndex;
    _mint(msg.sender, quantity);
  }


}