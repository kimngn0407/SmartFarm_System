// Simple CORS Proxy Server for Testing
const http = require('http');
const https = require('https');
const url = require('url');

const BACKEND_URL = 'https://hackathonpionedream-production.up.railway.app';
const PORT = 3001;

const server = http.createServer((req, res) => {
    // Enable CORS for all origins
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, PATCH, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    res.setHeader('Access-Control-Allow-Credentials', 'true');

    // Handle preflight
    if (req.method === 'OPTIONS') {
        res.writeHead(200);
        res.end();
        return;
    }

    console.log(`\n[${new Date().toISOString()}] ${req.method} ${req.url}`);

    // Parse request
    const parsedUrl = url.parse(req.url);
    const targetUrl = BACKEND_URL + parsedUrl.path;

    console.log(`→ Proxying to: ${targetUrl}`);

    // Build request options
    const options = {
        method: req.method,
        headers: {}
    };

    // Copy relevant headers
    if (req.headers['content-type']) {
        options.headers['Content-Type'] = req.headers['content-type'];
    }
    if (req.headers['authorization']) {
        options.headers['Authorization'] = req.headers['authorization'];
    }

    // Make request to backend
    const proxyReq = https.request(targetUrl, options, (proxyRes) => {
        console.log(`← Response: ${proxyRes.statusCode} ${proxyRes.statusMessage}`);

        // Copy response headers
        res.writeHead(proxyRes.statusCode, proxyRes.headers);
        
        // Pipe response
        proxyRes.pipe(res);
    });

    // Handle errors
    proxyReq.on('error', (error) => {
        console.error('✗ Proxy Error:', error.message);
        res.writeHead(500);
        res.end(JSON.stringify({ error: error.message }));
    });

    // Pipe request body
    req.pipe(proxyReq);
});

server.listen(PORT, () => {
    console.log('\n═══════════════════════════════════════════════');
    console.log('  🚀 CORS Proxy Server Running');
    console.log('═══════════════════════════════════════════════');
    console.log(`  Local:    http://localhost:${PORT}`);
    console.log(`  Backend:  ${BACKEND_URL}`);
    console.log('═══════════════════════════════════════════════');
    console.log('\nProxy is ready. Update your frontend to use:');
    console.log(`  API_BASE = "http://localhost:${PORT}"`);
    console.log('\nPress Ctrl+C to stop');
    console.log('═══════════════════════════════════════════════\n');
});

