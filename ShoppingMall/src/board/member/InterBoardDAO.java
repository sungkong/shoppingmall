package board.member;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface InterBoardDAO {

	List<BoardVO> selectPagingMember(Map<String, String> paraMap) throws SQLException;

	int getTotalPage(Map<String, String> paraMap) throws SQLException;


}
