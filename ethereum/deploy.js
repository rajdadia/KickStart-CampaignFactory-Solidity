const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const compiledFactory = require('./build/CampaignFactory.json');

const provider = new HDWalletProvider(
	'drill sword snap tooth find illegal void monkey crop stock unfair total',
	'https://rinkeby.infura.io/v3/890109b79939455491b6553110aa430e'
);
const web3 = new Web3(provider);

const deploy = async () => {
	const accounts = await web3.eth.getAccounts();

	console.log('deploying from',accounts[0]);

	const result = await new web3.eth.Contract(JSON.parse(compiledFactory.interface))
	.deploy({data:compiledFactory.bytecode})
	.send({gas: '1000000',from : accounts[0]});

	console.log('deployed to ',result.options.address);
};

deploy();
