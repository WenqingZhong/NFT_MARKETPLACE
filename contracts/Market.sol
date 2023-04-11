// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "/Users/wenqingzhong/Desktop/nft_marketplace/contracts";

contract Market{

    enum ListingStatus {
        Active,
        Sold,
        Cancelled
    }

    struct Listing{
        ListingStatus status;
        address seller;
        address token;
        uint tokenId;
        uint price;
    }

    event Listed(
        uint listingId,
        address seller,
        address token,
        uint tokenId,
        uint price
    );

    event Sale(
        uint listingId,
        address buyer,
        address token,
        uint tokenId,
        uint price
    );

    event Cancel(
        uint listingId,
        address seller
    );

    uint private _listingId =0;
    mapping (uint => Listing) private _listings;

    function listToken(address token, uint tokenId, uint price) external {
        IERC721(token).transferFrom(msg.sender, address(this), tokenId);

        Listing memory listing = Listing(
            ListingStatus.Active,
            msg.sender,
            token,
            tokenId,
            price
        );

        _listingId++;
        _listings[_listingId]=listing;

        emit Listed(
            _listingId,
            msg.sender,
            token,
            tokenId,
            price
        );
    }

    function getListing(unit listingId) public view returns (Listing){
        return _listings[listingId];
    }

    function buyToken(uint listingId) external payable{
        Listing storage listing = _listings[listingId];
        require(listing.status == ListingStatus.Active,"Listing is not active");
        require(msg.sender != listing.seller,"Seller cannot be buyer");
        require(msg.value >= listing.price, "Insufficient payment");
        listing.status=ListingStatus.Sold;

        IERC21(listing.token).transferFrom(address(this), msg.sender, listing.tokenId);
        payable(listing.seller).transfer(listing.price);

        emit Sale(
            listingId,
            msg.sender,
            listing.token,
            listing.tokenId,
            listing.price
        );
    }

    function cancel(uint listingId) public {
        Listing storage listing = _listings[listingId];
        require(listing.status == ListingStatus.Active,"Listing is not active");
        require(msg.sender == listing.seller,"The canceler needs to be the seller");
        listing.status=ListingStatus.Cancelled;
        IERC21(listing.token).transferFrom(address(this), msg.sender, listing.tokenId);
        emit.Cancle(listingId,listing.seller)
    }
}