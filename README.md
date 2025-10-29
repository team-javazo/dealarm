# Dealarm

실시간 할인정보 공유 플랫폼 **Dealarm** 은 사용자가 등록한 키워드를 바탕으로 외부 쇼핑/뉴스/커뮤니티 등에서 **할인·딜 정보를 수집**하고, **스케줄러**로 주기 실행된 **크롤러**가 데이터를 정제·중복제거 후 **알림(SMS)** 으로 전달합니다. 사용자의 클릭을 **추적·집계**하여 개인화 추천과 대시보드 통계를 제공합니다.

## 🧰 Tech Stack

- **Backend:** Java, Spring MVC, JSP, JSTL
- **Frontend:** JSP (JSTL), HTML/CSS/JS
- **Python:** Python (크롤러, SMS 연동), venv
- **DB:** MySQL (AWS RDS)
- **Infra/DevOps:** Tomcat (WAR 배포), AWS EC2, AWS RDS, 환경변수(.env) 연동, Scheduler (Spring)
- **External APIs:** Solapi(SMS), Naver/Google 검색 API, Google Ads 키워드 API

## 📁 Project Structure
```
dealarm_extract/
├─ 2┴╢_╡⌠╢≈ppt.pptx
├─ dealarm.zip
├─ dealarm_└Γ╕«╜║╞«.xlsx
├─ Javajo╚╕└╟╖╧.xlsx
└─ WBS.png
```


### 📌 Controllers (추출)
- (자동 탐색 결과 없음)


### 🔗 Request Mappings (일부 자동 추출)
- (주석 기반 매핑 탐색 결과 없음)


### 🛠 Services
- (자동 탐색 결과 없음)

### 🗄 DAO/Repository
- (자동 탐색 결과 없음)

### 🔧 DB 설정 파일 위치(탐지)
- (datasource 관련 설정 탐지 실패)

### 🧩 JSP Views
- (JSP 탐지 실패)

### 🐍 Python Modules
- (Python 모듈 탐지 실패)

### 🧾 SQL / Schema Files
- (SQL 파일 탐지 실패)

## ✨ Features

- **회원관리**: 가입/로그인/권한/관리자 기능
- **키워드 등록**: 사용자별 관심 키워드 저장
- **크롤링/집계**: 외부 소스 수집, 유사도 기반 중복 제거, 랭킹
- **스케줄러**: 정해진 주기마다 크롤러 실행 (Spring @Scheduled)
- **알림(SMS)**: Solapi 연동 — 키워드 매칭 결과 전송
- **클릭 추적**: 링크 클릭 이벤트 수집 → 개인화/통계
- **대시보드**: 인기/개인화 지표 제공 (성별/연령 필터 등)

## 🔄 User & Data Flow

1. 사용자가 **키워드 등록**
2. **스케줄러**가 주기적으로 **크롤러** 실행 → 데이터 수집
3. **중복 제거 / 정제** 로 유의미한 딜만 저장
4. 사용자 **키워드-딜 매칭** → **SMS 발송**
5. 사용자가 링크 **클릭** → 서버에 **클릭 로그 축적**
6. 통계/개인화 점수 반영 → 다음 추천과 대시보드에 활용

## ▶️ Run (Local)

1. **Java & Maven 설치** (또는 Gradle)  
2. **MySQL 준비**: 스키마 생성 및 `application.properties` / `.env` 에 DB 접속정보 설정  
3. (선택) **Python venv 설치** 후 크롤러/ SMS 모듈 의존성 설치  
4. `mvn clean package` 로 WAR 생성  
5. **Tomcat** `webapps/` 에 WAR 배치 → 서버 시작  
6. 환경변수/경로 확인: `.env`, 이미지/JSON 디렉토리 경로, 스케줄러 주기

## ☁️ Deploy (AWS)

- **EC2 (Ubuntu) + Tomcat**: `/opt/tomcat` 기준 배포
- **RDS(MySQL)** 보안그룹 및 계정 권한 구성
- `.env` → `/opt/tomcat/dealarm-data/.env` 등 **외부 경로**에 배치 (권장)
- `systemd` 로 Tomcat 서비스 등록 및 재시작 스크립트
- 로그/리소스: 크롤링/이미지 폴더 권한, 디스크 사용량, CPU 모니터링

> 참고 이슈: `.env` 미탐지, DB 인증 오류(Access denied), 스케줄러 크롤링 과부하 등

## 👥 Team & Roles

