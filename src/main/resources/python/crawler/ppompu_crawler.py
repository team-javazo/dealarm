import requests
from bs4 import BeautifulSoup
import json
from datetime import datetime
import os
import re

base_dir = os.path.expanduser("~")
save_dir = os.path.join(base_dir, "dealarm-data")
os.makedirs(save_dir, exist_ok=True)
base_url = "https://www.ppomppu.co.kr/zboard/"
headers = {
    "User-Agent": "Mozilla/5.0"
}
stop_flag = False
page = 1
deals = []

while not stop_flag:
    print(f"페이지 {page} 크롤링 중...")
    url = f"https://www.ppomppu.co.kr/zboard/zboard.php?id=ppomppu&page={page}&divpage=104"
    res = requests.get(url, headers=headers)
    soup = BeautifulSoup(res.text, "html.parser")

    items = soup.select("tr.baseList")
    if not items:
        print("❌ 더 이상 게시글이 없습니다.")
        break

    for item in items:
        try:
            # ✅ end2 클래스가 포함된 게시글은 건너뛰기
            link_tag = item.select_one("a.baseList-title")
            if link_tag and 'end2' in link_tag.get('class', []):
                continue
            
            title_tag = item.select_one("a.baseList-title > span")
            title_raw = title_tag.get_text(strip=True) if title_tag else "제목 없음"
            title = re.sub(r'\[.*?\]', '', title_raw).strip()

            # 가격 추출
            price = None
            brackets = re.findall(r'\((.*?)\)', title_raw)
            for bracket in reversed(brackets):
                price_match = re.search(r'(\d{1,3}(,\d{3})*|\d+)(?=\s*원|\s*/|[^\d])', bracket)
                if price_match:
                    price = int(price_match.group(1).replace(',', ''))
                    break

            # 사이트명
            site_match = re.search(r'\[(.*?)\]', title_raw)
            site = site_match.group(1) if site_match else "Unknown"

            # 링크
            link_tag = item.select_one("a.baseList-title")
            relative_link = link_tag['href'] if link_tag else ""
            url = base_url + relative_link

            # 게시일
            td_tag = item.select_one("td.baseList-space[title]")
            posted_at_str = td_tag['title'] if td_tag and 'title' in td_tag.attrs else None

            try:
                posted_at = datetime.strptime(posted_at_str, "%y.%m.%d %H:%M:%S")
            except:
                posted_at = datetime.now()

            today = datetime.now()
            if (today - posted_at).days >= 7:
                stop_flag = True
                print("📛 오래된 게시글 감지됨 → 크롤링 종료")
                break

            # 수집일
            created_at = today.strftime("%Y-%m-%d %H:%M:%S")

            # 추천수 계산
            rec_tag = item.select_one("td.baseList-rec")
            rec_text = rec_tag.get_text(strip=True) if rec_tag else "0"
            rec_score = 0
            if '-' in rec_text:
                try:
                    up, down = map(int, rec_text.split('-'))
                    rec_score = up - down
                except:
                    rec_score = 0
            else:
                try:
                    rec_score = int(rec_text)
                except:
                    rec_score = 0

            deal = {
                "title": title,
                "url": url,
                "price": price,
                "site": site,
                "posted_at": posted_at.strftime("%Y-%m-%d %H:%M:%S"),
                "likes": rec_score
            }

            print(deal)
            deals.append(deal)

        except Exception as e:
            print("❌ Error parsing item:", e)
            continue

    page += 1


try:
    with open(os.path.join(save_dir, "ppomppu_crawling.json"), "w", encoding="utf-8") as f:
        json.dump(deals, f, ensure_ascii=False, indent=2)
except Exception as e:
    print("JSON 저장 실패:", e)
