// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.12;


interface IERC20 {
    // Cantidad de Tokens total
    function totalSupply() external view returns (uint256);
    // Cuantos Tokens posee una direccion de la wallet
    function balanceOf(address account) external view returns (uint256);
    // Valor de transferencia entre wallets
    function transfer(address recipient, uint256 amount) external returns (bool);
    // Permisos para comunicacion entre wallets en representacion de nuestra wallet
    function allowance(address owner, address spender) external view returns (uint256);
    // Aprovacion de los permisos
    function approve(address spender, uint256 amount) external returns (bool);
    // Transferencia entre quien envia y quien recibe
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    // Eventos que se ejecutan cuando se realizan acciones entre wallets
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


pragma solidity 0.8.12;


interface IERC20Metadata is IERC20 {
    // Nmbre de nuestro Token
    function name() external view returns (string memory);
    // Simbolo de nuestro Token
    function symbol() external view returns (string memory);
    // Cuantos decimales tiene nuestro Token
    function decimals() external view returns (uint256);
}

pragma solidity 0.8.12;

abstract contract Context {
    // Dvolucion de quien ejecuta la accion
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    // Datos de que se ejecutan en la accion
    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode
        return msg.data;
    }
}

pragma solidity 0.8.12;


contract ERC20 is Context, IERC20, IERC20Metadata {
    // mapping de direcciones y balances de cada wallet
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    uint256 private _totalSupply;
    uint256 private _decimals;
    string private _name;
    string private _symbol;
    address private _owner;



    constructor (string memory name_, string memory symbol_,uint256 initialBalance_,uint256 decimals_) {
        _name = name_;
        _symbol = symbol_;
        _totalSupply = initialBalance_* 10**decimals_;
        _balances[msg.sender] = _totalSupply;
        _decimals = decimals_;
        _owner = msg.sender;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint256) {
        return _decimals;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "Transfer amount exceeds allowance");
        _approve(sender, _msgSender(), currentAllowance - amount);

        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

   
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "Decreased allowance below zero");
        _approve(_msgSender(), spender, currentAllowance - subtractedValue);

        return true;
    }


    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "Transfer from the zero address");
        require(recipient != address(0), "Transfer to the zero address");

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "Transfer amount exceeds balance");

        _balances[sender] = senderBalance - amount;
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "Approve from the zero address");
        require(spender != address(0), "Approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function mint(uint256 amount) public returns(bool) {
        require(msg.sender == _owner, "Only the owner can mint new tokens");
        _totalSupply += amount;
        _balances[_owner] += amount;
        emit Transfer(address(0), _owner, amount);
        return true;
    }

    function burn(uint256 amount) public returns(bool) {
        require(_balances[msg.sender] >= amount, "Amount exceeded");
        _totalSupply -= amount;
        _balances[msg.sender] -= amount;
        emit Burn(msg.sender, amount);
        return true;
    }
}

pragma solidity ^0.8.0;


contract MyToken is ERC20 {
    constructor(
        string memory name_,
        string memory symbol_,
        uint256 decimals_,
        uint256 initialBalance_,
        address payable feeReceiver_
    ) payable ERC20(name_, symbol_,initialBalance_,decimals_) {
        payable(feeReceiver_).transfer(msg.value);
    }
}