# Bài 3:

### Hướng giải:
- Làm theo hướng dẫn trên Viblo:
  1. Viết file C++ giải phương trình bậc 2 (chỉnh kiểu dữ liệu để có thể gọi qua cầu nối).
  2. Cấu hình với Android:
     - Tạo file `CMakeLists.txt`, khi build app tạo ra thư viện `.so` cho cầu nối FFI gọi.
     - Khai báo build native trong `build.gradle(app)`.
  3. Cấu hình iOS:
     - Đặt file C++ vào thư mục `Runner.xcworkspace`.
     - Tạo cầu nối (dùng thư viện FFI để gọi đến thư viện `.so`).
  4. Vẽ giao diện theo đề bài yêu cầu.

<p align="center">
  <img src="3.gif" alt="Pendulum Simulation" width="300">
</p>
