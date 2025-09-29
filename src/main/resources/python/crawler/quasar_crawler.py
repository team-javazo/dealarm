import requests
from bs4 import BeautifulSoup
import json
from datetime import datetime, timedelta
import os
import re

base_dir = os.path.expanduser("~")
save_dir = os.path.join(base_dir, "dealarm-data")
os.makedirs(save_dir, exist_ok=True)

base_url = "https://quasarzone.com"
headers = {
    "User-Agent": "Mozilla/5.0"
}

stop_flag = False
page = 1
deals = []

while not stop_flag:
    print(f"📄 페이지 {page} 크롤링 중...")
    url = f"{base_url}/bbs/qb_saleinfo?page={page}"
    res = requests.get(url, headers=headers)
    soup = BeautifulSoup(res.text, "html.parser")

    items = soup.select("tr")

    if not items:
        print("❌ 더 이상 게시글이 없습니다.")
        break

    for item in items:
        try:
            # 제목 추출
            title_tag = item.select_one("a.subject-link .ellipsis-with-reply-cnt")
            if not title_tag:
                continue
            title_raw = title_tag.get_text(strip=True)

            # 가격 추출
            price_tag = item.select_one("span.text-orange")
            price = None
            if price_tag:
                price_text = price_tag.get_text(strip=True)
                price_match = re.search(r'(\d{1,3}(,\d{3})*|\d+)', price_text)
                if price_match:
                    price = int(price_match.group(1).replace(',', ''))

            # 괄호 안에 가격이 있는지 확인
            brackets = re.findall(r'\((.*?)\)', title_raw)
            has_price_in_brackets = False
            for bracket in reversed(brackets):
                if re.search(r'\d+(,\d{3})*\s*원', bracket):
                    has_price_in_brackets = True
                    break

            # 제목 정제
            title = re.sub(r'\[.*?\]', '', title_raw).strip()
            if not has_price_in_brackets and price:
                title += f" ({price:,}원)"

            # 사이트명
            site_match = re.search(r'\[(.*?)\]', title_raw)
            site = site_match.group(1) if site_match else "퀘이사존"

            # 링크
            link_tag = item.select_one("a.subject-link")
            relative_link = link_tag['href'] if link_tag else ""
            clean_link = relative_link.split("?")[0]
            full_url = base_url + clean_link

            # 게시일 처리
            date_tag = item.select_one("span.date")
            posted_at = datetime.now()
            if date_tag:
                date_text = date_tag.get_text(strip=True)
                now = datetime.now()

                if "시간" in date_text:
                    hours_ago = int(re.search(r'\d+', date_text).group())
                    posted_at = now - timedelta(hours=hours_ago)
                    posted_at = posted_at.replace(minute=0, second=0)

                elif "분" in date_text:
                    minutes_ago = int(re.search(r'\d+', date_text).group())
                    posted_at = now - timedelta(minutes=minutes_ago)
                    posted_at = posted_at.replace(minute=0, second=0)

                elif re.match(r"\d{2}-\d{2}", date_text):
                    month, day = map(int, date_text.split("-"))
                    posted_at = datetime(now.year, month, day, 0, 0, 0)

                else:
                    posted_at = now.replace(minute=0, second=0)

            # 오래된 게시글 필터링
            if (datetime.now() - posted_at).days >= 7:
                stop_flag = True
                print("📛 오래된 게시글 감지됨 → 크롤링 종료")
                break

            # 추천수
            rec_tag = item.select_one("span.num.tp4")
            rec_score = 0
            if rec_tag:
                try:
                    rec_score = int(rec_tag.get_text(strip=True))
                except:
                    rec_score = 0

            # 이미지 URL 추출
            img_tag = item.select_one("img")
            img_url = img_tag['src'] if img_tag and 'src' in img_tag.attrs else None

            # ✅ ?t= 파라미터 제거 및 https 보정
            if img_url:
                img_url = img_url.split("?")[0]
                if img_url.startswith("//"):
                    img_url = "https:" + img_url

            deal = {
                "title": title,
                "url": full_url,
                "price": price,
                "site": site,
                "posted_at": posted_at.strftime("%Y-%m-%d %H:%M:%S"),
                "likes": rec_score,
                "img": img_url
            }

            print(deal)
            deals.append(deal)

        except Exception as e:
            print("❌ Error parsing item:", e)
            continue

    page += 1

# 저장
try:
    with open(os.path.join(save_dir, "quasarzone_crawling.json"), "w", encoding="utf-8") as f:
        json.dump(deals, f, ensure_ascii=False, indent=2)
except Exception as e:
    print("JSON 저장 실패:", e)
