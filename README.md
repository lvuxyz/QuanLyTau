# ShipManagerApp (QuanLyTau)

Ứng dụng quản lý tàu thuyền được phát triển bằng Flutter, giúp người dùng theo dõi và quản lý thông tin tàu một cách hiệu quả.

## Tính năng chính

- Quản lý thông tin tàu
- Theo dõi vị trí tàu
- Quản lý thông tin thuyền viên
- Báo cáo và thống kê
- Giao diện người dùng thân thiện

## Cấu trúc dự án

```
lib/
├── blocs/         # Quản lý state với BLoC pattern
├── config/        # Cấu hình ứng dụng
├── models/        # Các model dữ liệu
├── routes/        # Định tuyến ứng dụng
├── screens/       # Các màn hình chính
├── services/      # Các service xử lý logic
├── utils/         # Các tiện ích và hàm helper
└── widgets/       # Các widget tái sử dụng
```

## Yêu cầu hệ thống

- Flutter SDK: phiên bản mới nhất
- Dart SDK: phiên bản mới nhất
- Android Studio / VS Code với Flutter plugin
- Git

## Cài đặt

1. Clone repository:

```bash
git clone [repository-url]
cd shipmanagerapp
```

2. Cài đặt các dependencies:

```bash
flutter pub get
```

3. Chạy ứng dụng:

```bash
flutter run
```

## Cấu hình môi trường

1. Tạo file `.env` trong thư mục gốc của dự án
2. Thêm các biến môi trường cần thiết:

```
API_URL=your_api_url
API_KEY=your_api_key
```

## Đóng góp

Mọi đóng góp đều được chào đón. Vui lòng tạo pull request hoặc báo cáo lỗi.

## Giấy phép

Dự án này được phân phối dưới giấy phép MIT. Xem file `LICENSE` để biết thêm chi tiết.

## Liên hệ

Nếu bạn có bất kỳ câu hỏi hoặc đề xuất nào, vui lòng liên hệ với chúng tôi.
