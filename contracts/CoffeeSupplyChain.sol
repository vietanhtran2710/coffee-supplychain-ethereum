// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./SupplyChainStorage.sol";
import "./Ownable.sol";

contract CoffeeSupplyChain is Ownable
{
  
    event PerformCultivation(address indexed user, address indexed batchNo);
    event DoneInspection(address indexed user, address indexed batchNo);
    event DoneHarvesting(address indexed user, address indexed batchNo);
    event DoneExporting(address indexed user, address indexed batchNo);
    event DoneImporting(address indexed user, address indexed batchNo);
    event DoneProcessing(address indexed user, address indexed batchNo);

    
    /*Modifier*/
    modifier isValidPerformer(address batchNo, string memory role) {
    
        require(keccak256(abi.encodePacked(supplyChainStorage.getUserRole(msg.sender))) == keccak256(abi.encodePacked(role)));
        require(keccak256(abi.encodePacked(supplyChainStorage.getNextAction(batchNo))) == keccak256(abi.encodePacked(role)));
        _;
    }
    
    /* Storage Variables */    
    SupplyChainStorage supplyChainStorage;
    
    constructor(address _supplyChainAddress) public {
        supplyChainStorage = SupplyChainStorage(_supplyChainAddress);
    }
    
    
    /* Get Next Action  */    
    function getNextAction(address _batchNo) public view returns(string memory action)
    {
       (action) = supplyChainStorage.getNextAction(_batchNo);
       return (action);
    }
    

    /* get Basic Details */
    function getBasicDetails(address _batchNo) public view returns (
        string memory registrationNo,
        string memory farmerName,
        string memory farmAddress,
        string memory exporterName,
        string memory importerName
    ) {
        /* Call Storage Contract */
        (registrationNo, farmerName, farmAddress, exporterName, importerName) = supplyChainStorage.getBasicDetails(_batchNo);  
        return (registrationNo, farmerName, farmAddress, exporterName, importerName);
    }

    /* perform Basic Cultivation */
    function addBasicDetails(
        string memory _registrationNo,
        string memory _farmerName,
        string memory _farmAddress,
        string memory _exporterName,
        string memory _importerName
    ) public onlyOwner returns(address) {
    
        address batchNo = supplyChainStorage.setBasicDetails(
            _registrationNo,
            _farmerName,
            _farmAddress,
            _exporterName,
            _importerName);
        
        emit PerformCultivation(msg.sender, batchNo); 
        
        return (batchNo);
    }                            
    
    /* get Farm Inspection */
    function getFarmInspectorData(address _batchNo) public view returns (string memory coffeeFamily,string memory typeOfSeed,string memory fertilizerUsed) {
        /* Call Storage Contract */
        (coffeeFamily, typeOfSeed, fertilizerUsed) = supplyChainStorage.getFarmInspectorData(_batchNo);  
        return (coffeeFamily, typeOfSeed, fertilizerUsed);
    }
    
    /* perform Farm Inspection */
    function updateFarmInspectorData(
        address _batchNo,
        string memory _coffeeFamily,
        string memory _typeOfSeed,
        string memory _fertilizerUsed
    ) public isValidPerformer(_batchNo,'FARM_INSPECTION') returns(bool) {
        /* Call Storage Contract */
        bool status = supplyChainStorage.setFarmInspectorData(_batchNo, _coffeeFamily, _typeOfSeed, _fertilizerUsed);  
        
        emit DoneInspection(msg.sender, _batchNo);
        return (status);
    }

    
    /* get Harvest */
    function getHarvesterData(address _batchNo) public view returns (string memory cropVariety, string memory temperatureUsed, string memory humidity) {
        /* Call Storage Contract */
        (cropVariety, temperatureUsed, humidity) =  supplyChainStorage.getHarvesterData(_batchNo);  
        return (cropVariety, temperatureUsed, humidity);
    }
    
    /* perform Harvest */
    function updateHarvesterData(
        address _batchNo,
        string memory _cropVariety,
        string memory _temperatureUsed,
        string memory _humidity
    ) public isValidPerformer(_batchNo,'HARVESTER') returns(bool) {
                                    
        /* Call Storage Contract */
        bool status = supplyChainStorage.setHarvesterData(_batchNo, _cropVariety, _temperatureUsed, _humidity);  
        
        emit DoneHarvesting(msg.sender, _batchNo);
        return (status);
    }
    
    /* get Export */
    function getExporterData(address _batchNo) public view returns (
        uint256 quantity,
        string memory destinationAddress,
        string memory shipName,
        string memory shipNo,
        uint256 departureDateTime,
        uint256 estimateDateTime,
        uint256 exporterId
    ) {
        /* Call Storage Contract */
       (quantity,
        destinationAddress,
        shipName,
        shipNo,
        departureDateTime,
        estimateDateTime,
        exporterId) =  supplyChainStorage.getExporterData(_batchNo);  
        
        return (quantity,
                destinationAddress,
                shipName,
                shipNo,
                departureDateTime,
                estimateDateTime,
                exporterId);
    }
    
    /* perform Export */
    function updateExporterData(
        address _batchNo,
        uint256 _quantity,    
        string memory _destinationAddress,
        string memory _shipName,
        string memory _shipNo,
        uint256 _estimateDateTime,
        uint256 _exporterId
    ) public isValidPerformer(_batchNo,'EXPORTER') returns(bool) {
                                    
        /* Call Storage Contract */
        bool status = supplyChainStorage.setExporterData(_batchNo, _quantity, _destinationAddress, _shipName,_shipNo, _estimateDateTime,_exporterId);  
        
        emit DoneExporting(msg.sender, _batchNo);
        return (status);
    }
    
    /* get Import */
    function getImporterData(address _batchNo) public view returns (
        uint256 quantity,
        string memory shipName,
        string memory shipNo,
        uint256 arrivalDateTime,
        string memory transportInfo,
        string memory warehouseName,
        string memory warehouseAddress,
        uint256 importerId
    ) {
        /* Call Storage Contract */
        (quantity,
         shipName,
         shipNo,
         arrivalDateTime,
         transportInfo,
         warehouseName,
         warehouseAddress,
         importerId) =  supplyChainStorage.getImporterData(_batchNo);  
         
         return (quantity,
                 shipName,
                 shipNo,
                 arrivalDateTime,
                 transportInfo,
                 warehouseName,
                 warehouseAddress,
                 importerId);
        
    }
    
    /* perform Import */
    function updateImporterData(
        address _batchNo,
        uint256 _quantity, 
        string memory _shipName,
        string memory _shipNo,
        string memory _transportInfo,
        string memory _warehouseName,
        string memory _warehouseAddress,
        uint256 _importerId
    ) public isValidPerformer(_batchNo,'IMPORTER') returns(bool) {
                                    
        /* Call Storage Contract */
        bool status = supplyChainStorage.setImporterData(_batchNo, _quantity, _shipName, _shipNo, _transportInfo,_warehouseName,_warehouseAddress,_importerId);  
        
        emit DoneImporting(msg.sender, _batchNo);
        return (status);
    }
    
    
    /* get Processor */
    
    function getProcessorData(address _batchNo) public view returns (
        uint256 quantity,
        string memory temperature,
        uint256 rostingDuration,
        string memory internalBatchNo,
        uint256 packageDateTime,
        string memory processorName,
        string memory processorAddress
    ) {
        /* Call Storage Contract */
        (quantity,
         temperature,
         rostingDuration,
         internalBatchNo,
         packageDateTime,
         processorName,
         processorAddress) =  supplyChainStorage.getProcessorData(_batchNo);  
         
        return (quantity,
                temperature,
                rostingDuration,
                internalBatchNo,
                packageDateTime,
                processorName,
                processorAddress);
 
    }
    
    /* perform Processing */
    function updateProcessorData(address _batchNo,
        uint256 _quantity, 
        string memory _temperature,
        uint256 _rostingDuration,
        string memory _internalBatchNo,
        uint256 _packageDateTime,
        string memory _processorName,
        string memory _processorAddress
    ) public isValidPerformer(_batchNo,'PROCESSOR') returns(bool) {
                                    
        /* Call Storage Contract */
        bool status = supplyChainStorage.setProcessorData(
            _batchNo, 
            _quantity, 
            _temperature, 
            _rostingDuration, 
            _internalBatchNo,
            _packageDateTime,
            _processorName,
            _processorAddress
        );  
        
        emit DoneProcessing(msg.sender, _batchNo);
        return (status);
    }
}
