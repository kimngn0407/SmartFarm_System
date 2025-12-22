'use client';

import { useEffect } from 'react';

export default function GlobalError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    console.error('Global error in Chatbot:', error);
  }, [error]);

  return (
    <html>
      <body>
        <div className="flex flex-col items-center justify-center min-h-screen p-4 bg-gray-50">
          <div className="max-w-md w-full bg-white rounded-lg shadow-lg p-6">
            <h2 className="text-2xl font-bold text-red-600 mb-4">
              Lỗi hệ thống
            </h2>
            <p className="text-gray-700 mb-4">
              {error.message || 'Đã xảy ra lỗi nghiêm trọng. Vui lòng liên hệ quản trị viên.'}
            </p>
            {error.digest && (
              <p className="text-sm text-gray-500 mb-4">
                Mã lỗi: {error.digest}
              </p>
            )}
            <button
              onClick={reset}
              className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
            >
              Thử lại
            </button>
          </div>
        </div>
      </body>
    </html>
  );
}
