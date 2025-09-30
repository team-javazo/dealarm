import os
import sys
import json
import logging
import pymysql
from dotenv import load_dotenv
from twilio.rest import Client

print(f"sys.argv = {sys.argv}", file=sys.stderr)

# ==================================================
# 1) 환경 변수 로드
# ==================================================
load_dotenv()

TWILIO_ACCOUNT_SID = os.getenv("TWILIO_ACCOUNT_SID")
TWILIO_AUTH_TOKEN = os.getenv("TWILIO_AUTH_TOKEN")
TWILIO_FROM_NUMBER = os.getenv("TWILIO_FROM_NUMBER")

twilio_client = Client(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")

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
            f"제품링크: {url or ''}")

    try:
        # 1) Twilio 발송
        message = twilio_client.messages.create(
            to=to_number,
            from_=TWILIO_FROM_NUMBER,
            body=body
        )
        logging.info(f"✅ SMS 전송 성공: user={user_id}, dealId={deal_id}, to={to_number}, sid={message.sid}")

        # # 2) DB 기록
        # conn = get_connection()
        # with conn.cursor() as cursor:
        #     sql = """
        #         INSERT INTO deal_match (user_id, deal_id)
        #         VALUES (%s, %s)
        #         ON DUPLICATE KEY UPDATE matched_at = CURRENT_TIMESTAMP
        #     """
        #     cursor.execute(sql, (user_id, deal_id))
        #     conn.commit()
        # conn.close()

        return {"result": "sent", "sid": message.sid}

    except Exception as e:
        logging.exception("❌ SMS 전송 실패")
        return {"error": str(e)}

# ==================================================
# 5) 엔트리포인트 (직접 데이터 넣기)
# ==================================================
if __name__ == "__main__":
    try:
        # -------------------------------
        # 🔹 테스트용 임시 데이터 직접 정의
        # -------------------------------
        data = {
            "userId": "정지호",
            "phone": "01032047742",  # ⚠️ Twilio Trial 계정은 인증된 번호만 허용
            "title": "최고급 홍요셉",
            "url": "http://example.com",
            "dealId": 99
        }

        # 디버그 출력
        print(f">>> RAW JSON: {json.dumps(data, ensure_ascii=False)}", file=sys.stderr)

        # 실제 SMS 발송
        result = send_sms(
            data["userId"],
            data["phone"],
            data["title"],
            data.get("url", ""),
            data["dealId"],
        )
        print(json.dumps(result, ensure_ascii=False))

    except Exception as e:
        print(json.dumps({"error": str(e)}))
        sys.exit(1)
