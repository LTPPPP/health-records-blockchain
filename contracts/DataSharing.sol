// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AccessControl.sol";

contract DataSharing {
    AccessControl public accessControl;

    struct SharedAccess {
        address patient;
        address doctor;
        uint256 expirationTime;
    }

    mapping(bytes32 => SharedAccess) public sharedAccesses;

    event AccessGranted(
        address indexed patient,
        address indexed doctor,
        uint256 expirationTime
    );
    event AccessRevoked(address indexed patient, address indexed doctor);

    constructor(address _accessControlAddress) {
        accessControl = AccessControl(_accessControlAddress);
    }

    modifier onlyPatient() {
        require(
            accessControl.patients(msg.sender),
            "Only patients can perform this action"
        );
        _;
    }

    function grantAccess(
        address _doctor,
        uint256 _duration
    ) public onlyPatient {
        bytes32 accessId = keccak256(abi.encodePacked(msg.sender, _doctor));
        sharedAccesses[accessId] = SharedAccess({
            patient: msg.sender,
            doctor: _doctor,
            expirationTime: block.timestamp + _duration
        });

        emit AccessGranted(msg.sender, _doctor, block.timestamp + _duration);
    }

    function revokeAccess(address _doctor) public onlyPatient {
        bytes32 accessId = keccak256(abi.encodePacked(msg.sender, _doctor));
        delete sharedAccesses[accessId];

        emit AccessRevoked(msg.sender, _doctor);
    }

    function checkAccess(
        address _patient,
        address _doctor
    ) public view returns (bool) {
        bytes32 accessId = keccak256(abi.encodePacked(_patient, _doctor));
        SharedAccess memory access = sharedAccesses[accessId];

        return (access.patient == _patient &&
            access.doctor == _doctor &&
            access.expirationTime > block.timestamp);
    }
}
