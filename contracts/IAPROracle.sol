
interface IAPROracle {
  function recommendDAI() external view returns (string memory);
  function recommendETH() external view returns (string memory);
  function recommendUSDC() external view returns (string memory);
  function getAllCompoundAPR()
      external
      view
      returns (
          uint256 cDAI,
          uint256 cBAT,
          uint256 cETH,
          uint256 cREP,
          uint256 cSAI,
          uint256 cUSDC,
          uint256 cWBTC,
          uint256 cZRC
      );

  // Compound
  function getCDAIAPR() external view returns (uint256);
  function getCBATAPR() external view returns (uint256);
  function getCETHAPR() external view returns (uint256);
  function getCREPAPR() external view returns (uint256);
  function getCSAIAPR() external view returns (uint256);
  function getCUSDCAPR() external view returns (uint256);
  function getCWBTCAPR() external view returns (uint256);
  function getCZRCAPR() external view returns (uint256);
  function getCompoundAPR(address token) external view returns (uint256);

  function getAllDyDxAPR()
      external
      view
      returns (
          uint256 dSAI,
          uint256 dETH,
          uint256 dUSDC,
          uint256 dDAI
      );

  // dYdX
  function getDyDxSAIAPR() external view returns (uint256);
  function getDyDxETHAPR() external view returns (uint256);
  function getDyDxUSDCAPR() external view returns (uint256);
  function getDyDxDAIAPR() external view returns (uint256);

  function getAllFulcrumAPR()
      external
      view
      returns (
          uint256 iZRX,
          uint256 iREP,
          uint256 iKNC,
          uint256 iWBTC,
          uint256 iUSDC,
          uint256 iETH,
          uint256 iSAI,
          uint256 iDAI,
          uint256 iLINK,
          uint256 iSUSD
      );

  // Fulcrum
  function getIZRXAPR() external view returns (uint256);
  function getIREPAPR() external view returns (uint256);
  function getIKNCAPR() external view returns (uint256);
  function getIWBTCAPR() external view returns (uint256);
  function getIUSDCAPR() external view returns (uint256);
  function getIETHAPR() external view returns (uint256);
  function getISAIAPR() external view returns (uint256);
  function getIDAIAPR() external view returns (uint256);
  function getILINKAPR() external view returns (uint256);
  function getISUSDAPR() external view returns (uint256);

  function getFulcrumAPR(address token) external view returns(uint256);

  function getDyDxAPR(uint256 marketId) external view returns(uint256);

  function getAllAaveAPR()
      external
      view
      returns (
          uint256 aDAI,
          uint256 aTUSD,
          uint256 aUSDC,
          uint256 aUSDT,
          uint256 aSUSD,
          uint256 aBAT,
          uint256 aETH,
          uint256 aLINK,
          uint256 aKNC,
          uint256 aREP,
          uint256 aZRX,
          uint256 aSNX
      );

  function getADAIAPR() external view returns (uint256);
  function getATUSDAPR() external view returns (uint256);
  function getAUSDCAPR() external view returns (uint256);
  function getAUSDTAPR() external view returns (uint256);
  function getASUSDAPR() external view returns (uint256);
  function getALENDAPR() external view returns (uint256);
  function getABATAPR() external view returns (uint256);
  function getAETHAPR() external view returns (uint256);
  function getALINKAPR() external view returns (uint256);
  function getAKNCAPR() external view returns (uint256);
  function getAREPAPR() external view returns (uint256);
  function getAMKRAPR() external view returns (uint256);
  function getAMANAAPR() external view returns (uint256);
  function getAZRXAPR() external view returns (uint256);
  function getASNXAPR() external view returns (uint256);
  function getAWBTCAPR() external view returns (uint256);

  function getAaveAPR(address token) external view returns (uint256);
}
