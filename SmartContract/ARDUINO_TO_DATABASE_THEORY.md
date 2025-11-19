# Lý Thuyết: Đưa Dữ Liệu Arduino Lên Database với Spring Boot

## 1. Tổng Quan Kiến Trúc

### 1.1. Luồng Dữ Liệu Cơ Bản
```
[Arduino/ESP32] 
    ↓ (HTTP POST / Serial)
[Spring Cloud Gateway] 
    ↓ (Routing + Security)
[Sensor Service - Microservice]
    ↓ (Business Logic + Validation)
[Database Service / JPA Repository]
    ↓ (ORM Mapping)
[PostgreSQL/MySQL Database]
```

### 1.2. Các Thành Phần Chính

#### A. Device Layer (Arduino/ESP32)
- **ESP32**: Có WiFi tích hợp → Gửi trực tiếp HTTP POST
- **Arduino UNO**: Không có WiFi → Cần Serial Gateway

#### B. Gateway Layer (Spring Cloud Gateway)
- **Authentication**: JWT Token hoặc API Key
- **Rate Limiting**: Giới hạn request từ device
- **Routing**: Route đến đúng microservice
- **Load Balancing**: Phân tải request

#### C. Service Layer (Microservices)
- **Sensor Service**: Nhận và xử lý dữ liệu sensor
- **Data Processing Service**: Xử lý, validate, transform data
- **Notification Service**: Gửi cảnh báo nếu cần

#### D. Data Layer
- **Spring Data JPA**: ORM mapping
- **Flyway**: Database migration
- **Connection Pooling**: Tối ưu kết nối database

---

## 2. Phương Pháp 1: HTTP REST API (ESP32)

### 2.1. Kiến Trúc
```
ESP32 → WiFi → HTTP POST → Spring Cloud Gateway → Sensor Service → Database
```

### 2.2. Arduino Code (ESP32)
```cpp
#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

const char* ssid = "YOUR_WIFI";
const char* password = "YOUR_PASSWORD";
const char* apiUrl = "http://your-gateway:8080/api/v1/sensors/data";

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
  }
}

void loop() {
  // Đọc sensor
  float temp = readTemperature();
  float humidity = readHumidity();
  
  // Tạo JSON payload
  JsonDocument doc;
  doc["sensorId"] = 1;
  doc["time"] = getUnixTimestamp();
  doc["temperature"] = temp;
  doc["humidity"] = humidity;
  
  String jsonPayload;
  serializeJson(doc, jsonPayload);
  
  // Gửi HTTP POST
  HTTPClient http;
  http.begin(apiUrl);
  http.addHeader("Content-Type", "application/json");
  http.addHeader("x-api-key", "YOUR_API_KEY");
  
  int httpCode = http.POST(jsonPayload);
  if (httpCode == 200) {
    Serial.println("Data sent successfully");
  }
  
  http.end();
  delay(5000); // Gửi mỗi 5 giây
}
```

### 2.3. Spring Boot Controller
```java
@RestController
@RequestMapping("/api/v1/sensors")
@RequiredArgsConstructor
public class SensorController {
    
    private final SensorService sensorService;
    
    @PostMapping("/data")
    public ResponseEntity<SensorDataResponseDTO> receiveSensorData(
            @RequestHeader("x-api-key") String apiKey,
            @RequestBody @Valid SensorDataRequestDTO request) {
        
        // Validate API Key
        if (!apiKeyService.isValid(apiKey)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        // Process and save
        SensorDataResponseDTO response = sensorService.saveSensorData(request);
        return ResponseEntity.ok(response);
    }
}
```

### 2.4. Service Layer
```java
@Service
@RequiredArgsConstructor
@Transactional
public class SensorService {
    
    private final SensorDataRepository repository;
    private final SensorDataMapper mapper;
    
    public SensorDataResponseDTO saveSensorData(SensorDataRequestDTO request) {
        // Validate data
        validateSensorData(request);
        
        // Map DTO to Entity
        SensorDataEntity entity = mapper.toEntity(request);
        
        // Save to database
        SensorDataEntity saved = repository.save(entity);
        
        // Map Entity to Response DTO
        return mapper.toResponseDTO(saved);
    }
    
    private void validateSensorData(SensorDataRequestDTO request) {
        if (request.getTemperature() < -50 || request.getTemperature() > 100) {
            throw new InvalidSensorDataException("Temperature out of range");
        }
        // More validations...
    }
}
```

