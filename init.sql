CREATE DATABASE IF NOT EXISTS business_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE business_db;

-- 社員テーブル
CREATE TABLE IF NOT EXISTS members (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    position VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- 顧客テーブル
CREATE TABLE IF NOT EXISTS customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(200) NOT NULL,
    tel VARCHAR(20) NOT NULL,
    email VARCHAR(100) -- 追加: 顧客のメールアドレス
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- 製品テーブル
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0 -- 追加: 在庫数
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- 販売テーブル
CREATE TABLE IF NOT EXISTS sales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    member_id INT,
    customer_id INT,
    product_id INT,
    quantity INT NOT NULL,
    total_price DECIMAL(10, 2), -- 修正: 総額
    status ENUM('受注済み', '発送済み', 'キャンセル') DEFAULT '受注済み', -- 追加: ステータス
    FOREIGN KEY (member_id) REFERENCES members(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- トリガーを作成して総額を計算
DELIMITER //
CREATE TRIGGER calculate_total_price BEFORE INSERT ON sales
FOR EACH ROW
BEGIN
    DECLARE product_price DECIMAL(10, 2);
    SELECT price INTO product_price FROM products WHERE id = NEW.product_id;
    SET NEW.total_price = product_price * NEW.quantity;
END;
//
DELIMITER ;

-- 社員テーブルにダミーデータを挿入
INSERT INTO members (name, position, email) VALUES
('山田 太郎', '営業部長', 'yamada@example.com'),
('鈴木 花子', '営業課長', 'suzuki@example.com'),
('佐藤 健太', '営業課長', 'sato@example.com'),
('田中 紬', '営業担当', 'tanaka@example.com'),
('清原 翠', '営業担当', 'kiyohara@example.com'),
('佐々木 凛', '営業担当', 'sasaki@example.com'),
('野村 陽葵', 'マーケティング担当', 'nomura@example.com'),
('泊口 芽依', 'マーケティング担当', 'tomariguchi@example.com');

-- 顧客テーブルにダミーデータを挿入
INSERT INTO customers (name, address, tel, email) VALUES
('株式会社東京', '東京都渋谷区', '03-1234-5678', 'info@company-tokyo.com'),
('株式会社大阪', '大阪府大阪市', '06-9876-5432', 'info@company-osaka.com'),
('株式会社福岡', '福岡県福岡市', '092-111-2222', 'info@company-fukuoka.com'),
('有限会社宮崎', '宮崎県宮崎市', '0985-2222-2222', 'info@company-miyazaki.com'),
('合資会社大分', '大分県大分市', '097-536-2222', 'info@company-oita.com');

-- 製品テーブルにダミーデータを挿入
INSERT INTO products (name, price, stock) VALUES
('ノートパソコン', 120000, 50),
('スマートフォン', 110000, 100),
('大型モニター', 100000, 70),
('プロジェクター', 145000, 45),
('カラープリンター', 150000, 50),
('スキャナー', 80000, 120),
('タブレット', 60000, 30);

-- 販売テーブルにダミーデータを挿入
INSERT INTO sales (date, member_id, customer_id, product_id, quantity, status) VALUES
('2025-01-01', 4, 4, 1, 5, '受注済み'),
('2025-01-02', 2, 2, 7, 10, '発送済み'),
('2025-02-03', 1, 2, 2, 8, 'キャンセル'),
('2025-02-03', 2, 3, 6, 8, '発送済み'),
('2025-02-03', 3, 2, 3, 8, 'キャンセル'),
('2025-03-10', 1, 1, 7, 3, '受注済み'),
('2025-03-11', 7, 5, 4, 8, '発送済み'),
('2025-03-12', 3, 2, 3, 8, 'キャンセル'),
('2025-03-15', 6, 1, 5, 3, '受注済み'),
('2025-03-16', 2, 5, 2, 10, '発送済み');