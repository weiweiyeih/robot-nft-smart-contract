// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract RobotNft is ERC721, Ownable {
    /* Errors */
    error RobotNft__CantTrainRobotIfNotOwner();
    error RobotNft__RobotHasReachedMaxGrade();

    /* Type declarations */
    struct RobotSpec {
        string name;
        uint256 exp;
        uint256 level;
        string image;
    }

    /* State variables */
    uint256 private s_tokenCounter;

    string private i_level1SvgUri;
    string private i_level2SvgUri;
    string private i_level3SvgUri;

    mapping(uint256 => RobotSpec) private s_tokenIdToRobotSpec;
    mapping(address => uint256[]) private s_addressToTokenIds;

    /* Events */
    event CreatedRobot(uint256 indexed tokenId);
    event IncreasedExp(uint256 indexed tokenId, uint256 indexed Exp);
    event IncreasedLv(uint256 indexed tokenId, uint256 indexed Lv);

    constructor(string memory level1SvgUri, string memory level2SvgUri, string memory level3SvgUri)
        ERC721("RobotNft", "RBT")
        Ownable(msg.sender)
    {
        s_tokenCounter = 0;
        i_level1SvgUri = level1SvgUri;
        i_level2SvgUri = level2SvgUri;
        i_level3SvgUri = level3SvgUri;
    }

    function createRobot(string memory _name) public {
        uint256 tokenId = s_tokenCounter;
        _safeMint(msg.sender, tokenId);

        s_addressToTokenIds[msg.sender].push(tokenId);
        s_tokenIdToRobotSpec[tokenId] = RobotSpec({name: _name, exp: 0, level: 1, image: i_level1SvgUri});

        s_tokenCounter = s_tokenCounter + 1;
        emit CreatedRobot(tokenId);
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        RobotSpec memory robot = s_tokenIdToRobotSpec[tokenId];
        string memory robotName = robot.name;
        uint256 robotExp = robot.exp;
        uint256 robotLv = robot.level;

        // string memory imageURI = i_level1SvgUri;
        if (robotLv == 2) {
            robot.image = i_level2SvgUri;
        } else if (robotLv == 3) {
            robot.image = i_level3SvgUri;
        }

        // To-do: update image in struct
        // robot.image = imageURI;

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "',
                            name(),
                            '", "description": "An 100%-on-Chain Robot NFT that can be trained and upgraded!", ',
                            '"attributes": [{"trait_type": "robot name", "value": "',
                            robotName,
                            '"}, {"trait_type": "Exp", "value": ',
                            Strings.toString(robotExp),
                            '}, {"trait_type": "Level", "value": ',
                            Strings.toString(robotLv),
                            '}], "image": "',
                            robot.image,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    function trainRobot(uint256 tokenId) public {
        if (ownerOf(tokenId) != msg.sender) {
            revert RobotNft__CantTrainRobotIfNotOwner();
        }

        RobotSpec storage robot = s_tokenIdToRobotSpec[tokenId];
        uint256 robotExp = robot.exp;
        uint256 robotLv = robot.level;

        if (robotLv >= 3) {
            if (robotExp < 100) {
                robot.exp = robot.exp + 50;
                emit IncreasedExp(tokenId, robot.exp);
            } else {
                revert RobotNft__RobotHasReachedMaxGrade();
            }
        } else {
            if (robotExp < 50) {
                robot.exp = robot.exp + 50;
                emit IncreasedExp(tokenId, robot.exp);
            } else {
                robot.exp = 0;
                robot.level = robot.level + 1;

                // update imange for frontend
                if (robot.level == 2) {
                    robot.image = i_level2SvgUri;
                } else if (robot.level == 3) {
                    robot.image = i_level3SvgUri;
                }

                emit IncreasedLv(tokenId, robot.level);
            }
        }
    }

    /* Getter functions */
    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }

    function getRobotName(uint256 tokenId) public view returns (string memory) {
        return s_tokenIdToRobotSpec[tokenId].name;
    }

    function getRobotExp(uint256 tokenId) public view returns (uint256) {
        return s_tokenIdToRobotSpec[tokenId].exp;
    }

    function getRobotLv(uint256 tokenId) public view returns (uint256) {
        return s_tokenIdToRobotSpec[tokenId].level;
    }

    function getRobotImage(uint256 tokenId) public view returns (string memory) {
        return s_tokenIdToRobotSpec[tokenId].image;
    }

    function getAddressToTokenIds(address player) public view returns (uint256[] memory) {
        return s_addressToTokenIds[player];
    }
}
