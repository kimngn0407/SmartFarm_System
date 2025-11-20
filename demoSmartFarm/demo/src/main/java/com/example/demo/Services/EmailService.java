package com.example.demo.Services;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.thymeleaf.context.Context;
import org.thymeleaf.spring6.SpringTemplateEngine;

import java.util.List;
import java.util.Map;

/**
 * Email Service - Gửi email cảnh báo
 * 
 * ⚠️ TẠM TẮT - Service này chỉ hoạt động khi có cấu hình MAIL_HOST trong docker-compose.yml
 * Để bật lại, uncomment các dòng MAIL_* trong docker-compose.yml và set giá trị
 */
@Service
@ConditionalOnProperty(name = "spring.mail.host")
public class EmailService {

    private static final Logger logger = LoggerFactory.getLogger(EmailService.class);

    @Autowired(required = false)
    private JavaMailSender mailSender;
    
    @Autowired
    private SpringTemplateEngine templateEngine;

    @Value("${app.mail.from:alerts@example.com}")
    private String fromAddress;

    @Async
    public void sendAlertEmail(String to, String subject, String htmlBody) {
        sendAlertEmail(List.of(to), null, null, subject, Map.of("body", htmlBody));
    }

    @Async
    public void sendAlertEmail(List<String> to, List<String> cc, List<String> bcc, String subject, Map<String, Object> templateVariables) {
        if (mailSender == null) {
            logger.warn("Email service is not configured. Skipping email to: {}", to);
            return;
        }
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, "utf-8");

            // prepare HTML from template variables; if template includes 'body' key, use it directly
            String htmlBody;
            if (templateVariables != null && templateVariables.containsKey("templateName")) {
                // render Thymeleaf template
                String templateName = (String) templateVariables.get("templateName");
                Context ctx = new Context();
                for (Map.Entry<String, Object> e : templateVariables.entrySet()) {
                    if ("templateName".equals(e.getKey())) continue;
                    ctx.setVariable(e.getKey(), e.getValue());
                }
                htmlBody = templateEngine.process(templateName, ctx);
            } else if (templateVariables != null && templateVariables.containsKey("body")) {
                htmlBody = String.valueOf(templateVariables.get("body"));
            } else {
                htmlBody = "";
            }

            helper.setText(htmlBody, true);

            // set recipients
            if (to != null && !to.isEmpty()) {
                helper.setTo(to.toArray(new String[0]));
            }
            if (cc != null && !cc.isEmpty()) {
                helper.setCc(cc.toArray(new String[0]));
            }
            if (bcc != null && !bcc.isEmpty()) {
                helper.setBcc(bcc.toArray(new String[0]));
            }

            helper.setSubject(subject);
            helper.setFrom(fromAddress);
            mailSender.send(message);
            logger.info("Alert email sent to {} with subject={}", to, subject);
        } catch (MessagingException ex) {
            logger.error("Failed to build alert email to {}: {}", to, ex.getMessage(), ex);
        } catch (Exception ex) {
            logger.error("Failed to send alert email to {}: {}", to, ex.getMessage(), ex);
        }
    }
}
