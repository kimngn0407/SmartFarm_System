'use server';

/**
 * @fileOverview File này xử lý logic chính của chatbot Smart Farm Bot
 * 
 * Chức năng chính:
 * - Nhận câu hỏi từ người dùng về nông nghiệp và canh tác
 * - Đọc dữ liệu từ file Excel chứa câu hỏi-đáp về cây trồng
 * - Gửi cho AI để phân tích và trả lời dựa trên kiến thức có sẵn
 * - Trả về câu trả lời thông minh về nông nghiệp
 */

// Import các thư viện cần thiết
import {ai} from '@/ai/genkit';           // Engine AI chính
import {z} from 'genkit';                // Thư viện validation dữ liệu
import * as xlsx from 'xlsx';            // Thư viện đọc file Excel
import * as fs from 'fs';                // Thư viện đọc file từ hệ thống
import * as path from 'path';            // Thư viện xử lý đường dẫn file

// ===== ĐỊNH NGHĨA CẤU TRÚC DỮ LIỆU =====

/**
 * Schema (Quy tắc) cho dữ liệu đầu vào từ frontend
 * Giống như "form đăng ký" - quy định user phải cung cấp gì
 */
const GenerateInsightsFromExcelInputSchema = z.object({
  // File Excel (không bắt buộc vì có file mặc định)
  excelDataUri: z
    .string()
    .describe(
      "File Excel dạng base64. Format: 'data:<mimetype>;base64,<encoded_data>'. Không dùng thì sẽ dùng file mặc định."
    ).optional(),
  
  // Câu hỏi của sinh viên (bắt buộc)
  query: z.string().describe('Câu hỏi về dữ liệu trong file Excel.'),
  
  // Lịch sử cuộc trò chuyện (không bắt buộc) - QUAN TRỌNG để AI nhớ context!
  conversationHistory: z.string().optional().describe('Ngữ cảnh cuộc trò chuyện trước đó để AI trả lời tốt hơn.'),
});

// Tạo type TypeScript từ schema (để code có thể hiểu được)
export type GenerateInsightsFromExcelInput = z.infer<typeof GenerateInsightsFromExcelInputSchema>;

/**
 * Schema cho dữ liệu nội bộ (dùng trong AI processing)
 * Đây là dữ liệu đã được xử lý, chuẩn bị gửi cho AI
 */
const GenerateInsightsFromExcelInternalInputSchema = z.object({
    // Dữ liệu Excel đã convert thành JSON string
    excelDataJson: z.string().describe("Dữ liệu từ file Excel ở dạng JSON."),
    
    // Câu hỏi của sinh viên
    query: z.string().describe('Câu hỏi về dữ liệu trong file Excel.'),
    
    // Lịch sử cuộc trò chuyện
    conversationHistory: z.string().optional().describe('Ngữ cảnh cuộc trò chuyện trước đó để AI trả lời tốt hơn.'),
});

/**
 * Schema cho kết quả trả về
 * Quy định AI phải trả về như thế nào
 */
const GenerateInsightsFromExcelOutputSchema = z.object({
  // Câu trả lời từ AI
  answer: z.string().describe('Câu trả lời thông minh từ AI.'),
});

// Tạo type TypeScript cho output
export type GenerateInsightsFromExcelOutput = z.infer<typeof GenerateInsightsFromExcelOutputSchema>;

// ===== FUNCTION CHÍNH CHO FRONTEND =====

/**
 * Function này sẽ được gọi từ frontend (page.tsx)
 * Đây là "cửa ra vào" chính của AI system
 */
export async function generateInsightsFromExcel(
  input: GenerateInsightsFromExcelInput
): Promise<GenerateInsightsFromExcelOutput> {
  // Gọi flow xử lý chính và trả về kết quả
  return generateInsightsFromExcelFlow(input);
}

// ===== ĐỊNH NGHĨA PROMPT CHO AI =====

/**
 * Đây là "kịch bản" dạy AI cách trả lời
 * Giống như viết hướng dẫn cho nhân viên tư vấn
 */
const prompt = ai.definePrompt({
  name: 'generateInsightsFromExcelPrompt',
  input: {schema: GenerateInsightsFromExcelInternalInputSchema},
  output: {schema: GenerateInsightsFromExcelOutputSchema},

  // PROMPT NGẮN GỌN: TRẢ VỀ TRỰC TIẾP KHÔNG IN TIÊU ĐỀ
  prompt: `Bạn là Smart Farm Bot — trợ lý AI cho nông nghiệp thông minh tại Việt Nam.

Nguyên tắc trả lời (rút gọn):
- Trả lời trực tiếp bằng tiếng Việt, ngắn gọn và hữu dụng. KHÔNG in các tiêu đề như "Trả lời:", "Nguồn dữ liệu:", "Khuyến nghị:", "Độ tin cậy:" hay "Giả định:".
- Nếu câu hỏi có thể trả lời từ dữ liệu Excel ({{{excelDataJson}}}), ưu tiên dùng nội dung "CÂU TRẢ LỜI"; nếu dùng dữ liệu, được phép thêm một chú thích nguồn ngắn ở cuối câu trong ngoặc, ví dụ: (nguồn: STT 12).
- Nếu không có dữ liệu phù hợp, bắt đầu câu trả lời bằng "(không tìm thấy trong dữ liệu)" rồi tiếp phần trả lời ngắn.
- Nếu cần đưa ra khuyến nghị, ghi trực tiếp các bước dưới dạng câu ngắn, không cần số mục hoặc tiêu đề.

Dữ liệu đầu vào: {{{excelDataJson}}} (mảng JSON; cột chuẩn: STT, CÂU HỎI, CÂU TRẢ LỜI). Ngữ cảnh cuộc trò chuyện: {{{conversationHistory}}}. Câu hỏi: {{{query}}}.

Ghi chú: Trả về đúng một chuỗi văn bản (output.answer). Tránh in dữ liệu thô, tránh in nhiều mục tiêu đề; ưu tiên câu trả lời ngắn và các bước hành động dễ hiểu cho nông dân hoặc kỹ sư nông nghiệp.`,
});