- **정세준(조장, PM)**: 전체 설계/관리/배포, AWS RDS 구축, 파이썬 크롤링 모듈
- **신동연(부조장)**: 회원가입/키워드 등록, 중복제거(유사도), 키워드 순위/필터, API 연관키워드, 클릭률 수집
- **조현준**: 고객 문의 등록/수정/관리
- **홍요셉**: 관리자(회원 상세/수정/삭제), 스케줄러 설계, 뉴스 추천(API)
- **변정건**: 로그인/소셜 로그인, 암호화
- **정지호**: DB 설계/관리, 파이썬 SMS 전송 모듈

## 🧯 Troubleshooting

- **.env 인식 실패**: 배포 경로/권한 확인 (`/opt/tomcat/dealarm-data/.env`), 서비스 재기동
- **DB 접속 오류 (1045)**: 사용자/비밀번호/권한 확인, RDS 보안그룹/방화벽 점검
- **크롤러 과부하**: 스케줄러 간격 조정, CPU/메모리 모니터링, 배치 분할
- **이미지/임시파일 누적**: 주기적 정리(스케줄러), 경로 환경변수화

## 📊 Archive Extraction

- Extracted inner zips from:
  - `/mnt/data/dealarm_extract/dealarm`


## 🧭 Detection Summary

{
  "file_counts": {
    ".pptx": 1,
    ".zip": 1,
    ".xlsx": 2,
    ".png": 3,
    "": 487,
    ".xml": 32,
    ".md": 1,
    ".txt": 2,
    ".idx": 37,
    ".pack": 37,
    ".iml": 1,
    ".prefs": 6,
    ".component": 1,
    ".java": 63,
    ".py": 8,
    ".ico": 2,
    ".css": 1,
    ".jpg": 4,
    ".js": 1,
    ".jsp": 36,
    ".war": 1,
    ".class": 67,
    ".mf": 1,
    ".properties": 1
  },
  "controllers_found": 13,
  "services_found": 11,
  "daos_found": 22,
  "jsp_count": 36,
  "python_count": 8,
  "sql_count": 0,
  "has_pom": true,
  "has_gradle": false
}

## 📂 File Lists (Detected)

### Controllers
- `dealarm/src/main/java/kr/co/dong/ClickController.java`
- `dealarm/src/main/java/kr/co/dong/CommentController.java`
- `dealarm/src/main/java/kr/co/dong/DealSummaryController.java`
- `dealarm/src/main/java/kr/co/dong/ErrorController.java`
- `dealarm/src/main/java/kr/co/dong/GlobalControllerAdvice.java`
- `dealarm/src/main/java/kr/co/dong/HomeController.java`
- `dealarm/src/main/java/kr/co/dong/InquiryController.java`
- `dealarm/src/main/java/kr/co/dong/MemberController.java`
- `dealarm/src/main/java/kr/co/dong/NewsController.java`
- `dealarm/src/main/java/kr/co/dong/SmsController.java`
- `dealarm/src/main/java/kr/co/dong/SmsTestController.java`
- `dealarm/src/main/java/kr/co/dong/StatsController.java`
- `dealarm/src/main/java/kr/co/dong/UserKeywordController.java`


### Services
- `dealarm/src/main/java/kr/co/dong/UserKeyword/UserKeywordServiceImpl.java`
- `dealarm/src/main/java/kr/co/dong/click/ClickServiceImpl.java`
- `dealarm/src/main/java/kr/co/dong/deal/DealMatchServiceImpl.java`
- `dealarm/src/main/java/kr/co/dong/deal/DealSummaryService.java`
- `dealarm/src/main/java/kr/co/dong/inquiry/CommentServiceImpl.java`
- `dealarm/src/main/java/kr/co/dong/inquiry/InquiryServiceImpl.java`
- `dealarm/src/main/java/kr/co/dong/member/MemberServiceImpl.java`
- `dealarm/src/main/java/kr/co/dong/news/NaverNewsService.java`
- `dealarm/src/main/java/kr/co/dong/sms/SmsApiServiceImpl.java`
- `dealarm/src/main/java/kr/co/dong/sms/SmsDBServiceImpl.java`
- `dealarm/src/main/java/kr/co/dong/sms/SmsManualService.java`


