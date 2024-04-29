// grade contract 
contract UpgradableContract {
    uint public value;
    
    function setValue(uint _value) public {
        value = _value;
    }
}
