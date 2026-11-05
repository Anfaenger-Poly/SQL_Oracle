-- 조건 값(변수)에 따른 다른 정렬기준 적용하기
SELECT INVOICE_NO, LINE_NO, ITEM_CD, ITEM_NM, ORDER_QTY
  FROM LO_OUT_D
 WHERE INVOICE_NO = '346724706214'
 ORDER BY CASE WHEN :SORT_TYPE = 1 THEN LINE_NO ELSE ORDER_QTY END
         ,LINE_NO;
         
-- 1월 4일에 B상품 또는 D상품을 주문한 주문의 [브랜드], [출고일자], [인보이스], [라인번호], [주문수량]을 표시해줘
SELECT M.OUTBOUND_DATE, M.INVOICE_NO, D.LINE_NO, D.ORDER_QTY
  FROM A_OUT_M M
  JOIN A_OUT_D D ON M.BRAND_CD   = D.BRAND_CD
                AND M.INVOICE_NO = D.INVOICE_NO
 WHERE OUTBOUND_DATE = DATE '2023-01-04'
   AND ITEM_CD IN ('B', 'D');
   
-- 1월 3일에서 1월 4일 사이에 B상품 또는 D상품을 주문한 주문의 [브랜드], [출고일자], [상품코드], [주문수량 합계]를 표시해줘
SELECT M.BRAND_CD, M.OUTBOUND_DATE, D.ITEM_CD
      ,SUM(D.ORDER_QTY) AS ORDER_QTY
  FROM A_OUT_M M
  JOIN A_OUT_D D ON M.BRAND_CD   = D.BRAND_CD
                AND M.INVOICE_NO = D.INVOICE_NO
 WHERE OUTBOUND_DATE BETWEEN DATE '2023-01-03' AND DATE '2023-01-04'
   AND ITEM_CD IN ('B', 'D')
 GROUP BY M.BRAND_CD, M.OUTBOUND_DATE, D.ITEM_CD
;

-- 1001 브랜드에서 1월 4일부터 1월 5일 사이에 주문한 인보이스들 중에서 총 주문수량이 가장 많은 [인보이스], [주문자]를 가르쳐 줘
SELECT INVOICE_NO, ORDER_NM, SUM_QTY
  FROM (
        SELECT M.INVOICE_NO ,M.ORDER_NM, SUM(D.ORDER_QTY) AS SUM_QTY
          FROM A_OUT_M M
               JOIN A_OUT_D D ON M.BRAND_CD   = D.BRAND_CD
                             AND M.INVOICE_NO = D.INVOICE_NO
         WHERE M.BRAND_CD = '1001'
           AND M.OUTBOUND_DATE BETWEEN DATE '2023-01-04' AND DATE '2023-01-05'
         GROUP BY M.INVOICE_NO, M.ORDER_NM
         ORDER BY SUM_QTY DESC
         )
  WHERE ROWNUM = '1'
;

-- 1월 1일부터 1월 4일 사이에 3개 이상 주문한 상품이 있는 주문의 [브랜드], [출고일자], [인보이스], [상품코드]
-- ,[상품명], [주문수량]을 표시해줘
SELECT M1.BRAND_CD, M1.OUTBOUND_DATE, M1.INVOICE_NO, M2.ITEM_CD, M3.ITEM_NM, M2.ORDER_QTY
  FROM A_OUT_M M1
       JOIN A_OUT_D M2 ON M1.BRAND_CD = M2.BRAND_CD
                      AND M1.INVOICE_NO = M2.INVOICE_NO
       JOIN A_ITEM M3  ON M2.BRAND_CD = M3.BRAND_CD
                      AND M2.ITEM_CD  = M3.ITEM_CD
 WHERE M1.OUTBOUND_DATE BETWEEN DATE '2023-01-01' AND DATE '2023-01-04'
   AND M2.ORDER_QTY >= 3;
   
