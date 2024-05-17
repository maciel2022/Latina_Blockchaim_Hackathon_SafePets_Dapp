// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract TSPContract {
	
    uint public tspCounter = 0;

    event TSPCreated (
        uint id,
        string nombre,
        string clase,
        string genero,
        string nombreD,
        string walletD,
        bool done,
        uint createdAt
    );

    event TSPToggleDone(
        uint id,
        bool done
    );

    struct TSP {
        uint256 id;
        string nombre;
        string clase;
        string genero;
        string nombreD;
        string walletD;
        bool done;
        uint256 createdAt;
    }
    
    mapping (uint256 => TSP) public tsps;

	function createTSP(string memory _nombre, string memory _clase, string memory _genero, string memory _nombreD, string memory _walletD) public {
		tspCounter++;
        tsps[tspCounter] = TSP(tspCounter, _nombre, _clase, _genero, _nombreD, _walletD, false, block.timestamp);
        emit TSPCreated(tspCounter, _nombre, _clase, _genero, _nombreD, _walletD, false, block.timestamp);  
	}

    function toggleDone(uint _id) public {
        TSP memory tsp = tsps[_id];
        tsp.done = !tsp.done;
        tsps[_id] = tsp;
        emit TSPToggleDone(_id, tsp.done);
    }
}