---

## 3. Phương Pháp 2: Serial Gateway (Arduino UNO)

### 3.1. Kiến Trúc
```
Arduino UNO → Serial/USB → Gateway Service (Java) → Spring Cloud Gateway → Sensor Service → Database
```

### 3.2. Arduino Code (UNO)
```cpp
#include <ArduinoJson.h>

void setup() {
  Serial.begin(9600);
}

void loop() {
  // Đọc sensor
  float temp = readTemperature();
  float humidity = readHumidity();
  
  // Tạo JSON
  JsonDocument doc;
  doc["sensorId"] = 1;
  doc["time"] = millis() / 1000; // Seconds since boot
  doc["temperature"] = temp;
  doc["humidity"] = humidity;
  
  // Gửi qua Serial
  serializeJson(doc, Serial);
  Serial.println(); // Newline để gateway đọc
  
  delay(5000);
}
```

### 3.3. Gateway Service (Spring Boot)
```java
@Component
@RequiredArgsConstructor
@Slf4j
public class SerialGatewayService {
    
    private final SensorApiClient sensorApiClient;
    private SerialPort serialPort;
    
    @PostConstruct
    public void init() {
        // Kết nối Serial Port
        serialPort = SerialPort.getCommPort("COM4"); // Windows
        serialPort.setBaudRate(9600);
        serialPort.setComPortTimeouts(
            SerialPort.TIMEOUT_READ_SEMI_BLOCKING, 0, 0);
        
        if (serialPort.openPort()) {
            log.info("Serial port opened successfully");
            startReading();
        }
    }
    
    private void startReading() {
        CompletableFuture.runAsync(() -> {
            try (Scanner scanner = new Scanner(serialPort.getInputStream())) {
                while (scanner.hasNextLine()) {
                    String line = scanner.nextLine();
                    processSerialData(line);
                }
            } catch (Exception e) {
                log.error("Error reading serial data", e);
            }
        });
    }
    
    private void processSerialData(String jsonLine) {
        try {
            // Parse JSON từ Arduino
            ObjectMapper mapper = new ObjectMapper();
            SensorDataRequestDTO request = mapper.readValue(
                jsonLine, SensorDataRequestDTO.class);
            
            // Gửi đến API Gateway
            sensorApiClient.sendSensorData(request);
            
        } catch (Exception e) {
            log.error("Error processing serial data: {}", jsonLine, e);
        }
    }
}
```

**Lưu ý**: Cần thư viện `jSerialComm` hoặc `RXTX` cho Java Serial communication.

---

## 4. Phương Pháp 3: Message Queue (RabbitMQ/Kafka)

### 4.1. Kiến Trúc
```
Arduino → API Gateway → Sensor Service → RabbitMQ → Data Processing Service → Database
```

### 4.2. Ưu Điểm
- **Decoupling**: Services không phụ thuộc trực tiếp
- **Reliability**: Message persistence, retry mechanism
- **Scalability**: Xử lý nhiều device đồng thời
- **Buffering**: Lưu message khi service tạm thời down

### 4.3. Implementation
```java
@Service
@RequiredArgsConstructor
public class SensorDataProducer {
    
    private final RabbitTemplate rabbitTemplate;
    
    public void publishSensorData(SensorDataRequestDTO data) {
        rabbitTemplate.convertAndSend(
            "sensor.exchange",
            "sensor.data.routing.key",
            data
        );
    }
}

@Service
@RequiredArgsConstructor
@RabbitListener(queues = "sensor.data.queue")
public class SensorDataConsumer {
    
    private final SensorDataRepository repository;
    
    @RabbitHandler
    public void handleSensorData(SensorDataRequestDTO request) {
        // Process and save to database
        SensorDataEntity entity = mapper.toEntity(request);
        repository.save(entity);
    }
}
```

---

## 5. Database Schema Design

