// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AccessControl {
    mapping(address => bool) public authorizedDoctors;
    mapping(address => bool) public patients;
    address public admin;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    function addDoctor(address _doctor) public onlyAdmin {
        authorizedDoctors[_doctor] = true;
    }

    function removeDoctor(address _doctor) public onlyAdmin {
        authorizedDoctors[_doctor] = false;
    }

    function registerPatient(address _patient) public onlyAdmin {
        patients[_patient] = true;
    }

    function isAuthorized(address _user) public view returns (bool) {
        return authorizedDoctors[_user] || patients[_user];
    }
}
