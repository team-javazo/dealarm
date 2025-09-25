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
stop_flag = False
page = 1
deals = []

while not stop_flag:
    print(f"FM코리아 페이지 {page} 크롤링 중...")
    url = f"{base_url}/index.php?mid=hotdeal&page={page}"
    res = requests.get(url, headers=headers)
    soup = BeautifulSoup(res.text, "html.parser")

    for item in soup.select("li.li"):
        try:
            link_tag = item.select_one("a.hotdeal_var8")
            relative_link = link_tag['href'] if link_tag else ""
            full_url = base_url + relative_link

            # 상세 페이지 요청
            detail_res = requests.get(full_url, headers=headers)
            detail_soup = BeautifulSoup(detail_res.text, "html.parser")

            # 제목
            title_tag = detail_soup.select_one("tr th:contains('상품명') + td .xe_content")
            title = title_tag.get_text(strip=True) if title_tag else "제목 없음"

            # 외부 링크
            link_tag = detail_soup.select_one("a.hotdeal_url")
            external_url = link_tag['href'] if link_tag else full_url

            # 쇼핑몰
            site_tag = detail_soup.select_one("tr th:contains('쇼핑몰') + td .xe_content")
            site = site_tag.get_text(strip=True).split()[0] if site_tag else "Unknown"

            # 가격
            price_tag = detail_soup.select_one("tr th:contains('가격') + td .xe_content")
            price_text = price_tag.get_text(strip=True) if price_tag else None
            price_match = re.search(r'(\d+(,\d{3})*)원', price_text) if price_text else None
            price = int(price_match.group(1).replace(',', '')) if price_match else None

            # 게시일
            date_tag = detail_soup.select_one("span.date.m_no")
            posted_at_str = date_tag.get_text(strip=True) if date_tag else None
            try:
                posted_at = datetime.strptime(posted_at_str, "%Y.%m.%d %H:%M")
            except:
                posted_at = datetime.now()

            # 추천수
            rec_tag = detail_soup.select_one("div.side.fr span:contains('추천 수') b")
            rec_text = rec_tag.get_text(strip=True) if rec_tag else "0"
            try:
                rec_score = int(rec_text)
            except:
                rec_score = 0

            # 일주일 이상 지난 글이면 중단
            today = datetime.now()
            if (today - posted_at).days >= 7:
                stop_flag = True
                print("📛 오래된 게시글 감지됨 → 크롤링 종료")
                break

            created_at = today.strftime("%Y-%m-%d %H:%M:%S")

            deal = {
                "title": title,
                "url": external_url,
                "price": price,
                "site": site,
                "posted_at": posted_at.strftime("%Y-%m-%d %H:%M:%S"),
                "created_at": created_at,
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