### 5.1. Entity Design (JPA)
```java
@Entity
@Table(name = "sensor_data")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SensorDataEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sensor_id", nullable = false)
    private SensorEntity sensor;
    
    @Column(name = "value", nullable = false)
    private Double value;
    
    @Column(name = "time", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private LocalDateTime time;
    
    @Column(name = "created_at")
    @CreationTimestamp
    private LocalDateTime createdAt;
}
```

### 5.2. Repository với Pagination
```java
@Repository
public interface SensorDataRepository extends JpaRepository<SensorDataEntity, Long> {
    
    @Query("SELECT sd FROM SensorDataEntity sd " +
           "WHERE sd.sensor.id = :sensorId " +
           "ORDER BY sd.time DESC")
    Page<SensorDataEntity> findBySensorId(
        @Param("sensorId") Long sensorId,
        Pageable pageable
    );
    
    @Query("SELECT sd FROM SensorDataEntity sd " +
           "WHERE sd.sensor.id = :sensorId " +
           "AND sd.time BETWEEN :startTime AND :endTime")
    List<SensorDataEntity> findBySensorIdAndTimeRange(
        @Param("sensorId") Long sensorId,
        @Param("startTime") LocalDateTime startTime,
        @Param("endTime") LocalDateTime endTime
    );
}
```

---

## 6. Security & Best Practices

### 6.1. API Key Authentication
```java
@Component
@RequiredArgsConstructor
public class ApiKeyValidator {
    
    private final ApiKeyRepository apiKeyRepository;
    
    public boolean isValid(String apiKey) {
        return apiKeyRepository.findByKeyAndActiveTrue(apiKey)
            .isPresent();
    }
}

@Configuration
public class SecurityConfig {
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/v1/sensors/**")
                    .hasRole("DEVICE")
                .anyRequest().authenticated()
            )
            .addFilterBefore(
                new ApiKeyAuthenticationFilter(),
                UsernamePasswordAuthenticationFilter.class
            );
        return http.build();
    }
}
```

### 6.2. Rate Limiting
```java
@Component
public class RateLimitingService {
    
    private final RedisTemplate<String, String> redisTemplate;
    
    public boolean isAllowed(String deviceId) {
        String key = "rate_limit:" + deviceId;
        String count = redisTemplate.opsForValue().get(key);
        
        if (count == null) {
            redisTemplate.opsForValue().set(key, "1", 60, TimeUnit.SECONDS);
            return true;
        }
        
        int currentCount = Integer.parseInt(count);
        if (currentCount >= 100) { // 100 requests per minute
            return false;
        }
        
        redisTemplate.opsForValue().increment(key);
        return true;
    }
}
```

### 6.3. Data Validation
```java
@Getter
@Setter
public class SensorDataRequestDTO {
    
    @NotNull(message = "Sensor ID is required")
    @Min(value = 1, message = "Sensor ID must be positive")
    private Long sensorId;
    
    @NotNull(message = "Time is required")
    private Long time; // Unix timestamp
    
    @DecimalMin(value = "-50.0", message = "Temperature too low")
    @DecimalMax(value = "100.0", message = "Temperature too high")
    private Double temperature;
    
    @DecimalMin(value = "0.0", message = "Humidity cannot be negative")
    @DecimalMax(value = "100.0", message = "Humidity cannot exceed 100%")
    private Double humidity;
    
    @DecimalMin(value = "0.0")
    @DecimalMax(value = "100.0")
    private Double soilPct;
    
    @DecimalMin(value = "0.0")
    @DecimalMax(value = "100.0")
    private Double light;
}
```

---

## 7. Error Handling & Retry Mechanism

### 7.1. Circuit Breaker Pattern
```java
@Service
@RequiredArgsConstructor
public class SensorDataService {
    
    private final SensorDataRepository repository;
    private final CircuitBreaker circuitBreaker;
    
    @Retryable(value = {DataAccessException.class}, maxAttempts = 3)
    public SensorDataResponseDTO saveSensorData(SensorDataRequestDTO request) {
        return circuitBreaker.executeSupplier(() -> {
            try {
                SensorDataEntity entity = mapper.toEntity(request);
                SensorDataEntity saved = repository.save(entity);
                return mapper.toResponseDTO(saved);
            } catch (Exception e) {
                log.error("Error saving sensor data", e);
                throw new SensorDataSaveException("Failed to save sensor data", e);
            }
        });
    }
}
```

