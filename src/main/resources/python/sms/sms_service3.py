import os
import sys
import json
import logging
import base64
import pymysql
from dotenv import load_dotenv
from pathlib import Path

# Solapi SDK import
from solapi import SolapiMessageService
from solapi.model import RequestMessage

logging.basicConfig(level=logging.INFO, stream=sys.stderr,
                    format="%(asctime)s [%(levelname)s] %(message)s")

# ==================================================
# 1) 환경 변수 로드
# ==================================================
dotenv_path = (Path(__file__).resolve().parent / ".env")
load_dotenv(dotenv_path)

SOLAPI_API_KEY = os.getenv("SOLAPI_API_KEY", "").strip()
SOLAPI_API_SECRET = os.getenv("SOLAPI_API_SECRET", "").strip()
SOLAPI_FROM_NUMBER = os.getenv("SOLAPI_FROM_NUMBER", "").strip()

# DB 설정
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
# 2) Solapi SDK 초기화
# ==================================================
message_service = SolapiMessageService(
    api_key=SOLAPI_API_KEY,
    api_secret=SOLAPI_API_SECRET
)

# ==================================================
# 3) 번호 변환 유틸
# ==================================================
def normalize_phone(phone: str) -> str:
    phone = phone.strip()
    if phone.startswith("0"):
        return "+82" + phone[1:]
    return phone

# ==================================================
# 4) SMS 전송 (중복 방지 + DB 기록)
# ==================================================
def send_sms(user_id: str, phone: str, title: str, url: str, deal_id: int, keyword: str = None):
    if not (user_id and phone and title and deal_id is not None):
        return {"result": "failed", "error": "필수 값 누락", "userId": user_id, "dealId": deal_id}

    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            # 중복 발송 방지 체크
            # 1) 알림 허용 여부 확인
            cursor.execute("SELECT notification FROM users WHERE id=%s", (user_id,))
            row = cursor.fetchone()
            if not row or row["notification"] != 1:
                logging.info(f"🔕 알림 차단된 사용자: user={user_id}")
                return {"result": "skipped", "reason": "notification_off", "userId": user_id, "dealId": deal_id}

            # 2) 중복 발송 방지 체크
            cursor.execute("SELECT 1 FROM deal_match WHERE user_id=%s AND deal_id=%s", (user_id, deal_id))
            if cursor.fetchone():
                logging.info(f"🔁 이미 발송된 알림: user={user_id}, dealId={deal_id}")
                return {"result": "skipped", "reason": "already_sent", "userId": user_id, "dealId": deal_id}

        to_number = normalize_phone(phone)
        body = (f"[dealarm 알림]\n"
                f"[{user_id}님 키워드 {keyword} 알림]\n"
                f"제품명: {title}\n"
                f"제품링크: {url or ''}")

        # Solapi SDK 메시지 객체
        message = RequestMessage(
            from_=SOLAPI_FROM_NUMBER,
            to=to_number,
            text=body
        )

        # SDK 발송
        response = message_service.send(message)

        # SDK 응답 성공 처리
        if response and response.group_info.count.registered_success > 0:
            with conn.cursor() as cursor:
                cursor.execute(
                    "INSERT INTO deal_match (user_id, deal_id, matched_at) VALUES (%s, %s, CURRENT_TIMESTAMP)",
                    (user_id, deal_id)
                )
            conn.commit()

            logging.info(f"✅ SMS 전송 성공: user={user_id}, dealId={deal_id}, to={to_number}")
            return {
                "result": "sent",
                "groupId": response.group_info.group_id,
                "successCount": response.group_info.count.registered_success,
                "failCount": response.group_info.count.registered_failed,
                "userId": user_id,
                "dealId": deal_id
            }
        else:
            logging.error(f"❌ SMS 전송 실패: {response}")
            return {"result": "failed", "error": str(response), "userId": user_id, "dealId": deal_id}

    except Exception as e:
        logging.exception("❌ SMS 전송 중 예외 발생")
        return {"result": "failed", "error": str(e), "userId": user_id, "dealId": deal_id}
    finally:
        conn.close()

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

        data = json.loads(raw_json)

        result = send_sms(
            data["userId"],
            data["phone"],
            data["title"],
            data.get("url", ""),
            data["dealId"],
            data.get("keyword")
        )

        print(json.dumps(result, ensure_ascii=False))

    except Exception as e:
        logging.exception(f"fatal error: {e}")
        sys.exit(1)
