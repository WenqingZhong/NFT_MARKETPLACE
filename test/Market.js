const Market= artifacts.require("Market");
const NFT= artifacts.require("NFT");

contract ('Market',()=>{
    let market;
    let token;
    before (async ()=> {
        market= await Market.deployed();
        token = await NFT.deployed();
    });

    describe("List Token", ()=> {

    });
});