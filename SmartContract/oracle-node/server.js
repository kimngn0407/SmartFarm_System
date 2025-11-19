import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { ethers } from "ethers";

dotenv.config();
const app = express();
app.use(cors());
app.use(express.json());

const RPC_URL = process.env.RPC_URL || "https://rpc.zeroscan.org";
const CHAIN_ID = Number(process.env.CHAIN_ID || 5080);
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS;

const provider = new ethers.JsonRpcProvider(RPC_URL, CHAIN_ID);
const wallet   = new ethers.Wallet(PRIVATE_KEY, provider);
const abi = ["function storeHash(uint256 time,string dataHash)"];
const contract = new ethers.Contract(CONTRACT_ADDRESS, abi, wallet);

app.get("/oracle/health", (req, res) => {
  return res.json({ 
    ok: true, 
    status: "running",
    port: Number(process.env.PORT || 5001),
    contract: CONTRACT_ADDRESS ? "configured" : "not configured",
    rpc: RPC_URL
  });
});

app.post("/oracle/push", async (req, res) => {
  try {
    const { time, hash } = req.body; // hash là 0x... keccak256
    const tx = await contract.storeHash(Number(time), String(hash));
    const receipt = await tx.wait();
    return res.json({ ok: true, txHash: receipt.hash });
  } catch (e) {
    console.error(e);
    return res.status(500).json({ ok: false, error: e.message });
  }
});

const PORT = Number(process.env.PORT || 5001);
app.listen(PORT, () => console.log(`[oracle] listening on ${PORT}`));

