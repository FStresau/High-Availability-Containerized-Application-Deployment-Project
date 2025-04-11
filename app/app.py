from flask import Flask, jsonify
import psycopg2
from psycopg2 import sql

app = Flask(__name__)

# Database connection parameters
DB_HOST = 'db'  # This is the name of the service in the docker-compose.yml file
DB_NAME = 'flaskdb'
DB_USER = 'flaskuser'
DB_PASSWORD = 'flaskpass'

# Function to connect to the PostgreSQL database
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
    # Test database connection by querying data
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT message FROM messages LIMIT 1;')
    message = cursor.fetchone()
    conn.close()

    if message:
        return jsonify({"message": message[0]})
    else:
        return jsonify({"message": "No message found in database!"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)

