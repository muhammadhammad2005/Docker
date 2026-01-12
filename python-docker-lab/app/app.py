from flask import Flask, render_template, request, jsonify
import os
import psycopg2
from psycopg2.extras import RealDictCursor
from datetime import datetime
import time

app = Flask(__name__)

# Database configuration
DB_CONFIG = {
    "host": os.getenv("DB_HOST", "postgres-db"),
    "database": os.getenv("DB_NAME", "flaskapp"),
    "user": os.getenv("DB_USER", "flaskuser"),
    "password": os.getenv("DB_PASSWORD", "flaskpass"),
    "port": os.getenv("DB_PORT", "5432"),
}

def get_db_connection():
    return psycopg2.connect(**DB_CONFIG)

def wait_for_db():
    for i in range(30):
        try:
            conn = get_db_connection()
            conn.close()
            print("Database connected")
            return True
        except psycopg2.OperationalError:
            print(f"Waiting for database ({i+1}/30)")
            time.sleep(2)
    return False

def init_db():
    if not wait_for_db():
        print("Database not available, continuing without init")
        return

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS visitors (
            id SERIAL PRIMARY KEY,
            name VARCHAR(255) NOT NULL,
            visit_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    """)
    conn.commit()
    conn.close()

def add_visitor(name):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO visitors (name) VALUES (%s)", (name,))
    conn.commit()
    conn.close()

def get_visitors():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute("""
        SELECT name, visit_time
        FROM visitors
        ORDER BY visit_time DESC
        LIMIT 10
    """)
    visitors = cursor.fetchall()
    conn.close()
    return visitors

@app.route("/")
def home():
    try:
        visitors = get_visitors()
        return render_template("index.html", visitors=visitors)
    except Exception as e:
        return f"Database error: {e}", 500

@app.route("/add_visitor", methods=["POST"])
def add_visitor_route():
    name = request.form.get("name")
    if not name:
        return jsonify({"status": "error", "message": "Name is required"})

    try:
        add_visitor(name)
        return jsonify({"status": "success", "message": f"Welcome {name}!"})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

@app.route("/health")
def health_check():
    try:
        conn = get_db_connection()
        conn.close()
        return jsonify({
            "status": "healthy",
            "database": "connected",
            "timestamp": datetime.utcnow().isoformat()
        })
    except Exception as e:
        return jsonify({
            "status": "unhealthy",
            "database": "disconnected",
            "error": str(e)
        }), 500

if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=5000)

