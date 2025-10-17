package kr.co.dong.inquiry;

import java.util.List;
import javax.inject.Inject;
import org.springframework.stereotype.Service;

@Service
public class InquiryServiceImpl implements InquiryService {

    @Inject
    private InquiryDAO dao;

    @Override
    public List<InquiryDTO> list() {
        return dao.list();
    }

    @Override
    public InquiryDTO detail(int id) {
        return dao.detail(id);
    }

    @Override
    public void insert(InquiryDTO dto) {
        dao.insert(dto);
    }

    @Override
    public void update(InquiryDTO dto) {
        dao.update(dto);
    }

    @Override
    public void updateHit(int id) {
        dao.updateHit(id);
    }

    @Override
    public void insertAnswer(InquiryDTO dto) {
        dao.insertAnswer(dto);
    }

    @Override
    public void updateStatus(InquiryDTO dto) {
        dao.updateStatus(dto);
    }

    @Override
    public void delete(int id) {
        dao.delete(id);
    }
}
