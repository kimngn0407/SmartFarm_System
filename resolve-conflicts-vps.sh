#!/bin/bash
# Script để resolve merge conflicts trên VPS

echo "🔍 Đang resolve merge conflicts..."

# Resolve conflict cho next.config.ts - giữ version từ GitHub (có assetPrefix)
echo "📝 Resolving AI_SmartFarm_CHatbot/next.config.ts..."
cat > AI_SmartFarm_CHatbot/next.config.ts << 'EOF'
import type {NextConfig} from 'next';

const nextConfig: NextConfig = {
  /* config options here */
  basePath: '/chatbot',  // Route prefix để match Nginx location /chatbot/
  assetPrefix: '/chatbot', // Đảm bảo static assets có prefix đúng
  output: 'standalone', // Cần thiết cho Docker deployment
  typescript: {
    ignoreBuildErrors: true,
  },
  eslint: {
    ignoreDuringBuilds: true,
  },
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'placehold.co',
        port: '',
        pathname: '/**',
      },
      {
        protocol: 'https',
        hostname: 'images.unsplash.com',
        port: '',
        pathname: '/**',
      },
      {
        protocol: 'https',
        hostname: 'picsum.photos',
        port: '',
        pathname: '/**',
      },
    ],
  },
  serverExternalPackages: ['genkit', '@genkit-ai/googleai'],
  outputFileTracingIncludes: {
    '/*': ['./src/data/**/*'],
  },
};

export default nextConfig;
EOF

# Resolve conflict cho nginx.conf - giữ version từ GitHub (có location /_next/)
echo "📝 Resolving nginx/nginx.conf..."
# Đọc file hiện tại và tìm conflict markers
if grep -q "<<<<<<< HEAD" nginx/nginx.conf; then
    echo "⚠️  File nginx.conf có conflicts, đang resolve..."
    # Sử dụng version từ GitHub (có location /_next/)
    git checkout --theirs nginx/nginx.conf
    git add nginx/nginx.conf
else
    echo "✅ nginx.conf không có conflicts"
    git add nginx/nginx.conf
fi

# Mark conflicts as resolved
git add AI_SmartFarm_CHatbot/next.config.ts

echo ""
echo "✅ Đã resolve conflicts!"
echo "📊 Trạng thái hiện tại:"
git status

echo ""
echo "💡 Nếu muốn commit, chạy:"
echo "   git commit -m 'Resolve merge conflicts - keep GitHub version'"

