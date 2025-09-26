import os
import logging
import pymysql
from dotenv import load_dotenv
from twilio.rest import Client

# -------------------------
# 환경 설정 (.env 파일 로드)
# -------------------------
load_dotenv()

TWILIO_ACCOUNT_SID = os.getenv("TWILIO_ACCOUNT_SID")
TWILIO_AUTH_TOKEN = os.getenv("TWILIO_AUTH_TOKEN")
TWILIO_FROM_NUMBER = os.getenv("TWILIO_FROM_NUMBER")

# Twilio client 초기화
twilio_client = Client(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)

# 로깅 설정
logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")

# DB 환경 변수 불러오기
DB_HOST = os.getenv("DB_HOST")
DB_PORT = int(os.getenv("DB_PORT", 3306))
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_NAME = os.getenv("DB_NAME")

def get_connection():
    return pymysql.connect(
        host=DB_HOST,
        port=DB_PORT,
        user=DB_USER,
        password=DB_PASSWORD,
        db=DB_NAME,
        charset="utf8mb4",
        cursorclass=pymysql.cursors.DictCursor
    )

# -------------------------
# 전화번호를 국제 포맷으로 변환 (010 → +82)
# -------------------------
def normalize_phone(phone: str) -> str:
    if phone.startswith("0"):
        return "+82" + phone[1:]
    return phone

# -------------------------
# SMS 전송 함수 (중앙 서버가 직접 호출)
# -------------------------
def send_sms(user_id: str, phone: str, title: str, url: str, deal_id: int):
    if not (user_id and phone and title and deal_id):
        raise ValueError("userId, phone, title, dealId are required")

    try:
        deal_id = int(deal_id)
    except ValueError:
        raise ValueError("dealId must be an integer")

    to_number = normalize_phone(phone)
    body = (f"[dealarm 알림]\n"
            f"[{user_id}님 키워드 알림]\n"
            f"제품명: {title}\n"
            f"제품링크: {url}")

    try:
        # Twilio 전송
        message = twilio_client.messages.create(
            to=to_number,
            from_=TWILIO_FROM_NUMBER,
            body=body
        )
        logging.info(f"✅ SMS 전송 성공: user={user_id}, dealId={deal_id}, to={to_number}, sid={message.sid}")

        # DB 기록
        conn = get_connection()
        with conn.cursor() as cursor:
            sql = """
                INSERT INTO deal_match (user_id, deal_id)
                VALUES (%s, %s)
                ON DUPLICATE KEY UPDATE matched_at = CURRENT_TIMESTAMP
            """
            cursor.execute(sql, (user_id, deal_id))
            conn.commit()
        conn.close()

        return {"result": "sent", "sid": message.sid}

    except Exception as e:
        logging.exception("❌ SMS 전송 실패")
        return {"error": str(e)}