-- 1월 1일부터 1월 4일 사이에 [브랜드별] & [상품별] 주문수량 합계를 표시해줘
SELECT M1.BRAND_CD, M2.ITEM_CD, SUM(M2.ORDER_QTY) AS SUM_QTY
  FROM A_OUT_M M1
       JOIN A_OUT_D M2 ON M1.BRAND_CD   = M2.BRAND_CD
                      AND M1.INVOICE_NO = M2.INVOICE_NO  
       JOIN A_ITEM M3  ON M2.BRAND_CD   = M3.BRAND_CD
                      AND M2.ITEM_CD    = M3.ITEM_CD
 WHERE OUTBOUND_DATE BETWEEN DATE '2023-01-01' AND DATE '2023-01-04'
 GROUP BY M1.BRAND_CD, M2.ITEM_CD
 ORDER BY M1.BRAND_CD, M2.ITEM_CD
;

-- 위 결과에 인라인뷰를 적용하여 박스수, 낱개수량을 표시해 줘
SELECT BRAND_CD, ITEM_CD, ITEM_NM, QTY_IN_BOX, SUM_QTY
      ,TRUNC(SUM_QTY / QTY_IN_BOX) AS BOX_QTY  --박스수량 (몫)
      ,MOD  (SUM_QTY, QTY_IN_BOX)  AS PCS_QTY  --낱개수량 (나머지)
  FROM (
        SELECT M1.BRAND_CD, M2.ITEM_CD, M3.ITEM_NM, M3.QTY_IN_BOX, SUM(M2.ORDER_QTY) AS SUM_QTY
          FROM A_OUT_M M1
               JOIN A_OUT_D M2 ON M1.BRAND_CD   = M2.BRAND_CD
                              AND M1.INVOICE_NO = M2.INVOICE_NO  
               JOIN A_ITEM M3  ON M2.BRAND_CD   = M3.BRAND_CD
                              AND M2.ITEM_CD    = M3.ITEM_CD
         WHERE M1.OUTBOUND_DATE BETWEEN DATE '2023-01-01' AND DATE '2023-01-04'
         GROUP BY M1.BRAND_CD, M2.ITEM_CD, M3.ITEM_NM, M3.QTY_IN_BOX
        )
;

-- 위 결과에 인라인뷰를 적용하여 박스수가 가장 많은 TOP3만 표시해 줘 ROWNUM 활용
SELECT *
  FROM (--인라인뷰를 적용하여 박스수, 낱개수량을 구하고 TOP3 정렬
        SELECT BRAND_CD, ITEM_CD, ITEM_NM, QTY_IN_BOX, SUM_QTY
              ,TRUNC(SUM_QTY / QTY_IN_BOX) AS BOX_QTY  --박스수량 (몫)
              ,MOD  (SUM_QTY, QTY_IN_BOX)  AS PCS_QTY  --낱개수량 (나머지)
          FROM (--1월 1일부터 1월 4일 사이에 [브랜드별] & [상품별] 주문수량 합계를 표시해줘
                SELECT M1.BRAND_CD, M2.ITEM_CD, M3.ITEM_NM, M3.QTY_IN_BOX, SUM(M2.ORDER_QTY) AS SUM_QTY
                  FROM A_OUT_M M1
                       JOIN A_OUT_D M2 ON M1.BRAND_CD   = M2.BRAND_CD
                                      AND M1.INVOICE_NO = M2.INVOICE_NO  
                       JOIN A_ITEM M3  ON M2.BRAND_CD   = M3.BRAND_CD
                                      AND M2.ITEM_CD    = M3.ITEM_CD
                 WHERE M1.OUTBOUND_DATE BETWEEN DATE '2023-01-01' AND DATE '2023-01-04'
                 GROUP BY M1.BRAND_CD, M2.ITEM_CD, M3.ITEM_NM, M3.QTY_IN_BOX
                )
          ORDER BY BOX_QTY DESC
        )
 WHERE ROWNUM <= 3
;

-- NO TABLE
SELECT NO
      ,TRUNC(SYSDATE) + 2 * NO AS NEXT_10_DAYS
  FROM CS_NO
 WHERE NO <= 10
;

-- 원하는 만큼의 레코드를 만듦
SELECT LEVEL AS NO
  FROM DUAL
CONNECT BY LEVEL <= 10
;

SELECT NO
  FROM CS_NO
 WHERE NO <= TO_DATE('20260110', 'YYYY-MM-DD') - TO_DATE('20260101', 'YYYY-MM-DD') + 1