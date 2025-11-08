"use client";

/**
 * Chatbot Widget Component
 * Component này có thể được embed vào bất kỳ website nào
 */

import { generateInsightsFromExcel } from "@/ai/flows/generate-insights-from-excel";
import { ChatMessage } from "@/components/chat-message";
import { LoadingDots } from "@/components/typing-animation";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Textarea } from "@/components/ui/textarea";
import { useToast } from "@/hooks/use-toast";
import {
  Loader2,
  Send,
  RefreshCw,
  Minimize2,
  Maximize2,
  Leaf,
} from "lucide-react";
import React, { useRef, useState, useTransition, useEffect } from "react";
import { generateUUID } from "@/lib/uuid"; // UUID generator với fallback

type Message = {
  id: string;
  role: "user" | "assistant";
  content: string | React.ReactNode;
};

interface ChatbotWidgetProps {
  initialMessage?: string;
  width?: string;
  height?: string;
}

export function ChatbotWidget({ 
  initialMessage = "Xin chào! Tôi là Smart Farm Bot - Trợ lý AI chuyên về nông nghiệp thông minh và canh tác cây trồng tại Việt Nam. Tôi có thể hỗ trợ bạn về kỹ thuật trồng trọt, chăm sóc cây trồng, quản lý sâu bệnh và các kiến thức nông nghiệp khác. Bạn có câu hỏi gì về cây trồng không?",
  width = "100%",
  height = "600px"
}: ChatbotWidgetProps) {
  const [messages, setMessages] = useState<Message[]>([
    {
      id: generateUUID(),
      role: 'assistant',
      content: initialMessage
    }
  ]);
  
  const [isPending, startTransition] = useTransition();
  const [isMinimized, setIsMinimized] = useState(false);
  const formRef = useRef<HTMLFormElement>(null);
  const textareaRef = useRef<HTMLTextAreaElement>(null);
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const { toast } = useToast();

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages, isPending]);

  useEffect(() => {
    if (!isPending && messages.length > 1) {
      setTimeout(() => {
        textareaRef.current?.focus();
      }, 300);
    }
  }, [isPending, messages]);

  const handleClearChat = () => {
    setMessages([{
      id: generateUUID(),
      role: 'assistant',
      content: initialMessage
    }]);
    setTimeout(() => {
      textareaRef.current?.focus();
    }, 100);
  };

  const handleQuery = (query: string) => {
    if (!query || isPending) return;

    setMessages((prev) => [
      ...prev,
      { id: crypto.randomUUID(), role: "user", content: query },
    ]);

    startTransition(async () => {
      try {
        const recentMessages = messages.slice(-6);
        const conversationHistory = recentMessages
          .map(msg => `${msg.role === 'user' ? 'Người dùng' : 'Smart Farm Bot'}: ${msg.content}`)
          .join('\n');

        const result = await generateInsightsFromExcel({
          excelDataUri: '',
          query,
          conversationHistory,
        });
        
        setMessages((prev) => [
          ...prev,
          {
            id: generateUUID(),
            role: "assistant",
            content: result.answer,
          },
        ]);
      } catch (error) {
        console.error("Error generating insights:", error);
        
        toast({
          variant: "destructive",
          title: "Có lỗi xảy ra",
          description: "Không thể lấy thông tin chi tiết. Vui lòng thử lại.",
        });
        
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

  if (isMinimized) {
    return (
      <div className="fixed bottom-4 right-4 z-50">
        <Button
          onClick={() => setIsMinimized(false)}
          className="bg-gradient-to-r from-emerald-500 to-lime-500 hover:from-emerald-600 hover:to-lime-600 shadow-lg h-14 px-6 rounded-full"
        >
          <Leaf className="h-5 w-5 mr-2 text-white" />
          Mở SmartFarm Bot
        </Button>
      </div>
    );
  }
  return (
    <div 
      className="fixed bottom-4 right-4 z-50 shadow-2xl rounded-2xl overflow-hidden border border-gray-200"
      style={{ width, height, maxWidth: '500px', maxHeight: 'calc(100vh - 2rem)' } as React.CSSProperties}
    >
      <div className="flex flex-col h-full bg-white">
  {/* Header */}
  <div className="p-4 border-b border-gray-200 bg-gradient-to-r from-emerald-600 to-lime-400">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 bg-white/20 rounded-full flex items-center justify-center">
                <Leaf className="h-5 w-5 text-white" />
              </div>
              <div>
                <h3 className="text-white font-bold text-sm">Smart Farm Bot</h3>
                <p className="text-white/90 text-xs">Hỗ trợ canh tác, dinh dưỡng và tưới tiêu</p>
              </div>
            </div>
            <div className="flex items-center gap-2">
              <Button
                onClick={handleClearChat}
                disabled={isPending}
                variant="ghost"
                size="sm"
                className="text-white hover:bg-white/20 h-8 w-8 p-0"
              >
                <RefreshCw className="h-4 w-4" />
              </Button>
              <Button
                onClick={() => setIsMinimized(true)}
                variant="ghost"
                size="sm"
                className="text-white hover:bg-white/20 h-8 w-8 p-0"
              >
                <Minimize2 className="h-4 w-4" />
              </Button>
            </div>
          </div>
        </div>

        {/* Messages */}
        <ScrollArea className="flex-1 p-4 bg-gray-50">
          <div className="space-y-4">
            {messages.map((msg, index) => (
              <div key={msg.id}>
                <ChatMessage role={msg.role}>
                  {msg.content}
                </ChatMessage>
              </div>
            ))}
            {isPending && (
              <ChatMessage role="assistant">
                <div className="flex items-center space-x-2">
                  <LoadingDots />
                  <span className="text-sm text-gray-500 font-medium">Đang suy nghĩ</span>
                <Leaf className="h-3.5 w-3.5 text-emerald-600/80 animate-pulse" />
                </div>
              </ChatMessage>
            )}
            <div ref={messagesEndRef} />
          </div>
        </ScrollArea>
        
        {/* Input */}
        <div className="p-4 border-t border-gray-200 bg-white">
          <form
            ref={formRef}
            onSubmit={handleSubmit}
            className="flex items-end gap-2"
          >
            <Textarea
              ref={textareaRef}
              name="query"
              placeholder="Nhập câu hỏi..."
              className="flex-1 resize-none border-gray-200 focus-visible:ring-blue-500 min-h-[50px] text-sm"
              rows={1}
              disabled={isPending}
              onKeyDown={(e) => {
                if (e.key === "Enter" && !e.shiftKey) {
                  e.preventDefault();
                  formRef.current?.requestSubmit();
                }
              }}
            />
            <Button
              type="submit"
              size="icon"
              disabled={isPending}
              className="bg-gradient-to-r from-emerald-600 to-lime-400 hover:from-emerald-700 hover:to-lime-500 h-[50px] w-[50px]"
            >
              {isPending ? (
                <Loader2 className="h-5 w-5 animate-spin text-white" />
              ) : (
                <Send className="h-5 w-5 text-white" />
              )}
            </Button>
          </form>
        </div>
      </div>
    </div>
  );
}