### DAOs/Repositories
- `dealarm/src/main/java/kr/co/dong/UserKeyword/UserKeywordDAO.java`
- `dealarm/src/main/java/kr/co/dong/UserKeyword/UserKeywordDAOImpl.java`
- `dealarm/src/main/java/kr/co/dong/UserKeyword/UserKeywordServiceImpl.java`
- `dealarm/src/main/java/kr/co/dong/click/ClickDAO.java`
- `dealarm/src/main/java/kr/co/dong/click/ClickDAOImpl.java`
- `dealarm/src/main/java/kr/co/dong/click/ClickServiceImpl.java`
- `dealarm/src/main/java/kr/co/dong/deal/DealMatchDAO.java`
- `dealarm/src/main/java/kr/co/dong/deal/DealMatchDAOImpl.java`
- `dealarm/src/main/java/kr/co/dong/deal/DealMatchServiceImpl.java`
- `dealarm/src/main/java/kr/co/dong/deal/DealSummaryDAO.java`
- `dealarm/src/main/java/kr/co/dong/deal/DealSummaryDAOImpl.java`
- `dealarm/src/main/java/kr/co/dong/deal/DealSummaryService.java`
- `dealarm/src/main/java/kr/co/dong/inquiry/CommentDAO.java`
- `dealarm/src/main/java/kr/co/dong/inquiry/CommentDAOImpl.java`
- `dealarm/src/main/java/kr/co/dong/inquiry/CommentServiceImpl.java`
- `dealarm/src/main/java/kr/co/dong/inquiry/InquiryDAO.java`
- `dealarm/src/main/java/kr/co/dong/inquiry/InquiryDAOImpl.java`
- `dealarm/src/main/java/kr/co/dong/inquiry/InquiryServiceImpl.java`
- `dealarm/src/main/java/kr/co/dong/member/MemberDAO.java`
- `dealarm/src/main/java/kr/co/dong/member/MemberDAOImpl.java`
- `dealarm/src/main/java/kr/co/dong/member/MemberServiceImpl.java`
- `dealarm/src/main/java/kr/co/dong/sms/SmsDBServiceImpl.java`


### JSP Views (top)
- `dealarm/src/main/webapp/WEB-INF/views/admin/adminpage.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/admin/adminupdate.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/admin/detail.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/admin/members.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/admin/stats.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/error/405.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/home.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/include/Graph.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/include/banner.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/include/dealMatch.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/include/footer.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/include/header.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/include/left_nav.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/include/newDeal.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/include/section.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/include/top_nav.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/inquiry/detail.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/inquiry/edit.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/inquiry/forbidden.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/inquiry/list.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/inquiry/list23.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/inquiry/update.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/inquiry/write.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/main.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/member/join.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/member/login.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/member/mypage.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/member/naverJoin.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/member/oauthLogin.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/member/temp.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/member/userupdate.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/newDeal.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/news.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/sms/manualForm.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/sms/manualResult.jsp`
- `dealarm/src/main/webapp/WEB-INF/views/╝║╣╬╛▓╖╣▒Γ.jsp`


### Python Modules (top)
- `dealarm/src/main/resources/python/crawler/ppompu_crawler.py`
- `dealarm/src/main/resources/python/crawler/quasar_crawler.py`
- `dealarm/src/main/resources/python/sms/sms_service2.py`
- `dealarm/src/main/resources/python/sms/sms_service3.py`
- `dealarm/target/classes/python/crawler/ppompu_crawler.py`
- `dealarm/target/classes/python/crawler/quasar_crawler.py`
- `dealarm/target/classes/python/sms/sms_service2.py`
- `dealarm/target/classes/python/sms/sms_service3.py`


## ⏱ Scheduled Tasks (Detected)

| File | Method | Args |
|---|---|---|
| `dealarm/src/main/java/kr/co/dong/scheduler/CrawlScheduler.java` | `deleteOldDeals` | `fixedDelay = 300000` |
| `dealarm/src/main/java/kr/co/dong/scheduler/CrawlScheduler.java` | `runCrawlerAndReadJson` | `fixedDelay = 300000` |


## 📦 Maven Dependencies (from pom.xml)
- org.springframework:spring-context:${org.springframework-version}
- org.springframework:spring-webmvc:${org.springframework-version}
- org.aspectj:aspectjrt:${org.aspectj-version}
- org.slf4j:slf4j-api:${org.slf4j-version}
- org.slf4j:jcl-over-slf4j:${org.slf4j-version}
- org.slf4j:slf4j-log4j12:${org.slf4j-version}
- javax.inject:javax.inject:1
- javax.servlet:servlet-api:2.5
- javax.servlet.jsp:jsp-api:2.1
- javax.servlet:jstl:1.2
- junit:junit:4.12
- com.mysql:mysql-connector-j:8.0.33
- org.springframework:spring-jdbc:${org.springframework-version}
- org.springframework:spring-test:${org.springframework-version}
- org.mybatis:mybatis:3.5.6
- org.mybatis:mybatis-spring:2.0.1
- com.googlecode.json-simple:json-simple:1.1.1
- org.lazyluke:log4jdbc-remix:0.2.7
- com.fasterxml.jackson.core:jackson-databind:2.11.2
- com.fasterxml.jackson.core:jackson-core:2.11.2
- org.apache.commons:commons-text:1.10.0
- com.github.scribejava:scribejava-core:2.8.1
- org.springframework.security:spring-security-core:5.2.6.RELEASE
- log4j:log4j:1.2.17
