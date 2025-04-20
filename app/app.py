from flask import Flask, jsonify
import psycopg2
from psycopg2 import sql

app = Flask(__name__)

# Database connection parameters
DB_HOST = 'db'
DB_NAME = 'flaskdb'
DB_USER = 'flaskuser'
DB_PASSWORD = 'flaskpass'

def get_db_connection():
    conn = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    return conn

@app.route('/')
def home():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT message FROM messages;')
    messages = cursor.fetchall()
    conn.close()

    return jsonify({"messages": [row[0] for row in messages]})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
