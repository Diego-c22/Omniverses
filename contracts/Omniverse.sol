// SPDX-License-Identifier: Mit

pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./ERC721-upgradeable/ERC721AUpgradeable.sol";

/** @author Diego Cortes **/
/** @title Omniverse */
contract Omniverse is ERC721AUpgradeable, OwnableUpgradeable {
    /**
     * @dev Initialize upgradeable storage (constructor).
     * @custom:restriction This function only can be executed one time.
     */
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

    /**
     * @dev Mint NFT taking as reference presale values
     * @param quantity Quantity of nfts to mint in transaction
     * @custom:restriction Quantity must be less or equals to maxBatchSize
     */
    function preSaleMint(uint256 quantity) external payable {
        require(
            ERC721AStorage.layout()._amountForPreSale <=
                (ERC721AStorage.layout()._preSaleCurrentIndex + quantity),
            "Transfer exceeds total supply."
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

    /**
     * @dev Mint NFT taking as reference public sale values
     * @param quantity Quantity of nfts to mint in transaction
     * @custom:restriction Quantity must be less or equals to maxBatchSize
     */
    function publicSaleMint(uint256 quantity) external payable {
        require(
            ERC721AStorage.layout()._amountForPublicSale <=
                (ERC721AStorage.layout()._publicSaleCurrentIndex + quantity),
            "Transfer exceeds total supply."
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

    /**
     * @dev Mint nft without pay
     * @param quantity Quantity of nfts to mint in transaction
     * @custom:restriction Only owner can execute this function
     */
    function freeMint(uint256 quantity) external onlyOwner {
        require(
            ERC721AStorage.layout()._amountForFree <=
                (ERC721AStorage.layout()._freeSaleCurrentIndex + quantity),
            "Transfer exceeds total supply."
        );

        _mint(msg.sender, quantity);

        unchecked {
            ERC721AStorage.layout()._freeSaleCurrentIndex + quantity;
        }
    }

    /**
     * @dev Distribute rewards for holders.
     * @custom:restriction Function can only be executed when collection is sold out.
     * @custom:restriction Only owner can execute this function.
     */
    function distributeHoldersReward() external onlyOwner {
        require(
            ERC721AStorage.layout()._currentIndex == 1000,
            "Collection is not sold out."
        );
        uint256 totalSalesAmount;
        unchecked {
            totalSalesAmount = ((ERC721AStorage.layout()._pricePublicSale *
                ERC721AStorage.layout()._amountForPublicSale) +
                (ERC721AStorage.layout()._pricePublicSale *
                    ERC721AStorage.layout()._amountForPublicSale));
        }

        _distribution({value: totalSalesAmount, percent: 15});
    }
}
