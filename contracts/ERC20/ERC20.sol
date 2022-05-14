// SPDX-License-Identifier: MIT

pragma solidity >=0.4.21 < 0.7.0;

contract ERC20 {
    string _name = "ERC20 Token";
    string _symbol = "E20";
    uint8 _decimals = 8;
    uint _totalSupply;
    mapping (address => uint256) _balances;
    mapping (address => mapping (address => uint256)) _allowances;

    event Transfer(address from, address to, uint amount);
    event Approval(address owner, address spender, uint amount);

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

    function allowance(address _owner, address _spender) public view returns (uint256 tokenAllowance) {
        tokenAllowance = _allowances[_owner][_spender];
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_balances[msg.sender] > _value, "ERROR: amount transferred exceed balance");
        _balances[msg.sender] -= _value;
        _balances[_to] -= _value;
        emit Transfer(msg.sender, _to, _value);
        success = true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_allowances[_from][msg.sender] > _value, "ERROR: amount transferred exceed allowance");
        require(_balances[msg.sender] > _value, "ERROR: amount transferred exceed balance");
        _balances[_from] -= _value;
        _balances[_to] -= _value;
        _allowances[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        success = true;
    }

    function approve(address spender, uint256 _value) public returns (bool success) {
        _allowances[msg.sender][spender] = _value;
        emit Approval(msg.sender, spender, _value);
        success = true;
    }
}
