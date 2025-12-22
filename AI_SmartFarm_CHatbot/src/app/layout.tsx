import type { Metadata } from 'next';
import './globals.css';
import { Toaster } from "@/components/ui/toaster";
import { ParticlesBackground } from "@/components/particles-background";
import { cn } from '@/lib/utils';

export const metadata: Metadata = {
  title: 'Smart Farm Bot - Trợ lý AI về Nông nghiệp thông minh',
  description: 'Chatbot AI hỗ trợ kiến thức về cây trồng, canh tác nông nghiệp và nông nghiệp thông minh tại Việt Nam.',
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="vi" className="h-full">
      <head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet" />
        <meta name="theme-color" content="#1e1b4b" />
        <script
          dangerouslySetInnerHTML={{
            __html: `
              // Ẩn Next.js dev server overlay/panel
              (function() {
                function hideOverlay() {
                  // Ẩn các element có data attribute của Next.js
                  document.querySelectorAll('[data-nextjs-toast], [data-nextjs-dialog], [data-nextjs-portal]').forEach(el => {
                    el.style.display = 'none';
                    el.style.visibility = 'hidden';
                    el.style.opacity = '0';
                    el.style.pointerEvents = 'none';
                  });
                  
                  // Ẩn panel có chứa Route/Turbopack/Preferences
                  document.querySelectorAll('div').forEach(div => {
                    const text = div.textContent || '';
                    if (text.includes('Route') && text.includes('Turbopack') && text.includes('Preferences')) {
                      div.style.display = 'none';
                      div.style.visibility = 'hidden';
                      div.style.opacity = '0';
                      div.style.pointerEvents = 'none';
                    }
                  });
                }
                
                // Chạy ngay lập tức
                hideOverlay();
                
                // Chạy lại sau khi DOM load
                if (document.readyState === 'loading') {
                  document.addEventListener('DOMContentLoaded', hideOverlay);
                }
                
                // Chạy lại sau một khoảng thời gian (để bắt overlay được inject sau)
                setTimeout(hideOverlay, 100);
                setTimeout(hideOverlay, 500);
                setTimeout(hideOverlay, 1000);
                
                // Observer để theo dõi thay đổi DOM - chỉ observe khi body đã sẵn sàng
                function setupObserver() {
                  if (document.body && document.body instanceof Node) {
                    try {
                      const observer = new MutationObserver(hideOverlay);
                      observer.observe(document.body, { childList: true, subtree: true });
                    } catch (e) {
                      // Ignore observer errors
                      console.warn('Could not setup MutationObserver:', e);
                    }
                  } else {
                    // Retry after a short delay if body is not ready
                    setTimeout(setupObserver, 100);
                  }
                }
                
                // Setup observer after DOM is ready
                if (document.readyState === 'loading') {
                  document.addEventListener('DOMContentLoaded', setupObserver);
                } else {
                  setupObserver();
                }
              })();
            `,
          }}
        />
      </head>
      <body className={cn("font-sans antialiased h-full overflow-hidden")}>
        <div className="fixed inset-0 bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50">
          <ParticlesBackground />
        </div>
        <div className="relative z-10 h-full">
          {children}
        </div>
        <Toaster />
      </body>
    </html>
  );
}
