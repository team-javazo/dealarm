package kr.co.dong;

import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.*;

@RestController
@RequestMapping("/trend")
public class TrendController {

    private final RestTemplate restTemplate = new RestTemplate();

    @GetMapping("/social")
    public ResponseEntity<?> getSocialTrends() {
        try {
            List<String> results = new ArrayList<>();

            /* ------------------- 1) YouTube ------------------- */
            String youtubeApiKey = "AIzaSyBQQq0wLONB_JScLSwZPnQDIqwC_MU2aG8";
            String youtubeUrl = "https://www.googleapis.com/youtube/v3/videos"
                    + "?part=snippet&chart=mostPopular&regionCode=KR&maxResults=5&key=" + youtubeApiKey;

            try {
                Map ytBody = restTemplate.getForObject(youtubeUrl, Map.class);
                if (ytBody != null && ytBody.get("items") instanceof List) {
                    List<Map<String, Object>> ytItems = (List<Map<String, Object>>) ytBody.get("items");
                    for (Map<String, Object> item : ytItems) {
                        Map<String, Object> snippet = (Map<String, Object>) item.get("snippet");
                        if (snippet != null) {
                            String title = (String) snippet.get("title");
                            if (title != null && !title.isEmpty()) {
                                results.add("[YouTube] " + title);
                            }
                        }
                    }
                }
            } catch (Exception ex) {
                System.out.println("YouTube API 호출 실패: " + ex.getMessage());
            }

            return ResponseEntity.ok(results);

        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> error = new HashMap<>();
            error.put("status", 500);
            error.put("message", e.toString());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }
}
//package kr.co.dong;
//
//import org.springframework.http.*;
//import org.springframework.web.bind.annotation.*;
//import org.springframework.web.client.RestTemplate;
//
//import java.util.*;
//
//@RestController
//@RequestMapping("/trend")
//public class TrendController {
//
//    private final RestTemplate restTemplate = new RestTemplate();
//
//    @GetMapping("/social")
//    public ResponseEntity<?> getSocialTrends() {
//        try {
//            List<String> results = new ArrayList<>();
//
//            /* ------------------- 1) YouTube ------------------- */
//            String youtubeApiKey = "AIzaSyBQQq0wLONB_JScLSwZPnQDIqwC_MU2aG8";
//            String youtubeUrl = "https://www.googleapis.com/youtube/v3/videos"
//                    + "?part=snippet&chart=mostPopular&regionCode=KR&maxResults=5&key=" + youtubeApiKey;
//
//            try {
//                Map ytBody = restTemplate.getForObject(youtubeUrl, Map.class);
//                if (ytBody != null && ytBody.get("items") instanceof List) {
//                    List<Map<String, Object>> ytItems = (List<Map<String, Object>>) ytBody.get("items");
//                    for (Map<String, Object> item : ytItems) {
//                        Map<String, Object> snippet = (Map<String, Object>) item.get("snippet");
//                        if (snippet != null) {
//                            String title = (String) snippet.get("title");
//                            if (title != null && !title.isEmpty()) {
//                                results.add("[YouTube] " + title);
//                            }
//                        }
//                    }
//                }
//            } catch (Exception ex) {
//                System.out.println("YouTube API 호출 실패: " + ex.getMessage());
//            }
//
//            /* ------------------- 2) Reddit ------------------- */
//            String redditUrl = "https://www.reddit.com/r/all/hot.json?limit=5";
//            HttpHeaders headers = new HttpHeaders();
//            headers.set("User-Agent", "Mozilla/5.0 (compatible; TrendApp/1.0)");
//            HttpEntity<String> entity = new HttpEntity<>(headers);
//
//            try {
//                ResponseEntity<Map> redditResponse =
//                        restTemplate.exchange(redditUrl, HttpMethod.GET, entity, Map.class);
//
//                if (redditResponse.getStatusCode().is2xxSuccessful() && redditResponse.getBody() != null) {
//                    Map<String, Object> redditData = (Map<String, Object>) redditResponse.getBody().get("data");
//                    if (redditData != null && redditData.get("children") instanceof List) {
//                        List<Map<String, Object>> redditChildren = (List<Map<String, Object>>) redditData.get("children");
//                        for (Map<String, Object> child : redditChildren) {
//                            Map<String, Object> data = (Map<String, Object>) child.get("data");
//                            if (data != null) {
//                                String title = (String) data.get("title");
//                                if (title != null && !title.isEmpty()) {
//                                    results.add("[Reddit] " + title);
//                                }
//                            }
//                        }
//                    }
//                }
//            } catch (Exception ex) {
//                System.out.println("Reddit API 호출 실패: " + ex.getMessage());
//            }
//
//            return ResponseEntity.ok(results);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            Map<String, Object> error = new HashMap<>();
//            error.put("status", 500);
//            error.put("message", e.toString());
//            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
//        }
//    }
//}
