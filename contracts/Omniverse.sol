// SPDX-License-Identifier: Mit

pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./ERC721-upgradeable/ERC721AUpgradeable.sol";

/** @author Diego Cortes **/
/** @title Omniverse */
contract Omniverse is ERC721AUpgradeable, OwnableUpgradeable {
    function initialize() public initializerERC721A initializer {
        __ERC721A_init({
            name_: "Omniverses",
            symbol_: "OMS",
            pricePublicSale_: 0.05 ether,
            pricePreSale_: 0.03 ether,
            amountForFree_: 50,
            amountForPreSale_: 500,
            amountForPublicSale_: 450,
            maxBatchSizePublicSale_: 10,
            maxBatchSizePreSale_: 5
        });
        __Ownable_init();
    }

    function preSaleMint(uint256 quantity) external payable {
        require(
            ERC721AStorage.layout()._amountForPreSale <=
                (ERC721AStorage.layout()._preSaleCurrentIndex + quantity),
            "Transfer exceeds total suplay."
        );
        require(
            balanceOf(msg.sender) + quantity <=
                ERC721AStorage.layout()._maxBatchSizePreSale,
            "Transfer exceeds max amount."
        );
        uint256 amount = quantity * ERC721AStorage.layout()._pricePreSale;
        require(msg.value == amount, "Price not covered.");
        _mint(msg.sender, quantity);

        unchecked {
            ERC721AStorage.layout()._preSaleCurrentIndex + quantity;
        }
    }

    function publicSaleMint(uint256 quantity) external payable {
        require(
            ERC721AStorage.layout()._amountForPublicSale <=
                (ERC721AStorage.layout()._publicSaleCurrentIndex + quantity),
            "Transfer exceeds total suplay."
        );
        require(
            balanceOf(msg.sender) + quantity <=
                ERC721AStorage.layout()._maxBatchSizePublicSale,
            "Transfer exceeds max amount."
        );
        uint256 amount = quantity * ERC721AStorage.layout()._pricePublicSale;
        require(msg.value == amount, "Price not covered.");
        _mint(msg.sender, quantity);

        unchecked {
            ERC721AStorage.layout()._publicSaleCurrentIndex + quantity;
        }
    }

    function freeMint(uint256 quantity) external payable {
        require(
            ERC721AStorage.layout()._amountForFree <=
                (ERC721AStorage.layout()._freeSaleCurrentIndex + quantity),
            "Transfer exceeds total suplay."
        );

        _mint(msg.sender, quantity);

        unchecked {
            ERC721AStorage.layout()._freeSaleCurrentIndex + quantity;
        }
    }
}
