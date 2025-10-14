package kr.co.dong.deal;

import java.io.File;
import java.io.InputStream;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.security.MessageDigest;
import java.util.Base64;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DealMatchServiceImpl implements DealMatchService {
    @Autowired
    private DealMatchDAO dealMatchDAO;
    
    private static final String BASE_DIR;
    
    private static final String WEB_ACCESS_PATH = "/dealarm/images/";
    
    static {
    	BASE_DIR = System.getProperty("user.home") + 
    			File.separator + "dealarm-data" +
    			File.separator + "images";
    	File dir = new File(BASE_DIR);
    	if(!dir.exists()) {
    		dir.mkdirs();
    	}
    }

	@Override
	public List<DealMatchDTO> dealMatch(String id, int offset, int limit) {
		List<DealMatchDTO> dealList = dealMatchDAO.dealMatch(id, offset, limit);
		processImageUrls(dealList);
		return dealList;
	}


	@Override
	public int deleteDeal(int matchId, String userId) {
		// TODO Auto-generated method stub
		return dealMatchDAO.deleteDeal(matchId, userId);
	}
	
	@Override
	public List<DealMatchDTO> newDeal(Map<String, Object> params) {
		List<DealMatchDTO> dealList = dealMatchDAO.newDeal(params);
		processImageUrls(dealList);
		return dealList;
	}

	private void processImageUrls(List<DealMatchDTO> dealList) {
		if (dealList == null) return;
		
		for (DealMatchDTO dto : dealList) {
			String originalUrl = dto.getImg();
			if (originalUrl != null && !originalUrl.isEmpty()) {
				String localPath = downAndGetLocalPath(originalUrl);
				dto.setImg(localPath);
			}
		}
	}


	private String downAndGetLocalPath(String remoteUrl) {
		try {
			// 1. URL 해시값 기반 고유 파일 이름 생성 
			String filename = hashUrl(remoteUrl) + getFileExtension(remoteUrl);
			Path targetPath = Paths.get(BASE_DIR, filename);
			
			// 2. 이미 파일이 로컬에 존재하면 다운로드 건너뛰고 경로 반환
			if (Files.exists(targetPath)) {
				return WEB_ACCESS_PATH + filename;
			}
			
			// 3. 이미지 다운로드
			URL url = new URL(remoteUrl);
			try (InputStream in = url.openStream()) {
				Files.copy(in, targetPath, StandardCopyOption.REPLACE_EXISTING);
			}
			
			return WEB_ACCESS_PATH + filename;
		} catch (Exception e) {
			System.err.println("Error downloading image from " + remoteUrl + ": " + e.getMessage());
			return remoteUrl;
		}
	}

	private String hashUrl(String url) throws Exception {
		MessageDigest digest = MessageDigest.getInstance("SHA-256");
		byte[] hash = digest.digest(url.getBytes("UTF-8"));
		return Base64.getUrlEncoder().withoutPadding().encodeToString(hash);
	}

	private String getFileExtension(String url) {
		try {
			String path = new URL(url).getPath();
			int lastDot = path.lastIndexOf('.');
			if (lastDot > 0) {
				return path.substring(lastDot).toLowerCase();
			}
		} catch (Exception e) {
			// TODO: handle exception
		}
		return ".jpg";
	}


	

}