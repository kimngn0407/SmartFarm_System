// ===== KHAI BÁO "USE CLIENT" =====
// Báo cho Next.js biết đây là component chạy trên browser (client-side)
// Cần thiết vì sử dụng useState, useEffect và các tương tác người dùng
"use client";

// ===== IMPORT CÁC THƯ VIỆN VÀ COMPONENT =====
import { generateInsightsFromExcel } from "@/ai/flows/generate-insights-from-excel"; // AI engine
import { ChatMessage } from "@/components/chat-message";           // Component hiển thị tin nhắn
import { Logo } from "@/components/logo";                          // Logo HUTECH
import { LoadingDots } from "@/components/typing-animation";       // Hiệu ứng "đang gõ"
import { Button } from "@/components/ui/button";                   // Nút bấm
import { Card, CardContent } from "@/components/ui/card";          // Khung chat
import { ScrollArea } from "@/components/ui/scroll-area";          // Vùng cuộn tin nhắn
import { Textarea } from "@/components/ui/textarea";               // Ô nhập text
import { useToast } from "@/hooks/use-toast";                      // Thông báo lỗi
import {
  Loader2,    // Icon loading (quay tròn)
  Send,       // Icon gửi tin nhắn
  Sparkles,   // Icon hiệu ứng
  RefreshCw,  // Icon làm mới
} from "lucide-react"; // Thư viện icons
import React, { useRef, useState, useTransition, useEffect } from "react"; // React hooks
import { generateUUID } from "@/lib/uuid"; // UUID generator với fallback

// ===== ĐỊNH NGHĨA TYPE CHO TIN NHẮN =====
// Mỗi tin nhắn sẽ có cấu trúc như này
type Message = {
  id: string;                           // ID duy nhất
  role: "user" | "assistant";           // Vai trò: người dùng hoặc AI
  content: string | React.ReactNode;    // Nội dung tin nhắn
};

