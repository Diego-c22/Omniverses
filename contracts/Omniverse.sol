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
            ERC721AStorage.layout()._preSaleActive,
            "Presale is not active"
        );
        require(
            ERC721AStorage.layout()._amountForPreSale >=
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
            ERC721AStorage.layout()._publicSaleActive,
            "Public sale is not active"
        );
        require(
            ERC721AStorage.layout()._amountForPublicSale >=
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
            ERC721AStorage.layout()._amountForFree >=
                (ERC721AStorage.layout()._freeSaleCurrentIndex + quantity),
            "Transfer exceeds total supply."
        );

        _mint(msg.sender, quantity);

        unchecked {
            ERC721AStorage.layout()._freeSaleCurrentIndex + quantity;
        }
    }

    /**
     * @dev active or deactivate public sale and if it is the
     *  first time is activated reveling time is set.
     * @param status Use true to activate or false to deactivate.
     * @custom:restriction Only owner can execute this function
     */
    function activePublicSale(bool status) external onlyOwner {
        ERC721AStorage.layout()._publicSaleActive = status;
        if (ERC721AStorage.layout()._reveledURI == 0) {
            unchecked {
                ERC721AStorage.layout()._reveledURI = block.timestamp + 259200;
            }
        }
    }

    /**
     * @dev active or deactivate pre-sale.
     * @param status Use true to activate or false to deactivate.
     * @custom:restriction Only owner can execute this function
     */
    function activePreSale(bool status) external onlyOwner {
        ERC721AStorage.layout()._preSaleActive = status;
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

    /**
     * @dev get the receiver of royalties and the
     *  amount that must receive.
     * @param tokenId The identifier of the token to get receiver.
     * @param value The amount for get royalties.
     * @return receiver Return address of the receiver.
     * @return amount Return value that receiver must get.
     */
    function getRoyalties(uint256 tokenId, uint256 value)
        external
        view
        returns (address, uint256)
    {
        uint256 royalty = ((value * 10) / 100);
        return (ERC721AStorage.layout()._royalties[tokenId], royalty);
    }
}
