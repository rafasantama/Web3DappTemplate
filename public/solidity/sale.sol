// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract ERC20 {
  uint public totalSupply;
  function balanceOf(address who) public virtual returns (uint);
  function allowance(address owner, address spender) public view virtual returns (uint);
  function transfer(address to, uint value) public virtual returns (bool ok);
  function transferFrom(address from, address to, uint value) public virtual returns (bool ok);
  function approve(address spender, uint value) public virtual returns (bool);
  function create_held_tokens(uint _value) public virtual;
  function mint_presale_tokens(address _buyer, uint _value) public virtual;
  function burn(uint _amount) public virtual;
  function approveDex() public virtual;
  //function mintToken(address to, uint256 value) public virtual returns (uint256);
  function changeTransfer(bool allowed) public virtual;
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

contract Sale {
    address public token_address;
    uint256 public maxMintable;
    uint256 public totalMinted;
    uint public maxLimitBuyAmount;
    uint public duration;
    uint public exchangeRate;
    bool public isFunding;
    bool public refund_state;
    mapping (address => bool) public address2refund_state;
    ERC20 public Token;
    ERC20 public ContractBUSD;
    ERC20 public ContractETH;
    ERC20 public ContractBTC;
    IPancakeRouter public IDex;
    address payable public BNBWallet;
    uint256 public heldTotal;
    uint256 public heldBlockLimit;
    mapping (uint => uint) public stageDiscount;
    uint public actual_stage=1;
    mapping (uint => uint) public stageLimit;
    mapping (uint => uint) public stageRate;
    mapping (uint => uint) public stageAmount;
    mapping (uint => uint) public coin2recolected;
    mapping (uint => bool) public stage2state;
    mapping (uint => uint) tokenID2rate;
    uint public goal_count;
    uint amount;
    uint public wei_limit;
    uint public max_wei_unverified;
    uint ERC20decimals;
    uint TokenDecimals;
    uint public HeldTokens;
    uint public foundersHeld;
    uint public airdropHeld;
    uint public poolTokens;
    uint public presaleTokens;
    uint public notSaleTokens;
    uint public poolDeployTime;
    //uint public burn_period=2628000;
    uint public burn_period=60;
    uint public burnStage;
    //uint BUSDBNBprice_update;
    bool private configSet;
    address public creator;
    uint rateCeros;
    uint buy_amount;
    mapping (uint => uint) public stageAmount_count;
    address BUSDBNBpair2address = 0xe0e92035077c39594793e61802a350347c320cf2; //BUSDBNBpairAddress
    address ETHBNBpair2address  = 0xb27F628C12573594437B180A1eA1542d15E0cb78; //ETHBNBpairAddress
    address BTCBNBpair2address  = 0x3129B45b375a11Abf010D2D10DB1E3DcF474A13c; //TSTBNBpairAddress
    address pancake_address = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
    uint foundersCapitalPercentage = 30; //1-100 Percentage for capital pool
    mapping (uint => uint) public maxFoundersCap;
    mapping (uint => uint) public availableCap;
    mapping (uint => uint) stageDistributionPercentage;
    mapping (uint => mapping (address => uint)) public stage_address2supply;
    mapping (address => bool) public address2verificado;
    mapping (uint => mapping (uint => mapping (address => uint))) public coin_stage_address2invested;
    mapping (uint => uint) public coin2USDcapital;
    mapping (uint => uint) public Coin2CapitalPercentage;
    mapping (uint => uint) public coin2PoolTokens;
    mapping (uint => uint) public totalBurnCoins;
    uint DexPrice;
    uint PoolFinalLiquidity;
    uint TotalUSDColected;
    address BUSDTokenAddress;
    address ETHTokenAddress;
    address BTCTokenAddress;

    event Contribution(address from, uint256 amount);
    event ReleaseTokens(address from, uint256 amount);

    //constructor (address payable _wallet) {
    constructor () {
        BUSDTokenAddress=0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7;
        ContractBUSD = ERC20(BUSDTokenAddress);
        ETHTokenAddress=0x8BaBbB98678facC7342735486C851ABD7A0d17Ca;
        ContractETH = ERC20(ETHTokenAddress);
        BTCTokenAddress=0xDAcbdeCc2992a63390d108e8507B98c7E2B5584a;
        ContractBTC = ERC20(BTCTokenAddress);
        IDex = IPancakeRouter(pancake_address);
        ERC20decimals = 1e18;
        TokenDecimals = 1e18;
        maxMintable = 10000000*TokenDecimals; //Token with 18 decimals
        //BNBWallet = _wallet;
        BNBWallet = payable(msg.sender);
        isFunding = true;
        creator = msg.sender;
        HeldTokens = maxMintable*45/100;
        airdropHeld = HeldTokens*10/100;
        foundersHeld = HeldTokens*50/100;
        poolTokens = (maxMintable - HeldTokens)*30/100;
        notSaleTokens = HeldTokens + poolTokens;
        presaleTokens = maxMintable - notSaleTokens;
        actual_stage = 1;
        stageDistributionPercentage[1]=20;
        stageDistributionPercentage[2]=30;
        stageDistributionPercentage[3]=50;
        stageLimit[1] = presaleTokens*stageDistributionPercentage[1]/100; //Token with 18 decimals
        stageLimit[2] = stageLimit[1]+(presaleTokens*stageDistributionPercentage[2]/100); //Token with 18 decimals
        stageLimit[3] = stageLimit[2]+(presaleTokens*stageDistributionPercentage[3]/100); //Token with 18 decimals
        stageRate[3] = 164502164502165;
        stageDiscount[1] = 50; 
        stageDiscount[2] = 75;  
        rateCeros = 1e18; //testnet
        stageRate[1]= stageRate[3] * stageDiscount[1] / 100;
        stageRate[2] = stageRate[3] * stageDiscount[2] / 100;

        wei_limit = 1000000*ERC20decimals;
        max_wei_unverified = 1000*ERC20decimals; 
    }

    function setup(address _token_address, uint _duration) public {
        require(!configSet);
        require(msg.sender == creator);
        token_address=_token_address;
        Token = ERC20(_token_address);
        duration = block.timestamp + _duration;
        configSet = true;
    }

    function get_Capital() public {
      require(msg.sender == creator);
     
      if (totalMinted > stageLimit[1]) {
            maxFoundersCap[0]=coin2recolected[0]*foundersCapitalPercentage/100;
            availableCap[0]=maxFoundersCap[0]-availableCap[0];
            if (availableCap[0]>0){
                BNBWallet.transfer(availableCap[0]);
            }
            maxFoundersCap[1]=coin2recolected[1]*foundersCapitalPercentage/100;
            availableCap[1]=maxFoundersCap[1]-availableCap[1];
            if (availableCap[1]>0){
                ContractBUSD.transfer(msg.sender, availableCap[1]);
            }
            maxFoundersCap[2]=coin2recolected[2]*foundersCapitalPercentage/100;
            availableCap[2]=maxFoundersCap[2]-availableCap[2];
            if (availableCap[2]>0){
                ContractETH.transfer(msg.sender, availableCap[2]);
            }
            maxFoundersCap[3]=coin2recolected[3]*foundersCapitalPercentage/100;
            availableCap[3]=maxFoundersCap[3]-availableCap[3];
            if (availableCap[3]>0){
                ContractBTC.transfer(msg.sender, availableCap[3]);
            }
      }
      else if (block.timestamp >= duration){
            refund_state = true;
            isFunding = false;
        }
    }

    function create_pools() public{
        require(block.timestamp>duration,"time is not over");
        require(msg.sender == creator, "must be creator");
        get_Capital();
        if(isFunding && !refund_state){
            Token.transfer(creator,foundersHeld+airdropHeld);
            //require(block.timestamp>duration,"time left");
            uint _balanceBNB= address(this).balance;
            uint _balanceUSD=ContractBUSD.balanceOf(address(this));
            uint _balanceETH=ContractETH.balanceOf(address(this));
            uint _balanceBTC=ContractBTC.balanceOf(address(this));
        
            coin2USDcapital[0]=_balanceBNB*getTokenPrice(BUSDBNBpair2address)/ERC20decimals;
            coin2USDcapital[1]=_balanceUSD;
            coin2USDcapital[2]=_balanceETH*getTokenPrice(BUSDBNBpair2address)/getTokenPrice(ETHBNBpair2address);
            coin2USDcapital[3]=_balanceBTC*getTokenPrice(BUSDBNBpair2address)/getTokenPrice(BTCBNBpair2address);
            TotalUSDColected=coin2USDcapital[0]+coin2USDcapital[1]+coin2USDcapital[2]+coin2USDcapital[3];
            DexPrice=stageRate[5]*150/100;
            PoolFinalLiquidity=TotalUSDColected*rateCeros/DexPrice;
            Coin2CapitalPercentage[0]=coin2USDcapital[0]*1000000/TotalUSDColected; //1000000 for percentage with 4 decimal res
            Coin2CapitalPercentage[1]=coin2USDcapital[1]*1000000/TotalUSDColected; //1000000 for percentage with 4 decimal res
            Coin2CapitalPercentage[2]=coin2USDcapital[2]*1000000/TotalUSDColected; //1000000 for percentage with 4 decimal res
            Coin2CapitalPercentage[3]=coin2USDcapital[3]*1000000/TotalUSDColected; //1000000 for percentage with 4 decimal res
            
            if(_balanceBNB>0){
                coin2PoolTokens[0]=PoolFinalLiquidity*Coin2CapitalPercentage[0]/1000000; //1000000 for percentage with 4 decimal res
                Token.approve(pancake_address,coin2PoolTokens[0]);
                IDex.addLiquidityETH{value:_balanceBNB} (token_address, coin2PoolTokens[0],0, 0, address(this),block.timestamp + 10800 );
            }
            if(_balanceUSD>0){
                coin2PoolTokens[1]=PoolFinalLiquidity*Coin2CapitalPercentage[1]/1000000; //1000000 for percentage with 4 decimal res
                Token.approve(pancake_address,coin2PoolTokens[1]);
                ContractBUSD.approve(pancake_address,_balanceUSD);
                IDex.addLiquidity(token_address,BUSDTokenAddress, coin2PoolTokens[1],_balanceUSD,0, 0, address(this),block.timestamp + 10800 );
            }
            if(_balanceETH>0){
                coin2PoolTokens[2]=PoolFinalLiquidity*Coin2CapitalPercentage[2]/1000000; //1000000 for percentage with 4 decimal res
                Token.approve(pancake_address,coin2PoolTokens[2]);
                ContractETH.approve(pancake_address,_balanceETH);
                IDex.addLiquidity(token_address,ETHTokenAddress, coin2PoolTokens[2],_balanceETH,0, 0, address(this),block.timestamp + 10800 );
            }
            if(_balanceBTC>0){
                coin2PoolTokens[3]=PoolFinalLiquidity*Coin2CapitalPercentage[3]/1000000; //1000000 for percentage with 4 decimal res
                Token.approve(pancake_address,coin2PoolTokens[3]);
                ContractBTC.approve(pancake_address,_balanceBTC);
                IDex.addLiquidity(token_address,BTCTokenAddress, coin2PoolTokens[3],_balanceBTC,0, 0, address(this),block.timestamp + 10800 );
            }
            totalBurnCoins[0]=Token.balanceOf(address(this))-airdropHeld;
            totalBurnCoins[1]=totalBurnCoins[0]*50/100;
            totalBurnCoins[2]=totalBurnCoins[0]*30/100;
            totalBurnCoins[3]=totalBurnCoins[0]*20/100;
            Token.approveDex();
            poolDeployTime=block.timestamp;
            burnStage=1;
            isFunding = false;
        }
    }
   
    function refund() public {
        require(!isFunding);
        require (refund_state);
        require (!address2refund_state[msg.sender]); 
        if (actual_stage==1){
            address payable refund_address = payable(msg.sender);
            if(coin_stage_address2invested[0][0][msg.sender]>0){
                refund_address.transfer(coin_stage_address2invested[0][0][msg.sender]);
            }
            if (coin_stage_address2invested[1][0][msg.sender]>0){
                ContractBUSD.transfer(msg.sender,coin_stage_address2invested[1][0][msg.sender]);
            }
            if (coin_stage_address2invested[2][0][msg.sender]>0){
                ContractETH.transfer(msg.sender,coin_stage_address2invested[2][0][msg.sender]);
            }
            if (coin_stage_address2invested[3][0][msg.sender]>0){
                ContractBTC.transfer(msg.sender,coin_stage_address2invested[3][0][msg.sender]);
            }
            coin_stage_address2invested[0][0][msg.sender]=0;
            coin_stage_address2invested[1][0][msg.sender]=0;
            coin_stage_address2invested[2][0][msg.sender]=0;
            coin_stage_address2invested[3][0][msg.sender]=0;
            address2refund_state[msg.sender]=true;
        }
    }

   function getTokenPrice(address _pairAddress) public view returns(uint priceERC20dec)
   {
    IUniswapV2Pair pair = IUniswapV2Pair(_pairAddress);
    (uint Res0, uint Res1,) = pair.getReserves();
    return(Res0*ERC20decimals/Res1); // return amount of token0 needed to buy token1
   }

    //CONTRIBUTE FUNCTION (converts BNB to TOKEN and sends new TOKEN to the sender)
    function contribute_bnb() external payable {
        tokenID2rate[0]=getTokenPrice(BUSDBNBpair2address)/ERC20decimals;
        contribute_mint(msg.value*tokenID2rate[0], 0);
        coin2recolected[0]+=msg.value;
    }
    //CONTRIBUTE FUNCTION (converts ETH to TOKEN and sends new TOKEN to the sender)
    function contribute_token(uint _tokenID, uint _tokenValue) public {
        if(_tokenID==1){
            require(ContractBUSD.allowance(msg.sender,address(this))>=_tokenValue,"contract BUSD not autorized");
            require(ContractBUSD.balanceOf(msg.sender)>=_tokenValue,"not enought BUSD");
            ContractBUSD.transferFrom(msg.sender, address(this),_tokenValue);
            tokenID2rate[1]=1;
            buy_amount = _tokenValue;
            coin2recolected[1]+=_tokenValue;
        }
        else if(_tokenID==2){
            require(ContractETH.allowance(msg.sender,address(this))>=_tokenValue,"contract ETH not autorized");
            require(ContractETH.balanceOf(msg.sender)>=_tokenValue,"not enough ETH");
            ContractETH.transferFrom(msg.sender, address(this),_tokenValue);
            coin2recolected[2]+=_tokenValue;
            tokenID2rate[2]=getTokenPrice(BUSDBNBpair2address)/getTokenPrice(ETHBNBpair2address);
            buy_amount = _tokenValue*tokenID2rate[2];
        }
        else if (_tokenID==3){
            require(ContractBTC.allowance(msg.sender,address(this))>=_tokenValue,"contract BTC not autorized");
            require(ContractBTC.balanceOf(msg.sender)>=_tokenValue,"not enough BTC");
            ContractBTC.transferFrom(msg.sender, address(this),_tokenValue);
            coin2recolected[3]+=_tokenValue;
            tokenID2rate[3]=getTokenPrice(BUSDBNBpair2address)/getTokenPrice(BTCBNBpair2address);
            buy_amount = _tokenValue*tokenID2rate[3];
        }
        contribute_mint(buy_amount,_tokenID);
    }

        //CONTRIBUTE FUNCTION (converts ETH to TOKEN and sends new TOKEN to the sender)
    function contribute_mint(uint _buy_amount, uint _tokenID) internal {
        require(_buy_amount > 0, "Equivalente en BUSD enviados = 0");
        require(isFunding, "Campaign is over");
        require(block.timestamp <= duration, "Campaign time over");
        if (!address2verificado[msg.sender]){
            require(_buy_amount + coin_stage_address2invested[4][0][msg.sender] <= max_wei_unverified, "Supera el monto maximo para no verificados");
        }
        else {
            require(coin_stage_address2invested[4][0][msg.sender] + _buy_amount <= wei_limit, "Supera el monto maximo de inversion en ether por inversionista");
        }
        stageAmount[1] = 0;
        stageAmount[2] = 0;
        stageAmount[3] = 0;
        phase_check(actual_stage,_buy_amount, _tokenID);
        require(totalMinted < maxMintable, "No es posible crear mas monedas");
        goal_count = goal_count + _buy_amount;
        amount = stageAmount[1] + stageAmount[2] + stageAmount[3]+ stageAmount[4]+ stageAmount[5];
        Token.transfer(msg.sender, amount);
        emit Contribution(msg.sender, amount);
    }
    function phase_check(uint _actual_stage, uint _buy_amount, uint _tokenID) internal{
        stageAmount[_actual_stage] = (_buy_amount*rateCeros) / stageRate[_actual_stage];
        if (totalMinted + stageAmount[_actual_stage] >= stageLimit[_actual_stage]){
            stageAmount[_actual_stage] = stageLimit[_actual_stage] - totalMinted;//new stage amount
            maxLimitBuyAmount=(stageAmount[_actual_stage]*stageRate[_actual_stage] /rateCeros);
            phase_data(_actual_stage, _tokenID);
            actual_stage++;
            phase_check(actual_stage,_buy_amount-maxLimitBuyAmount, _tokenID); //Next phase check
        }
        else {
            phase_data(_actual_stage, _tokenID);
        }
    }
    function phase_data(uint _actual_stage, uint _tokenID ) internal{
        stageAmount_count[_actual_stage]+=stageAmount[_actual_stage];
        totalMinted += stageAmount[_actual_stage];
        stage_address2supply[actual_stage][msg.sender] += stageAmount[_actual_stage];
        stage_address2supply[0][msg.sender] += stageAmount[_actual_stage];
        coin_stage_address2invested[4][actual_stage][msg.sender] += stageAmount[actual_stage] * stageRate[actual_stage]/rateCeros;
        coin_stage_address2invested[4][0][msg.sender] += stageAmount[actual_stage] * stageRate[actual_stage]/rateCeros;
        coin_stage_address2invested[_tokenID][actual_stage][msg.sender] += stageAmount[actual_stage] * stageRate[actual_stage]/(rateCeros*tokenID2rate[_tokenID]);
        coin_stage_address2invested[_tokenID][0][msg.sender] += stageAmount[actual_stage] * stageRate[actual_stage]/(rateCeros*tokenID2rate[_tokenID]);
        coin_stage_address2invested[_tokenID][actual_stage][address(this)] += stageAmount[actual_stage] * stageRate[actual_stage]/(rateCeros*tokenID2rate[_tokenID]);
        coin_stage_address2invested[_tokenID][0][address(this)] += stageAmount[actual_stage] * stageRate[actual_stage]/(rateCeros*tokenID2rate[_tokenID]);
    }
    function token_schedule_burn() public{
        require(msg.sender == creator, "must be owner");
        require(burnStage>0,"burn stage not initiated");
        require(burnStage<4,"burn stages over");
        if (block.timestamp>poolDeployTime+burn_period){
            Token.burn(totalBurnCoins[burnStage]);
            burnStage++;
            poolDeployTime=block.timestamp;
        }
    }
}