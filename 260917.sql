-- 데이터베이스 실무_5주차

-- 브랜드, 상품별 주문수량 합계를 표시하되 상품명은 스칼라쿼리를 이용해 표시해라
-- 메인쿼리의 레코드 수 만큼 서브쿼리 실행
SELECT BRAND_CD, ITEM_CD, SUM(ORDER_QTY)
      ,(SELECT S1.ITEM_NM
          FROM A_ITEM S1
         WHERE S1.BRAND_CD = M1.BRAND_CD
           AND S1.ITEM_CD = M1.ITEM_CD
       ) AS ITEM_NM
  FROM A_OUT_D M1
 GROUP BY BRAND_CD, ITEM_CD
 ORDER BY BRAND_CD, SUM(ORDER_QTY) DESC;
 
SELECT M1.BRAND_CD, M1.ITEM_CD, S1.ITEM_NM, SUM(M1.ORDER_QTY)
  FROM A_OUT_D M1
  JOIN A_ITEM S1 ON S1.BRAND_CD = M1.BRAND_CD
                AND S1.ITEM_CD  = M1.ITEM_CD
 GROUP BY M1.BRAND_CD, M1.ITEM_CD, S1.ITEM_NM
 ORDER BY M1.BRAND_CD, SUM(M1.ORDER_QTY) DESC;
 
 
SELECT OUTBOUND_DATE
  FROM LO_OUT_M
 WHERE OUTBOUND_DATE >= :OUTBOUND_DATE;


-- 2019년 6월 15일 이후 10일간의 출고일자를 중복없이 출력
SELECT DISTINCT OUTBOUND_DATE
  FROM LO_OUT_M --
  출고주문
 WHERE OUTBOUND_DATE BETWEEN TO_DATE(:OUTBOUND_DATE, 'YYYY-MM-DD') + 1 
                         AND TO_DATE(:OUTBOUND_DATE, 'YYYY-MM-DD') + 10;

-- 왜 안되는지 하나씩 확인할때는 DUAL테이블을 사용하도록 하자...
SELECT TO_DATE(:OUTBOUND_DATE, 'YYYY-MM-DD') + 1 AS FROM_DATE
      ,TO_DATE(:OUTBOUND_DATE, 'YYYY-MM-DD') + 10 AS TO_DATE
  FROM DUAL;
  
-- DISTINCT를 써도 관련된 레코드를 다 읽고 중복되는걸 표시를 안 할 뿐이다 >> 그럼 가장 효율적인게 뭘까...용?
-- EXISTS : 조건에 맞는거 하나라도 존재하냐를 검사 > 하나라도 찾으면 이후는 검사안함

-- 없는 DATA 만들기

SELECT COUNT(*), MIN(NO), MAX(NO)
  FROM CS_NO;

SELECT *
  FROM CS_NO
 WHERE NO <= 10;
 
-- 계층형 쿼리 
SELECT LEVEL AS NO
  FROM DUAL
 CONNECT BY LEVEL <= 10;

-- 필요한 레코드 형식에 맞는 집합만 뽑아내기
-- 2019년 6월 15일, 10만을 이용해 뽑아내기
SELECT TO_DATE(:OUTBOUND_DATE, 'YYYY-MM-DD') + NO AS ORG_DATE
  FROM CS_NO
 WHERE NO <= :DAYS;
 
SELECT LEVEL AS NO
  FROM DUAL
 CONNECT BY LEVEL <= :DAYS;
 
 
SELECT TO_DATE(:FROM_DATE, 'YYYY-MM-DD') + (NO - 1)
  FROM CS_NO
 WHERE NO <= TO_DATE(:TO_DATE, 'YYYY-MM-DD') - TO_DATE(:FROM_DATE, 'YYYY-MM-DD') + 1;

SELECT TO_DATE(:TO_DATE, 'YYYY-MM-DD') - TO_DATE(:FROM_DATE, 'YYYY-MM-DD')
  FROM DUAL;

-- 와우 ! 조회할게 줄어드니까 성능이 좋아짐
SELECT *
  FROM ( -- INLINE_VIEW : FROM절에 쓰는 서브쿼리
        SELECT TO_DATE(:OUTBOUND_DATE, 'YYYY-MM-DD') + NO AS ORG_DATE
         FROM CS_NO
        WHERE NO <= :DAYS
       ) M1
 WHERE EXISTS (
               SELECT *
                 FROM LO_OUT_M S1
                WHERE S1.OUTBOUND_DATE = M1.ORG_DATE
              )
;
 

-- 인라인뷰
-- 브랜드, 상품 별 주문수량 합계를 표시

-- 박스수 : 몫
-- 낱개수 : 나머지
SELECT BRAND_CD, ITEM_CD, SUM_QTY
      ,TRUNC(SUM_QTY / :QTY_IN_BOX) AS BOX_CNT
      ,MOD  (SUM_QTY , :QTY_IN_BOX) AS PCS_CNT
  FROM (-- 1단계 : 브랜드, 상품별 주문수량 합계 구하기
        SELECT BRAND_CD, ITEM_CD, SUM(ORDER_QTY) AS SUM_QTY
          FROM A_OUT_D
         GROUP BY BRAND_CD, ITEM_CD
       )
;

-- MOD() : 나머지 구하는 함수
SELECT MOD(5, 3)
  FROM DUAL;
  
SELECT MOD(ORDER_QTY, 3)
  FROM A_OUT_D;

-- 인라인뷰를 적용하여 박스수와 낱개수량을 표시
