package kr.co.dong.inquiry;

import java.util.List;
import javax.inject.Inject;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

@Repository
public class InquiryDAOImpl implements InquiryDAO {

    private static final String NS = "kr.co.dong.inquiry.InquiryDAO";

    @Inject
    private SqlSession session;

    @Override
    public void insert(InquiryDTO dto) {
        session.insert(NS + ".insert", dto);
    }

    @Override
    public List<InquiryDTO> list() {
        return session.selectList(NS + ".list");
    }

    @Override
    public InquiryDTO detail(int id) {
        return session.selectOne(NS + ".detail", id);
    }

    @Override
    public void updateHit(int id) {
        session.update(NS + ".updateHit", id);
    }

    @Override
    public void updateStatus(int id, String status) {
        var param = new java.util.HashMap<String, Object>();
        param.put("id", id);
        param.put("status", status);
        session.update(NS + ".updateStatus", param);
    }

    @Override
    public void insertAnswer(int id, String answer) {
        var param = new java.util.HashMap<String, Object>();
        param.put("id", id);
        param.put("answer", answer);
        session.update(NS + ".insertAnswer", param);
    }
}
