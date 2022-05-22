// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract ERC20 {
    string _name = "ERC223 Token";
    string _symbol = "E223";
    uint8 _decimals = 8;
    uint _totalSupply;
    mapping (address => uint256) _balances;

    event Transfer(address from, address to, uint amount);

    constructor(string memory new_name, string memory new_symbol, string memory new_decimals) {
        _name = new_name;
        _symbol = new_symbol;
        _decimals = new_decimals;
    }

    function name() public view returns (string memory tokenName) {
        tokenName = _name;
    }

    function symbol() public view returns (string memory tokenSymbol) {
        tokenSymbol = _symbol;
    }

    function decimals() public view returns (uint8 tokenDecimals) {
        tokenDecimals = _decimals;
    }

    function totalSupply() public view returns (uint tokenTotalSupply) {
        tokenTotalSupply = _totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        balance = _balances[_owner];
    }

    function transfer(address _to, uint _value, bytes calldata _data) public override returns (bool success) {
        require(_balances[msg.sender] > _value, "ERROR: amount transferred exceed balance");
        _balances[msg.sender] = _balances[msg.sender] - _value;
        _balances[_to] = _balances[_to] + _value;
        if(Address.isContract(_to)) {
            IERC223Recipient(_to).tokenReceived(msg.sender, _value, _data);
        }
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        bytes memory _empty = hex"00000000";
        transfer(_to, _value, _empty);
    }
}
