// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Lottery{
    address owner;
    address payable[] players;

    constructor(){
        owner = msg.sender;
    }

    function notAlreadyParticipated() private view returns(bool){
        for(uint i=0;i<players.length;i++){
            if(msg.sender==players[i]){return false;}
        }
        return true;
    }

    function participate() payable public{
        require(msg.sender != owner,"Owner can't participate in the lottery");
        require(notAlreadyParticipated(),"you have already participated in the lottery");
        require(msg.value>=10 ether,"Please deposit 10 ethers or more to take part in the lottery");
        players.push(payable(msg.sender));
    }

    function generateRandomWinner() private view returns(uint){
        return uint(sha256(abi.encode(owner, block.number, players,tx.origin, tx.gasprice)))%players.length;
    }

    function declareWinner() public payable{
        require(msg.sender==owner,"only owner can declare winner of the lottery");
        players[generateRandomWinner()].transfer(address(this).balance);
        delete players;
    }

}
