package kr.co.dong.inquiry;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class InquiryServiceImpl implements InquiryService {

    @Autowired
    private InquiryDAO inquiryDAO;

    @Override
    public void insert(InquiryDTO dto) {
        inquiryDAO.insert(dto);
    }

    @Override
    public List<InquiryDTO> list() {
        return inquiryDAO.list();
    }

    @Override
    public InquiryDTO detail(int id) {
        return inquiryDAO.detail(id);
    }

    @Override
    public void updateHit(int id) {
        inquiryDAO.updateHit(id);
    }

    @Override
    public void update(InquiryDTO dto) {
        inquiryDAO.update(dto);
    }

    @Override
    public void delete(int id) {
        inquiryDAO.delete(id);
    }

    @Override
    public void updateStatus(int id, String status) {
        inquiryDAO.updateStatus(id, status);
    }

    @Override
    public void insertAnswer(int id, String answer) {
        inquiryDAO.insertAnswer(id, answer);
    }

    @Override
    public List<InquiryDTO> search(String keyword) {
        return inquiryDAO.search(keyword);
    }

    @Override
    public List<InquiryDTO> listByCategory(String category) {
        return inquiryDAO.listByCategory(category);
    }

    // ✅ 페이징 + 검색
    @Override
    public List<InquiryDTO> list(int page, String keyword) {
        int pageSize = 10;
        int offset = (page - 1) * pageSize;
        return inquiryDAO.listWithPaging(offset, pageSize, keyword);
    }

    @Override
    public int getTotalPages(String keyword) {
        int totalCount = inquiryDAO.count(keyword);
        return (int) Math.ceil((double) totalCount / 10);
    }

    @Override
    public List<InquiryDTO> listByWriter(String writer) {
        return inquiryDAO.listByWriter(writer);
    }

    @Override
    public Map<String, Integer> getStats() {
        return inquiryDAO.getStats();
    }
}
