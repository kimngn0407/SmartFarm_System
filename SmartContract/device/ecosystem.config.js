// PM2 Ecosystem Config cho Arduino Forwarder
// Note: File này phải là .cjs vì package.json có "type": "module"
module.exports = {
  apps: [
    {
      name: 'arduino-forwarder',
      script: 'forwarder_auto.py',
      interpreter: 'python3',
      cwd: '/root/projects/SmartFarm/SmartContract/device',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '200M',
      env: {
        FLASK_URL: 'http://173.249.48.25:8000/api/sensors',
        API_KEY: 'MY_API_KEY',
        NODE_ENV: 'production'
      },
      error_file: './logs/arduino-forwarder-error.log',
      out_file: './logs/arduino-forwarder-out.log',
      log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
      merge_logs: true,
      // Restart khi mất kết nối serial
      min_uptime: '10s',
      max_restarts: 10,
      restart_delay: 5000,
      // Không restart nếu exit code = 0 (thoát bình thường)
      stop_exit_codes: [0]
    }
  ]
};

