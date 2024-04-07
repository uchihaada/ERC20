
async function main() {
    const [deployer] = await ethers.getSigners();

    const NftToken = await ethers.getContractFactory("NftToken");
    const tokenDeploy = await NftToken.deploy();
    console.log("ERC721Token address:", tokenDeploy.address);
    console.log("owner address: ", deployer.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

    // ERC721Token address: 0xD804b612374F0A24Ca5737617649b74B31D9b8ae
    // owner address:  0x46FC374d89D8FAb2dcbBACbDbD9Eb620D1A2AA8D
    // Successfully verified contract NftToken on the block explorer.
    // https://sepolia.etherscan.io/address/0xD804b612374F0A24Ca5737617649b74B31D9b8ae#code