// ===== FLOW XỬ LÝ CHÍNH =====

/**
 * Đây là "nhà máy xử lý" chính của chatbot
 * Quy trình: Nhận input → Đọc Excel → Gửi AI → Trả kết quả
 */
const generateInsightsFromExcelFlow = ai.defineFlow(
  {
    name: 'generateInsightsFromExcelFlow',              // Tên flow
    inputSchema: GenerateInsightsFromExcelInputSchema,  // Schema đầu vào
    outputSchema: GenerateInsightsFromExcelOutputSchema, // Schema đầu ra
  },
  async input => {
    try {
      // ===== BƯỚC 1: ĐỌC FILE EXCEL =====
      let buffer: Buffer; // Biến chứa dữ liệu file Excel

      // Kiểm tra xem có file Excel được upload không
      if (input.excelDataUri) {
        // Nếu có file upload, decode từ base64
        const base64Data = input.excelDataUri.split(',')[1]; // Tách phần base64
        buffer = Buffer.from(base64Data, 'base64');          // Convert thành buffer
      } else {
        // Nếu không có file upload, dùng file mặc định
        const filePath = path.join(process.cwd(), 'src', 'data', 'sample-data.xlsx');
        
        // Kiểm tra file có tồn tại không
        if (!fs.existsSync(filePath)) {
          // Nếu không có file, dùng dữ liệu mặc định
          const defaultData = [
            { STT: 1, 'CÂU HỎI': 'Cách trồng lúa?', 'CÂU TRẢ LỜI': 'Trồng lúa cần đất phù sa, nước đầy đủ, và chăm sóc thường xuyên.' },
            { STT: 2, 'CÂU HỎI': 'Cách bón phân cho cây?', 'CÂU TRẢ LỜI': 'Bón phân đúng liều lượng, đúng thời điểm, và tưới nước sau khi bón.' }
          ];
          const excelDataJson = defaultData;
          
          // Gửi cho AI xử lý với dữ liệu mặc định
          const {output} = await prompt({
            excelDataJson: JSON.stringify(excelDataJson),
            query: input.query,
            conversationHistory: input.conversationHistory || '',
          });
          
          return output!;
        }
        
        buffer = fs.readFileSync(filePath); // Đọc file từ hệ thống
      }
      
      // ===== BƯỚC 2: XỬ LÝ DỮ LIỆU EXCEL =====
      const workbook = xlsx.read(buffer, { type: 'buffer' }); // Đọc workbook
      const sheetName = workbook.SheetNames[0];               // Lấy sheet đầu tiên
      const worksheet = workbook.Sheets[sheetName];           // Lấy dữ liệu sheet
      const excelDataJson = xlsx.utils.sheet_to_json(worksheet); // Convert sang JSON

      // ===== BƯỚC 3: GỬI CHO AI XỬ LÝ =====
      const {output} = await prompt({
          excelDataJson: JSON.stringify(excelDataJson),    // Dữ liệu Excel dạng JSON
          query: input.query,                              // Câu hỏi của user
          conversationHistory: input.conversationHistory || '', // Lịch sử chat (nếu có)
      });
      
      // ===== BƯỚC 4: TRẢ KẾT QUẢ =====
      return output!; // Trả về câu trả lời từ AI
    } catch (error: any) {
      // Xử lý lỗi và trả về thông báo thân thiện
      console.error('Error in generateInsightsFromExcelFlow:', error);
      console.error('Error details:', {
        message: error?.message,
        digest: error?.digest,
        stack: error?.stack,
        code: error?.code,
        cause: error?.cause,
        name: error?.name
      });
      
      // Kiểm tra lỗi API key
      const errorMsg = error?.message || '';
      const errorStr = JSON.stringify(error || {});
      
      if (errorMsg.includes('API key') || errorMsg.includes('GOOGLE') || errorStr.includes('API key') || errorStr.includes('GOOGLE')) {
        throw new Error('API key chưa được cấu hình. Vui lòng liên hệ quản trị viên để cấu hình GOOGLE_GENAI_API_KEY.');
      }
      
      // Kiểm tra lỗi file
      if (error?.code === 'ENOENT') {
        throw new Error('Không tìm thấy file dữ liệu. Đang sử dụng dữ liệu mặc định.');
      }
      
      // Kiểm tra lỗi network/connection
      if (errorMsg.includes('fetch') || errorMsg.includes('network') || errorMsg.includes('ECONNREFUSED')) {
        throw new Error('Không thể kết nối đến AI service. Vui lòng kiểm tra kết nối mạng.');
      }
      
      // Lỗi khác - trả về message chi tiết hơn
      const detailedError = error?.message || error?.digest || 'Unknown error';
      throw new Error(`Có lỗi xảy ra khi xử lý câu hỏi: ${detailedError}. Vui lòng thử lại sau.`);
    }
  }
);
