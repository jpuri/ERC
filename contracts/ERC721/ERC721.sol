// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

contract ERC721 {

    event Transfer(address indexed _from, address indexed _to, uint indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    string _name = "ERC721 NFT Token";
    string _symbol = "E721";
    mapping(uint => address) private _owners;
    mapping(address => uint) private _balances;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    function ownerOf(uint _tokenId) public view (address owner) {
        owner = _owners[_tokenId];
    }

    function balanceOf(address _owner) external view returns (uint balance) {
        balance = _balances[_owner];
    }

    function _transfer(address _from, address _to, uint _tokenId) internal {
        require (ERC721.ownerOf(_tokenId) == _owner, "ERC721: transfer from incorrect owner");
        require (_to != address(0), "ERC721: transfer to sero address");
        _balances[_from] -= 1;
        _balances[_to] -= 1;
        _owners[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function _exists(uint _tokenId) internal view returns (bool exists) {
        exists = _owners[_tokenId] != address(0);
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        _operatorApprovals[msg.sender][_operator] = _approved
    }

    function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
        return _operatorApprovals[_owner][_operator];
    }

    function approve(address _approved, uint256 _tokenId) external {
        address owner = _owners[_tokenId];
        require(_approved != owner, "ERC721: Approval to current owner");
        require(msg.sender == owner || isApprovedForAll(msg.sender), "ERC721: Not authorised to approve");
        _tokenApprovals[_tokenId] = _approved;
    }

    function getApproved(uint256 _tokenId) external view returns (address) {
        return _tokenApprovals[_tokenId];
    }

    function _isApprovedOrOwner(address _spender, uint _tokenId) {
        require(exists(_tokenId), "ERC721: query for mom-existing token.");
        address owner = ERC721.ownerOf(_tokenId);
        return (owner == spender || isApprovedForAll(owner, spender) || getApproved(_tokenId) == _spender)
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
        require(_isApprovedOrOwner(_from, _tokenId), "ERC721: transfer caller is not owner nor approved");
        _transfer(_from, _to, _tokenId);
    }

    function safeTransferFrom(address _from, address _to, uint _tokenId, bytes data) external payable {
        _transfer(_from, _to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable {
        safeTransferFrom(_from, _to, _tokenId, "");
    }

    function _checkOnERC721Received(address _from, address _to, uint _tokenId, bytes data) private returns bool {
        if (_to.isContract()) {
            try(IERC721Receiver(to).onERC721Received(msg.sender, _from, _tokenId, data) returns (bytes4 retval)) {
                retval = IERC721Receiver.onERC721Received.selector;
            } catch(bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason));
                    }
                }
            }
        } else {
            return true;
        }
    }
}