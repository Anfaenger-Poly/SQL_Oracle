SELECT *
  FROM A_OUT_M
 WHERE BRAND_CD = '1001'
   AND OUTBOUND_DATE = TO_DATE('20230103', 'YYYY-MM-DD');

SELECT *
  FROM A_OUT_M
 WHERE BRAND_CD = '1001'
    OR OUTBOUND_DATE = TO_DATE('20230103', 'YYYY-MM-DD');
    
SELECT BRAND_CD, INVOICE_NO, OUTBOUND_DATE, OUT_TYPE_DIV, ORDER_NM
  FROM A_OUT_M
 WHERE BRAND_CD = '1001'
   AND OUT_TYPE_DIV  IN ('M11', 'M12')
   AND OUTBOUND_DATE BETWEEN TO_DATE('20230104', 'YYYY-MM-DD') AND 
                             TO_DATE('20230105', 'YYYY-MM-DD')
   AND INVOICE_NO    LIKE    '#0%';

SELECT BRAND_CD, INVOICE_NO, OUTBOUND_DATE, OUT_TYPE_DIV, ORDER_NM
  FROM A_OUT_M
 WHERE BRAND_CD = '1001'
   AND OUT_TYPE_DIV IN ('M11', 'M12')
   AND OUTBOUND_DATE BETWEEN TO_DATE('20230104', 'YYYY-MM-DD') AND
                             TO_DATE('20230105', 'YYYY-MM-DD')
   AND INVOICE_NO LIKE '#0%'
 ORDER BY OUT_TYPE_DIV ASC, OUTBOUND_DATE DESC;
 
SELECT ITEM_CD
  FROM A_OUT_D
 WHERE BRAND_CD IN ('1001', '2001')
   AND ORDER_QTY BETWEEN 1 AND 2
   GROUP BY ITEM_CD
   ORDER BY ITEM_CD;
   
SELECT DISTINCT ITEM_CD
  FROM A_OUT_D
 WHERE BRAND_CD IN ('1001', '2001')
   AND ORDER_QTY BETWEEN 1 AND 2
 GROUP BY ITEM_CD;


SELECT ITEM_CD, SUM(ORDER_QTY)
  FROM A_OUT_D
 GROUP BY ITEM_CD
 ORDER BY ITEM_CD ASC;

--Day4
--1-1 브랜드별 인보이스 수는 각각 몇 개인가?
SELECT BRAND_CD, COUNT(DISTINCT INVOICE_NO)
  FROM A_OUT_D
 GROUP BY BRAND_CD;
 
SELECT BRAND_CD, COUNT(INVOICE_NO)
  FROM A_OUT_M
 GROUP BY BRAND_CD;

--1-2 1001 브랜드의 주문에서 A 상품의 총 주문수량은 몇 개인가?
SELECT BRAND_CD, SUM(ORDER_QTY)
  FROM A_OUT_D
 WHERE BRAND_CD = '1001'
   AND ITEM_CD = 'A'
 GROUP BY BRAND_CD;
 
SELECT SUM(ORDER_QTY)
  FROM A_OUT_D
 WHERE BRAND_CD = '1001'
   AND ITEM_CD = 'A';

--1-3 1월 3일에 주문한 각 브랜드/상품별 총 주문수량은 몇 개인가?
SELECT D.BRAND_CD, M.OUTBOUND_DATE, D.ITEM_CD, SUM(D.ORDER_QTY) AS ORDER_QTY
  FROM A_OUT_D D, A_OUT_M M
 WHERE D.BRAND_CD = M.BRAND_CD 
   AND D.INVOICE_NO = M.INVOICE_NO
   AND M.OUTBOUND_DATE = '20230103'
 GROUP BY D.BRAND_CD, M.OUTBOUND_DATE, D.ITEM_CD
 ORDER BY D.BRAND_CD ASC, D.ITEM_CD ASC;
 
SELECT M2.BRAND_CD, M2.ITEM_CD, SUM(M2.ORDER_QTY)
    FROM A_OUT_M M1
        JOIN A_OUT_D M2 ON M2.BRAND_CD = M1.BRAND_CD
                        AND M2.INVOICE_NO = M1.INVOICE_NO
    WHERE M1.OUTBOUND_DATE = '2023-01-03'
    GROUP BY M2.BRAND_CD, M2.ITEM_CD
    ORDER BY M2.BRAND_CD, M2.ITEM_CD;

