SELECT BRAND_CD, COUNT(*) AS INV_CNT
  FROM A_OUT_M
GROUP BY BRAND_CD
ORDER BY INV_CNT DESC;

SELECT BRAND_CD, OUTBOUND_DATE, COUNT(*)
  FROM A_OUT_M
GROUP BY BRAND_CD, OUTBOUND_DATE
ORDER BY BRAND_CD, COUNT(*) DESC;

SELECT BRAND_CD, SUM(ORDER_QTY)
  FROM A_OUT_D
GROUP BY BRAND_CD
ORDER BY SUM(ORDER_QTY) DESC;

SELECT BRAND_CD, ITEM_CD, SUM(ORDER_QTY)
  FROM A_OUT_D
GROUP BY BRAND_CD, ITEM_CD
ORDER BY BRAND_CD, SUM(ORDER_QTY) DESC;

SELECT BRAND_CD, MAX(ORDER_QTY), MIN(ORDER_QTY)
  FROM A_OUT_D
 GROUP BY BRAND_CD;

SELECT OUTBOUND_DATE, OUT_TYPE_DIV, OUT_BOX_DIV, ORDER_PLACE
  FROM LO_OUT_M
 WHERE OUTBOUND_DATE BETWEEN '2019-09-01' AND '2019-09-02'
   AND OUT_TYPE_DIV IN ('M15', 'M22')
   AND OUT_BOX_DIV LIKE 'F%'
   AND ORDER_PLACE LIKE '52685'
 ORDER BY OUTBOUND_DATE, INVOICE_NO;
 
SELECT OUTBOUND_DATE
      ,COUNT(*)                    AS TOT_CNT
      ,COUNT(DISTINCT OUT_BOX_DIV) AS OUT_BOX_CNT
      ,MIN  (OUT_BOX_DIV)          AS OUT_BOX_MIN
      ,MAX  (OUT_BOX_DIV)          AS OUT_BOX_MAX
  FROM LO_OUT_M
 WHERE OUTBOUND_DATE BETWEEN '2019-09-01' AND '2019-09-02'
   AND OUT_TYPE_DIV IN ('M15', 'M22')
   AND OUT_BOX_DIV LIKE 'F%'
   AND ORDER_PLACE LIKE '52685'
 GROUP BY OUTBOUND_DATE
 ORDER BY OUTBOUND_DATE;
 
SELECT M1.OUTBOUND_DATE
      ,M1.INVOICE_NO
      ,M1.OUT_TYPE_DIV
      ,(
        SELECT SUM(S1.ORDER_QTY) AS SUM_ORDER_QTY
          FROM LO_OUT_D S1
         WHERE S1.INVOICE_NO = M1.INVOICE_NO
        ) AS SUM_QTY
  FROM LO_OUT_M M1
 WHERE M1.INVOICE_NO LIKE '3467247026%';
 
SELECT *
  FROM A_OUT_D
 WHERE (BRAND_CD, INVOICE_NO) IN (
                                  SELECT BRAND_CD, INVOICE_NO
                                    FROM A_OUT_M
                                   WHERE OUTBOUND_DATE = '2023-01-03'
                                   );

SELECT *
  FROM A_OUT_D
 WHERE (BRAND_CD, INVOICE_NO) IN (
                                  SELECT BRAND_CD, INVOICE_NO
                                    FROM A_OUT_M
                                   WHERE BRAND_CD = '1001'
                                     AND OUT_TYPE_DIV LIKE 'M1%'
                                   );
                                   
SELECT *
  FROM A_OUT_M
 WHERE (BRAND_CD, INVOICE_NO) IN (--총 주문 수량이 3 이상인 인보이스 구하기
                                  SELECT BRAND_CD, INVOICE_NO
                                    FROM A_OUT_D
                                   GROUP BY BRAND_CD, INVOICE_NO
                                  HAVING SUM(ORDER_QTY) >= 3
                                  );
 
                                   
                                   