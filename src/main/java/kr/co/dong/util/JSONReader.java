package kr.co.dong.util;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.core.io.ClassPathResource;

import java.io.InputStreamReader;
import java.io.InputStream;

public class JSONReader {

    // JSON 파일을 JSONArray로 읽기
    public static JSONArray readJsonArray(String path) {
        try {
            ClassPathResource resource = new ClassPathResource(path);
            InputStream inputStream = resource.getInputStream();
            JSONParser parser = new JSONParser();
            return (JSONArray) parser.parse(new InputStreamReader(inputStream, "UTF-8"));
        } catch (Exception e) {
            System.err.println("❌ JSON 읽기 실패: " + path);
            e.printStackTrace();
            return new JSONArray();
        }
    }

    // JSON 파일을 JSONObject로 읽기
    public static JSONObject readJsonObject(String path) {
        try {
            ClassPathResource resource = new ClassPathResource(path);
            InputStream inputStream = resource.getInputStream();
            JSONParser parser = new JSONParser();
            return (JSONObject) parser.parse(new InputStreamReader(inputStream, "UTF-8"));
        } catch (Exception e) {
            System.err.println("❌ JSON 읽기 실패: " + path);
            e.printStackTrace();
            return new JSONObject();
        }
    }
}
