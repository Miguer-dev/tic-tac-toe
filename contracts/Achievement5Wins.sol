// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; 
import "@openzeppelin/contracts/utils/Counters.sol";  

contract Achievement5Wins is ERC721("Achievement: 5 Wins", "A5W"), Ownable  {
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
            emit achievementObtained("Achievement: 5 Wins", tokenId, to);
        }   

        return result;      
    }
}