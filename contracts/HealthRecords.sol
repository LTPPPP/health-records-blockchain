// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AccessControl.sol";

contract HealthRecords {
    AccessControl public accessControl;

    struct HealthRecord {
        string dataHash;
        uint256 timestamp;
        address uploader;
    }

    mapping(address => HealthRecord[]) private patientRecords;

    event RecordAdded(
        address indexed patient,
        string dataHash,
        uint256 timestamp
    );

    constructor(address _accessControlAddress) {
        accessControl = AccessControl(_accessControlAddress);
    }

    modifier onlyAuthorized() {
        require(accessControl.isAuthorized(msg.sender), "Unauthorized access");
        _;
    }

    function addRecord(
        address _patient,
        string memory _dataHash
    ) public onlyAuthorized {
        HealthRecord memory newRecord = HealthRecord({
            dataHash: _dataHash,
            timestamp: block.timestamp,
            uploader: msg.sender
        });

        patientRecords[_patient].push(newRecord);
        emit RecordAdded(_patient, _dataHash, block.timestamp);
    }

    function getRecords(
        address _patient
    ) public view onlyAuthorized returns (HealthRecord[] memory) {
        return patientRecords[_patient];
    }
}
