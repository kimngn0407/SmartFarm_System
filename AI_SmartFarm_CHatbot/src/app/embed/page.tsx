"use client";

/**
 * Trang này dùng để embed chatbot vào iframe
 * URL: https://your-domain.com/embed
 */

import { generateInsightsFromExcel } from "@/ai/flows/generate-insights-from-excel";
import { ChatMessage } from "@/components/chat-message";
import { LoadingDots } from "@/components/typing-animation";
import { Button } from "@/components/ui/button";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Textarea } from "@/components/ui/textarea";
import { useToast } from "@/hooks/use-toast";
import {
  Loader2,
  Send,
  Sparkles,
  RefreshCw,
} from "lucide-react";
import React, { useRef, useState, useTransition, useEffect } from "react";
import { generateUUID } from "@/lib/uuid"; // UUID generator với fallback

type Message = {
  id: string;
  role: "user" | "assistant";
  content: string | React.ReactNode;
};

export default function EmbedPage() {
  const [messages, setMessages] = useState<Message[]>([
    {
      id: generateUUID(),
      role: 'assistant',
      content: "Xin chào! Tôi là Smart Farm Bot - Trợ lý AI chuyên về nông nghiệp thông minh và canh tác cây trồng tại Việt Nam. Tôi có thể hỗ trợ bạn về kỹ thuật trồng trọt, chăm sóc cây trồng, quản lý sâu bệnh và các kiến thức nông nghiệp khác. Bạn có câu hỏi gì về cây trồng không?"
    }
  ]);
  
  const [isPending, startTransition] = useTransition();
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
      content: "Xin chào! Tôi là Smart Farm Bot - Trợ lý AI chuyên về nông nghiệp thông minh và canh tác cây trồng tại Việt Nam. Tôi có thể hỗ trợ bạn về kỹ thuật trồng trọt, chăm sóc cây trồng, quản lý sâu bệnh và các kiến thức nông nghiệp khác. Bạn có câu hỏi gì về cây trồng không?"
    }]);
    setTimeout(() => {
      textareaRef.current?.focus();
    }, 100);
  };

  const handleQuery = (query: string) => {
    if (!query || isPending) return;

    setMessages((prev) => [
      ...prev,
      { id: generateUUID(), role: "user", content: query },
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

  return (
    <div className="flex flex-col h-screen w-full bg-white">
      {/* Header */}
      <div className="p-4 border-b border-gray-200 bg-gradient-to-r from-blue-500 to-purple-500">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-8 h-8 bg-white/20 rounded-full flex items-center justify-center">
              <Sparkles className="h-5 w-5 text-white" />
            </div>
            <div>
              <h3 className="text-white font-bold">Smart Farm Bot</h3>
              <p className="text-white/80 text-xs">Nông nghiệp thông minh</p>
            </div>
          </div>
          <Button
            onClick={handleClearChat}
            disabled={isPending}
            variant="ghost"
            size="sm"
            className="text-white hover:bg-white/20"
          >
            <RefreshCw className="h-4 w-4 mr-2" />
            Làm mới
          </Button>
        </div>
      </div>

      {/* Messages */}
      <ScrollArea className="flex-1 p-4 bg-gray-50">
        <div className="space-y-4">
          {messages.map((msg) => (
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
                <Sparkles className="h-3.5 w-3.5 text-blue-500/70 animate-pulse" />
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
            className="bg-gradient-to-r from-blue-500 to-purple-500 hover:from-blue-600 hover:to-purple-600 h-[50px] w-[50px]"
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
  );
}

