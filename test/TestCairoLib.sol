// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {CairoLib} from "src/CairoLib.sol";

contract ByteArrayConverterTest is Test {
    function testfoo() public {
        bytes memory input = hex"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004d79546f6b656e0000000000000000000000000000000000000000000000000000000000000007";
        string memory result = CairoLib.byteArrayToString(input);
        assertEq(result, "MyToken");
    }

    function testMyTokenConversion() public {
        bytes memory input = abi.encodePacked(
            uint256(0),  // fullWordsLength
            uint256(0x000000000000000000000000000000000000000000000000004d79546f6b656e),  // pendingWord
            uint256(7)   // pendingWordLen
        );

        string memory result = CairoLib.byteArrayToString(input);
        assertEq(result, "MyToken", "Conversion failed for 'MyToken' input");
    }

    function testMultiWordConversion() public {
        bytes memory data = abi.encodePacked(
            uint256(1),  // fullWordsLength
            uint256(0x48656c6c6f20576f726c642c20746869732069732061206c6f6e6765722073),  // "Hello World, this is a longer s"
            uint256(0x7472696e672e),  // "longer string."
            uint256(6)  // pendingWordLen
        );

        string memory result = CairoLib.byteArrayToString(data);
        assertEq(result, "Hello World, this is a longer string.", "Conversion failed for multi-word input");
    }

    function testEmptyString() public {
        bytes memory input = abi.encodePacked(
            uint256(0),  // fullWordsLength
            uint256(0),  // pendingWord
            uint256(0)   // pendingWordLen
        );

        string memory result = CairoLib.byteArrayToString(input);
        assertEq(result, "", "Conversion failed for empty string");
    }

    function testInvalidPendingWordLength() public {
        bytes memory input = abi.encodePacked(
            uint256(0),
            uint256(0),
            uint256(32)  // Invalid pendingWordLen
        );

        vm.expectRevert("Invalid pending word length");
        CairoLib.byteArrayToString(input);
    }

    function testInvalidInputLength() public {
        bytes memory input = new bytes(95); // Too short to be valid

        vm.expectRevert("Invalid byte array length");
        CairoLib.byteArrayToString(input);
    }

    function testConcreteExample() public {
        // test with a concrete example where

        bytes memory input = hex"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004d79546f6b656e0000000000000000000000000000000000000000000000000000000000000007";
        string memory result = CairoLib.byteArrayToString(input);
        assertEq(result, "MyToken");

    }
}
