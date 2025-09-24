import requests
from bs4 import BeautifulSoup
import json
from datetime import datetime
import os
import re

current_dir = os.path.dirname(__file__)
save_dir = os.path.join(current_dir, '..', '..', 'resources', 'crawler')
save_dir = os.path.abspath(save_dir)
os.makedirs(save_dir, exist_ok=True)

base_url = "https://www.fmkorea.com"
headers = {
    "User-Agent": "Mozilla/5.0"
}
page = 1
deals = []

while page <= 5:  # 예시로 5페이지까지만
    print(f"FM코리아 페이지 {page} 크롤링 중...")
    url = f"https://www.fmkorea.com/index.php?mid=hotdeal&page={page}"
    res = requests.get(url, headers=headers)
    soup = BeautifulSoup(res.text, "html.parser")

    for item in soup.select("li.li"):
        try:
            title_tag = item.select_one("span.ellipsis-target")
            title = title_tag.get_text(strip=True) if title_tag else "제목 없음"

            link_tag = item.select_one("a.hotdeal_var8")
            relative_link = link_tag['href'] if link_tag else ""
            full_url = base_url + relative_link

            info_tag = item.select_one("div.hotdeal_info")
            info_text = info_tag.get_text(" ", strip=True) if info_tag else ""

            # 가격 추출
            price_match = re.search(r'가격:\s*(\d+(,\d{3})*)원', info_text)
            price = int(price_match.group(1).replace(',', '')) if price_match else None

            # 쇼핑몰 추출
            site_match = re.search(r'쇼핑몰:\s*(\S+)', info_text)
            site = site_match.group(1) if site_match else "Unknown"

            # 추천수
            rec_tag = item.select_one("span.count")
            rec_text = rec_tag.get_text(strip=True) if rec_tag else "0"
            try:
                rec_score = int(rec_text)
            except:
                rec_score = 0

            # 게시일
            reg_tag = item.select_one("span.regdate")
            posted_at_str = reg_tag.get_text(strip=True) if reg_tag else ""
            try:
                posted_at = datetime.strptime(posted_at_str, "%H:%M")
                posted_at = posted_at.replace(
                    year=datetime.now().year,
                    month=datetime.now().month,
                    day=datetime.now().day
                )
            except:
                posted_at = datetime.now()

            collected_at = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

            deal = {
                "title": title,
                "url": full_url,
                "price": price,
                "site": site,
                "posted_at": posted_at.strftime("%Y-%m-%d %H:%M:%S"),
                "collected_at": collected_at,
                "likes": rec_score
            }

            print(deal)
            deals.append(deal)

        except Exception as e:
            print("❌ Error parsing item:", e)
            continue

    page += 1

try:
    with open(os.path.join(save_dir, "fmkorea_crawling.json"), "w", encoding="utf-8") as f:
        json.dump(deals, f, ensure_ascii=False, indent=2)
except Exception as e:
    print("JSON 저장 실패:", e)
