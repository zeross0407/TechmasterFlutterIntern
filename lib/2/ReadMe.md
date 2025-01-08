# Bài 2:
Hướng giải 1:
Tạo class model là các line đại diện cho các dòng chat, các line chứa thông tin về
Người gửi,màu sắc,giời gian bắt đầu chạy(phục vụ cho ý 4).
Các line chứa các word, các word sẽ được load style dựa trên format của file toml.
Các word chứa các thông tin : text , index_start (phục vụ cho việc load style) , style , highlight.
sử dụng thư viện justaudio để lắng nghe stream và thực hiện các event (chuyển ảnh , highlight)
Luồng hoạt động của chương trình
khi bật lên sẽ chạy hàm prepare() để load và xử lý data từ file toml(load data vào các object cần thiết)
khi chuẩn bị xong dữ liệu , stream audio chạy và lắng nghe, khi đến khoảng thời gian có event xảy ra (chuyển ảnh) thì setstate ảnh theo file toml chỉ định
khi stream chạy , xác định từ nào đang được highlight và truyền lại data cho widget bouble_chat để widget cập nhật giao diện
khi nhấn vào dòng chat , phát âm thanh từ milisecond chỉ định trong file toml.
Hướng giải này xử lý dữ liệu dựa trên từng từ 1, không thích hợp nếu phát sinh những yêu cầu xử lí trên từng chữ 1 

Hướng giải 2 : (xử lý từng chữ - tốn tài nguyên hơn)

các thư viện và luồng thực hiện tương tự hướng 1, nhưng các thuộc tính xử lí trên từng ký tự, hoạt động tốt nếu có thêm các yêu cầu xử lý trên từng kí tự
vd format cho 1 chữ cái 
![Pendulum Simulation](2.gif)