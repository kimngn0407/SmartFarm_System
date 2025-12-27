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