// ===== COMPONENT CHÍNH =====
export default function Home() {
  // ===== STATE MANAGEMENT =====
  // Danh sách tin nhắn (bắt đầu với lời chào từ AI)
  const [messages, setMessages] = useState<Message[]>([
    {
      id: generateUUID(), // Tạo ID ngẫu nhiên
      role: 'assistant',       // Tin nhắn từ AI
      content: "Xin chào! Tôi là Smart Farm Bot - Trợ lý AI chuyên về nông nghiệp thông minh và canh tác cây trồng tại Việt Nam. Tôi có thể hỗ trợ bạn về kỹ thuật trồng trọt, chăm sóc cây trồng, quản lý sâu bệnh và các kiến thức nông nghiệp khác. Bạn có câu hỏi gì về cây trồng không?"
    }
  ]);
  
  // ===== CÁC BIẾN TRẠNG THÁI VÀ REF =====
  const [isPending, startTransition] = useTransition();  // Quản lý loading state khi gọi AI
  const formRef = useRef<HTMLFormElement>(null);          // Tham chiếu đến form nhập tin nhắn
  const textareaRef = useRef<HTMLTextAreaElement>(null);  // Tham chiếu đến ô nhập text
  const messagesEndRef = useRef<HTMLDivElement>(null);    // Tham chiếu đến cuối danh sách tin nhắn
  const { toast } = useToast();                           // Hook hiển thị thông báo lỗi

  // ===== AUTO SCROLL XUỐNG CUỐI KHI CÓ TIN NHẮN MỚI =====
  useEffect(() => {
    // Cuộn xuống cuối mỗi khi có tin nhắn mới hoặc đang loading
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages, isPending]); // Chạy khi messages hoặc isPending thay đổi

  // ===== AUTO FOCUS VÀO Ô NHẬP SAU KHI AI TRẢ LỜI =====
  useEffect(() => {
    if (!isPending && messages.length > 1) {
      // Đợi 300ms để cuộn hoàn tất, sau đó focus vào ô nhập
      setTimeout(() => {
        textareaRef.current?.focus();
      }, 300);
    }
  }, [isPending, messages]); // Chạy khi trạng thái loading hoặc tin nhắn thay đổi

  // ===== FUNCTION XÓA TẤT CẢ TIN NHẮN =====
  const handleClearChat = () => {
    // Reset về tin nhắn chào ban đầu
    setMessages([{
      id: generateUUID(),
      role: 'assistant',
      content: "Xin chào! Tôi là Smart Farm Bot - Trợ lý AI chuyên về nông nghiệp thông minh và canh tác cây trồng tại Việt Nam. Tôi có thể hỗ trợ bạn về kỹ thuật trồng trọt, chăm sóc cây trồng, quản lý sâu bệnh và các kiến thức nông nghiệp khác. Bạn có câu hỏi gì về cây trồng không?"
    }]);
    // Focus vào ô nhập sau khi xóa
    setTimeout(() => {
      textareaRef.current?.focus();
    }, 100);
  };

  // ===== FUNCTION XỬ LÝ CÂUHỎI CHÍNH =====
  const handleQuery = (query: string) => {
    // Kiểm tra: không xử lý nếu câu hỏi rỗng hoặc đang loading
    if (!query || isPending) return;

    // ===== BƯỚC 1: THÊM TIN NHẮN CỦA USER VÀO DANH SÁCH =====
    setMessages((prev) => [
      ...prev, // Giữ lại tin nhắn cũ
      { id: generateUUID(), role: "user", content: query }, // Thêm tin nhắn mới
    ]);

    // ===== BƯỚC 2: GỬI CHO AI XỬ LÝ (ASYNC) =====
    startTransition(async () => {
      try {
        // ===== TẠO NGỮ CẢNH TỪ TIN NHẮN TRƯỚC ĐÓ =====
        const recentMessages = messages.slice(-6); // Lấy 6 tin nhắn gần nhất (3 cặp hỏi-đáp)
        const conversationHistory = recentMessages
          .map(msg => `${msg.role === 'user' ? 'Người dùng' : 'Smart Farm Bot'}: ${msg.content}`)
          .join('\n'); // Nối thành chuỗi với xuống dòng

        // ===== GỌI AI ENGINE =====
        const result = await generateInsightsFromExcel({
          excelDataUri: '',     // Không dùng file upload, dùng file mặc định
          query,                // Câu hỏi hiện tại
          conversationHistory,  // Ngữ cảnh cuộc trò chuyện
        });
        
        // ===== THÊM CÂU TRẢ LỜI CỦA AI VÀO DANH SÁCH =====
        setMessages((prev) => [
          ...prev, // Giữ lại tin nhắn cũ
          {
            id: generateUUID(),
            role: "assistant",
            content: result.answer, // Câu trả lời từ AI
          },
        ]);
      } catch (error) {
        // ===== XỬ LÝ LỖI =====
        console.error("Error generating insights:", error);
        
        // Hiển thị thông báo lỗi cho user
        toast({
          variant: "destructive",
          title: "Có lỗi xảy ra",
          description: "Không thể lấy thông tin chi tiết. Vui lòng thử lại.",
        });
        
        // Xóa tin nhắn user vừa gửi (vì không có response)
        setMessages((prev) =>
          prev.filter((msg, index) => index !== prev.length - 1)
        );
      }
    });
  };

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const formData = new FormData(e.currentTarget);
    const query = (formData.get("query") as string)?.trim();
    
    if (query) {
      formRef.current?.reset();
      handleQuery(query);
    }
  };

  return (
    <div className="flex flex-col h-screen w-full text-foreground">
      <main className="flex-1 flex flex-col h-full">
        {/* Header */}
        <div className="p-4 border-b border-gray-200/50 bg-gradient-to-r from-white/95 via-white/90 to-white/95 backdrop-blur-lg">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="relative group">
                <div className="absolute -inset-1 bg-gradient-to-r from-blue-500/20 via-purple-500/20 to-pink-500/20 rounded-full opacity-0 group-hover:opacity-100 blur transition-all duration-500"></div>
                <Logo className="h-10 w-10 animate-float relative z-10" />
              </div>
              <div className="space-y-0.5">
                <div className="flex items-center gap-2">
                  <h1 className="text-xl font-bold bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 bg-clip-text text-transparent">Smart Farm Bot</h1>
                  {/* <div className="px-2 py-0.5 bg-green-500/10 border border-green-500/20 rounded-full text-xs font-medium text-green-600">
                    HUTECH
                  </div> */}
                </div>
                <p className="text-sm text-black-500">Trợ lý AI về Nông nghiệp thông minh & Canh tác cây trồng</p>
              </div>
            </div>
            <div className="flex items-center gap-4">
              <Button
                onClick={handleClearChat}
                disabled={isPending}
                variant="outline"
                size="sm"
                className="bg-white/80 backdrop-blur-sm border-gray-200/60 hover:bg-gray-50/80 transition-all duration-200 group"
              >
                <RefreshCw className="h-4 w-4 mr-2 group-hover:rotate-180 transition-transform duration-500" />
                Làm mới
              </Button>
              <div className="relative">
                <div className="absolute inset-0 bg-green-500/20 rounded-full blur animate-pulse"></div>
                <div className="relative w-3 h-3 bg-green-500 rounded-full"></div>
              </div>
              <div className="text-right">
                <div className="text-sm font-medium text-green-600">Online</div>
              </div>
            </div>
          </div>
        </div>

        <ScrollArea className="flex-1 p-6 university-bg">
          <div className="space-y-6 max-w-4xl mx-auto">
            {messages.map((msg, index) => (
              <div 
                key={msg.id} 
                className={`animate-slide-up delay-${Math.min(index * 100, 500)}`}
              >
                <ChatMessage role={msg.role}>
                  {msg.content}
                </ChatMessage>
              </div>
            ))}
            {isPending && (
              <div className="animate-slide-up">
                <ChatMessage role="assistant">
                  <div className="flex items-center space-x-2">
                    <LoadingDots />
                    <span className="text-sm text-gray-500 font-medium">Đang suy nghĩ</span>
                    <Sparkles className="h-3.5 w-3.5 text-blue-500/70 animate-pulse" />
                  </div>
                </ChatMessage>
              </div>
            )}
            <div ref={messagesEndRef} />
          </div>
        </ScrollArea>
        
        <div className="p-6 border-t border-gray-200/50 bg-gradient-to-r from-white/95 via-white/90 to-white/95 backdrop-blur-lg">
          <div className="max-w-4xl mx-auto">
            <div className="relative">
              <div className="absolute inset-0 bg-gradient-to-r from-blue-500/10 via-purple-500/5 to-pink-500/10 rounded-2xl blur-xl"></div>
              <Card className="relative bg-white/80 backdrop-blur-sm border-white/40 shadow-xl rounded-2xl overflow-hidden">
                <CardContent className="p-1">
                  <form
                    ref={formRef}
                    onSubmit={handleSubmit}
                    className="flex items-end gap-3"
                  >
                    <div className="flex-1 relative">
                      <Textarea
                        ref={textareaRef}
                        name="query"
                        placeholder="Nhập câu hỏi của bạn tại đây... ✨"
                        className="flex-1 resize-none border-0 shadow-none focus-visible:ring-0 bg-transparent text-gray-800 placeholder:text-gray-400 min-h-[56px] px-4 py-4 pr-16 text-base"
                        rows={1}
                        disabled={isPending}
                        onKeyDown={(e) => {
                          if (e.key === "Enter" && !e.shiftKey) {
                            e.preventDefault();
                            formRef.current?.requestSubmit();
                          }
                        }}
                      />
                      <div className="absolute right-4 bottom-4 flex items-center gap-2">
                        {/* <kbd className="px-2 py-1 text-xs bg-gray-100 border border-gray-200 rounded text-gray-600 font-mono">
                          ⏎ Enter
                        </kbd> */}
                      </div>
                    </div>
                    <div className="relative group">
                      <div className="absolute -inset-1 bg-gradient-to-r from-blue-500 via-purple-500 to-pink-500 rounded-xl opacity-0 group-hover:opacity-100 blur-sm transition-all duration-300"></div>
                      <Button
                        type="submit"
                        size="icon"
                        disabled={isPending}
                        className="relative bg-gradient-to-r from-blue-500 to-purple-500 hover:from-blue-600 hover:to-purple-600 border-0 shadow-lg transition-all transform hover:scale-105 h-12 w-12 rounded-xl"
                      >
                        {isPending ? (
                          <Loader2 className="h-5 w-5 animate-spin text-white" />
                        ) : (
                          <Send className="h-5 w-5 text-white" />
                        )}
                      </Button>
                    </div>
                  </form>
                </CardContent>
              </Card>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}