SELECT BRAND_CD, ITEM_CD, SUM(ORDER_QTY) AS 총_주문수량
  FROM A_OUT_D
 WHERE (BRAND_CD, INVOICE_NO) IN (
                                  SELECT BRAND_CD, INVOICE_NO
                                    FROM A_OUT_M
                                   WHERE OUTBOUND_DATE = '2023-01-03'
                                  )
 GROUP BY BRAND_CD, ITEM_CD
 ORDER BY BRAND_CD, ITEM_CD;
--2-1 주문마스터 표에 있는 모든 정보를 표시해 줘
SELECT *
  FROM A_OUT_M;
  
--2-2 주문디테일 표에 있는 모든 정보를 표시해 줘
SELECT *
  FROM A_OUT_D;
  
--2-3 상품 마스터 표에 있는 모든 정보를 표시해 줘
SELECT *
  FROM A_ITEM;
  
--3-1 1월 3일에 주문한 주문마스터 정보를 표시해 줘
SELECT *
  FROM A_OUT_M
 WHERE OUTBOUND_DATE = DATE '2023-01-03';

--3-2 1월 4일에 김민기가 주문한 주문마스터 정보를 표시해 줘
SELECT *
  FROM A_OUT_M
 WHERE OUTBOUND_DATE = DATE '2023-01-04' 
   AND ORDER_NM = '김민기';
   
--3-3 A상품을 주문한 주문디테일 정보를 표시해 줘
SELECT *
  FROM A_OUT_D
 WHERE ITEM_CD = 'A';
 
--3-4 C상품을 3개 이상 주문한 주문디테일 정보를 표시해 줘
SELECT *
  FROM A_OUT_D
 WHERE ITEM_CD = 'C'
   AND ORDER_QTY >= 3;
   
--3-5 1001 브랜드가 보유하고 있는 상품마스터 정보를 표시해 줘
SELECT *
  FROM A_ITEM
 WHERE BRAND_CD = '1001'
 ORDER BY ITEM_CD ASC;
 
--4-1 1월 3일 또는 1월 사일에 주문한 주문의 [브랜드], [인보이스], [주문자명]을 표시해 줘
SELECT BRAND_CD, INVOICE_NO, OUTBOUND_DATE, ORDER_NM
  FROM A_OUT_M
 WHERE OUTBOUND_DATE = DATE '2023-01-03'
    OR OUTBOUND_DATE = DATE '2023-01-04'
 ORDER BY OUTBOUND_DATE;
 
--4-2 1001 브랜드에서 A상품 또는 B상품 또는 C상품을 3개 이상 주문한 주문의 [브랜드], 
--    [인보이스], [상품코드], [주문수량]을 표시해 줘
SELECT BRAND_CD, INVOICE_NO, ITEM_CD, ORDER_QTY
  FROM A_OUT_D
 WHERE BRAND_CD = '1001'
   AND ITEM_CD IN ('A', 'B', 'C')
   AND ORDER_QTY >= 3;

--5-1 1월 1일에서 1월 4일 사이의 주문 중에 윤현수 또는 김민기 라는 사람이 주문한 주문의 [브랜드], [인보이스], [출고일자],
--    [주문자]를 표시해 줘
SELECT BRAND_CD, INVOICE_NO, OUTBOUND_DATE, ORDER_NM
  FROM A_OUT_M
 WHERE OUTBOUND_DATE BETWEEN DATE '2023-01-01' AND '2023-01-04'
   AND ORDER_NM IN ('윤현수', '김민기');
  
--5-2 인보이스 #01번부터 #05번 사이의 주문 중에 A상품 또는 B 상품 또는 C상품을 3개 이상 주문한 주문의 [브랜드],
--    [인보이스], [상품코드], [주문수량]을 표시해 줘!
SELECT BRAND_CD, INVOICE_NO, ITEM_CD, ORDER_QTY
  FROM A_OUT_D
 WHERE INVOICE_NO BETWEEN '#01' AND '#05'
   AND ITEM_CD IN ('A', 'B', 'C')
   AND ORDER_QTY >= 3;
   
