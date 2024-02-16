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
        address customer_organizations;
        bool kyc_status;
    }
    struct Dob{
        uint day;
        uint month;
        uint year;
    }
    struct Organization{
        string name;
        address id;
        Customer[] customersList;
    }
    constructor(){
        admin=msg.sender;
    }
    /*struct keyRequests{
        uint cnt;
        address organization;
        address customeraddress;
    }*/
    //mappings
    mapping (address => Customer) customersList;
    mapping (address => Organization) organizationsList;
    
    //modifiers
    modifier isAdmin{
        require(msg.sender == admin,"Only Admin have the Access");
        _;
    }
    modifier isOrgRegistered(address _org_address){
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
        revert("Organization doesn't exist");
   }
    function addOrganization(string memory _name,address _id) public isAdmin isOrgRegistered(_id) {
        Organization memory org;
        org.id=_id;
        org.name=_name;
        org.customersList ;
        registered_organizations.push(org);
        organizationsList[_id]=org;
    }
    function delOrganisation(address _id) public isAdmin  returns(string memory) {
         for(uint i=0;i<registered_organizations.length;i++){
            if(registered_organizations[i].id == _id){
                delete registered_organizations[i];
                delete organizationsList[_id];
                return "Organization deleted successfully";
            }
        }
        revert("Organization doesn't exist");
    }
    function viewOrganization(address _id) public view isValidOrganization(_id) returns(Organization memory){
        return organizationsList[_id];
    }
    function addCustomer(address _id,string memory _name,uint _aadhaar_no,Dob memory _dob,string memory _gender,uint _phone_no,string memory _residential_address,string memory _nationality,string memory _pan_no,uint _income,string memory _photo_hash,address[] memory _customer_organizations) public {
        Customer memory customer;
        customer.id=_id;
        customer.name=_name;
        customer.aadhaar_no=_aadhaar_no;
        customer.dob=_dob;
        customer.gender=_gender;
        customer.phone_no=_phone_no;
        customer.residential_address=_residential_address;
        customer.nationality=_nationality;
        customer.pan_no=_pan_no;
        customer.income=_income;
        customer.customer_organizations = msg.sender;
        customer.kyc_status=true;
        customersList[msg.sender]=customer;
    }
    function delCustomer(address _id) public {
        delete  customer_organizations[msg.sender];
    }

}