### 7.2. Dead Letter Queue (DLQ)
```java
@RabbitListener(queues = "sensor.data.dlq")
public class DeadLetterHandler {
    
    @RabbitHandler
    public void handleFailedMessage(SensorDataRequestDTO request) {
        // Log failed message
        // Store in separate table for manual review
        // Send alert to admin
    }
}
```

---

## 8. Monitoring & Observability

### 8.1. Actuator Endpoints
```yaml
# application.yml
management:
  endpoints:
    web:
      exposure:
        include: health,metrics,prometheus
  metrics:
    export:
      prometheus:
        enabled: true
```

### 8.2. Custom Metrics
```java
@Component
@RequiredArgsConstructor
public class SensorMetrics {
    
    private final MeterRegistry meterRegistry;
    private Counter sensorDataReceived;
    private Timer sensorDataProcessingTime;
    
    @PostConstruct
    public void init() {
        sensorDataReceived = Counter.builder("sensor.data.received")
            .description("Total sensor data received")
            .register(meterRegistry);
        
        sensorDataProcessingTime = Timer.builder("sensor.data.processing.time")
            .description("Time to process sensor data")
            .register(meterRegistry);
    }
    
    public void recordSensorData() {
        sensorDataReceived.increment();
    }
    
    public void recordProcessingTime(Duration duration) {
        sensorDataProcessingTime.record(duration);
    }
}
```

---

## 9. So Sánh Các Phương Pháp

| Phương Pháp | Độ Phức Tạp | Latency | Reliability | Scalability | Use Case |
|------------|-------------|---------|-------------|-------------|----------|
| HTTP REST | Thấp | Thấp | Trung bình | Trung bình | ESP32, số lượng device ít |
| Serial Gateway | Trung bình | Thấp | Trung bình | Thấp | Arduino UNO, local network |
| Message Queue | Cao | Trung bình | Cao | Cao | Production, nhiều device, high throughput |

---

## 10. Khuyến Nghị

### 10.1. Cho ESP32 (Có WiFi)
- **Sử dụng**: HTTP REST API trực tiếp
- **Gateway**: Spring Cloud Gateway với JWT/API Key
- **Service**: Sensor Service microservice
- **Database**: PostgreSQL với JPA

### 10.2. Cho Arduino UNO (Không WiFi)
- **Sử dụng**: Serial Gateway Service
- **Gateway**: Java service đọc Serial, forward đến API
- **Service**: Sensor Service microservice
- **Database**: PostgreSQL với JPA

### 10.3. Cho Production Scale
- **Sử dụng**: Message Queue (RabbitMQ/Kafka)
- **Gateway**: Spring Cloud Gateway
- **Services**: Sensor Service → Queue → Data Processing Service
- **Database**: PostgreSQL với connection pooling
- **Monitoring**: Prometheus + Grafana
- **Tracing**: Spring Cloud Sleuth + Zipkin

---

## 11. Checklist Implementation

- [ ] Setup Spring Cloud Gateway với routing rules
- [ ] Implement Sensor Service với REST API
- [ ] Setup Database schema với Flyway migration
- [ ] Implement Entity, DTO, Mapper (MapStruct)
- [ ] Setup Spring Security với API Key authentication
- [ ] Implement rate limiting
- [ ] Setup Circuit Breaker (Resilience4j)
- [ ] Implement error handling & retry
- [ ] Setup monitoring (Actuator, Prometheus)
- [ ] Implement logging (centralized logging)
- [ ] Write unit tests (JUnit 5, Mockito)
- [ ] Write integration tests (TestContainers)
- [ ] Setup Docker containerization
- [ ] Setup CI/CD pipeline

---

## 12. Tài Liệu Tham Khảo

- Spring Cloud Gateway: https://spring.io/projects/spring-cloud-gateway
- Spring Data JPA: https://spring.io/projects/spring-data-jpa
- MapStruct: https://mapstruct.org/
- RabbitMQ Spring: https://spring.io/guides/gs/messaging-rabbitmq/
- Spring Cloud Circuit Breaker: https://spring.io/projects/spring-cloud-circuitbreaker


