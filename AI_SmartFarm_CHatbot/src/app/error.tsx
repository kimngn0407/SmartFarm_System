'use client';

import { useEffect } from 'react';
import { Button } from '@/components/ui/button';

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    // Log error to console for debugging
    console.error('Error in Chatbot:', error);
  }, [error]);

  return (
    <div className="flex flex-col items-center justify-center min-h-screen p-4">
      <div className="max-w-md w-full bg-white rounded-lg shadow-lg p-6">
        <h2 className="text-2xl font-bold text-red-600 mb-4">
          Có lỗi xảy ra
        </h2>
        <p className="text-gray-700 mb-4">
          {error.message || 'Đã xảy ra lỗi không xác định. Vui lòng thử lại sau.'}
        </p>
        {error.digest && (
          <p className="text-sm text-gray-500 mb-4">
            Mã lỗi: {error.digest}
          </p>
        )}
        <div className="flex gap-2">
          <Button onClick={reset} variant="default">
            Thử lại
          </Button>
          <Button 
            onClick={() => window.location.href = '/'} 
            variant="outline"
          >
            Về trang chủ
          </Button>
        </div>
      </div>
    </div>
  );
}
