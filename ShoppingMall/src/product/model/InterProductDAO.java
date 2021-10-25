package product.model;

import java.sql.SQLException;
import java.util.*;

public interface InterProductDAO {

	// 모든 카테고리 불러오기
	List<SortVO> AllSort() throws SQLException;

	// 모든 상품 불러오기
	List<ProductVO> AllProduct() throws SQLException;

	// 상품등록하기
	int insertProd(Map<String, Object> paraMap) throws SQLException;
	
	// 상품 리스트
	List<HashMap<String, Object>> productList(String sort_code) throws SQLException;
   
	// 광고(배너) 이미지(상품 top_image)
	String adimg(String sort_code) throws SQLException;
   
	// 카테고리 이름(중간 카테고리 이름설정)
	String categoryName(String sort_code) throws SQLException;

	// 상품정보 update
	int updateProd(Map<String, Object> paraMap) throws SQLException;

	// 타이틀이미지 update
	int updateTitle(List<String> titleimglist, String prod_code) throws SQLException;

	// 상세이미지 update
	int updateDetail(List<String> detailimglist, String prod_code) throws SQLException;

}
