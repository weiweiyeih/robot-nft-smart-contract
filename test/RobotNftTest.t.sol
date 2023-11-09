// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {DeployRobotNft} from "../script/DeployRobotNft.s.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {RobotNft} from "../src/RobotNft.sol";

contract RobotNftTest is Test {
    DeployRobotNft public deployer;
    RobotNft public robotNft;
    HelperConfig public helperConfig;

    address public PLAYER = makeAddr("PLAYER");

    event CreatedRobot(uint256 indexed tokenId);
    event IncreasedExp(uint256 indexed tokenId, uint256 indexed Exp);
    event IncreasedLv(uint256 indexed tokenId, uint256 indexed Lv);

    function setUp() public {
        deployer = new DeployRobotNft();
        (robotNft, helperConfig) = deployer.run();
    }

    /* CreateRobot */
    function testCreateRobotMintsNftAndIncreasesTokenCounter() public {
        string memory name = "robotOne";

        vm.prank(PLAYER);
        robotNft.createRobot(name);

        assert(robotNft.ownerOf(0) == PLAYER);
        assert(robotNft.balanceOf(PLAYER) == 1);
        assert(robotNft.getTokenCounter() == 1);
    }

    function testCreateRobotInitializesRobotSpec() public {
        string memory name = "robotOne";

        vm.prank(PLAYER);
        robotNft.createRobot(name);

        assert(robotNft.getRobotExp(0) == 0);
        assert(robotNft.getRobotLv(0) == 1);
        assert(keccak256(abi.encodePacked(name)) == keccak256(abi.encodePacked(robotNft.getRobotName(0))));
    }

    function testCreateRobotEmitsEvent() public {
        string memory name = "robotOne";

        vm.expectEmit(true, false, false, false);
        emit CreatedRobot(0);

        vm.prank(PLAYER);
        robotNft.createRobot(name);
    }

    function testCreateRobotUpdatesAddressToTokenIds() public {
        string memory name = "robotOne";

        vm.prank(PLAYER);
        robotNft.createRobot(name);
        assert(robotNft.getAddressToTokenIds(PLAYER).length == 1);

        string memory anotherName = "robotTwo";

        vm.prank(PLAYER);
        robotNft.createRobot(anotherName);
        assert(robotNft.getAddressToTokenIds(PLAYER).length == 2);
    }

    /* TokenUri */
    function testTokenURIDefaultIsCorrectlySet() public {
        string memory name = "robotOne";

        vm.prank(PLAYER);
        robotNft.createRobot(name);

        console.log(robotNft.tokenURI(0));
    }

    /* TrainRobot */
    function testTrainRobotRevertsIfNotOwner() public {
        string memory name = "robotOne";

        vm.prank(PLAYER);
        robotNft.createRobot(name);

        vm.expectRevert(RobotNft.RobotNft__CantTrainRobotIfNotOwner.selector);
        robotNft.trainRobot(0);
    }

    function testTrainRobotUpdatesRobotSpecAndEmitsEventsAndRevertsWhenReachedMaxGrade() public {
        string memory name = "robotOne";

        vm.startPrank(PLAYER);
        robotNft.createRobot(name);

        vm.expectEmit(true, true, false, false);
        emit IncreasedExp(0, 50);
        robotNft.trainRobot(0);
        assert(robotNft.getRobotExp(0) == 50);
        assert(robotNft.getRobotLv(0) == 1);
        assert(keccak256(abi.encodePacked(name)) == keccak256(abi.encodePacked(robotNft.getRobotName(0))));
        // console.log(robotNft.tokenURI(0));

        vm.expectEmit(true, true, false, false);
        emit IncreasedLv(0, 2);
        robotNft.trainRobot(0);
        assert(robotNft.getRobotExp(0) == 0);
        assert(robotNft.getRobotLv(0) == 2);
        // console.log(robotNft.tokenURI(0));

        vm.expectEmit(true, true, false, false);
        emit IncreasedExp(0, 50);
        robotNft.trainRobot(0);
        assert(robotNft.getRobotExp(0) == 50);
        assert(robotNft.getRobotLv(0) == 2);

        vm.expectEmit(true, true, false, false);
        emit IncreasedLv(0, 3);
        robotNft.trainRobot(0);
        assert(robotNft.getRobotExp(0) == 0);
        assert(robotNft.getRobotLv(0) == 3);

        vm.expectEmit(true, true, false, false);
        emit IncreasedExp(0, 50);
        robotNft.trainRobot(0);
        assert(robotNft.getRobotExp(0) == 50);
        assert(robotNft.getRobotLv(0) == 3);

        vm.expectEmit(true, true, false, false);
        emit IncreasedExp(0, 100);
        robotNft.trainRobot(0);
        assert(robotNft.getRobotExp(0) == 100);
        assert(robotNft.getRobotLv(0) == 3);
        console.log(robotNft.tokenURI(0));

        vm.expectRevert(RobotNft.RobotNft__RobotHasReachedMaxGrade.selector);
        robotNft.trainRobot(0);

        vm.stopPrank();
    }
}
