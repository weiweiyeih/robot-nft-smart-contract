// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {RobotNft} from "../src/RobotNft.sol";

contract DeployRobotNft is Script {
    HelperConfig public helperConfig;
    RobotNft public robotNft;

    function run() external returns (RobotNft, HelperConfig) {
        helperConfig = new HelperConfig();
        string memory level1SvgUri = helperConfig.getLvl1SvgUri();
        string memory level2SvgUri = helperConfig.getLvl2SvgUri();
        string memory level3SvgUri = helperConfig.getLvl3SvgUri();

        vm.startBroadcast();
        robotNft = new RobotNft(level1SvgUri, level2SvgUri, level3SvgUri);
        vm.stopBroadcast();

        return (robotNft, helperConfig);
    }
}
