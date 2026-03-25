CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    author VARCHAR(255),
    category VARCHAR(100),
    publish_year INT,
    price INT,
    stock INT
);

INSERT INTO books (id, title, author, category, publish_year, price, stock) VALUES
    (1, 'Lập trình C cơ bản', 'Nguyễn Văn Nam', 'CNTT', 2018, 95000, 20),
    (2, 'Học SQL qua ví dụ', 'Trần Thị Hạnh', 'CSDL', 2020, 125000, 12),
    (3, 'Lập trình C cơ bản', 'Nguyễn Văn Nam', 'CNTT', 2018, 95000, 20),
    (4, 'Phân tích dữ liệu với Python', 'Lê Quốc Bảo', 'CNTT', 2022, 180000, NULL),
    (5, 'Quản trị cơ sở dữ liệu', 'Nguyễn Thị Minh', 'CSDL', 2021, 150000, 5),
    (6, 'Học máy cho người mới bắt đầu', 'Nguyễn Văn Nam', 'AI', 2023, 220000, 8),
    (7, 'Khoa học dữ liệu cơ bản', 'Nguyễn Văn Nam', 'AI', 2023, 220000, NULL);

--Xóa các bản ghi trùng lặp hoàn toàn về title, author và publish_year
DELETE FROM books
WHERE id NOT IN (
    SELECT MIN(id)
    FROM books
    GROUP BY title, author, publish_year
);

--Tăng giá 10% cho những sách xuất bản từ năm 2021 trở đi và có price < 200000
UPDATE books
SET price = price * 1.10
WHERE publish_year >= 2021
  AND price < 200000;

--Với những sách có stock IS NULL, cập nhật stock = 0
UPDATE books
SET stock = 0
WHERE stock IS NULL;

select * FROM books;
--Truy vấn nâng cao:
--Liệt kê danh sách sách thuộc chủ đề CNTT hoặc AI có giá trong khoảng 100000 - 250000

select *
FROM books
WHERE category IN ('CNTT','AI')
AND price BETWEEN 100000 AND 250000
--Sắp xếp giảm dần theo price, rồi tăng dần theo title
ORDER BY price DESC , title ASC;

--Tìm kiếm tự do:
--Tìm các sách có tiêu đề chứa từ “học” (không phân biệt hoa thường)
--Gợi ý: dùng ILIKE '%học%'
SELECT *
FROM books
WHERE title ILIKE '%học%';

--Thống kê chuyên mục:
--Liệt kê các thể loại duy nhất (DISTINCT) có ít nhất một cuốn sách xuất bản sau năm 2020
SELECT DISTINCT category
FROM books
WHERE publish_year > 2020;

--Phân trang kết quả:
--Chỉ hiển thị 2 kết quả đầu tiên, bỏ qua 1 kết quả đầu tiên (dùng LIMIT + OFFSET)
SELECT *
FROM books
LIMIT 2 OFFSET 1;

