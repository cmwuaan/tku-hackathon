# 🔊 SOUND WATCHER

> **AI-Powered Real-Time Sound Detection & Alert System**  
> Protecting lives through intelligent audio monitoring

[![License: ISC](https://img.shields.io/badge/License-ISC-blue.svg)](https://opensource.org/licenses/ISC)
[![Python 3.11+](https://img.shields.io/badge/Python-3.11+-blue.svg)](https://www.python.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.8+-blue.svg)](https://www.typescriptlang.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.104+-green.svg)](https://fastapi.tiangolo.com/)

---

## 📋 Mục lục

- [Vấn đề](#-vấn-đề-pain-point)
- [Giải pháp](#-giải-pháp-solution)
- [Tính năng](#-tính-năng-features)
- [Kiến trúc hệ thống](#-kiến-trúc-hệ-thống-system-architecture)
- [Thông số kỹ thuật](#-thông-số-kỹ-thuật-technical-specifications)
- [Cài đặt](#-cài-đặt-installation)
- [Sử dụng](#-sử-dụng-usage)
- [API Documentation](#-api-documentation)
- [User Journey](#-user-journey)
- [Roadmap](#-roadmap)

---

## 🎯 Vấn đề (Pain Point)

Người khiếm thính, người đeo tai nghe, hoặc người ngủ sâu gặp **nguy hiểm** hoặc **bất tiện** vì không nghe được các âm thanh quan trọng:

- 🚨 **Báo cháy** - Đe dọa tính mạng
- 🚗 **Còi xe** - Nguy hiểm giao thông
- 🚪 **Chuông cửa** - Bỏ lỡ khách quan trọng
- 👶 **Tiếng em bé khóc** - Cần chăm sóc ngay
- 💧 **Nước sôi** - Nguy cơ cháy nổ
- 💥 **Tiếng vỡ, rơi** - Sự cố trong nhà

---

## 💡 Giải pháp (Solution)

**SOUND WATCHER** là ứng dụng Mobile sử dụng **AI Multimodal** để "nghe" môi trường xung quanh **24/7** và chuyển hóa âm thanh thành:

- 📳 **Rung** (Haptic Feedback)
- 💡 **Ánh sáng** (Flash/Torch)
- 📱 **Cảnh báo màn hình** (Visual Alert)

Tất cả hoạt động theo **thời gian thực** với độ trễ < 5 giây.

### 🔄 Luồng hoạt động (Core Flow)

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐     ┌──────────────┐
│   Lắng nghe  │ --> │ Bắt sự kiện  │ --> │  Phân tích  │ --> │   Phản hồi   │
│  (Monitor)   │     │   (Trigger)   │     │     (AI)    │     │   (Alert)    │
└─────────────┘     └──────────────┘     └─────────────┘     └──────────────┘
     ↓                    ↓                    ↓                    ↓
  Đo Decibel         > -25dB              Gửi Base64         Rung + Flash
  liên tục           Ngưỡng kích hoạt      Lên AI Service     + Màn hình đỏ
```

1. **Lắng nghe:** App đo cường độ âm thanh (Decibel) liên tục và phân loại
2. **Bắt sự kiện:** Khi âm thanh > ngưỡng quy định (ví dụ: -20dB)
3. **Phân tích:** Gửi đoạn âm thanh (Base64) lên AI Service
4. **Phản hồi:** AI trả về JSON với:
   - Loại âm thanh (Nguy hiểm/Cảnh báo)
   - Tên âm thanh
   - Độ tin cậy (Confidence)
5. **Cảnh báo:** App thực hiện Rung mạnh + Nháy Flash + Màn hình đỏ (nếu Nguy hiểm)

---

## ✨ Tính năng (Features)

### 🎧 Module Lắng nghe (Listening Module)

- **FR-01: Decibel Trigger**
  - Ghi âm liên tục, lưu **3 giây gần nhất** vào RAM buffer
  - Khi có tiếng động lớn (> 30dB), lấy ngay 3 giây trước + 1 giây tiếp theo
  - Gửi file WAV lên AI Service kèm timestamp

- **FR-02: Visual Waveform**
  - Hiển thị sóng âm thanh real-time trên màn hình chính
  - Người dùng biết Mic đang hoạt động

### 🤖 Module Phân tích AI (AI Processing Module)

- **FR-03: API Classification**
  - Gửi audio (Base64/Blob) lên AI Platform
  - Nhận kết quả JSON với phân loại và độ tin cậy

### 🚨 Module Cảnh báo (Alert Module)

- **FR-04: Cảnh báo Nguy hiểm (DANGER)**
  - Màn hình: Nháy đỏ toàn màn hình + Text "NGUY HIỂM" cực lớn
  - Đèn Flash: Nháy SOS (nhanh-nhanh-nhanh)
  - Rung: Pattern mạnh, kéo dài

- **FR-05: Cảnh báo Thông thường (WARNING/INFO)**
  - Màn hình: Màu vàng/Xanh + Icon loại âm thanh
  - Đèn Flash: Nháy 2 lần
  - Rung: Pattern ngắn (bzz-bzz)

### 📜 Module Lịch sử (History Log)

- **FR-06:** Lưu lại danh sách các sự kiện đã phát hiện
  - Thời gian
  - Loại âm thanh
  - Mức độ nguy hiểm
  - Độ tin cậy

---

## 🏗️ Kiến trúc hệ thống (System Architecture)

```
┌─────────────────────────────────────────────────────────────┐
│                    MOBILE APP (Frontend)                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │ Audio Monitor │  │ Alert System  │  │ History Log  │     │
│  │  (Decibel)    │  │ (Rung/Flash)  │  │   (Local DB) │     │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘     │
│         │                  │                  │              │
│         └──────────────────┼──────────────────┘              │
│                            │                                 │
└────────────────────────────┼─────────────────────────────────┘
                             │
                             │ HTTP/HTTPS
                             │ (Audio Base64)
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                    BACKEND API (Node.js)                    │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │   Controller  │  │   Service    │  │   Database   │     │
│  │  (Express)    │  │  (Business)  │  │  (MongoDB)   │     │
│  └──────┬───────┘  └──────┬───────┘  └───────────────┘     │
│         │                  │                                 │
└─────────┼──────────────────┼─────────────────────────────────┘
          │                  │
          │                  │ HTTP/HTTPS
          │                  │ (Audio File)
          │                  ▼
          │         ┌─────────────────────────────────────────┐
          │         │      AI SERVICE (FastAPI/Python)        │
          │         │  ┌──────────────┐  ┌──────────────┐   │
          │         │  │   Router      │  │   Service    │   │
          │         │  │  (Detection)  │  │  (AI Model)  │   │
          │         │  └──────┬───────┘  └──────┬───────┘   │
          │         │         │                  │            │
          │         │         └──────────────────┘            │
          │         │                  │                      │
          │         │                  ▼                      │
          │         │         ┌──────────────────┐            │
          │         │         │  AI Model API    │            │
          │         │         │  (Multimodal)    │            │
          │         │         └──────────────────┘            │
          │         └─────────────────────────────────────────┘
          │
          └───────────────────┐
                              │
                              ▼
                    ┌──────────────────┐
                    │  Response JSON    │
                    │  {                │
                    │    type: "DANGER" │
                    │    name: "Fire"   │
                    │    confidence: 0.9│
                    │  }                │
                    └──────────────────┘
```

### 📁 Cấu trúc thư mục

```
tku-hackathon/
├── AI_Service/          # FastAPI service cho AI detection
│   ├── app/
│   │   ├── routers/     # API endpoints
│   │   ├── schemas/     # Pydantic models
│   │   └── services/    # Business logic
│   ├── main.py
│   └── requirements.txt
│
├── BE/                  # Backend API (Node.js/Express)
│   ├── src/
│   │   ├── controllers/ # Request handlers
│   │   ├── services/    # Business logic
│   │   ├── routes/      # API routes
│   │   ├── dtos/        # Data Transfer Objects
│   │   └── models/      # Database models
│   └── package.json
│
└── FE/                  # Mobile App (Frontend)
    └── docs/            # Documentation
```

---

## 📊 Thông số kỹ thuật (Technical Specifications)

### Audio Input

| Thông số | Giá trị | Giải thích |
|----------|---------|------------|
| **Trigger Threshold** | `> -25 dB` | Chỉ kích hoạt khi âm thanh đủ lớn, lọc tiếng quạt/gió |
| **Sample Rate** | `16,000 Hz` (Mono) | Chuẩn tối ưu cho AI nhận diện âm thanh, file nhẹ |
| **Chunk Duration** | `3000 ms` (3 giây) | Đủ để chứa trọn vẹn 1 tiếng động (còi, chuông, rơi vỡ) |
| **File Format** | `WAV` → `Base64` | Nén dung lượng xuống ~15KB để gửi API cực nhanh |

### AI Processing

| Thông số | Giá trị | Giải thích |
|----------|---------|------------|
| **Model** | Multimodal AI | Tốc độ phản hồi nhanh nhất, giá rẻ, hiểu Multimodal tốt |
| **Debounce/Cool-down** | `2 - 3 giây` | Thời gian nghỉ sau mỗi lần gửi để tránh spam API |
| **Confidence Threshold** | `> 0.7` (70%) | Chỉ báo khi AI chắc chắn, tránh báo sai (False Positive) |

### Performance

| Thông số | Giá trị | Giải thích |
|----------|---------|------------|
| **Check Interval** | `100 ms` | Tần suất kiểm tra độ ồn (10 lần/giây) |
| **Target Latency** | `< 5 giây` | Tổng thời gian từ lúc "Vỡ ly" → "Rung điện thoại" |

---

## 🎚️ Phân loại mức độ nguy hiểm (Danger Zones)

### ⚪ ZONE 0: BACKGROUND (Nhiễu nền)

- **Mức độ:** `0.0`
- **Định nghĩa:** Tạp âm, tiếng quạt, tiếng xe cộ xa xa, tiếng nói chuyện rầm rì
- **Hành động:** Bỏ qua (Ignore), không làm gì cả

### 🔵 ZONE 1: INFORMATION (Thông tin)

- **Mức độ:** `0.1` - `0.4`
- **Định nghĩa:** Âm thanh sinh hoạt, sự kiện cần biết nhưng không gây hại
- **Hành động của App:**
  - **Màn hình:** Hiện thông báo nhỏ (Toast/Banner) màu Xanh/Trắng
  - **Rung:** Rung nhẹ 1 nhịp (Haptic: Light Impact)
  - **Flash:** TẮT

### 🟡 ZONE 2: CAUTION (Cảnh báo/Cẩn thận)

- **Mức độ:** `0.5` - `0.7`
- **Định nghĩa:** Có nguy cơ gây thương tích nhẹ hoặc cần xử lý ngay để tránh hậu quả
- **Hành động của App:**
  - **Màn hình:** Hiện Modal/Popup màu **VÀNG**
  - **Rung:** Rung dài 2 nhịp (Buzz Buzz)
  - **Flash:** Nháy chậm (Blink... Blink...)

### 🔴 ZONE 3: DANGER (Nguy hiểm tính mạng)

- **Mức độ:** `0.8` - `1.0`
- **Định nghĩa:** Đe dọa trực tiếp đến tính mạng hoặc tài sản lớn. Cần phản ứng tức thì
- **Hành động của App:**
  - **Màn hình:** Chớp nháy màu **ĐỎ** toàn màn hình. Font chữ cực lớn
  - **Rung:** Rung liên hồi, cường độ mạnh nhất (SOS Pattern)
  - **Flash:** Nháy liên tục tốc độ cao (Strobe Light) để đánh thức cả người đang ngủ

---

## 🚀 Cài đặt (Installation)

### Prerequisites

- **Node.js** 18+ (cho Backend)
- **Python** 3.11+ (cho AI Service)
- **MongoDB** (cho database)
- **Docker & Docker Compose** (optional, cho containerized deployment)

### 1. Clone Repository

```bash
git clone https://github.com/cmwuaan/tku-hackathon.git
cd tku-hackathon
```

### 2. Backend Setup (Node.js)

```bash
cd BE
yarn install  # hoặc npm install

# Tạo file .env
cp .env.example .env
# Chỉnh sửa .env với các biến môi trường cần thiết

# Chạy development server
yarn dev
```

### 3. AI Service Setup (Python/FastAPI)

#### Option A: Virtual Environment (Recommended for Development)

**Windows:**
```powershell
cd AI_Service
.\setup_venv.ps1
.\venv\Scripts\Activate.ps1
python main.py
```

**Unix/Linux/Mac:**
```bash
cd AI_Service
chmod +x setup_venv.sh
./setup_venv.sh
source venv/bin/activate
python main.py
```

#### Option B: Docker (Recommended for Production)

```bash
cd AI_Service
docker-compose up --build
```

### 4. Frontend Setup (Mobile App)

```bash
cd FE
# Tùy theo framework (React Native, Flutter, etc.)
# Xem hướng dẫn chi tiết trong thư mục FE/docs/
```

---

## 📖 Sử dụng (Usage)

### API Endpoints

#### AI Service (FastAPI)

- `GET /` - Health check
- `GET /health` - Health check
- `POST /api/v1/detection/detect` - Detect audio from uploaded file
- `GET /api/v1/detection/status` - Get detection service status

**Example Request:**
```bash
curl -X POST "http://localhost:8000/api/v1/detection/detect" \
  -H "Content-Type: multipart/form-data" \
  -F "file=@audio.wav"
```

**Example Response:**
```json
{
  "success": true,
  "message": "Detection completed successfully",
  "data": {
    "detected": true,
    "confidence": 0.95,
    "type": "DANGER",
    "name": "Fire Alarm",
    "details": {
      "filename": "audio.wav",
      "size_bytes": 15360,
      "processing_time_ms": 100
    }
  }
}
```

#### Backend API (Express)

- `POST /api/v1/audio-detection/detect` - Audio detection endpoint
- `GET /api/v1/audio-detection/history` - Get detection history

### Accessing Services

- **AI Service API Docs:** http://localhost:8000/docs (Swagger)
- **Backend API:** http://localhost:3000 (hoặc port được cấu hình)

---

## 🎭 User Journey

### Giai đoạn 1: Onboarding & Thiết lập (Setup)

1. **Hành động:** Mở app Sound Watcher lần đầu
2. **Hệ thống:**
   - Yêu cầu quyền: Microphone, Camera (Flash), Notification
   - UI thông báo ứng dụng đang chạy ngầm
3. **Cảm xúc:** Người dùng thấy an tâm vì biết "tai điện tử" đang hoạt động

### Giai đoạn 2: Tình huống khẩn cấp (The "Fire Alarm" Scenario)

*Mục tiêu: Đảm bảo an toàn tính mạng.*

1. **Bối cảnh:** Đang ngủ say vào ban đêm. Hệ thống báo cháy của chung cư hú còi
2. **Sự kiện:** Còi báo cháy kêu to
3. **Hệ thống (AI Processing):**
   - AI nhận diện: `Type: DANGER`, `Name: Fire Alarm`, `Confidence: 0.95`
4. **Phản hồi của App:**
   - Điện thoại **Rung cực mạnh và liên hồi**
   - **Đèn Flash nháy liên tục** (Strobe light) để đánh thức thị giác trong bóng tối
   - Màn hình chuyển màu **ĐỎ RỰC** với chữ lớn: "BÁO CHÁY! NGUY HIỂM!"
5. **Hành động:** Tỉnh dậy nhờ đèn Flash và độ rung, nhìn màn hình và chạy thoát hiểm
6. **Giá trị:** Cứu mạng sống

### Giai đoạn 3 (Optional): Cá nhân hóa

1. **Vấn đề:** Mới mua một cái ấm đun nước siêu tốc, khi nước sôi nó kêu tiếng "Rít" rất lạ, App chưa nhận ra
2. **Hành động:**
   - Vào mục "Teach My Sound"
   - Chọn "Thêm âm thanh mới" và đặt tên "Ấm nước sôi"
   - App yêu cầu ghi âm tiếng ấm nước đó 3 lần
3. **Hệ thống:** App lưu mẫu âm thanh này vào bộ nhớ (local hoặc profile)
4. **Kết quả:** Lần sau khi đun nước, nước sôi kêu "Rít", App báo đúng tên: "Ấm nước sôi"

---

## 🗺️ Roadmap

### ✅ Phase 1: Core Features (Current)

- [x] Audio monitoring với Decibel trigger
- [x] AI Service integration
- [x] Basic alert system (Rung, Flash, Screen)
- [x] History log

### 🚧 Phase 2: Optimization & Enhancement

- [ ] **Eco Mode / High Performance Mode**
  - Tối ưu pin khi chạy ngầm
  - Chế độ hiệu năng cao cho tình huống khẩn cấp

- [ ] **Smart Watch Integration**
  - Đồng bộ cảnh báo lên đồng hồ thông minh
  - Rung và hiển thị trên màn hình đồng hồ

- [ ] **Advanced Sound Detection**
  - Cải thiện độ chính xác nhận diện âm thanh
  - Hỗ trợ nhiều loại âm thanh hơn

- [ ] **Custom Sound Training**
  - Người dùng có thể dạy app nhận diện âm thanh mới
  - Machine Learning on-device

### 🔮 Phase 3: Advanced Features

- [ ] **Background Notification**
  - Hiển thị thông báo ứng dụng đang hoạt động ngầm trên notification bar
  - Status indicator

- [ ] **Emergency Contact Notification**
  - Gửi cảnh báo cho người thân khi phát hiện nguy hiểm
  - Tích hợp SMS/Email/Phone call

- [ ] **iOS Lock Screen Support**
  - Hiển thị cảnh báo đầy đủ trên màn hình khóa iOS
  - Widget support

---

## 🤝 Contributing

Chúng tôi hoan nghênh mọi đóng góp! Vui lòng:

1. Fork repository
2. Tạo feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Mở Pull Request

---

## 📄 License

This project is licensed under the ISC License.

---

## 👥 Team

**TKU Hackathon Team**

- Backend: Node.js/Express/TypeScript
- AI Service: Python/FastAPI
- Frontend: Mobile App (React Native/Flutter)

---

## 📞 Contact & Support

- **Repository:** [https://github.com/cmwuaan/tku-hackathon](https://github.com/cmwuaan/tku-hackathon)
- **Issues:** [GitHub Issues](https://github.com/cmwuaan/tku-hackathon/issues)

---

## 🙏 Acknowledgments

- FastAPI community
- Express.js community
- AI/ML model providers
- All contributors and testers

---

<div align="center">

**Made with ❤️ for safety and accessibility**

*Protecting lives, one sound at a time* 🔊

</div>

