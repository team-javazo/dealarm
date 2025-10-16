package kr.co.dong.inquiry;

import java.util.List;
import javax.inject.Inject;
import org.springframework.stereotype.Service;

@Service
public class InquiryServiceImpl implements InquiryService {

    @Inject
    private InquiryDAO dao;

    @Override
    public void insert(InquiryDTO dto) { dao.insert(dto); }

    @Override
    public List<InquiryDTO> list() { return dao.list(); }

    @Override
    public InquiryDTO detail(int id) { return dao.detail(id); }

    @Override
    public void updateHit(int id) { dao.updateHit(id); }

    @Override
    public void updateStatus(int id, String status) { dao.updateStatus(id, status); }

    @Override
    public void insertAnswer(int id, String answer) { dao.insertAnswer(id, answer); }
}
