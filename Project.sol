// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GameBasedLearning {
    struct Module {
        string title;
        string description;
        uint256 reward;
        bool completed;
    }

    address public owner;
    mapping(address => uint256) public balances;
    Module[] public modules;

    event ModuleCompleted(address indexed user, uint256 moduleIndex, uint256 reward);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addModule(string memory _title, string memory _description, uint256 _reward) public onlyOwner {
        modules.push(Module({
            title: _title,
            description: _description,
            reward: _reward,
            completed: false
        }));
    }

    function completeModule(uint256 _moduleIndex) public {
        require(_moduleIndex < modules.length, "Module does not exist");
        require(!modules[_moduleIndex].completed, "Module already completed");

        Module storage module = modules[_moduleIndex];
        module.completed = true;

        balances[msg.sender] += module.reward;

        emit ModuleCompleted(msg.sender, _moduleIndex, module.reward);
    }

    function withdraw() public {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No balance to withdraw");

        balances[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function fundContract() public payable onlyOwner {
        // Owner can fund the contract with Ether for rewards
    }

    function getModules() public view returns (Module[] memory) {
        return modules;
    }
}