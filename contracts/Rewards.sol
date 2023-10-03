// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Rewards is ERC1155, Ownable {
    using Counters for Counters.Counter;
    
    // This will help keep track of token IDs for each collection
    mapping(string => Counters.Counter) private _collectionIds;
    
    // URI for each collection. We'll use this to differentiate collections
    mapping(string => string) private _collectionURIs;
    
    // Array of collection names
    string[] private _collections;

    constructor() ERC1155("https://myapi.com/api/token/{id}.json") {}

    function setURIForCollection(string memory collectionName, string memory newURI) external onlyOwner {
        // If this is a new collection, add to the array
        if (bytes(_collectionURIs[collectionName]).length == 0) {
            _collections.push(collectionName);
        }
        _collectionURIs[collectionName] = newURI;
    }

    function mint(string memory collectionName, address account, uint256 amount) external onlyOwner {
        require(bytes(_collectionURIs[collectionName]).length > 0, "Collection does not exist");
        
        // Create a new ID for the token
        _collectionIds[collectionName].increment();
        uint256 newTokenId = _collectionIds[collectionName].current();

        _mint(account, newTokenId, amount, "");
    }

    function uri(uint256 tokenId) public view override returns (string memory) {
        // Custom logic to determine the URI based on collection
        // For simplicity, we're assuming tokenIds are sequential for each collection.
        // You'd likely want more complex logic in a real-world scenario.
        for (uint256 i = 0; i < _collections.length; i++) {
            if (tokenId <= _collectionIds[_collections[i]].current()) {
                return _collectionURIs[_collections[i]];
            }
        }
    }
}