--6-1 인보이스 #01번부터 #05번 사이의 주문 중에 전씨 또는 권씨 성을 가진 사람이 주문한 주문의 [브랜드], [인보이스],
--    [출고일자], [주문자]를 표시해 줘
SELECT BRAND_CD, INVOICE_NO, OUTBOUND_DATE, ORDER_NM
  FROM A_OUT_M
 WHERE INVOICE_NO BETWEEN '#01' AND '#05'
   AND (ORDER_NM LIKE '전%' OR ORDER_NM LIKE '권%');
   
--6-2 인보이스가 #0으로 시작하고 주문수량이 3이상인 주문의 [브랜드], [인보이스], [상품코드], [주문수량]을 표시해 줘
SELECT BRAND_CD, INVOICE_NO, ITEM_CD, ORDER_QTY
  FROM A_OUT_D
 WHERE INVOICE_NO LIKE '#0%'
   AND ORDER_QTY >= 3;
   
--Day 5
--1-1 인보이스가 #0으로 시작하고 주문수량이 3이상인 주문의 [브랜드], [인보이스], [상품코드], [주문수량]을 표시하되,
--     주문수량이 많은 것부터 먼저 표시해 줘
SELECT BRAND_CD, INVOICE_NO, ITEM_CD, ORDER_QTY
  FROM A_OUT_D
 WHERE INVOICE_NO LIKE '#0%'
   AND ORDER_QTY >= 3
 ORDER BY ORDER_QTY DESC;
 
--1-2 인보이스가 #0으로 시작하고 주문수량이 3이상인 주문의 [브랜드], [인보이스], [상품코드], [주문수량]을 표시하되,
--    주문수량이 많은 것부터 먼저 표시하고, 수량이 동일하면 상품코드의 오름차순으로 정렬해 줘
SELECT BRAND_CD, INVOICE_NO, ITEM_CD, ORDER_QTY
  FROM A_OUT_D
 WHERE INVOICE_NO LIKE '#0%'
   AND ORDER_QTY >= 3
 ORDER BY ORDER_QTY DESC, ITEM_CD ASC;
 
--1-3 위의 결과를 기준으로 TOP3까지만 표시해 줘
SELECT *
  FROM (SELECT BRAND_CD, INVOICE_NO, ITEM_CD, ORDER_QTY
          FROM A_OUT_D
         WHERE INVOICE_NO LIKE '#0%'
           AND ORDER_QTY >= 3
         ORDER BY ORDER_QTY DESC, ITEM_CD ASC
        )
 WHERE ROWNUM <= 3;
 
--2-1 1월 3일부터 1월 4일 사이에 브랜드 구분없이 총 몇 개의 인보이스를 출고시켰는지 가르쳐 줘
SELECT COUNT(INVOICE_NO)
  FROM A_OUT_M
 WHERE OUTBOUND_DATE BETWEEN DATE '2023-01-03' AND DATE '2023-01-04';
 
SELECT SUM(CNT)
  FROM (
        SELECT BRAND_CD, COUNT(*) AS CNT
          FROM A_OUT_M
         WHERE OUTBOUND_DATE BETWEEN DATE '2023-01-03' AND DATE '2023-01-04'
         GROUP BY BRAND_CD
        );
        
--2-2 1001 브랜드는 총 몇 개의 주문수량을 출고시켰는지 가르쳐 줘
SELECT BRAND_CD, SUM(ORDER_QTY)
  FROM A_OUT_D
 WHERE BRAND_CD = '1001'
 GROUP BY BRAND_CD;
 
SELECT SUM(ORDER_QTY)
  FROM A_OUT_D
 WHERE BRAND_CD = '1001';
 
SELECT COUNT(ORDER_QTY), SUM(ORDER_QTY)
  FROM A_OUT_D
 WHERE BRAND_CD = '1001';
 
--3-1 [브랜드]별로 몇 개씩의 인보이스를 처리했는지 가르쳐 줘
SELECT BRAND_CD, COUNT(*) AS INVOICE_CNT
  FROM A_OUT_M
 GROUP BY BRAND_CD;
 
