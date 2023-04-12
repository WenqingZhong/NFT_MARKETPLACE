const Market= artifacts.require("Market");
const NFT= artifacts.require("NFT");
const {expectRevert}= require("@openzeppelin/test-helpers");

contract ('Market',()=>{
    let market;
    let token;
    before (async ()=> {
        market= await Market.deployed();
        token = await NFT.deployed();

        await token.mint();
    });

    const tokenId = 1;
    const price = 1000;

    describe("List Token", ()=> {
        it ('should not listing if contract is not approved', ()=> {
            return expectRevert(
                market.listToken(
                token.address,
                tokenId,
                price
                ), 'ERC721: caller is not token owner or approved' 
            );
        })
    });
});