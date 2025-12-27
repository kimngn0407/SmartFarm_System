import type {NextConfig} from 'next';

const nextConfig: NextConfig = {
  /* config options here */
  basePath: '/chatbot',  // Next.js expects /chatbot prefix
  assetPrefix: '/chatbot', // Static assets also need /chatbot prefix
  trailingSlash: true, // Đồng bộ với Nginx thêm slash: /chatbot -> /chatbot/
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