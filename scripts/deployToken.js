
async function main() {
    const [deployer] = await ethers.getSigners();
  
    const MyToken = await ethers.getContractFactory("MyToken");
    const tokenDeploy = await MyToken.deploy(100);
    console.log("MyToken address:", tokenDeploy.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });

    // MyToken address: 0xC3577f619865932366c8802760d0e3d47B6C7Ce7
    //https://sepolia.etherscan.io/address/0xC3577f619865932366c8802760d0e3d47B6C7Ce7#code