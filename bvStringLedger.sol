 contract bvStringLedger {

    address public voterRegistry;    // Contract Address from which we believe vote-counts are true.
    address public grandMaster;  // Address allowed to change special positions.
    int public ledgerHeight = 0; // A publically available height, then can explore from there. 

    function selfDestruct() { if (msg.sender == grandMaster) suicide(grandMaster); }

    struct ledgerEntry {
        uint128 id;
        uint128 votes;
        uint64 created;
        uint64 creation_time;
        string datastring;
    }
    
    struct ledgerIndex {
        bytes32 entryString;
    }


    function bvStringLedger() {
        grandMaster = msg.sender;
    }

    // Special position grandMaster changing it.
    function setSiblings(address _voterRegistry,address _grandMaster) {
        if( msg.sender == grandMaster ){ // Must be the current grandMaster.
            voterRegistry = _voterRegistry;
            grandMaster = _grandMaster;
        }
    }

    // voterRegistry tells us it has votes.
    function recordVotes(string dstr, uint128 voterSeconds) {
        bytes32 bdstr = bytes32(sha3(dstr));
        if( msg.sender == voterRegistry && byteStrings[bdstr].created != 0 ){
            byteStrings[bdstr].votes += voterSeconds;
        }
    }

    //Anyone can add a datastring. 
    function addString(string dstr) returns(uint64) {
        bytes32 bdstr = bytes32(sha3(dstr));
        ledgerEntry t = byteStrings[bdstr];
        if( t.created !=0 ){ 
            return 0; 
        }
        t.votes = 0;
        t.creation_time = uint64(block.timestamp);
        t.datastring = dstr;
        t.created = 1;
        ledgerIndex i = lIndex[ledgerHeight];
        i.entryString = bdstr;
        ledgerHeight++;
        return 1;
    }

    mapping (bytes32 => ledgerEntry) public byteStrings;
    mapping (int => ledgerIndex) public lIndex;
    
}

