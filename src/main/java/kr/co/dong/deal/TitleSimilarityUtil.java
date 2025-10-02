package kr.co.dong.deal;

import org.apache.commons.text.similarity.CosineSimilarity;
import java.util.*;

public class TitleSimilarityUtil {

	// 전처리: 카테고리, 가격, 특수문자 제거
	public static String preprocessTitle(String title) {
		if (title == null)
			return "";

		// 1. [카테고리] 제거
		title = title.replaceAll("\\[.*?\\]", " ");

		// 2. 괄호 안 가격/배송 정보 제거
		title = title.replaceAll("\\([^)]*원[^)]*\\)", " ");
		title = title.replaceAll("\\([^)]*무료[^)]*\\)", " ");
		title = title.replaceAll("\\([^)]*무배[^)]*\\)", " ");
		title = title.replaceAll("\\([^)]*KRW[^)]*\\)", " ");

		// 3. 숫자+원, KRW, 무료, 무배, 와우무료 제거
		title = title.replaceAll("[0-9,]+원", " ");
		title = title.replaceAll("KRW", " ");
		title = title.replaceAll("무배", " ");
		title = title.replaceAll("무료", " ");
		title = title.replaceAll("와우무료", " ");

		// 4. 특수문자 정리 (*, +, /, -, _, 등)
		title = title.replaceAll("[*+/\\-_=]", " ");

		// 5. 남은 괄호/대괄호 제거
		title = title.replaceAll("[\\[\\]{}()]", " ");

		// 6. 공백 정리
		return title.trim().replaceAll("\\s+", " ");
	}

	// 문자열 → 단어 빈도 맵 변환
	private static Map<CharSequence, Integer> getTermFrequency(String text) {
		Map<CharSequence, Integer> freq = new HashMap<>();
		for (String token : text.split("\\s+")) {
			if (!token.isBlank()) {
				freq.put(token, freq.getOrDefault(token, 0) + 1);
			}
		}
		return freq;
	}

	// 코사인 유사도 계산
	public static double calculateSimilarity(String title1, String title2) {
		String clean1 = preprocessTitle(title1);
		String clean2 = preprocessTitle(title2);

		if (clean1.isEmpty() || clean2.isEmpty())
			return 0.9;

		Map<CharSequence, Integer> freq1 = getTermFrequency(clean1);
		Map<CharSequence, Integer> freq2 = getTermFrequency(clean2);

		CosineSimilarity cosine = new CosineSimilarity();
		return cosine.cosineSimilarity(freq1, freq2);
	}

	// 동일 상품 여부
	public static boolean isSameProduct(String title1, String title2) {
	    double similarity = calculateSimilarity(title1, title2);
	    return similarity >= 0.9;
	}
}
