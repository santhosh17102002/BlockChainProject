// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
contract KycSmartContract{
    address admin;
    Organization[] registered_organizations;
    struct Customer{
        address id;
        string name;
        uint aadhaar_no;
        Dob dob;
        string gender;
        uint phone_no;
        string residential_address;
        string nationality;
        string pan_no;
        uint income;
        string photo_hash;
        address[] customer_organizations;
        bool key_status;
    }
    struct Dob{
        uint day;
        uint month;
        uint year;
    }
    struct Organization{
        string name;
        address id;
    }
    constructor(){
        admin=msg.sender;
    }
    struct keyRequests{
        uint cnt;
        address organization;
        address customer;
    }
    //mappings
    //mapping (address => Customer) customers;
    mapping (address => Organization) organizationsList;
    
    //modifiers
    modifier isAdmin{
        require(msg.sender == admin,"Only Admin have the Access");
        _;
    }
    modifier isOrgExists(address _org_address){
        for(uint i=0;i<registered_organizations.length;i++){
            require(registered_organizations[i].id != _org_address,"Already registered");
        }
        _;
    }
   modifier isValidOrganization(address _org_id){
        for(uint i=0;i<registered_organizations.length;i++){
            if(registered_organizations[i].id == _org_id){
                _;
                return;
            }
        }
        require(false,"Organization doesn't exist");
   }
    function addOrganization(string memory _name,address _id) public isAdmin isOrgExists(_id) {
        Organization memory org;
        org.id=_id;
        org.name=_name;
        registered_organizations.push(org);
    }
    function delOrganisation(address _id) public isAdmin  returns(string memory) {
         for(uint i=0;i<registered_organizations.length;i++){
            if(registered_organizations[i].id == _id){
                delete registered_organizations[i];
                return "Organization deleted successfully";
            }
        }
        return "Organization doesn't exist";
    }
    function viewOrganization(address _id) public view isValidOrganization(_id) returns(string memory){
        return string(abi.encodePacked("Organization name : ", organizationsList[_id].name, "\n", "Organization Id : ", _id));
    }
}