--3-2 [브랜드]&[출고일자]별로 몇 개씩의 인보이스를 처리했는지 가르쳐 줘
SELECT BRAND_CD, OUTBOUND_DATE, COUNT(*) AS INVOICE_CNT
  FROM A_OUT_M
 GROUP BY BRAND_CD, OUTBOUND_DATE
 ORDER BY BRAND_CD ASC, OUTBOUND_DATE ASC;
 
--3-3 [브랜드]별로 몇 개씩의 주문수량을 출고시켰어?
SELECT BRAND_CD, SUM(ORDER_QTY) AS TOTAL
  FROM A_OUT_D
 GROUP BY BRAND_CD;
 
--3-4 [브랜드]&[상품]별로 몇 개씩의 주문수량을 출고시켰어?
SELECT BRAND_CD, ITEM_CD, SUM(ORDER_QTY) AS TOTAL
  FROM A_OUT_D
 GROUP BY BRAND_CD, ITEM_CD
 ORDER BY BRAND_CD, ITEM_CD;
 
--3-5 [브랜드]별로 주문수량 중에서 가장 많이 주문한 수량과 가장 적게 주문한 수량은 몇 개인지 가르쳐 줘
SELECT BRAND_CD
      ,MAX(ORDER_QTY) AS MAX
      ,MIN(ORDER_QTY) AS MIN
  FROM A_OUT_D
 GROUP BY BRAND_CD;

--3-6 실전문제 1 다양한 조건절 적용하기 + 정렬하기
SELECT INVOICE_NO, OUTBOUND_DATE, OUT_TYPE_DIV, OUT_BOX_DIV, OUT_BOX_NM
  FROM LO_OUT_M
 WHERE OUTBOUND_DATE BETWEEN DATE '2019-09-01' AND DATE '2019-09-02'
   AND OUT_TYPE_DIV IN ('M15', 'M22')
   AND OUT_BOX_DIV LIKE 'F%'
   AND ORDER_PLACE = 52685
 ORDER BY OUTBOUND_DATE, INVOICE_NO;
 
--3-7 실전문제 2 집계함수 적용하기 + 정렬하기
SELECT TO_CHAR(OUTBOUND_DATE, 'YYYY-MM-DD') AS OUTBOUND_DATE
      ,COUNT(OUT_BOX_DIV) AS TOT_CNT
      ,COUNT(DISTINCT OUT_BOX_DIV) AS OUT_BOX_CNT
      ,MIN(OUT_BOX_DIV) AS OUT_BOX_MIN
      ,MAX(OUT_BOX_DIV) AS OUT_BOX_MAX
  FROM LO_OUT_M
 WHERE OUTBOUND_DATE BETWEEN '2019-09-01' AND '2019-09-02'
   AND OUT_TYPE_DIV IN ('M15', 'M22')
   AND OUT_BOX_DIV LIKE 'F%'
   AND ORDER_PLACE = 52685
 GROUP BY OUTBOUND_DATE;

--Day 6
--1-1 출고일자가 1월 3일인 인보이스에 대한 주문디테일 정보를 표시해 줘
SELECT *
  FROM A_OUT_D
 WHERE (BRAND_CD, INVOICE_NO) IN (
                                  SELECT BRAND_CD, INVOICE_NO
                                    FROM A_OUT_M
                                   WHERE OUTBOUND_DATE = DATE '2023-01-03'
                                  );
                                  
--1-2 1001 브랜드이고 출고유형이 M1로 시작하는 인보이스에 대한 주문디테일 정보를 표시해 줘
SELECT *
  FROM A_OUT_D
 WHERE (BRAND_CD, INVOICE_NO) IN (
                                  SELECT BRAND_CD, INVOICE_NO
                                    FROM A_OUT_M
                                   WHERE OUT_TYPE_DIV LIKE 'M1%'
                                     AND BRAND_CD = '1001'
                                  );
                                   
