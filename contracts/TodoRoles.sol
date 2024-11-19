// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;


// RBAC - ROLE BASE ACCESS CONTROL
contract TodoRoles {
    mapping(address => bool) public admins;
    mapping(address => bool) public users;

    modifier onlyAdmin() {
        require(admins[msg.sender], "Not an admin");
        _;
    }

    modifier onlyUser() {
        require(users[msg.sender] || admins[msg.sender], "Not a user");
        _;
    }


    constructor() {
        admins[msg.sender] = true;
    }


    function addAdmin(address _admin) public onlyAdmin()  {
        admins[_admin] = true;
    }

    function addUser(address _user) public onlyAdmin() {
        users[_user] = true;
    }

    function removeUser(address _user) public onlyAdmin() {
        users[_user] = false;
    }

}