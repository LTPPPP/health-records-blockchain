// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AccessControl.sol";

contract AuditLog {
    AccessControl public accessControl;

    struct LogEntry {
        address user;
        string action;
        uint256 timestamp;
    }

    LogEntry[] public logs;

    event LogAdded(address indexed user, string action, uint256 timestamp);

    constructor(address _accessControlAddress) {
        accessControl = AccessControl(_accessControlAddress);
    }

    modifier onlyAuthorized() {
        require(accessControl.isAuthorized(msg.sender), "Unauthorized access");
        _;
    }

    function addLog(string memory _action) public onlyAuthorized {
        logs.push(
            LogEntry({
                user: msg.sender,
                action: _action,
                timestamp: block.timestamp
            })
        );

        emit LogAdded(msg.sender, _action, block.timestamp);
    }

    function getLogsCount() public view returns (uint256) {
        return logs.length;
    }

    function getLog(uint256 _index) public view returns (LogEntry memory) {
        require(_index < logs.length, "Invalid log index");
        return logs[_index];
    }
}
