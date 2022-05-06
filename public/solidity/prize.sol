// SPDX-License-Identifier: MIT
pragma solidity ^0.8.00;

interface IERC20 {

    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IPancakeRouter {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}


interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

contract prizeGenerator {
    uint TotalUSDColected;
    address BUSDTokenAddress;
    address ETHTokenAddress;
    address BTCTokenAddress;
    uint ERC20decimals;
    IERC20 public Token;
    IERC20 public ContractBUSD;
    IERC20 public ContractETH;
    IERC20 public ContractBTC;
    IPancakeRouter public IDex;
    address BUSDBNBpair2address = 0xe0e92035077c39594793e61802a350347c320cf2; //BUSDBNBpairAddress
    address ETHBNBpair2address  = 0xb27F628C12573594437B180A1eA1542d15E0cb78; //ETHBNBpairAddress
    address BTCBNBpair2address  = 0x3129B45b375a11Abf010D2D10DB1E3DcF474A13c; //TSTBNBpairAddress
    address DRCBNBpair2address =  0x3129B45b375a11Abf010D2D10DB1E3DcF474A13c;
    address pancake_address = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
    address[] public prizeAddressList;
    address owner;

    //constructor (address payable _wallet) {
    constructor () {
        BUSDTokenAddress=0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7;
        ContractBUSD = IERC20(BUSDTokenAddress);
        ETHTokenAddress=0x8BaBbB98678facC7342735486C851ABD7A0d17Ca;
        ContractETH = IERC20(ETHTokenAddress);
        BTCTokenAddress=0xDAcbdeCc2992a63390d108e8507B98c7E2B5584a;
        ContractBTC = IERC20(BTCTokenAddress);
        IDex = IPancakeRouter(pancake_address);
        ERC20decimals = 1e18;
        owner=msg.sender;
    }
    
    struct prize{
        uint index;
        address manager;
    }
    mapping(address => prize) prizeStructs;

    function createPrize(uint _duration, uint _goal) public {
        require(_duration > 1000,"minimun duration is 1000 seconds");
        require(_goal > 100,"minimun goal is 100 USD");
        address newPrize = address(new Prize(payable(msg.sender),payable(owner),_duration, _goal));
        prizeAddressList.push(newPrize);
        prizeStructs[newPrize].index = prizeAddressList.length - 1;
        prizeStructs[newPrize].manager = msg.sender;

        // event
        emit prizeCreated(newPrize);
    }


    // Events
    event prizeCreated(
        address prizeAddress
    );
}

contract Prize {
    uint TotalUSDColected;
    address DRCTokenAddress;
    address BUSDTokenAddress;
    address ETHTokenAddress;
    address BTCTokenAddress;
    uint ERC20decimals;
    IERC20 public ContractDRC;
    IERC20 public ContractBUSD;
    IERC20 public ContractETH;
    IERC20 public ContractBTC;
    IPancakeRouter public IDex;
    address BUSDBNBpair2address = 0xe0e92035077c39594793e61802a350347c320cf2; //BUSDBNBpairAddress
    address ETHBNBpair2address  = 0xb27F628C12573594437B180A1eA1542d15E0cb78; //ETHBNBpairAddress
    address BTCBNBpair2address  = 0x3129B45b375a11Abf010D2D10DB1E3DcF474A13c; //TSTBNBpairAddress
    address DRCBNBpair2address =  0x3129B45b375a11Abf010D2D10DB1E3DcF474A13c;
    address pancake_address = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
    address[] public prizeAddressList;
    // name of the prize
    string public prizeName;
    // Creator of the prize contract
    address public manager;

    address[] public addressIndexes;
    mapping(address => uint) address2Entries; //total entries bought by the address
    mapping(address => bool) address2state; //view if address is new
    mapping(uint => uint) USDamount2tickets; //amount of tickets in USD packets
    mapping (uint => mapping (address => uint)) coin_address2invested; //0 BNB 1 BUSD 2 ETH 3 BTC 4 DRC 5 Todos en USD
    mapping (uint => uint) coin2recolected;

    address[] public prizeBag;

    // Variables for prize information
    address public winner;
    uint winnerEntryCount;
    address public factory;
    address public owner;
    bool public isPrizeLive;
    bool public refundState;
    uint public initialTime;
    uint public finalTime;
    uint public duration;
    uint public goal;

    // constructor
    constructor(address _manager,address _owner, uint _duration, uint _goal) {
        duration=_duration;
        initialTime=block.timestamp;
        finalTime=initialTime+duration;
        factory=msg.sender;
        manager = _manager;
        owner = _owner;
        goal=_goal;
        isPrizeLive = true;
        USDamount2tickets[5]=20;
        USDamount2tickets[10]=50;
        USDamount2tickets[25]=200;
        USDamount2tickets[100]=1200;
        BUSDTokenAddress=0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7;
        ContractBUSD = IERC20(BUSDTokenAddress);
        ETHTokenAddress=0x8BaBbB98678facC7342735486C851ABD7A0d17Ca;
        ContractETH = IERC20(ETHTokenAddress);
        BTCTokenAddress=0xDAcbdeCc2992a63390d108e8507B98c7E2B5584a;
        ContractBTC = IERC20(BTCTokenAddress);
        DRCTokenAddress=0xDAcbdeCc2992a63390d108e8507B98c7E2B5584a;
        ContractDRC = IERC20(DRCTokenAddress);
        IDex = IPancakeRouter(pancake_address);
        ERC20decimals = 1e18;
    }
   function getTokenPrice(address _pairAddress) public view returns(uint priceERC20dec){
        IUniswapV2Pair pair = IUniswapV2Pair(_pairAddress);
        (uint Res0, uint Res1,) = pair.getReserves();
        return(Res0*ERC20decimals/Res1); // return amount of token0 needed to buy token1
   }

   function getBNBperUSD(uint _USDAmount) public view returns(uint BNBforUSDinput){
       return(_USDAmount*ERC20decimals/getTokenPrice(BUSDBNBpair2address));
   }
   function getETHperUSD(uint _USDAmount) public view returns(uint BNBforUSDinput){
       return(_USDAmount*getTokenPrice(ETHBNBpair2address)/getTokenPrice(BUSDBNBpair2address));
   }
   function getBTCperUSD(uint _USDAmount) public view returns(uint BNBforUSDinput){
       return(_USDAmount*getTokenPrice(BTCBNBpair2address)/getTokenPrice(BUSDBNBpair2address));
   }
   function getDRCperUSD(uint _USDAmount) public view returns(uint BNBforUSDinput){
       return(_USDAmount*getTokenPrice(DRCBNBpair2address)/getTokenPrice(BUSDBNBpair2address));
   }

    function participate_bnb(uint _USDAmount) public payable{
        require(_USDAmount==5 || _USDAmount==10 || _USDAmount==25 || _USDAmount==100, "must be permited buy value 5,10,25 or 100 USD");
        require(isPrizeLive);
        uint buy_token_amount=getBNBperUSD(_USDAmount);
        require(msg.value>=buy_token_amount,"no se envio suficiente BNB en la transaccion");
        coin_address2invested[0][msg.sender]+=buy_token_amount;
        if(msg.value>buy_token_amount){
            payable(msg.sender).transfer(msg.value-buy_token_amount);
        }
    }

    function participate_token(uint _USDAmount, uint _tokenID)public{
        require(_USDAmount==5 || _USDAmount==10 || _USDAmount==25 || _USDAmount==100, "must be permited buy value 5,10,25 or 100 USD");
        require(isPrizeLive);
        uint buy_token_amount;
        coin_address2invested[5][msg.sender]+=_USDAmount;
        coin2recolected[5]+=_USDAmount;
        if(_tokenID==1){ //BUSD
            buy_token_amount=_USDAmount;
            require(ContractBUSD.allowance(msg.sender,address(this))>=buy_token_amount,"contract BUSD not autorized");
            require(ContractBUSD.balanceOf(msg.sender)>=buy_token_amount,"not enought BUSD");
            ContractBUSD.transferFrom(msg.sender, address(this),buy_token_amount);
            coin_address2invested[1][msg.sender]+=buy_token_amount;
            coin2recolected[1]+=buy_token_amount;
        }
        else if(_tokenID==2){  //ETH
            buy_token_amount=getETHperUSD(_USDAmount);
            require(ContractETH.allowance(msg.sender,address(this))>=buy_token_amount,"contract ETH not autorized");
            require(ContractETH.balanceOf(msg.sender)>=buy_token_amount,"not enough ETH");
            ContractETH.transferFrom(msg.sender, address(this),buy_token_amount);
            coin_address2invested[2][msg.sender]+=buy_token_amount;
            coin2recolected[2]+=buy_token_amount;
        }
        else if (_tokenID==3){ //BTC
            buy_token_amount=getBTCperUSD(_USDAmount);
            require(ContractBTC.allowance(msg.sender,address(this))>=buy_token_amount,"contract BTC not autorized");
            require(ContractBTC.balanceOf(msg.sender)>=buy_token_amount,"not enough BTC");
            ContractBTC.transferFrom(msg.sender, address(this),buy_token_amount);
            coin_address2invested[3][msg.sender]+=buy_token_amount;
            coin2recolected[3]+=buy_token_amount;
        }
        else if (_tokenID==4){ //DRC
            buy_token_amount=getDRCperUSD(_USDAmount);
            require(ContractDRC.allowance(msg.sender,address(this))>=buy_token_amount,"contract DRC not autorized");
            require(ContractDRC.balanceOf(msg.sender)>=buy_token_amount,"not enough DRC");
            ContractDRC.transferFrom(msg.sender, address(this),buy_token_amount);
            coin_address2invested[4][msg.sender]+=buy_token_amount;
            coin2recolected[4]+=buy_token_amount;
            _USDAmount=_USDAmount*110/100;
        }
        asignIndex(_USDAmount);
    }


    function asignIndex(uint _USDAmount) private {
        if (!address2state[msg.sender]) {
            addressIndexes.push(msg.sender);
            address2state[msg.sender]=true;
        } 
        for (uint i=0; i<=USDamount2tickets[_USDAmount]; i++){
            address2Entries[msg.sender] += 1;
            prizeBag.push(msg.sender);
        }
        // event
        emit PlayerParticipated(msg.sender, address2Entries[msg.sender]);
    }


    function declareWinner() public restricted {
        require(prizeBag.length > 0, "must be at least one participant");
        require(block.timestamp>finalTime, "time must be over");
        if (goal>coin2recolected[5]){
            // Mark the prize inactive
            isPrizeLive = false;
            refundState=true;
        }
        else {
            uint index = generateRandomNumber() % prizeBag.length;
            payable(prizeBag[index]).transfer(address(this).balance);
    
            winner = prizeBag[index];
            winnerEntryCount = address2Entries[prizeBag[index]];

            // Mark the prize inactive
            isPrizeLive = false;
        
            // event
            emit WinnerDeclared(winner, address2Entries[winner]);
            uint balanceBNB = address(this).balance;
            uint balanceBUSD = ContractBUSD.balanceOf(address(this));
            uint balanceETH = ContractETH.balanceOf(address(this));
            uint balanceBTC = ContractBTC.balanceOf(address(this));
            uint balanceDRC = ContractDRC.balanceOf(address(this));
            if(balanceBNB>0){
                payable(msg.sender).transfer(balanceBNB*60/100);
                payable(manager).transfer(balanceBNB*20/100);
                payable(owner).transfer(balanceBNB*20/100);
            }
            if(balanceBUSD>0){
                ContractBUSD.transfer(msg.sender,balanceBUSD*60/100);
                ContractBUSD.transfer(manager,balanceBUSD*20/100);
                ContractBUSD.transfer(owner,balanceBUSD*20/100);
            }
            if(balanceBTC>0){
                ContractBTC.transfer(msg.sender,balanceBTC*60/100);
                ContractBTC.transfer(manager,balanceBTC*20/100);
                ContractBTC.transfer(owner,balanceBTC*20/100);
            }
            if(balanceDRC>0){
                ContractDRC.transfer(msg.sender,balanceDRC*60/100);
                ContractDRC.transfer(manager,balanceDRC*20/100);
                ContractDRC.transfer(owner,balanceDRC*20/100);
            }
            if(balanceETH>0){
                ContractETH.transfer(msg.sender,balanceETH*60/100);
                ContractETH.transfer(manager,balanceETH*20/100);
                ContractETH.transfer(owner,balanceETH*20/100);
            }
        }
    }

    function get_refund() public{
        require(refundState,"refund not activated");
        if(coin_address2invested[0][msg.sender]>0){
            payable(msg.sender).transfer(coin_address2invested[0][msg.sender]);
        }
        if(coin_address2invested[1][msg.sender]>0){
            ContractBUSD.transfer(msg.sender,coin_address2invested[1][msg.sender]);
        }
        if(coin_address2invested[2][msg.sender]>0){
            ContractETH.transfer(msg.sender,coin_address2invested[2][msg.sender]);
        }
        if(coin_address2invested[3][msg.sender]>0){
            ContractBTC.transfer(msg.sender,coin_address2invested[3][msg.sender]);
        }
        if(coin_address2invested[4][msg.sender]>0){
            ContractDRC.transfer(msg.sender,coin_address2invested[4][msg.sender]);
        }
    }

    function getWinningPrice() public view returns (uint) {
        return address(this).balance;
    }


    // NOTE: This should not be used for generating random number in real world
    function generateRandomNumber() private view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, prizeBag)));
    }

    // Modifiers
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    // Events
    event WinnerDeclared( address winner, uint entryCount );
    event PlayerParticipated( address participant, uint entryCount );
}