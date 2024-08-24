const AccessControl = artifacts.require("AccessControl");
const HealthRecords = artifacts.require("HealthRecords");
const DataSharing = artifacts.require("DataSharing");
const AuditLog = artifacts.require("AuditLog");

module.exports = function (deployer) {
    deployer.deploy(AccessControl).then(function () {
        return deployer.deploy(HealthRecords, AccessControl.address);
    }).then(function () {
        return deployer.deploy(DataSharing, AccessControl.address);
    }).then(function () {
        return deployer.deploy(AuditLog, AccessControl.address);
    });
};