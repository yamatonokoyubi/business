from flask import Flask, render_template
import pymysql
app = Flask(__name__)

def get_db_connection():
    connection = pymysql.connect(
        host='db',
        user='business',
        password='Passw0rd',
        db='business_db',
        cursorclass=pymysql.cursors.DictCursor,
        charset='utf8mb4',
        use_unicode=True,
        init_command='SET NAMES utf8mb4',
        connect_timeout=5
    )
    return connection

# トップページ
@app.route('/')
def index():
    return render_template('index.html')

# 社員一覧
@app.route('/members')
def members():
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM members")
            members = cursor.fetchall()
    finally:
        connection.close()
    return render_template('members.html', members=members)

# 顧客一覧
@app.route('/customers')
def customers():
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM customers")
            customers = cursor.fetchall()
    finally:
        connection.close()
    return render_template('customers.html', customers=customers)

# 製品一覧
@app.route('/products')
def products():
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM products")
            products = cursor.fetchall()
    finally:
        connection.close()
    return render_template('products.html', products=products)

# 販売一覧
@app.route('/sales')
def sales():
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT s.id, s.date, m.name AS member_name, c.name AS customer_name, p.name AS product_name, s.quantity, s.total_price, s.status
                FROM sales s
                JOIN members m ON s.member_id = m.id
                JOIN customers c ON s.customer_id = c.id
                JOIN products p ON s.product_id = p.id
            """)
            sales = cursor.fetchall()
    finally:
        connection.close()
    return render_template('sales.html', sales=sales)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)