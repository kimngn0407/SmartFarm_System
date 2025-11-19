# SmartFarm IoT - Setup and Run Instructions

## Prerequisites

1. **PostgreSQL Database** with tables:
   - `public.sensor` (with sensors id=7,8,9,10)
   - `public.sensor_data`

2. **Node.js** (v16+) for Hardhat and Oracle Node

3. **Python** (v3.8+) for Flask API

4. **MetaMask** wallet with Pione Zero testnet tokens

## Setup Instructions

### 1. Deploy Smart Contract

```bash
# Install dependencies
npm install

# Compile contract
npx hardhat compile

# Deploy to Pione Zero testnet
RPC_URL=https://rpc.zeroscan.org CHAIN_ID=5080 PRIVATE_KEY=0xYOUR_PRIVATE_KEY npx hardhat run scripts/deploy.js --network pzo

# Copy the deployed contract address for oracle-node/.env
```

### 2. Setup Oracle Node

```bash
cd oracle-node
cp env.sample .env
# Edit .env with your PRIVATE_KEY and CONTRACT_ADDRESS
npm install
npm start
```

### 3. Setup Flask API

```bash
cd flask-api
cp env.sample .env
# Edit .env with your DB_URL and sensor IDs
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install -r requirements.txt
python app.py
```

### 4. Test the System

```bash
# Make test script executable
chmod +x test_system.sh

# Run tests
./test_system.sh
```

### 5. Device Setup

#### ESP32 (WiFi):
1. Upload `device/esp32_post.ino` to ESP32
2. Change WiFi credentials and Flask IP in the code
3. Monitor serial output

#### Arduino UNO (USB):
1. Upload Arduino code that outputs JSON to serial
2. Run `device/forwarder.py` on computer
3. Change COM port and Flask IP in the script

## Testing Commands

### Manual API Test:
```bash
curl -X POST http://localhost:8000/api/sensors \
  -H "Content-Type: application/json" \
  -H "x-api-key: MY_API_KEY" \
  -d '{"sensorId":1,"time":1730000000,"temperature":26.8,"humidity":60.5,"soil_pct":42,"light":55}'
```

### Check Database:
```sql
-- Run queries from test_queries.sql
SELECT s.id, s.sensor_name, s.type, sd.value, sd."time"
FROM public.sensor_data sd
JOIN public.sensor s ON s.id = sd.sensor_id
WHERE s.id IN (7,8,9,10)
ORDER BY sd."time" DESC
LIMIT 20;
```

### Check Blockchain:
- Visit [ZeroScan.org](https://zeroscan.org)
- Search for your wallet address or transaction hash
- Look for `SensorHashStored` events

## Troubleshooting

1. **Database Connection Issues**: Check DB_URL in flask-api/.env
2. **Oracle Connection Issues**: Verify RPC_URL and PRIVATE_KEY
3. **API Key Issues**: Ensure x-api-key header matches API_KEY in .env
4. **Sensor ID Issues**: Verify sensor IDs exist in database

## Security Notes

- Use testnet wallets only
- Never commit .env files
- Change default API keys in production
- Add rate limiting for production use


