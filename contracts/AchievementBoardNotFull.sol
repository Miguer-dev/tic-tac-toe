// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";   
import "@openzeppelin/contracts/utils/Counters.sol";

contract AchievementBoardNotFull is ERC721("Achievement: Board Not Full", "ABNF"), Ownable  {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    event achievementObtained(   
        string achievement,
        uint idAchievement,
        address player
    ); 

    function safeMint(address to) public onlyOwner returns(bool){
        bool result = false;

        if( balanceOf(to) == 0 ){
            uint256 tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            _safeMint(to, tokenId);
            result = true;
            emit achievementObtained("Achievement: Board Not Full", tokenId, to);
        }   

        return result;      
    }

}