--1-3 [브랜드] & [인보이스]별로 총 주문수량이 3 이상인 인보이스 의 주문마스터 정보를 표시해 줘                                    
SELECT *
  FROM A_OUT_M
 WHERE (BRAND_CD, INVOICE_NO) IN (
                                  SELECT BRAND_CD, INVOICE_NO
                                    FROM A_OUT_D
                                   GROUP BY BRAND_CD, INVOICE_NO
                                  HAVING SUM(ORDER_QTY) >= 3
                                  );
-- ORDER BY BRAND_CD, INVOICE_NO

--2-1 [브랜드] & [상품]별 주문수량 합계를 표시하되 상품명은 스칼라쿼리를 이용해 표시해 줘
SELECT D.BRAND_CD, D.ITEM_CD, SUM(D.ORDER_QTY) AS ORDER_TOTAL
      ,(
        SELECT I.ITEM_NM
          FROM A_ITEM I
         WHERE D.BRAND_CD = I.BRAND_CD
           AND D.ITEM_CD  = I.ITEM_CD
        ) AS ITEM_NM
  FROM A_OUT_D D
 GROUP BY D.BRAND_CD, D.ITEM_CD;
 
--3-1 트랜잭션 테이블의 레코드 건수 적게 읽기
SELECT DISTINCT TO_CHAR(OUTBOUND_DATE, 'YYYY/MM/DD') AS OUTBOUND_DATE
  FROM LO_OUT_M
 WHERE OUTBOUND_DATE BETWEEN DATE '2019-06-16' AND DATE '2019-06-25'
 ORDER BY OUTBOUND_DATE;

SELECT TO_CHAR(OUTBOUND_DATE, 'YYYY/MM/DD') AS OUTBOUND_DATE
  FROM LO_OUT_M
 WHERE OUTBOUND_DATE > DATE '2019-06-15' 
   AND OUTBOUND_DATE <= DATE '2019-06-15' + 10
 GROUP BY OUTBOUND_DATE
 ORDER BY OUTBOUND_DATE;
 
SELECT DISTINCT TO_CHAR(OUTBOUND_DATE, 'YYYY-MM-DD') AS OUTBOUND_DATE
  FROM LO_OUT_M
 WHERE OUTBOUND_DATE >= DATE '2019-06-16'
   AND OUTBOUND_DATE < DATE '2019-06-26';

--4-1 스칼라쿼리를 활용한 컬럼 연계 최대값 구하기
SELECT INVOICE_NO, OUT_TYPE_DIV, OUT_BOX_DIV,
       TO_NUMBER(SUBSTR(MX, 1, 10)) AS MAX_ORDER_QTY,
       TO_NUMBER(SUBSTR(MX, 11))    AS MAX_LINE_NO
  FROM (SELECT M.INVOICE_NO, M.OUT_TYPE_DIV, M.OUT_BOX_DIV,
               (SELECT MAX(LPAD(TO_CHAR(D.ORDER_QTY), 10, '0') || LPAD(TO_CHAR(D.LINE_NO), 5, '0'))
                  FROM LO_OUT_D D
                 WHERE D.INVOICE_NO = M.INVOICE_NO) AS MX
          FROM LO_OUT_M M
         WHERE M.OUTBOUND_DATE = DATE '2019-06-03'
           AND M.OUTBOUND_NO BETWEEN 'D190603-897353' AND 'D190603-897360');
 
--Day 7
--1-1 [브랜드] & [상품]별 주문수량 합계를 표시하되, 상품명과 입수는 스칼라쿼리와 인라인뷰를 이용해 표시해 줘


--Day 8
--1-1  1001 브랜드의 주문내역을 표시하되, 출고일자에 해당하는 요일 컬럼을 추가하여 표시해 줘!
--     (OUTBOUND_DATE, DY(요일), INVOICE_NO, ORDER_NM)
SELECT BRAND_CD
      ,TO_CHAR(TO_DATE(OUTBOUND_DATE, 'YYYY-MM-DD'), 'DY') AS DY
      ,INVOICE_NO
      ,ORDER_NM
  FROM A_OUT_M
 WHERE BRAND_CD = '1001'
 ORDER BY OUTBOUND_DATE DESC;

