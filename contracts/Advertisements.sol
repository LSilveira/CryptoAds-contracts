pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Advertisements is Ownable {

    uint256 private promotionFee = 2000000000000000000; // 2 BNB

    mapping(address => TokenInfo) listedTokens;
    address[] private advertisedTokens;
    address[] private nonPromotedTokens;
    uint256 private lastPromotedTokenIndex = 0;

    struct TokenListingInfo {
        address tokenBSC;
        address tokenETH;
        address tokenSOL;
        string name;
        string symbol;
        string description;
        string logo;
        uint256 price;
        uint256 marketcap;
        uint256 launchDate;
        string website;
        string telegram;
        string twitter;
    }

    struct TokenInfo {
        address tokenBSC;
        address tokenETH;
        address tokenSOL;
        string name;
        string symbol;
        string description;
        string logo;
        uint256 price;
        uint256 marketcap;
        uint256 launchDate;
        string website;
        string telegram;
        string twitter;
        bool isAvailable;
        uint256 position;
        uint256 votes;
    }

    event TokenListingCreated
    (
        address tokenBSC,
        address tokenETH,
        address tokenSOL,
        string name,
        string symbol,
        string logo
    );
    event TokenPromoted(address token);
    event TokenVoted(address token);

    function createTokenListing(TokenListingInfo calldata tokenListingInfo) public {
        require(tokenListingInfo.tokenBSC != address(0), "BSC address cannot be empty");
        require(bytes(tokenListingInfo.name).length > 0, "Name cannot be empty");
        require(bytes(tokenListingInfo.symbol).length > 0, "Symbol cannot be empty");
        require(bytes(tokenListingInfo.website).length > 0, "Website cannot be empty");
        require(tokenListingInfo.launchDate > block.timestamp, "Launch date needs to be after the current date");
        
        TokenInfo memory _tokenInfo = TokenInfo(
            tokenListingInfo.tokenBSC,
            tokenListingInfo.tokenETH,
            tokenListingInfo.tokenSOL,
            tokenListingInfo.name,
            tokenListingInfo.symbol,
            tokenListingInfo.description,
            tokenListingInfo.logo,
            tokenListingInfo.price,
            tokenListingInfo.marketcap,
            tokenListingInfo.launchDate,
            tokenListingInfo.website,
            tokenListingInfo.telegram,
            tokenListingInfo.twitter,
            true,
            lastPromotedTokenIndex,
            0
        );

        listedTokens[tokenListingInfo.tokenBSC] = _tokenInfo;

        emit TokenListingCreated
        (
            tokenListingInfo.tokenBSC,
            tokenListingInfo.tokenETH,
            tokenListingInfo.tokenSOL,
            tokenListingInfo.name,
            tokenListingInfo.symbol,
            tokenListingInfo.logo
        );
    }

    function promote(address token) public payable {
        require(msg.value == promotionFee, "Promotion fee is too low");
        require(listedTokens[token].isAvailable, "Token is not listed");
        require(_isRepeatedToken(token) == false, "Same token cannot be promoted multiple times");

        if (advertisedTokens.length == 10) {
            delete advertisedTokens[0];
        }
        advertisedTokens.push(token);

        // advertised tokens cannot exceed 10
        assert(advertisedTokens.length <= 10);
    }

    function _isRepeatedToken(address token) internal view returns (bool) {
        for(uint16 i = 0; i <= advertisedTokens.length; i++) {
            if (advertisedTokens[i] == token) {
                return true;
            }
        }

        return false;
    }

    function getPromotedTokens() public view returns(TokenInfo[10] memory) {
        return _reverse(advertisedTokens);
    }

    function _reverse(address[] storage tokens) internal view returns (TokenInfo[10] memory) {
        require(tokens.length <= 10, "Tokens list cannot exceed 10 elements");

        TokenInfo[10] memory _tokensInfo;
        for (uint i = 0; i < tokens.length / 2; i++) {
            address _token = tokens[tokens.length - i - 1];
            _tokensInfo[i] = listedTokens[_token];
        }
        return _tokensInfo;
    }

    function vote(address token) public {
        TokenInfo storage _tokenInfo = listedTokens[token];
        require(_tokenInfo.isAvailable, "Token is not listed");

        if (_tokenInfo.votes == 0) {
            _tokenInfo.position = lastPromotedTokenIndex;
            lastPromotedTokenIndex++;
            nonPromotedTokens[_tokenInfo.position] = _tokenInfo.tokenBSC;
        }
        else {
            for (
                uint256 i = _tokenInfo.position;
                _tokenInfo.position != 0 || _compareVotes(_tokenInfo.position, _tokenInfo.position - 1);
                i--
            ) {
                address previousToken = nonPromotedTokens[_tokenInfo.position - 1];
                nonPromotedTokens[_tokenInfo.position - 1] = nonPromotedTokens[_tokenInfo.position];
                nonPromotedTokens[_tokenInfo.position] = previousToken;
            }
        }

        _tokenInfo.votes++;
        
        assert(nonPromotedTokens[_tokenInfo.position] == _tokenInfo.tokenBSC);
    }

    function _compareVotes(uint256 token1, uint256 token2) private view returns (bool) {
        uint256 votesToken1 = listedTokens[nonPromotedTokens[token1]].votes;
        uint256 votesToken2 = listedTokens[nonPromotedTokens[token2]].votes;

        return votesToken2 < votesToken1;
    }

    function getNonPromotedTokens(uint256 from, uint256 to) public view returns (address[] memory) {
        require(from >= 0, "From cannot be lower than zero");
        require(to > from, "To needs to be higher than From");

        uint256 pageIndex = 0;
        address[] memory tokensPage;
        for (uint256 i = from; i < nonPromotedTokens.length && i >= from; i++) {
            tokensPage[pageIndex] = nonPromotedTokens[i];
            pageIndex++;
        }
        
        return tokensPage;
    }

    function getTokenInfo(address token) public view returns (TokenInfo memory) {
        require(token != address(0), "Token address cannot be empty");
        return listedTokens[token];
    }

    function getFee() public view returns (uint256) {
        return promotionFee;
    }

    function setFee(uint256 newFee) public onlyOwner {
        promotionFee = newFee;
    }

    function withdrawlFees() public onlyOwner {
        address payable owner = payable(msg.sender);
        owner.transfer(address(this).balance);
    }

}