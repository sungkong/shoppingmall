package product.model;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface InterProductDAO_JDH {

	// 할인값 가져오기
	// int discount_price() throws SQLException;

	// 상품리스트
	List<HashMap<String, Object>> productList(String sort_code) throws SQLException;
	
	// 상품관리 리스트 가져오기
	List<HashMap<String, Object>> mProductList(Map<String,String>searchMap) throws SQLException;

	// 상품 입고하기
	int PlusProduct(Map<String, String> pmMap) throws SQLException;
	
	// 상품 폐기하기
	int MinusProduct(Map<String, String> mmMap) throws SQLException;

	// 상품 결과 검색
	List<HashMap<String, Object>> cProductList(Map<String,String> cSearchMap) throws SQLException;

	// 상품관리 정렬방식
	List<HashMap<String, Object>> selectOrderbyProd(Map<String, String> searchMap) throws SQLException;

	// 카테고리 삭제
	int deleteCategory(Map<String, String> sortMap) throws SQLException;

	


	
	

	
}