--1-2 위의 내용에 인보이스 번호가 짝수인지 홀수인지에 대한 컬럼 을 추가하여 표시해 줘
--    (OUTBOUND_DATE, DY[요일], INVOICE_NO, EVENODD[홀/짝], ORDER_NM)
SELECT BRAND_CD
      ,TO_CHAR(TO_DATE(OUTBOUND_DATE, 'YYYY-MM-DD'), 'DY') AS DY
      ,DECODE(MOD(TO_NUMBER(LTRIM(INVOICE_NO, '#')), 2), 0, '짝', '홀') AS EVENODD
      ,ORDER_NM
  FROM A_OUT_M
 WHERE BRAND_CD = '1001'
 ORDER BY OUTBOUND_DATE DESC;
 
SELECT BRAND_CD
      ,TO_CHAR(TO_DATE(OUTBOUND_DATE, 'YYYY-MM-DD'), 'DY') AS DY
      ,INVOICE_NO
      ,CASE WHEN MOD(TO_NUMBER(LTRIM(INVOICE_NO, '#')), 2) = 0 THEN '짝' ELSE '홀' END AS EVENODD
      ,ORDER_NM
  FROM A_OUT_M
 WHERE BRAND_CD = '1001'
 ORDER BY OUTBOUND_DATE;
 
--2-1 [브랜드]별로 몇 개씩의 인보이스를 처리했는지 가르쳐 줘
SELECT BRAND_CD, COUNT(INVOICE_NO) AS INVOICE_CNT
  FROM A_OUT_M
 GROUP BY BRAND_CD;

--2-2 [브랜드] & [요일]별로 몇 개씩의 인보이스를 처리했는지 가르쳐 줘
SELECT BRAND_CD
      ,TO_CHAR(TO_DATE(OUTBOUND_DATE, 'YYYY-MM-DD'), 'DY') AS DY
      ,COUNT(INVOICE_NO) AS INVOICE_CNT
  FROM A_OUT_M
 GROUP BY BRAND_CD, TO_CHAR(TO_DATE(OUTBOUND_DATE, 'YYYY-MM-DD'), 'DY')
 ORDER BY BRAND_CD, TO_CHAR(TO_DATE(OUTBOUND_DATE, 'YYYY-MM-DD'), 'DY');
 
--2-3 [브랜드] & [인보이스 번호의 홀/짝]별로 주문수량의 합계를 가르쳐 줘
SELECT BRAND_CD
      ,CASE WHEN MOD(TO_NUMBER(LTRIM(INVOICE_NO, '#')), 2) = 0 THEN '짝' ELSE '홀' END AS EVENODD
      ,SUM(ORDER_QTY) AS TOTAL
  FROM A_OUT_D
 GROUP BY BRAND_CD, CASE WHEN MOD(TO_NUMBER(LTRIM(INVOICE_NO, '#')), 2) = 0 THEN '짝' ELSE '홀' END
 ORDER BY BRAND_CD, EVENODD;
 
--3-1 요일을 표시하는 내장함수 사용하기
SELECT INVOICE_NO
      ,TO_CHAR(OUTBOUND_DATE, 'YYYY/MM/DD') AS OUTBOUND_DATE
      ,TO_CHAR(OUTBOUND_DATE, 'DAY') AS DAYY
      ,OUTBOUND_NO
  FROM LO_OUT_M
 WHERE INVOICE_NO IN ('346724706214', '346724793596', '346724869970')
 ORDER BY OUTBOUND_DATE, INVOICE_NO;
 
--4-1 집계함수, 내장함수 응용하기
SELECT CASE WHEN COUNT(*) = 0 THEN 'Empty..' ELSE TO_CHAR(SUM(ORDER_QTY)) END AS ORDER_QTY
  FROM LO_OUT_D
 WHERE INVOICE_NO = '346724706215';
 
SELECT NVL(TO_CHAR(SUM(ORDER_QTY)), 'Empty..') AS ORDER_QTY
  FROM LO_OUT_D
 WHERE INVOICE_NO = '346724706215';

SELECT BRAND_CD, INVOICE_NO, ITEM_CD, ORDER_QTY
  FROM A_OUT_D
 WHERE ORDER_QTY >= 3
   AND INVOICE_NO LIKE '#0%'
 ORDER BY ORDER_QTY DESC, ITEM_CD ASC;
 
