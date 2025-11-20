# 📦 Dependencies & Requirements - SmartFarm

Danh sách đầy đủ các thư viện, framework và công cụ cần thiết cho SmartFarm System.

---

## 📋 Mục lục

- [System Requirements](#-system-requirements)
- [Backend Dependencies](#-backend-dependencies)
- [Frontend Dependencies](#-frontend-dependencies)
- [AI Chatbot Dependencies](#-ai-chatbot-dependencies)
- [ML Services Dependencies](#-ml-services-dependencies)
- [IoT & Blockchain Dependencies](#-iot--blockchain-dependencies)
- [Development Tools](#-development-tools)

---

## 💻 System Requirements

### Operating System
- **Windows**: 10/11 (64-bit)
- **Linux**: Ubuntu 20.04+, Debian 11+, CentOS 8+
- **macOS**: 12+ (Monterey+)

### Hardware
- **CPU**: 4 cores+ (2 cores minimum)
- **RAM**: 8GB+ (4GB minimum)
- **Storage**: 20GB+ free space
- **Network**: Internet connection for dependencies

---

## ☕ Backend Dependencies (Spring Boot)

### Core Framework
| Dependency | Version | Purpose |
|------------|---------|---------|
| Spring Boot | 3.4.4 | Main framework |
| Spring Boot Starter Web | 3.4.4 | Web MVC |
| Spring Boot Starter Data JPA | 3.3.3 | Database access |
| Spring Boot Starter Security | 3.4.4 | Authentication |
| Spring Boot Starter WebSocket | 3.4.4 | Real-time updates |

### Database
| Dependency | Version | Purpose |
|------------|---------|---------|
| PostgreSQL Driver | Latest | Database connector |
| HikariCP | (Included) | Connection pooling |

### Security & Authentication
| Dependency | Version | Purpose |
|------------|---------|---------|
| jjwt-api | 0.11.5 | JWT token creation |
| jjwt-impl | 0.11.5 | JWT implementation |
| jjwt-jackson | 0.11.5 | JWT JSON processing |
| Spring Security Core | 6.5.1 | Security framework |
| Spring Security Crypto | (Included) | Password encryption |

### Email
| Dependency | Version | Purpose |
|------------|---------|---------|
| Spring Boot Starter Mail | (Included) | Email sending |
| Thymeleaf | (Included) | Email templates |

### Testing
| Dependency | Version | Purpose |
|------------|---------|---------|
| Spring Boot Starter Test | 3.4.4 | Testing framework |
| JUnit | (Included) | Unit testing |

### Build Tool
- **Maven**: 3.8+
- **Java**: JDK 17+

**File:** `demoSmartFarm/demo/pom.xml`

---

## ⚛️ Frontend Dependencies (React)

### Core Framework
| Package | Version | Purpose |
|---------|---------|---------|
| react | 18.2.0 | UI library |
| react-dom | 18.2.0 | DOM rendering |
| react-router-dom | 6.22.1 | Routing |

### UI Components
| Package | Version | Purpose |
|---------|---------|---------|
| @mui/material | 5.17.1 | Material-UI components |
| @mui/icons-material | 5.17.1 | Material icons |
| @mui/x-date-pickers | 8.3.1 | Date pickers |
| @emotion/react | 11.14.0 | CSS-in-JS |
| @emotion/styled | 11.14.0 | Styled components |

### Data Visualization
| Package | Version | Purpose |
|---------|---------|---------|
| chart.js | 4.4.9 | Chart library |
| react-chartjs-2 | 5.3.0 | React wrapper for Chart.js |
| recharts | 2.15.3 | Alternative chart library |
| react-gauge-chart | 0.5.1 | Gauge charts |

### HTTP Client
| Package | Version | Purpose |
|---------|---------|---------|
| axios | 1.6.7 | HTTP requests |

### Maps
| Package | Version | Purpose |
|---------|---------|---------|
| @react-google-maps/api | 2.20.6 | Google Maps integration |
| google-map-react | 2.2.1 | Alternative Maps library |

### Utilities
| Package | Version | Purpose |
|---------|---------|---------|
| dayjs | 1.11.13 | Date manipulation |
| jwt-decode | 4.0.0 | JWT token decoding |
| chartjs-adapter-dayjs-4 | 1.0.4 | Chart.js date adapter |

### Build Tools
| Package | Version | Purpose |
|---------|---------|---------|
| react-scripts | 5.0.1 | Create React App scripts |
| @craco/craco | 7.1.0 | Create React App override |

### Testing
| Package | Version | Purpose |
|---------|---------|---------|
| @testing-library/react | 14.2.1 | React testing utilities |
| @testing-library/jest-dom | 6.4.2 | Jest DOM matchers |
| @testing-library/user-event | 14.5.2 | User interaction testing |

**File:** `J2EE_Frontend/package.json`

**Node.js**: 18+  
**npm**: 8+

---

## 🤖 AI Chatbot Dependencies (Next.js)

### Core Framework
| Package | Version | Purpose |
|---------|---------|---------|
| next | 15.3.3 | Next.js framework |
| react | 18.3.1 | React library |
| react-dom | 18.3.1 | React DOM |

### AI Integration
| Package | Version | Purpose |
|---------|---------|---------|
| @genkit-ai/googleai | 1.14.1 | Google AI integration |
| @genkit-ai/next | 1.14.1 | Genkit for Next.js |
| genkit | 1.14.1 | Genkit framework |

### UI Components
| Package | Version | Purpose |
|---------|---------|---------|
| @radix-ui/react-* | Various | Headless UI components |
| tailwindcss | 3.4.1 | CSS framework |
| tailwindcss-animate | 1.0.7 | Tailwind animations |
| lucide-react | 0.475.0 | Icons |

### Form Handling
| Package | Version | Purpose |
|---------|---------|---------|
| react-hook-form | 7.54.2 | Form management |
| @hookform/resolvers | 4.1.3 | Form validation |
| zod | 3.24.2 | Schema validation |

### Markdown & Content
| Package | Version | Purpose |
|---------|---------|---------|
| react-markdown | 10.1.0 | Markdown rendering |
| react-syntax-highlighter | 15.6.6 | Code highlighting |
| remark-gfm | 4.0.1 | GitHub Flavored Markdown |
| rehype-highlight | 7.0.2 | Syntax highlighting |
| rehype-raw | 7.0.0 | Raw HTML support |

### Data Processing
| Package | Version | Purpose |
|---------|---------|---------|
| xlsx | 0.18.5 | Excel file processing |

### Utilities
| Package | Version | Purpose |
|---------|---------|---------|
| date-fns | 3.6.0 | Date utilities |
| clsx | 2.1.1 | Class name utility |
| tailwind-merge | 3.0.1 | Tailwind class merging |
| class-variance-authority | 0.7.1 | Component variants |

### Development
| Package | Version | Purpose |
|---------|---------|---------|
| typescript | 5 | TypeScript compiler |
| genkit-cli | 1.14.1 | Genkit CLI tools |

**File:** `AI_SmartFarm_CHatbot/package.json`

**Node.js**: 18+  
**npm**: 8+

---

## 🐍 ML Services Dependencies

### Crop Recommendation Service

**File:** `RecommentCrop/requirements.txt`

| Package | Version | Purpose |
|---------|---------|---------|
| flask | 3.0.0 | Web framework |
| flask-cors | 4.0.0 | CORS handling |
| numpy | 1.24.3 | Numerical computing |
| scikit-learn | 0.24.2 | Machine Learning |
| joblib | 1.0.1 | Model serialization |

**Python**: 3.10+  
**Model File**: `RandomForest_RecomentTree.pkl` (2.3MB)

### Pest Detection Service

**File:** `PestAndDisease/requirements.txt`

| Package | Version | Purpose |
|---------|---------|---------|
| flask | 2.3.3 | Web framework |
| flask-cors | 4.0.0 | CORS handling |
| torch | 2.0.1 | PyTorch framework |
| torchvision | 0.15.2 | Computer vision |
| timm | 0.9.7 | Vision models |
| pillow | 10.0.0 | Image processing |
| numpy | 1.24.3 | Numerical computing |

**Python**: 3.10+  
**Model File**: `best_vit_wheat_model_4classes.pth` (343MB)

**Lưu ý:** PyTorch cần ~2-3GB disk space

---

## 🔗 IoT & Blockchain Dependencies

### Flask API Service

**File:** `SmartContract/flask-api/requirements.txt`

| Package | Version | Purpose |
|---------|---------|---------|
| Flask | 3.0.2 | Web framework |
| SQLAlchemy | 2.0.30 | ORM |
| psycopg2-binary | 2.9.9 | PostgreSQL driver |
| eth-utils | 2.3.1 | Ethereum utilities |
| eth-hash[pycryptodome] | Latest | Keccak hashing |
| python-dotenv | 1.0.1 | Environment variables |
| requests | 2.32.3 | HTTP client |

### Device Forwarder

**File:** `SmartContract/device/` (Manual install)

| Package | Version | Purpose |
|---------|---------|---------|
| pyserial | Latest | Serial communication |
| requests | Latest | HTTP client |

### Oracle Node

**File:** `SmartContract/oracle-node/package.json`

| Package | Version | Purpose |
|---------|---------|---------|
| express | Latest | Web server |
| web3 | Latest | Blockchain interaction |

---

## 🗄️ Database

### PostgreSQL

| Component | Version | Purpose |
|-----------|---------|---------|
| PostgreSQL | 15+ | Relational database |
| PostgreSQL Client | 15+ | Database client tools |

**Schema Files:**
- `DB_SM_ver1.sql` - Main schema
- `add_alert_columns.sql` - Migration script

---

## 🐳 Docker & Containerization

### Docker Components

| Component | Version | Purpose |
|-----------|---------|---------|
| Docker | 20.10+ | Container runtime |
| Docker Compose | 2.0+ | Multi-container orchestration |

### Base Images

| Service | Base Image | Purpose |
|---------|------------|---------|
| Backend | `openjdk:17-jdk-slim` | Java runtime |
| Frontend | `nginx:alpine` | Web server |
| Chatbot | `node:18-alpine` | Node.js runtime |
| Crop ML | `python:3.10-slim` | Python runtime |
| Pest ML | `python:3.10-slim` | Python runtime |
| Database | `postgres:15-alpine` | PostgreSQL |

---

## 🛠️ Development Tools

### Required Tools

| Tool | Version | Purpose |
|------|---------|---------|
| Git | Latest | Version control |
| IDE | - | Code editor (VS Code, IntelliJ, etc.) |
| Postman/Insomnia | Latest | API testing |
| Docker Desktop | Latest | Container management |

### Optional Tools

| Tool | Purpose |
|------|---------|
| pgAdmin | PostgreSQL GUI |
| DBeaver | Database management |
| MongoDB Compass | (If using MongoDB) |

---

## 📊 Dependency Summary

### Total Dependencies

| Category | Count | Total Size (approx.) |
|----------|-------|----------------------|
| Backend (Java) | ~30 | ~200MB |
| Frontend (Node.js) | ~50 | ~300MB |
| Chatbot (Node.js) | ~40 | ~400MB |
| Crop ML (Python) | 5 | ~500MB |
| Pest ML (Python) | 7 | ~3GB (PyTorch) |
| IoT (Python) | 7 | ~100MB |

### Disk Space Requirements

- **Development**: ~5GB
- **Production (Docker)**: ~8GB
- **With ML Models**: ~12GB

---

## 🔄 Update Dependencies

### Backend (Maven)
```bash
cd demoSmartFarm/demo
mvn versions:display-dependency-updates
mvn versions:use-latest-versions
```

### Frontend (npm)
```bash
cd J2EE_Frontend
npm outdated
npm update
```

### Python Services
```bash
cd RecommentCrop  # hoặc PestAndDisease
pip list --outdated
pip install --upgrade package-name
```

---

## 📝 Version Pinning

### Why Pin Versions?

- **Stability**: Đảm bảo môi trường nhất quán
- **Reproducibility**: Có thể rebuild chính xác
- **Security**: Kiểm soát được versions có lỗ hổng

### Current Strategy

- **Major versions**: Pinned (3.4.4, 18.2.0, etc.)
- **Minor versions**: Latest in range (^5.17.1)
- **Patch versions**: Auto-update

---

## 🔒 Security Considerations

### Regular Updates

- Kiểm tra security advisories hàng tháng
- Update dependencies có lỗ hổng ngay lập tức
- Sử dụng `npm audit` và `mvn dependency-check`

### Known Issues

- **scikit-learn 0.24.2**: Có warning về pickle version mismatch (không ảnh hưởng chức năng)
- **PyTorch 2.0.1**: Large download size

---

## 📚 Resources

- [Spring Boot Dependencies](https://docs.spring.io/spring-boot/docs/current/reference/html/dependency-versions.html)
- [React Dependencies](https://react.dev/)
- [Next.js Dependencies](https://nextjs.org/docs)
- [Python Package Index](https://pypi.org/)

---

**Cập nhật lần cuối:** 2025-11-20

