
async function main() {
    const [deployer] = await ethers.getSigners();

    const TokenBank = await ethers.getContractFactory("TokenBank");
    const address = "0xC3577f619865932366c8802760d0e3d47B6C7Ce7";
    const bankDeploy = await TokenBank.deploy(address);
    console.log("MyToken address:", bankDeploy.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

    // MyToken address: 0x993498c60315c9E118A07AF3dbce1CEFA58dEE1f
    // https://sepolia.etherscan.io/address/0x993498c60315c9E118A07AF3dbce1CEFA58dEE1f#code