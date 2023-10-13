// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "./ERC1155MixedFungible.sol";
import '@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol';
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract FreedomWorldAssets is
    Initializable,
    OwnableUpgradeable,
    ReentrancyGuardUpgradeable,
    PausableUpgradeable,
    ERC1155MixedFungible
{
    using AddressUpgradeable for address;
    using CountersUpgradeable for CountersUpgradeable.Counter;

    uint256 nonce;

    /// @notice The base URI per token type
    mapping (uint256 => string) private _tokenTypeURIs;

    /// @notice The URI per token ID
    mapping (uint256 => string) private _tokenURIs;
   
    /// @notice The Index per token type, if token type is fungible then index will be 1
    /// if non-fungible then it increments for every mint (up to max supply)
    mapping (uint256 => uint256) private _maxIndex;

    /// @notice Mapping of token type to max supply
    mapping (uint256 => uint256) private _typeMaxSupply;

    /// @notice Mapping of asset name to4 token type
    mapping (string => uint256) private _nameToType;

    function initialize(string memory _uri) public initializer {
        __ERC1155_init(_uri);
        __Ownable_init();
        __ReentrancyGuard_init_unchained();
    }

    /**
     * @dev pause contract
     */
    function pause() external onlyOwner {
        _pause();
    }

    /**
     * @dev unpause contract
     */
    function unpause() external onlyOwner {
        _unpause();
    }

    /// @notice Get the token URI
    /// @param tokenId The ID of the token to return the URI for
    function uri(uint256 tokenId) override public view returns (string memory) { 
        return(_tokenURIs[tokenId]); 
    }

    /// @notice Sets the base URI for a token type
    /// @param tokenType The token type as defined in ERC1155MixedFungible
    /// @param tokenURI The base URI for that token type
    function _setTokenTypeUri(uint256 tokenType, string memory tokenURI) private {
         _tokenTypeURIs[tokenType] = tokenURI; 
    }

    /// @notice Concatenate the base URI for the token type and the token ID
    /// @param tokenType The token type as defined in ERC1155MixedFungible
    /// @param tokenId The token ID that is appended to the base URI
    function _setTokenUri(uint256 tokenType, uint256 tokenId) private {
        _tokenURIs[tokenId] = strConcat(_tokenTypeURIs[tokenType], StringsUpgradeable.toString(tokenId));       
    }

    /// @notice Returns the asset type as a uint256. Can be useful for testing and keeping data parity between contract and backend server
    /// @param _name The name of the asset
    function getAssetType(string calldata _name) public view returns (uint256) {
        return _nameToType[_name];
    }

    /// @notice Returns the token type max supply
    /// @param _assetName The name of the token type
    function getTypeMaxsupply(string calldata _assetName) public view returns (uint256) {
        uint256 _type = _nameToType[_assetName];

        require(_type != 0, "Type does not exist");

        return _typeMaxSupply[_type];
    }

    /// @notice Returns the current max index for a token type
    /// @param _type The token type
    function getMaxIndexForType(uint256 _type) public view returns (uint256) {
        return _maxIndex[_type];
    }

    /// @notice Allows contract owner to create an asset type so it can be minted
    /// @param _uri The base URI for that token type
    /// @param _name The name for that token type
    /// @param _maxSupply The max supply for that token type
    /// @param _isNF Wether this token type is a fungible or non-fungible token
    function createAssetType(
        string calldata _uri,
        string calldata _name,
        uint256 _maxSupply,
        bool   _isNF
    ) public onlyOwner whenNotPaused {
        // Store the type in the upper 128 bits
        uint256 _type = (++nonce << 128);

        // Set a flag if this is an NFI.
        if (_isNF)
          _type = _type | TYPE_BIT;

        // Set the max supply for this NFI (0 implies no limit)
        _typeMaxSupply[_type] = _maxSupply;

        // Keep track of asset type name
        _nameToType[_name] = _type;

        // emit a Transfer event with Create semantic to help with discovery.
        emit TransferSingle(msg.sender, address(0x0), address(0x0), _type, 0);

        if (bytes(_uri).length > 0) {
            _setTokenTypeUri(_type, _uri);
            emit URI(_uri, _type);
        }
    }

    /// @notice Mints one non-fungible token to the given addresses
    /// @param _type The token type to be minted
    /// @param _to Array of receiving addresses
    function mintNonFungible(
        uint256 _type,
        address[] calldata _to
    ) external onlyOwner whenNotPaused {
        uint256 newMaxIndex = _to.length + _maxIndex[_type];
        require(isNonFungible(_type), "Token type must be non-fungible");
        require(_typeMaxSupply[_type] == 0 || newMaxIndex <= _typeMaxSupply[_type], "Max supply reached for this token type");

        // Index are 1-based.
        uint256 index = _maxIndex[_type] + 1;
        _maxIndex[_type] = newMaxIndex;

        for (uint256 i = 0; i < _to.length; ++i) {
            address dst = _to[i];
            uint256 id  = _type | index + i;

            _mint(dst, id, 1, "");

            _setTokenUri(_type, id);
        }
    }

    /// @notice Mints an amount of fungible token to the given addresses
    /// @param _type The token type to be minted
    /// @param _to Array of receiving addresses
    /// @param _quantities Array of token quantities for each receiving address
    function mintFungible(
        uint256 _type,
        address[] calldata _to,
        uint256[] calldata _quantities
    ) external onlyOwner whenNotPaused {
        uint256 index = 1;
        uint256 id = _type | index;
        require(isFungible(id), "Token type must be fungible");

        for (uint256 i = 0; i < _to.length; ++i) {
            _mint(_to[i], id, _quantities[i], "");
        }

        _setTokenUri(_type, id);
    }

    /// TODO: Maybe we should implement a way to withdraw tokens from the contract if they accidentally get sent to it?
    function withdraw(uint256[] calldata _id, uint256[] calldata _quantities) public onlyOwner {

    }

    /// @dev Helper function
    function strConcat(string storage _a, string memory _b) internal pure returns (string memory){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);

        string memory ab = new string(_ba.length + _bb.length);
        bytes memory bab = bytes(ab);

        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
        for (uint i = 0; i < _bb.length; i++) bab[k++] = _bb[i];

        return string(bab);
    }
}