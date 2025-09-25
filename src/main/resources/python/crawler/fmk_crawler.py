import requests
from bs4 import BeautifulSoup
from datetime import datetime, timedelta
import time
import random

def refresh_session():
    new_session = requests.Session()
    new_session.headers.update(headers)
    return new_session

# 기본 설정
base_url = "https://www.fmkorea.com/index.php?mid=hotdeal&page={}"
headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/117.0.0.0 Safari/537.36",
    "Referer": "https://www.fmkorea.com/",
    "Accept-Language": "ko-KR,ko;q=0.9"

}
max_days = 7
now = datetime.now()
page = 1
stop = False

# 세션 유지
session = requests.Session()
session.headers.update(headers)

while not stop:
    print(f"📄 페이지 {page} 크롤링 중...")
    try:
        response = session.get(base_url.format(page))
        soup = BeautifulSoup(response.text, "html.parser")

        items = soup.select("li.li_best2_hotdeal0")
        if not items:
            print("❌ 쿠키 만료 또는 서버 응답 이상. 세션 갱신 시도 중...")
            session = refresh_session()
            time.sleep(2)

        for item in items:
            try:
                title = item.select_one("h3.title .ellipsis-target").text.strip()
                link = "https://www.fmkorea.com" + item.select_one("a.hotdeal_var8")["href"]

                # 이미지 URL에서 게시 시간 추출
                image_tag = item.select_one("img.thumb")
                image_url = image_tag.get("data-original") or image_tag.get("src")

                if image_url and "?c=" in image_url:
                    timestamp_raw = image_url.split("?c=")[-1]
                    posted_at = datetime.strptime(timestamp_raw, "%Y%m%d%H%M%S")
                else:
                    posted_at = None

                # 게시 시간 기준으로 중단 여부 판단
                if posted_at and (now - posted_at > timedelta(days=max_days)):
                    print(f"⏹️ 중단: {posted_at} → 7일 초과")
                    stop = True
                    break

                # 기타 정보 추출
                price = item.select_one(".hotdeal_info span:nth-of-type(2) a").text.strip()
                site = item.select_one(".hotdeal_info span:nth-of-type(1) a").text.strip()
                delivery = item.select_one(".hotdeal_info span:nth-of-type(3) a").text.strip()
                comments = item.select_one(".comment_count").text.strip("[]")
                recommend = item.select_one(".pc_voted_count .count").text.strip()
                author = item.select_one(".author").text.strip(" /")
                category = item.select_one(".category a").text.strip()

                # 출력
                print(f"🛒 제목: {title}")
                print(f"🔗 링크: {link}")
                print(f"🕒 게시시간: {posted_at}")
                print(f"💬 댓글: {comments} / 추천: {recommend}")
                print(f"🏷️ 쇼핑몰: {site} / 가격: {price} / 배송: {delivery}")
                print(f"📂 카테고리: {category} / 작성자: {author}")
                print("-" * 60)

            except Exception as e:
                print("❌ 오류 발생:", e)

        # 랜덤 딜레이 (0.5초 ~ 2초)
        time.sleep(random.uniform(0.5, 1.0))
        page += 1

    except Exception as e:
        print(f"❌ 페이지 요청 실패: {e}")
        break
