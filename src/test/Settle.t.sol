// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/console.sol";
import "ds-test/test.sol";
import {IERC20} from "../interfaces/IERC20.sol";
import {IPriceOracle} from "../interfaces/IPriceOracle.sol";
import {Settle} from "../Settle.sol";
import {QuickswapOracleFactory} from "../QuickswapOracleFactory.sol";
import {ExponentialNoError}  from "../lib/ExponentialNoError.sol";


contract SettleTest is ExponentialNoError, DSTest {
    Settle settle;
    QuickswapOracleFactory qsOracleFactory;
    address public chip = 0xfd29982Fa0b7d3eDcaE9B0c49D350C07c7cEC5c1;
    address public currency = 0xe19B95fB3bDE006E436c7C83DCb8018D55671490;
    address public sam = 0x16EAF3c5201F57A9cc0B35688269c082e215627c;
    address public SYTEST3 = 0xE3052163A213bD13fDB88dCfb00363d808d5DEf1;
    address public testUser = 0xE3052163A213bD13fDB88dCfb00363d808d5DEf1;

    int8 public positiveNumSigned = 1;
    int8 public negativeNumSigned = -1;

    address public mumbaiBTCUSD = 0x007A22900a3B98143368Bd5906f8E17e9867581b;
    address public mumbaiUSDTUSD = 0x572dDec9087154dC5dfBB1546Bb62713147e0Ab0;

    address public WETHUSDC = 0x853Ee4b2A13f8a742d64C8F088bE7bA2131f670d;
    address public WBTCWETH = 0xdC9232E2Df177d7a12FdFf6EcBAb114E2231198D;
    address public WMATICUSDC = 0x6e7a5FAFcec6BB1e78bAE2A1F0B612012BF14827;
    address public WETHUSDT = 0xF6422B997c7F54D1c6a6e103bcb1499EeA0a7046;
    address public USDCDAI = 0xf04adBF75cDFc5eD26eeA4bbbb991DB002036Bdd;
    address public WBTCUSDC = 0xF6a637525402643B0654a54bEAd2Cb9A83C8B498;
    address public WMATICUSDT = 0x604229c960e5CACF2aaEAc8Be68Ac07BA9dF81c3;

    address public MATICUSD = 0xAB594600376Ec9fD91F8e885dADF0CE036862dE0;
    address public ETHUSD = 0xF9680D99D6C9589e2a93a78A04A279e509205945;
    address public BTCUSD = 0xc907E116054Ad103354f2D350FD2514433D57F6f;
    address public USDCUSD = 0xfE4A8cc5b5B2366C1B58Bea3858e81843581b2F7;
    address public WATICUSD = 0xAB594600376Ec9fD91F8e885dADF0CE036862dE0;
    address public USDTUSD = 0x0A6513e40db6EB1b165753AD52E80663aeA50545;
    address public DAIUSD = 0x4746DeC9e833A82EC7C2C1356372CcF2cfcD2F3D;
    address public BNBUSD = 0x82a6c4AF830caa6c97bb504425f6A66165C2c26e;
    address public BUSDUSD = 0xE0dC07D5ED74741CeeDA61284eE56a2A0f7A4Cc9;
    address public LINKUSD = 0xd9FFdb71EbE7496cC440152d43986Aae0AB76665;
    address public UNIUSD = 0xdf0Fb4e4F928d2dCB76f438575fDD8682386e13C;
    address public PAXUSD = 0x56D55D34EcC616e71ae998aCcba79F236ff2ff46;
    address public _1INCHUSD = 0x443C5116CdF663Eb387e72C688D276e702135C87;
    address public CRVUSD = 0x336584C8E6Dc19637A5b36206B1c79923111b405;
    address public OMGUSD = 0x93FfEE768F74208a7b9f2a4426f0F6BCbb1D09de;

    address public WBTC = 0x1BFD67037B42Cf73acF2047067bd4F2C47D9BfD6;
    address public MATIC = 0x0000000000000000000000000000000000001010;
    address public WETH = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619;
    address public USDC = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
    address public WMATIC = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
    address public USDT =  0xc2132D05D31c914a87C6611C10748AEb04B58e8F;
    address public DAI = 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063;
    address public BNB = 0x3BA4c387f786bFEE076A58914F5Bd38d668B42c3;
    address public BUSD = 0xdAb529f40E671A1D4bF91361c21bf9f0C9712ab7;
    address public bridgedLINK = 0x53E0bca35eC356BD5ddDFebbD1Fc0fD03FaBad39;
    address public LINK = 0xb0897686c545045aFc77CF20eC7A532E3120E0F1;
    address public UNI = 0xb33EaAd8d922B1083446DC23f610c2567fB5180f;
    address public PAX = 0x6F3B3286fd86d8b47EC737CEB3D0D354cc657B3e;
    address public _1INCH = 0x9c2C5fd7b07E95EE044DDeba0E97a665F142394f;
    address public CRV = 0x172370d5Cd63279eFa6d502DAB29171933a610AF;
    address public OMG = 0x62414D03084EeB269E18C970a21f45D2967F0170;

    address public aave_savings_dai = 0x27F8D03b3a2196956ED754baDc28D73be8830A6e;
    address public aave_savings_usdc = 0x1a13F4Ca1d028320A707D99520AbFefca3998b7F;
    address public aave_savings_usdt = 0x60D55F02A771d515e077c9C2403a1ef324885CeC;
    address public aave_savings_wbtc = 0x5c2ed810328349100A66B82b78a1791B101C9D61;
    address public aave_savings_weth = 0x28424507fefb6f7f8E9D3860F56504E4e5f5f390;
    address public aave_savings_wmatic = 0x8dF3aad3a84da6b69A4DA8aeC3eA40d9091B2Ac4;
    address public aave_debt_dai = 0x75c4d1Fb84429023170086f06E682DcbBF537b7d;
    address public aave_debt_usdc = 0x248960A9d75EdFa3de94F7193eae3161Eb349a12;
    address public aave_debt_usdt = 0x8038857FD47108A07d1f6Bf652ef1cBeC279A2f3;
    address public aave_debt_wbtc = 0xF664F50631A6f0D72ecdaa0e49b0c019Fa72a8dC;
    address public aave_debt_weth = 0xeDe17e9d79fc6f9fF9250D9EEfbdB88Cc18038b5;
    address public aave_debt_wmatic = 0x59e8E9100cbfCBCBAdf86b9279fa61526bBB8765;

    function setUp() public {
        qsOracleFactory = new QuickswapOracleFactory();
        address priceWmaticUsdc = qsOracleFactory.createOracleFeed("WMATIC-USDC",WMATICUSDC,WMATIC,USDC,WATICUSD,USDCUSD);
        address priceWethUsdc = qsOracleFactory.createOracleFeed("WETH-USDC",WETHUSDC,WETH,USDC,ETHUSD,USDCUSD);
        address priceWbtcWeth = qsOracleFactory.createOracleFeed("WBTC-WETH",WBTCWETH,WBTC,WETH,BTCUSD,ETHUSD);
        address priceWethUsdt = qsOracleFactory.createOracleFeed("WETH-USDT",WETHUSDT,WETH,USDT,ETHUSD,USDTUSD);
        address priceUsdcDai = qsOracleFactory.createOracleFeed("USDC-DAI",USDCDAI,USDC,DAI,USDCUSD,DAIUSD);
        address priceWbtcUsdc = qsOracleFactory.createOracleFeed("WBTC-USDC",WBTCUSDC,WBTC,USDC,BTCUSD,USDCUSD);
        address priceWmaticUsdt = qsOracleFactory.createOracleFeed("WMATIC-USDT",WMATICUSDT,WMATIC,USDT,WATICUSD,USDTUSD);

        settle = new Settle();
        settle.addSettleToken(WETHUSDC, priceWethUsdc, positiveNumSigned);
        settle.addSettleToken(WBTCWETH, priceWbtcWeth, positiveNumSigned);
        settle.addSettleToken(WMATICUSDC, priceWmaticUsdc, positiveNumSigned);
        settle.addSettleToken(WETHUSDT, priceWethUsdt, positiveNumSigned);
        settle.addSettleToken(USDCDAI, priceUsdcDai, positiveNumSigned);
        settle.addSettleToken(WBTCUSDC, priceWbtcUsdc, positiveNumSigned);
        settle.addSettleToken(WMATICUSDT, priceWmaticUsdt, positiveNumSigned);

        settle.addSettleToken(WMATIC, MATICUSD, positiveNumSigned);
        settle.addSettleToken(MATIC, MATICUSD, positiveNumSigned);
        settle.addSettleToken(USDT, USDTUSD, positiveNumSigned);
        settle.addSettleToken(WETH, ETHUSD, positiveNumSigned);
        settle.addSettleToken(WBTC, BTCUSD, positiveNumSigned);
        settle.addSettleToken(USDC, USDCUSD, positiveNumSigned);
        settle.addSettleToken(DAI, DAIUSD, positiveNumSigned);
        
        settle.addSettleToken(aave_savings_dai, DAIUSD, positiveNumSigned);
        settle.addSettleToken(aave_savings_usdc, USDCUSD, positiveNumSigned);
        settle.addSettleToken(aave_savings_usdt, USDTUSD, positiveNumSigned);
        settle.addSettleToken(aave_savings_wbtc, BTCUSD, positiveNumSigned);
        settle.addSettleToken(aave_savings_weth, ETHUSD, positiveNumSigned);
        settle.addSettleToken(aave_savings_wmatic, MATICUSD, positiveNumSigned);
        settle.addSettleToken(aave_debt_dai, DAIUSD, negativeNumSigned);
        settle.addSettleToken(aave_debt_usdc, USDCUSD, negativeNumSigned);
        settle.addSettleToken(aave_debt_usdt, USDTUSD, negativeNumSigned);
        settle.addSettleToken(aave_debt_wbtc, BTCUSD, negativeNumSigned);
        settle.addSettleToken(aave_debt_weth, ETHUSD, negativeNumSigned);
        settle.addSettleToken(aave_debt_wmatic, MATICUSD, negativeNumSigned);
    }

    function testExample() public {
        assertTrue(true);
    }
    
    function testSettleOwner() public {
        assertEq(settle.owner(), address(this));
    }

    function testGetTokenPriceConfig() public {
        settle.addSettleToken(chip, mumbaiBTCUSD, positiveNumSigned);
        (address _oracleLink, int8 _numSigned) = settle.getTokenSettleConfig(chip);
        assertEq(_oracleLink, mumbaiBTCUSD);
        assertLe(_numSigned, positiveNumSigned);
    }
    
    function testAddSettleToken() public {
        assertTrue(settle.addSettleToken(chip, mumbaiBTCUSD, positiveNumSigned));
    }

    function testIsTokenExists() public {
        assertTrue(settle.addSettleToken(chip, mumbaiBTCUSD, positiveNumSigned));
        assertTrue(settle.isTokenExists(chip));
        assertTrue(!settle.isTokenExists(sam));
    }

    function testGetWalletSettle() public {
        (uint value, uint debt) = settle.getWalletSettle(testUser);
        emit log_uint(value);
        emit log_uint(debt);
    }

    function testDelSettleToken() public {
        assertTrue(settle.addSettleToken(chip, mumbaiBTCUSD, positiveNumSigned));
        assertTrue(settle.delSettleToken(chip));
        assertTrue(!settle.isTokenExists(chip));
    }

    function testExponential() public {
        uint dec = IERC20(WMATIC).balanceOf(sam);
        Exp memory _res = Exp({mantissa: dec});
        console.log("exp", _res.mantissa);

        uint _test = truncate(_res);
        console.log("truncate", _test);

        uint _mul_ScalarTruncate = mul_ScalarTruncate(_res, 2);
        console.log("mul_ScalarTruncate", _mul_ScalarTruncate);
    }
}
