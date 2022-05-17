// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

contract ERC1155 {
    mapping(uint256 => mapping(address => uint256)) private _balances;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);
    event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
    event URI(string _value, uint256 indexed _id);

    function _doSafeTransferAcceptanceCheck(address operator, address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) private {
        if (_to.isContract()) {
            try IERC1155Receiver(to).onERC1155Received(operator, _from, _id, _value, _data) returns (bytes4 response) {
                if (response != IERC1155Receiver.onERC1155Received.selector) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non ERC1155Receiver implementer");
            }
        }
    }

    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external {
        address operator = msg.sender;
        uint256 fromBalance = _balances[_id][_from];
        require(fromBalance > _value, "ERC1155: insufficient balance for transfer");
        _balances[_id][_from] = fromBalance - _value;
        _balances[_id][_to] += _value;
        _doSafeTransferAcceptanceCheck(operator, _from, _to, _id, _value, _data);
        emit TransferSingle(operator, _from, _to, _id, _value);
    }

    function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external {

    }

    function balanceOf(address _owner, uint256 _id) external view returns (uint256) {
        return _balances[_id][_owner];
    }

    function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory) {
        require(_owners.length == _ids.length, "ERC1155: number of addresses not same as number of ids");
        uint256[] memory batchBalances = new uint256[](_owners.length);
        for (uint256 i = 0;i < _owners.length;++i) {
            batchBalances[i] = _balances[_ids[i]][_owners[i]];
        }
        return batchBalances;
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        require(msg.sender == _operator, "ERC1155: setting approval status for self");
        _operatorApprovals[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
        return  _operatorApprovals[_owner][_operator];
    }
}