SELECT *
  FROM (
        SELECT BRAND_CD, INVOICE_NO, ITEM_CD, ORDER_QTY
          FROM A_OUT_D
         WHERE ORDER_QTY >= 3
           AND INVOICE_NO LIKE '#0%'
         ORDER BY ORDER_QTY DESC , ITEM_CD ASC
         )
 WHERE ROWNUM <= 3;
 
SELECT COUNT(*) AS INVOICE_CNT
  FROM A_OUT_M
 WHERE OUTBOUND_DATE BETWEEN '2023-01-03' AND '2023-01-04';
 
SELECT BRAND_CD, SUM(ORDER_QTY) AS TOTAL_QTY
  FROM A_OUT_D
 WHERE BRAND_CD = '1001'
 GROUP BY BRAND_CD;
 
SELECT BRAND_CD, COUNT(*) AS INVOICE_CNT
  FROM A_OUT_M
 GROUP BY BRAND_CD;
 
SELECT BRAND_CD, SUM(ORDER_QTY) AS SUM_QTY
  FROM A_OUT_D
 WHERE ITEM_CD = 'A'
   AND BRAND_CD = '1001'
 GROUP BY BRAND_CD;
 
SELECT *
  FROM A_OUT_M
 WHERE OUTBOUND_DATE = '2023-01-04'
   AND ORDER_NM = '김민기';
   
SELECT *
  FROM A_ITEM
 WHERE BRAND_CD = '1001';
 
SELECT BRAND_CD, INVOICE_NO, ITEM_CD, ORDER_QTY
  FROM A_OUT_D
 WHERE BRAND_CD = '1001'
   AND ITEM_CD IN ('A', 'B', 'C') 
   AND ORDER_QTY >= 3;
   
SELECT BRAND_CD, INVOICE_NO, ITEM_CD, ORDER_QTY
  FROM A_OUT_D
 WHERE INVOICE_NO LIKE '#0%'
   AND ORDER_QTY >= 3;
   
SELECT *
  FROM A_OUT_M
 WHERE (BRAND_CD, INVOICE_NO) IN (
                                  SELECT BRAND_CD, INVOICE_NO
                                    FROM A_OUT_D
                                   GROUP BY BRAND_CD, INVOICE_NO
                                  HAVING SUM(ORDER_QTY) >= 3
                                   );
 
SELECT *
  FROM A_OUT_D
 WHERE (BRAND_CD, INVOICE_NO) IN (
                                  SELECT BRAND_CD, INVOICE_NO
                                    FROM A_OUT_M
                                   WHERE OUTBOUND_DATE = '2023-01-03'
                                  );
                                  
SELECT D.BRAND_CD, D.ITEM_CD, SUM(D.ORDER_QTY) AS SUM_QTY
      ,(SELECT I.ITEM_NM
          FROM A_ITEM I
         WHERE D.BRAND_CD = I.BRAND_CD
           AND D.ITEM_CD  = I.ITEM_CD
        ) AS ITEM_NM
  FROM A_OUT_D D
 GROUP BY D.BRAND_CD, D.ITEM_CD
 ORDER BY D.BRAND_CD, D.ITEM_CD;
 
SELECT DISTINCT TO_CHAR(OUTBOUND_DATE, 'YYYY/MM/DD') AS OUTBOUND_DATE
  FROM LO_OUT_M
 WHERE OUTBOUND_DATE > DATE '2019-06-15'
   AND OUTBOUND_DATE <= DATE '2019-06-15' +10
 ORDER BY OUTBOUND_DATE;
 
 
CASE WHEN MOD(TO_NUMBER(SUBSTR(INVOICE_NO, 2)), 2) = 0 THEN '짝' ELSE '홀' END AS EVENODD
NVL(TO_CHAR(SUM(ORDER_QTY)), 'Empty..') AS ORDER_QTY
CASE WHEN MOD(TO_NUMBER(LTRIM, SUBSTR(INVOICE_NO, '#')), 2) = 0 THEN '짝' ELSE '홀' END AS EVENODD