import mysql.connector
from dotenv import load_dotenv
import os

load_dotenv()

try:
    db = mysql.connector.connect(
        host=os.getenv("DB_HOST"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        database=os.getenv("DB_NAME"),
        use_pure=True
    )
    print("Connected successfully!")
except Exception as e:
    print("Error:", e)