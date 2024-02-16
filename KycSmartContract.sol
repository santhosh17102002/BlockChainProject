// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract MyNewKyc{
    address admin;
    Customer[] customers_list; //To view entire Customers list
    constructor(){
        admin = msg.sender;
    }
    struct Organization {
        string name;
        address id;
    }
    struct Customer {
        string name;
        address id;
        string dob;
        string gender;
        string nationality;
        string phone;
        string aadhar_no;
        string pan_no;
        string photo_hash;
        string residential_address;
        uint income;
    }
    mapping(address => bool) public registered_organization; // To check whether an organization is present or not in the registered organizations
    mapping(address => Customer) public customers_details; // To view customer_details
    mapping(address => Organization ) public organization_list; // to list all organizations under admin;
    mapping(address => mapping(address => bool) ) public registered_customer; //To check whether a customer is present under a particular organization or not
    mapping(address => Customer[]) public Customers_in_Organization; // to view customers details given the organization address
    mapping(address => bool) public Customer_exists;

    //Modifier written for admin
    modifier onlyAdmin{
        require(msg.sender == admin,"Only Admins have the Access");
        _;
    }


    //Modifiers written for organization
    
    modifier newOrganization(address _id){
        require(!registered_organization[_id],"Organization already registered");
        _;
    }
    modifier isOrganizationPresent(address _id){
        require(registered_organization[_id],"Organization does not exist with the given address");
        _;
    }

    //Modifiers for Customer
    modifier onlyOrganization() {
        require(registered_organization[msg.sender], "Only organization can perform this operation");
        _;
    }
    modifier ValidCustomer(address _id){
        require(Customer_exists[_id],"Customer doesnt exists");
        _;
    }

    modifier DoesCustomerExists(address _id){
        require(!Customer_exists[_id],"Customer already exists");
        _;
    }
    modifier isCustomerFromSameOrganization(address _id){
        require(registered_customer[msg.sender][_id],"He is not a customer of our organisation");
        _;
    }

    //Functions written for organization
    function addOrganization(address _id,string memory _name) public onlyAdmin newOrganization(_id) {
        Organization memory org;
        org.name = _name;
        org.id = _id;
        registered_organization[_id] = true;
        organization_list[_id] = org;
    }
    
    function delOrganization(address _id) public onlyAdmin isOrganizationPresent(_id){
        registered_organization[_id] = false;
        delete organization_list[_id];
        delete registered_organization[_id];
    }
    function viewOrganization(address _id) public view isOrganizationPresent(_id) returns(Organization memory){
        return organization_list[_id];
    }

    //functions written for customer
    function addCustomer(string memory _name,address _id,string memory _dob,string memory _gender,string memory _nationality,string memory _phone,string memory _aadhar_no, string memory _pan_no,string memory _photo_hash,string memory _residential_address,uint _income) public  onlyOrganization DoesCustomerExists(_id){
        Customer memory obj;
        obj.name = _name;
        obj.id = _id;
        obj.dob = _dob; 
        obj.gender = _gender;
        obj.nationality = _nationality;
        obj.phone = _phone;
        obj.aadhar_no = _aadhar_no;
        obj.pan_no = _pan_no;
        obj.photo_hash = _photo_hash;
        obj.residential_address = _residential_address;
        obj.income = _income;
        registered_customer[msg.sender][_id] = true;
        customers_details[_id] = obj;
        customers_list.push(obj);
        Customers_in_Organization[msg.sender].push(obj);
        Customer_exists[_id] = true;

    }

    function viewEntireCustomers() public view onlyAdmin returns(Customer[] memory){
        return customers_list;
    }
    function viewOrganizationCustomers() public view onlyOrganization returns (Customer[] memory){
        return Customers_in_Organization[msg.sender];
    }

    function deleteCustomer(address customerId) public ValidCustomer(customerId) onlyOrganization isCustomerFromSameOrganization(customerId){
        for (uint i = 0; i < customers_list.length; i++) {
            if (customers_list[i].id == customerId) {
                customers_list[i] = customers_list[customers_list.length - 1];
                
                customers_list.pop();
                return; 
            }
        }
        
        delete Customer_exists[customerId] ;
        delete customers_details[customerId];
        Customer[] storage temp = Customers_in_Organization[msg.sender];
        for (uint i = 0; i < temp.length; i++) {
            if (temp[i].id == customerId) {
                temp[i] = temp[temp.length - 1];
                temp.pop();
                return;
            }
        }
    }

    function kycCheck (string memory _name,address _id,string memory _dob,string memory _gender,string memory _nationality,string memory _phone,string memory _aadhar_no,string memory _pan_no,string memory _photo_hash,string memory _residential_address,uint _income) public view onlyOrganization returns (string memory) {
        Customer memory customer = customers_details[_id];
        
        require(keccak256(abi.encodePacked(customer.name)) == keccak256(abi.encodePacked(_name)), "Name does not match");
        require(customer.id == _id, "Address does not match");
        require(keccak256(abi.encodePacked(customer.dob)) == keccak256(abi.encodePacked(_dob)), "Date of Birth does not match");
        require(keccak256(abi.encodePacked(customer.gender)) == keccak256(abi.encodePacked(_gender)), "Gender does not match");
        require(keccak256(abi.encodePacked(customer.nationality)) == keccak256(abi.encodePacked(_nationality)), "Nationality does not match");
        require(keccak256(abi.encodePacked(customer.phone)) == keccak256(abi.encodePacked(_phone)), "Phone number does not match");
        require(keccak256(abi.encodePacked(customer.aadhar_no)) == keccak256(abi.encodePacked(_aadhar_no)), "Aadhar number does not match");
        require(keccak256(abi.encodePacked(customer.pan_no)) == keccak256(abi.encodePacked(_pan_no)), "PAN number does not match");
        require(keccak256(abi.encodePacked(customer.photo_hash)) == keccak256(abi.encodePacked(_photo_hash)), "Photo hash does not match");
        require(keccak256(abi.encodePacked(customer.residential_address)) == keccak256(abi.encodePacked(_residential_address)), "Residential address does not match");
        require(customer.income == _income, "Income does not match");
        return "He is our Customer";
    }   
}
