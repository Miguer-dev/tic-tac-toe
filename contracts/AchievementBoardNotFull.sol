// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";   

contract AchievementBoardNotFull is ERC721("Achievement: Board Not Full", "ABNF"), Ownable  {

    uint private nextTokenId;

    constructor() {
        nextTokenId = 0;
    }

    function mint(address to) external onlyOwner(){
         nextTokenId ++;
        _safeMint(to,nextTokenId);
    }
}