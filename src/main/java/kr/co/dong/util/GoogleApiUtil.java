package kr.co.dong.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;

@Component
public class GoogleApiUtil { 

    // 🔑 Google Custom Search JSON API 설정 값 (반드시 실제 값으로 대체해야 함!)
//    private static final String GOOGLE_API_KEY = "AIzaSyBpRyiNcDTCq5EivSfzUBjrqYOwn2pCDc0"; // <-- ⚠️ 실제 API Key로 변경
//    private static final String GOOGLE_CX = "730e7a6fa4c1344c4"; // <-- ⚠️ 실제 CX ID로 변경
    private static final String GOOGLE_API_KEY = ""; // <-- ⚠️ 실제 API Key로 변경
    private static final String GOOGLE_CX = ""; // <-- ⚠️ 실제 CX ID로 변경 
    
    // Google Custom Search JSON API URL
    private static final String GOOGLE_API_BASE_URL = "https://www.googleapis.com/customsearch/v1";

    /**
     * Google Custom Search API를 호출하여 연관 검색어(relatedQueries) 목록을 가져옵니다.
     * relatedQueries가 없을 경우, 검색 결과의 제목을 대체 키워드로 사용합니다.
     * @param keyword 검색 키워드
     * @return Google이 추천하는 연관 검색어 리스트
     */
    public List<String> getRelatedKeywords(String keyword) {
        List<String> relatedKeywords = new ArrayList<>();
        HttpURLConnection con = null;

        if (GOOGLE_API_KEY.startsWith("AIza") == false || GOOGLE_CX.isEmpty()) { 
            System.err.println("Google API Key 또는 CX가 설정되지 않았습니다. 설정을 확인하세요.");
            relatedKeywords.add("Google API 설정 오류");
            return relatedKeywords;
        }

        try {
            // 1. 쿼리 파라미터 구성 및 인코딩
            String encodedKeyword = URLEncoder.encode(keyword, "UTF-8");
            
            // num=4로 설정
            String apiURL = GOOGLE_API_BASE_URL +
                            "?q=" + encodedKeyword +
                            "&key=" + GOOGLE_API_KEY +
                            "&cx=" + GOOGLE_CX +
                            "&num=4"; 

            // 2. HTTP Connection 설정 및 응답 읽기 (기존 로직 유지)
            URL url = new URL(apiURL);
            con = (HttpURLConnection)url.openConnection();
            con.setRequestMethod("GET");
            con.setRequestProperty("Accept", "application/json"); 
            
            int responseCode = con.getResponseCode();
            BufferedReader br;
            if(responseCode == 200) {
                br = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
            } else {
                br = new BufferedReader(new InputStreamReader(con.getErrorStream(), "UTF-8"));
            }
            
            String inputLine;
            StringBuffer response = new StringBuffer();
            while ((inputLine = br.readLine()) != null) {
                response.append(inputLine);
            }
            br.close();
            
            // 3. JSON 응답 파싱
            ObjectMapper objectMapper = new ObjectMapper();
            Map<String, Object> jsonMap = objectMapper.readValue(response.toString(), Map.class);
            
            if (responseCode != 200) {
                relatedKeywords.add("API 오류: " + jsonMap.getOrDefault("error", "알 수 없는 오류").toString());
                return relatedKeywords;
            }

            // 4. 공식 연관 검색어(relatedQueries) 추출 시도
            if (jsonMap.get("queries") instanceof Map) {
                Map<String, Object> queriesMap = (Map<String, Object>) jsonMap.get("queries");
                
                if (queriesMap.get("relatedQueries") instanceof List) {
                    List<?> relatedQueriesList = (List<?>) queriesMap.get("relatedQueries");

                    for (Object rawQuery : relatedQueriesList) {
                        if (rawQuery instanceof Map) {
                            Map<String, Object> queryMap = (Map<String, Object>) rawQuery;
                            String relatedKeyword = (String) queryMap.get("title"); 
                            if (relatedKeyword != null && !relatedKeyword.isEmpty()) {
                                relatedKeywords.add(relatedKeyword.trim());
                            }
                        }
                    }
                }
            }
            
         // 5. ⭐️ 보완 로직: relatedQueries가 비어 있을 경우, 검색 결과 제목(items -> title)을 추출 (수정)
            if (relatedKeywords.isEmpty()) {
                if (jsonMap.get("items") instanceof List) {
                    List<?> items = (List<?>) jsonMap.get("items");

                    // num=4개 중 최대 4개의 제목을 키워드로 활용
                    for (Object rawItem : items) {
                        if (rawItem instanceof Map) {
                            Map<String, Object> itemMap = (Map<String, Object>) rawItem;
                            String title = (String) itemMap.get("title");
                            if (title != null && !title.isEmpty()) {
                                
                                // 💡 개선된 로직: 제목을 분리하여 키워드로 추가
                                String cleanTitle = title.trim()
                                        .replaceAll("\\s*-\\s*\\w+", "") // (예: "사과 - 나무위키"에서 '- 나무위키' 제거)
                                        .replaceAll(" \\|.*", "") // (예: "상품명 | 쇼핑몰명"에서 '| 쇼핑몰명' 제거)
                                        .trim();
                                
                                // 제목을 공백 기준으로 분리하여 2~3단어 구문으로 재구성 (예시)
                                String[] words = cleanTitle.split("\\s+");
                                
                                if (words.length >= 2) {
                                    // 첫 두 단어를 붙여서 키워드로 사용
                                    String compoundKeyword = words[0] + " " + words[1];
                                    if (!relatedKeywords.contains(compoundKeyword)) {
                                        relatedKeywords.add(compoundKeyword);
                                    }
                                } else if (words.length == 1 && !words[0].isEmpty()) {
                                    // 단일 단어도 추가
                                     if (!relatedKeywords.contains(words[0])) {
                                        relatedKeywords.add(words[0]);
                                    }
                                }
                                // 원래 제목도 추가 (선택 사항)
                                // if (!relatedKeywords.contains(cleanTitle)) {
                                //     relatedKeywords.add(cleanTitle);
                                // }
                            }
                        }
                    }
                }
            }

            // 6. 최종 처리
            if (relatedKeywords.isEmpty()) {
                relatedKeywords.add("연관 키워드를 찾을 수 없습니다.");
            }

        } catch (Exception e) {
            System.err.println("Google API 호출 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            relatedKeywords.clear();
            relatedKeywords.add("연관 검색어 조회 실패 (네트워크 또는 API 파싱 오류)");
        } finally {
            if (con != null) {
                con.disconnect();
            }
        }
        return relatedKeywords;
    }
}