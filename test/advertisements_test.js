const truffleAssert = require('truffle-assertions')
const Advertisements = artifacts.require("Advertisements");
const AdsToken = artifacts.require("Ads");
var ads;

contract('Advertisements', async (accounts) => {

    beforeEach(async () => {
        let initialSupply = 50000000
        ads = await AdsToken.new(initialSupply)
    })

    describe('List new token', () => {
        it('should create a new token listing', async () => {
            const instance = await Advertisements.deployed();
            
            let address = ads.address
            let ethAddress = ads.address
            let solddress = ads.address
            let name = await ads.name()
            let symbol = await ads.symbol()
            let description = "Advertisement description"
            let logo = "http://ads.finance/logo.jpg"
            let price = 5
            let marketcap = 50000000
            let launchDate = 1672444800
            let website = "http://ads.finance/"
            let telegram = "https://t.me/ads"
            let twitter = "https://twitter.com/ads"
            let result = await instance.createTokenListing
            ({
                tokenBSC: address, // binance smart chain token address
                tokenETH: ethAddress, // ethereum token address
                tokenSOL: solddress, // solana token address
                name: name, // name
                symbol: symbol, // symbol
                description: description, //description
                logo: logo, // logo
                price: price, // price
                marketcap: marketcap, // marketcap
                launchDate: launchDate, // launchDate
                website: website, // website
                telegram: telegram, // telegram
                twitter: twitter // twitter
            })

            truffleAssert.eventEmitted(result, 'TokenListingCreated',
                (event) => event.tokenBSC === address
                  && event.name === name
                  && event.symbol === symbol
            );

        });
        it('should fail create a new token listing when empty BSC token address', async () => {
            const instance = await Advertisements.deployed();
            
            let address = "0x0000000000000000000000000000000000000000"
            let ethAddress = ads.address
            let solddress = ads.address
            let name = await ads.name()
            let symbol = await ads.symbol()
            let description = "Advertisement description"
            let logo = "http://ads.finance/logo.jpg"
            let price = 5
            let marketcap = 50000000
            let launchDate = 1672444800
            let website = "http://ads.finance/"
            let telegram = "https://t.me/ads"
            let twitter = "https://twitter.com/ads"

            await truffleAssert.fails(
                instance.createTokenListing
                ({
                    tokenBSC: address, // empty binance smart chain token address
                    tokenETH: ethAddress, // ethereum token address
                    tokenSOL: solddress, // solana token address
                    name: name, // name
                    symbol: symbol, // symbol
                    description: description, //description
                    logo: logo, // logo
                    price: price, // price
                    marketcap: marketcap, // marketcap
                    launchDate: launchDate, // launchDate
                    website: website, // website
                    telegram: telegram, // telegram
                    twitter: twitter // twitter
                }), truffleAssert.ErrorType.REVERT
            )
        });
        it('should fail create a new token listing when empty token name', async () => {
            const instance = await Advertisements.deployed();
            
            let address = ads.address
            let ethAddress = ads.address
            let solddress = ads.address
            let name = ""
            let symbol = await ads.symbol()
            let description = "Advertisement description"
            let logo = "http://ads.finance/logo.jpg"
            let price = 5
            let marketcap = 50000000
            let launchDate = 1672444800
            let website = "http://ads.finance/"
            let telegram = "https://t.me/ads"
            let twitter = "https://twitter.com/ads"

            await truffleAssert.fails(
                instance.createTokenListing
                ({
                    tokenBSC: address, // binance smart chain token address
                    tokenETH: ethAddress, // ethereum token address
                    tokenSOL: solddress, // solana token address
                    name: name, // empty name
                    symbol: symbol, // symbol
                    description: description, //description
                    logo: logo, // logo
                    price: price, // price
                    marketcap: marketcap, // marketcap
                    launchDate: launchDate, // launchDate
                    website: website, // website
                    telegram: telegram, // telegram
                    twitter: twitter // twitter
                }), truffleAssert.ErrorType.REVERT
            )
        });
        it('should fail create a new token listing when empty token symbol', async () => {
            const instance = await Advertisements.deployed();
            
            let address = ads.address
            let ethAddress = ads.address
            let solddress = ads.address
            let name = await ads.name()
            let symbol = ""
            let description = "Advertisement description"
            let logo = "http://ads.finance/logo.jpg"
            let price = 5
            let marketcap = 50000000
            let launchDate = 1672444800
            let website = "http://ads.finance/"
            let telegram = "https://t.me/ads"
            let twitter = "https://twitter.com/ads"

            await truffleAssert.fails(
                instance.createTokenListing
                ({
                    tokenBSC: address, // binance smart chain token address
                    tokenETH: ethAddress, // ethereum token address
                    tokenSOL: solddress, // solana token address
                    name: name, // name
                    symbol: symbol, // empty symbol
                    description: description, //description
                    logo: logo, // logo
                    price: price, // price
                    marketcap: marketcap, // marketcap
                    launchDate: launchDate, // launchDate
                    website: website, // website
                    telegram: telegram, // telegram
                    twitter: twitter // twitter
                }), truffleAssert.ErrorType.REVERT
            )
        });
    })

    describe('Promote token', () => {

    })

    describe('Vote for token', () => {

    })

    describe('Owner operations', () => {

    })
})