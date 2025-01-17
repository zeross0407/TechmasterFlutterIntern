# Bài 2:

### Hướng giải 1:
- Tạo class model là các line đại diện cho các dòng chat. Các line chứa thông tin:
  - Người gửi.
  - Màu sắc.
  - Giờ bắt đầu chạy (phục vụ cho ý 4).
- Các line chứa các word, và các word sẽ được load style dựa trên format của file TOML.
- Các word chứa các thông tin: 
  - `text`
  - `index_start` (phục vụ cho việc load style)
  - `style`
  - `highlight`.
- Sử dụng thư viện `just_audio` để lắng nghe stream và thực hiện các event (chuyển ảnh, highlight).

#### Luồng hoạt động của chương trình:
1. Khi bật lên, chạy hàm `prepare()` để load và xử lý data từ file TOML (load data vào các object cần thiết).
2. Khi chuẩn bị xong dữ liệu, stream audio chạy và lắng nghe. Khi đến khoảng thời gian có event xảy ra (chuyển ảnh), thì `setState` ảnh theo file TOML chỉ định.
3. Khi stream chạy, xác định từ nào đang được highlight và truyền lại data cho widget `bubble_chat` để widget cập nhật giao diện.
4. Khi nhấn vào dòng chat, phát âm thanh từ millisecond chỉ định trong file TOML.

> **Lưu ý:** Hướng giải này xử lý dữ liệu dựa trên từng từ một, **không thích hợp** nếu phát sinh những yêu cầu xử lý trên từng ký tự.

---

### Hướng giải 2: (xử lý từng chữ - tốn tài nguyên hơn)
- Các thư viện và luồng thực hiện tương tự Hướng giải 1, nhưng các thuộc tính xử lý trên từng ký tự.
- Hoạt động tốt nếu có thêm các yêu cầu xử lý trên từng ký tự. 
  - Ví dụ: Format cho 1 chữ cái.

<p align="center">
  <img src="2.gif" alt="Pendulum Simulation" width="300">
</p>
