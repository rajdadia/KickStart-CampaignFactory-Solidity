pragma solidity ^0.4.17;

contract Campaignfactory
{
    address[] public deployedCampaigns;
    
    function createCampaign(uint minimum) public 
    {
        address newCampaign = new Campaign(minimum,msg.sender);
        deployedCampaigns.push(newCampaign);
    }
    
    function getDeployedCampaigns() public view returns(address[])
    {
        return deployedCampaigns;
    }
}

contract Campaign
{
    struct Request
    {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approval;
    }
    
    Request[] public requests;
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint public bal;
    int i;
    uint public contcount;
    
    modifier restricted()
    {
        require(msg.sender==manager);
        _;
    }
     
    
    function Campaign(uint min,address sender) public
    {
        manager=sender;
        minimumContribution=min;
        i=0;
    }
    
    function contribute() public payable
    {
        require(msg.value>=minimumContribution);
        
        approvers[msg.sender]= true;
        bal=bal+this.balance;
        contcount++;
    }
    
    function createRequest(string reason,uint  val,address forrec) public restricted 
    {
        Request memory temp= Request(reason,val,forrec,false,0);
        requests.push(temp);
    }
    
    function approveRequest(uint index) public
    {
        require(approvers[msg.sender]);
        
        require(!requests[index].approval[msg.sender]);
        
        requests[index].approval[msg.sender]=true;
        requests[index].approvalCount++;
    }
    
    function finalizeRequest(uint index) public restricted
    {
        Request storage request=requests[index];
        
        require(!requests[index].complete);
        
        require(requests[index].approvalCount>=(contcount/2));
        
        request.recipient.transfer(request.value);
        requests[index].complete=true;
        
        
    }
    
    
}