import os
import sys
import json
import logging
import base64
import pymysql
from dotenv import load_dotenv
from twilio.rest import Client
from pathlib import Path

logging.basicConfig(level=logging.INFO, stream=sys.stderr, format="%(asctime)s [%(levelname)s] %(message)s")

# ==================================================
# 1) 환경 변수 로드
# ==================================================
dotenv_path = (Path(__file__).resolve().parent / ".env")
load_dotenv("C:/jh/git/dealarm/src/main/resources/python/sms/.env")

logging.info("DEBUG DB_USER = %s", repr(os.getenv("DB_USER")))
logging.info("DEBUG DB_PASSWORD = %s", repr(os.getenv("DB_PASSWORD")))

TWILIO_ACCOUNT_SID = os.getenv("TWILIO_ACCOUNT_SID")
TWILIO_AUTH_TOKEN = os.getenv("TWILIO_AUTH_TOKEN")
TWILIO_FROM_NUMBER = os.getenv("TWILIO_FROM_NUMBER")

twilio_client = Client(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)

# ❌ stdout print 제거 → stderr 로만 남김
logging.info(f"DB_USER={os.getenv('DB_USER')}, DB_PASSWORD={'***' if os.getenv('DB_PASSWORD') else None}")

# ==================================================
# 2) DB 연결
# ==================================================
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

# ==================================================
# 3) 유틸
# ==================================================
def normalize_phone(phone: str) -> str:
    if phone.startswith("0"):
        return "+82" + phone[1:]
    return phone

# ==================================================
# 4) SMS 전송
# ==================================================
def send_sms(user_id: str, phone: str, title: str, url: str, deal_id: int):
    if not (user_id and phone and title and deal_id is not None):
        raise ValueError("userId, phone, title, dealId are required")

    try:
        deal_id = int(deal_id)
    except ValueError:
        raise ValueError("dealId must be an integer")

    to_number = normalize_phone(phone)
    body = (f"[dealarm 알림]\n"
            f"[{user_id}님 키워드 알림]\n"
            f"제품명: {title}\n"
            f"제품링크: {url or ''}")

    try:
        # 1) Twilio 발송
        message = twilio_client.messages.create(
            to=to_number,
            from_=TWILIO_FROM_NUMBER,
            body=body
        )
        logging.info(f"✅ SMS 전송 성공: user={user_id}, dealId={deal_id}, to={to_number}, sid={message.sid}")

        # 2) DB 기록
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

# ==================================================
# 5) 엔트리포인트
# ==================================================
if __name__ == "__main__":
    try:
        args = sys.argv[1:]
        if len(args) >= 2 and args[0] == "--b64":
            raw_b64 = args[1].strip('"')
            raw_json = base64.b64decode(raw_b64).decode("utf-8")
        else:
            logging.error(f"Invalid arguments: {args}")
            sys.exit(1)

        logging.info(f"argv ok, decoded json length={len(raw_json)}")

        data = json.loads(raw_json)

        result = send_sms(
            data["userId"], data["phone"], data["title"], data.get("url", ""), data["dealId"]
        )

        # ✅ stdout에는 JSON만 출력
        print(json.dumps(result, ensure_ascii=False))

    except Exception as e:
        logging.exception(f"fatal error: {e}")
        sys.exit(1)
