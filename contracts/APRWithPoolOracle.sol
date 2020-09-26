pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function decimals() external view returns (uint8);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Context {
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor () internal {
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
    }
    function owner() public view returns (address) {
        return _owner;
    }
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }
    function divCeil(
        uint256 a,
        uint256 b
    )
        internal
        pure
        returns (uint256)
    {
        uint256 quotient = div(a, b);
        uint256 remainder = a - quotient * b;
        if (remainder > 0) {
            return quotient + 1;
        } else {
            return quotient;
        }
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library Decimal {
    using SafeMath for uint256;

    uint256 constant BASE = 10**18;

    function one()
        internal
        pure
        returns (uint256)
    {
        return BASE;
    }

    function onePlus(
        uint256 d
    )
        internal
        pure
        returns (uint256)
    {
        return d.add(BASE);
    }

    function mulFloor(
        uint256 target,
        uint256 d
    )
        internal
        pure
        returns (uint256)
    {
        return target.mul(d) / BASE;
    }

    function mulCeil(
        uint256 target,
        uint256 d
    )
        internal
        pure
        returns (uint256)
    {
        return target.mul(d).divCeil(BASE);
    }

    function divFloor(
        uint256 target,
        uint256 d
    )
        internal
        pure
        returns (uint256)
    {
        return target.mul(BASE).div(d);
    }

    function divCeil(
        uint256 target,
        uint256 d
    )
        internal
        pure
        returns (uint256)
    {
        return target.mul(BASE).divCeil(d);
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
    }
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

// Compound
interface Compound {
  function interestRateModel() external view returns (address);
  function reserveFactorMantissa() external view returns (uint256);
  function totalBorrows() external view returns (uint256);
  function totalReserves() external view returns (uint256);

  function supplyRatePerBlock() external view returns (uint);
  function getCash() external view returns (uint256);
}

// Fulcrum
interface Fulcrum {
  function supplyInterestRate() external view returns (uint256);
  function nextSupplyInterestRate(uint256 supplyAmount) external view returns (uint256);
}

interface DyDx {
  struct val {
       uint256 value;
   }

   struct set {
      uint128 borrow;
      uint128 supply;
  }

  function getEarningsRate() external view returns (val memory);
  function getMarketInterestRate(uint256 marketId) external view returns (val memory);
  function getMarketTotalPar(uint256 marketId) external view returns (set memory);
}

interface LendingPoolAddressesProvider {
    function getLendingPoolCore() external view returns (address);
}

interface LendingPoolCore  {
  function getReserveCurrentLiquidityRate(address _reserve)
  external
  view
  returns (
      uint256 liquidityRate
  );
  function getReserveInterestRateStrategyAddress(address _reserve) external view returns (address);
  function getReserveTotalBorrows(address _reserve) external view returns (uint256);
  function getReserveTotalBorrowsStable(address _reserve) external view returns (uint256);
  function getReserveTotalBorrowsVariable(address _reserve) external view returns (uint256);
  function getReserveCurrentAverageStableBorrowRate(address _reserve)
     external
     view
     returns (uint256);
  function getReserveAvailableLiquidity(address _reserve) external view returns (uint256);
}

interface IReserveInterestRateStrategy {

    function getBaseVariableBorrowRate() external view returns (uint256);
    function calculateInterestRates(
        address _reserve,
        uint256 _utilizationRate,
        uint256 _totalBorrowsStable,
        uint256 _totalBorrowsVariable,
        uint256 _averageStableBorrowRate)
    external
    view
    returns (uint256 liquidityRate, uint256 stableBorrowRate, uint256 variableBorrowRate);
}

interface InterestRateModel {
  function getSupplyRate(uint cash, uint borrows, uint reserves, uint reserveFactorMantissa) external view returns (uint);
}

contract Structs {
  struct Asset {
    address lendingPool;
    address priceOralce;
    address interestModel;
  }
}

contract IDDEX is Structs {

  function getInterestRates(address token, uint256 extraBorrowAmount)
    external
    view
    returns (uint256 borrowInterestRate, uint256 supplyInterestRate);
  function getIndex(address token)
    external
    view
    returns (uint256 supplyIndex, uint256 borrowIndex);
  function getTotalSupply(address asset)
    external
    view
    returns (uint256 amount);
  function getTotalBorrow(address asset)
    external
    view
    returns (uint256 amount);
  function getAsset(address token)
    external
    view returns (Asset memory asset);
}

interface IDDEXModel {
  function polynomialInterestModel(uint256 borrowRatio) external view returns (uint256);
}

interface ILendF {
  function getSupplyBalance(address account, address token)
    external
    view
    returns (uint256);
  function supplyBalances(address account, address token)
    external
    view
    returns (uint256 principal, uint256 interestIndex);
  function supply(address asset, uint256 amount) external;
  function withdraw(address asset, uint256 amount) external;
  function markets(address asset) external view returns (
    bool isSupported,
    uint256 blockNumber,
    address interestRateModel,
    uint256 totalSupply,
    uint256 supplyRateMantissa,
    uint256 supplyIndex,
    uint256 totalBorrows,
    uint256 borrowRateMantissa,
    uint256 borrowIndex
  );
}

interface ILendFModel {
    function getSupplyRate(address asset, uint cash, uint borrows) external view returns (uint, uint);
}

contract APRWithPoolOracle is Ownable, Structs {
  using SafeMath for uint256;
  using Address for address;

  uint256 DECIMAL = 10 ** 18;

  address public DYDX;
  address public AAVE;
  address public DDEX;
  address public LENDF;

  uint256 public liquidationRatio;
  uint256 public dydxModifier;

  constructor() public {
    DYDX = address(0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e);
    AAVE = address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
    DDEX = address(0x241e82C79452F51fbfc89Fac6d912e021dB1a3B7);
    LENDF = address(0x0eEe3E3828A45f7601D5F54bF49bB01d1A9dF5ea);
    liquidationRatio = 50000000000000000;
    dydxModifier = 20;
  }

  function set_new_AAVE(address _new_AAVE) public onlyOwner {
      AAVE = _new_AAVE;
  }
  function set_new_DDEX(address _new_DDEX) public onlyOwner {
      DDEX = _new_DDEX;
  }
  function set_new_DYDX(address _new_DYDX) public onlyOwner {
      DYDX = _new_DYDX;
  }
  function set_new_LENDF(address _new_LENDF) public onlyOwner {
      LENDF = _new_LENDF;
  }
  function set_new_Ratio(uint256 _new_Ratio) public onlyOwner {
      liquidationRatio = _new_Ratio;
  }
  function set_new_Modifier(uint256 _new_Modifier) public onlyOwner {
      dydxModifier = _new_Modifier;
  }

  function getLENDFAPR(address token) public view returns (uint256) {
    (,,,,uint256 supplyRateMantissa,,,,) = ILendF(LENDF).markets(token);
    return supplyRateMantissa.mul(2102400);
  }

  function getLENDFAPRAdjusted(address token, uint256 supply) public view returns (uint256) {
    if (token == address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)) {
      return 0;
    }
    uint256 totalCash = IERC20(token).balanceOf(LENDF).add(supply);
    (,, address interestRateModel,,,, uint256 totalBorrows,,) = ILendF(LENDF).markets(token);
    if (interestRateModel == address(0)) {
      return 0;
    }
    (, uint256 supplyRateMantissa) = ILendFModel(interestRateModel).getSupplyRate(token, totalCash, totalBorrows);
    return supplyRateMantissa.mul(2102400);
  }

  function getDDEXAPR(address token) public view returns (uint256) {
    if (token == address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)) {
      token = address(0x000000000000000000000000000000000000000E);
    }
    (uint256 supplyIndex,) = IDDEX(DDEX).getIndex(token);
    if (supplyIndex == 0) {
      return 0;
    }
    (,uint256 supplyRate) = IDDEX(DDEX).getInterestRates(token, 0);
    return supplyRate;
  }

  function getDDEXAPRAdjusted(address token, uint256 _supply) public view returns (uint256) {
    if (token == address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)) {
      token = address(0x000000000000000000000000000000000000000E);
    }
    (uint256 supplyIndex,) = IDDEX(DDEX).getIndex(token);
    if (supplyIndex == 0) {
      return 0;
    }
    uint256 supply = IDDEX(DDEX).getTotalSupply(token).add(_supply);
    uint256 borrow = IDDEX(DDEX).getTotalBorrow(token);
    uint256 borrowRatio = borrow.mul(Decimal.one()).div(supply);
    address interestRateModel = IDDEX(DDEX).getAsset(token).interestModel;
    uint256 borrowRate = IDDEXModel(interestRateModel).polynomialInterestModel(borrowRatio);
    uint256 borrowInterest = Decimal.mulCeil(borrow, borrowRate);
    uint256 supplyInterest = Decimal.mulFloor(borrowInterest, Decimal.one().sub(liquidationRatio));
    return Decimal.divFloor(supplyInterest, supply);
  }

  function getCompoundAPR(address token) public view returns (uint256) {
    return Compound(token).supplyRatePerBlock().mul(2102400);
  }

  function getCompoundAPRAdjusted(address token, uint256 _supply) public view returns (uint256) {
    Compound c = Compound(token);
    address model = Compound(token).interestRateModel();
    if (model == address(0)) {
      return c.supplyRatePerBlock().mul(2102400);
    }
    InterestRateModel i = InterestRateModel(model);
    uint256 cashPrior = c.getCash().add(_supply);
    return i.getSupplyRate(cashPrior, c.totalBorrows(), c.totalReserves().add(_supply), c.reserveFactorMantissa()).mul(2102400);
  }

  function getFulcrumAPR(address token) public view returns(uint256) {
    return Fulcrum(token).supplyInterestRate().div(100);
  }

  function getFulcrumAPRAdjusted(address token, uint256 _supply) public view returns(uint256) {
    return Fulcrum(token).nextSupplyInterestRate(_supply).div(100);
  }

  function getDyDxAPR(uint256 marketId) public view returns(uint256) {
    uint256 rate      = DyDx(DYDX).getMarketInterestRate(marketId).value;
    uint256 aprBorrow = rate * 31622400;
    uint256 borrow    = DyDx(DYDX).getMarketTotalPar(marketId).borrow;
    uint256 supply    = DyDx(DYDX).getMarketTotalPar(marketId).supply;
    uint256 usage     = (borrow * DECIMAL) / supply;
    uint256 apr       = (((aprBorrow * usage) / DECIMAL) * DyDx(DYDX).getEarningsRate().value) / DECIMAL;
    return apr;
  }
  
  function getDyDxAPRAdjusted(uint256 marketId, uint256 _supply) public view returns(uint256) {
    uint256 rate      = DyDx(DYDX).getMarketInterestRate(marketId).value;
    // Arbitrary value to offset calculations
    _supply = _supply.mul(dydxModifier);
    uint256 aprBorrow = rate * 31622400;
    uint256 borrow    = DyDx(DYDX).getMarketTotalPar(marketId).borrow;
    uint256 supply    = DyDx(DYDX).getMarketTotalPar(marketId).supply;
    supply = supply.add(_supply);
    uint256 usage     = (borrow * DECIMAL) / supply;
    uint256 apr       = (((aprBorrow * usage) / DECIMAL) * DyDx(DYDX).getEarningsRate().value) / DECIMAL;
    return apr;
  }

  function getAaveCore() public view returns (address) {
    return address(LendingPoolAddressesProvider(AAVE).getLendingPoolCore());
  }

  function getAaveAPR(address token) public view returns (uint256) {
    LendingPoolCore core = LendingPoolCore(LendingPoolAddressesProvider(AAVE).getLendingPoolCore());
    return core.getReserveCurrentLiquidityRate(token).div(1e9);
  }

  function getAaveAPRAdjusted(address token, uint256 _supply) public view returns (uint256) {
    LendingPoolCore core = LendingPoolCore(LendingPoolAddressesProvider(AAVE).getLendingPoolCore());
    IReserveInterestRateStrategy apr = IReserveInterestRateStrategy(core.getReserveInterestRateStrategyAddress(token));
    (uint256 newLiquidityRate,,) = apr.calculateInterestRates(
      token,
      core.getReserveAvailableLiquidity(token).add(_supply),
      core.getReserveTotalBorrowsStable(token),
      core.getReserveTotalBorrowsVariable(token),
      core.getReserveCurrentAverageStableBorrowRate(token)
    );
    return newLiquidityRate.div(1e9);
  }

  // incase of half-way error
  function inCaseTokenGetsStuck(IERC20 _TokenAddress) onlyOwner public {
      uint qty = _TokenAddress.balanceOf(address(this));
      _TokenAddress.transfer(msg.sender, qty);
  }
  // incase of half-way error
  function inCaseETHGetsStuck() onlyOwner public{
      (bool result, ) = msg.sender.call.value(address(this).balance)("");
      require(result, "transfer of ETH failed");
  }
}
