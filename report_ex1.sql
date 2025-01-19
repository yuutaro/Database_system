-- Active: 1737172553221@@127.0.0.1@3307@myapp_database
-- レポート課題 問題1 解答用紙

-- 学籍番号と氏名を必ず記入すること
-- 学籍番号: 6322087
-- 氏名: 三笠　悠太郎

-- 注意：
-- 採点の際には提出したファイルが実行ができるかを確認します．
-- 実行エラーが発生した場合は採点できないので，必ず実行できることを確認してから提出してください．

-- 1. 準備 (変更しないでこと)
-- 既存のテーブルを削除
DROP TABLE 供給;
DROP TABLE 業者;
DROP TABLE 部品;
DROP TABLE 従業員;
DROP TABLE 部門;

-- テーブルの生成
CREATE TABLE 部門(
    部門番号 INTEGER PRIMARY KEY,
    部門名 VARCHAR(20) NOT NULL
);
CREATE TABLE 従業員(
    従業員番号 INTEGER PRIMARY KEY,
    部門番号 INTEGER REFERENCES 部門(部門番号),
    氏名 VARCHAR(20) NOT NULL,
    住所 VARCHAR(20),
    職級 INTEGER
);
CREATE TABLE 部品(
    部品番号 INTEGER PRIMARY KEY,
    部品名 VARCHAR(20) NOT NULL
);
CREATE TABLE 業者(
    業者番号 INTEGER PRIMARY KEY,
    業者名 VARCHAR(20) NOT NULL,
    住所 VARCHAR(20),
    電話番号 VARCHAR(20)
);
CREATE TABLE 供給(
    部門番号 INTEGER REFERENCES 部門(部門番号),
    部品番号 INTEGER REFERENCES 部品(部品番号),
    業者番号 INTEGER REFERENCES 業者(業者番号),
    単価 INTEGER,
    職級 INTEGER
);

-- データ例:
INSERT INTO 部門(部門番号, 部門名) VALUES (1, "総務");
INSERT INTO 部門(部門番号, 部門名) VALUES (2, "経理");
INSERT INTO 部門(部門番号, 部門名) VALUES (3, "製造");

INSERT INTO 従業員(従業員番号, 部門番号, 氏名, 住所, 職級) VALUES(1, 1, "田中次郎", "千葉県", 1);
INSERT INTO 従業員(従業員番号, 部門番号, 氏名, 住所, 職級) VALUES(2, 2, "山田一郎", "東京都", 2);
INSERT INTO 従業員(従業員番号, 部門番号, 氏名, 住所, 職級) VALUES(3, 3, "佐藤三郎", "神奈川県", 1);
INSERT INTO 従業員(従業員番号, 部門番号, 氏名, 住所, 職級) VALUES(4, 1, "四谷まるお", "東京都", 3);

INSERT INTO 部品(部品番号, 部品名) VALUES (1, "ネジ");
INSERT INTO 部品(部品番号, 部品名) VALUES (2, "金型");
INSERT INTO 部品(部品番号, 部品名) VALUES (3, "クギ");
INSERT INTO 部品(部品番号, 部品名) VALUES (4, "鉄板");

INSERT INTO 業者(業者番号, 業者名, 住所, 電話番号) VALUES(1, "日本スチール", "埼玉県", "000-000-000");
INSERT INTO 業者(業者番号, 業者名, 住所, 電話番号) VALUES(2, "あれこれ工業", "千葉県", "111-111-111");
INSERT INTO 業者(業者番号, 業者名, 住所, 電話番号) VALUES(3, "どこどこエンジニアリング", "東京都", "333-333-333");

INSERT INTO 供給(部門番号, 部品番号, 業者番号, 単価, 職級) VALUES(2, 3, 1, 1000, 1);
INSERT INTO 供給(部門番号, 部品番号, 業者番号, 単価, 職級) VALUES(3, 1, 2, 800,  1);
INSERT INTO 供給(部門番号, 部品番号, 業者番号, 単価, 職級) VALUES(1, 2, 1, 1200, 2);
INSERT INTO 供給(部門番号, 部品番号, 業者番号, 単価, 職級) VALUES(1, 1, 3, 1200, 2);
INSERT INTO 供給(部門番号, 部品番号, 業者番号, 単価, 職級) VALUES(1, 1, 2, 1050, 1);
-- ここまでが準備

-- 2. 答案
-- 問題の解答を以下の対応する番号の下に記入すること．

-- ① 部門番号1の部門に所属する従業員の氏名と住所の一覧
SELECT 氏名, 住所
FROM 従業員
WHERE 部門番号 = 1;

-- ② 山田一郎という氏名の従業員が所属する部門の部門名
SELECT 部門.部門名
FROM 部門
JOIN 従業員 ON 部門.部門番号 = 従業員.部門番号
WHERE 従業員.氏名 = '山田一郎';

-- ③ 職級が２以上の従業員が所属する部門の部門番号と部門名の一覧
SELECT DISTINCT 部門.部門番号, 部門.部門名
FROM 部門
JOIN 従業員 ON 部門.部門番号 = 従業員.部門番号
WHERE 従業員.職級 >= 2;

-- ④ 業者番号３の業者が部門番号1に部品番号1の部品を供給する単価よりも安い単価で、部品番号1の部品をいずれかの部門に供給している業者番号の一覧
SELECT DISTINCT 供給2.業者番号
FROM 供給 AS 供給1
JOIN 供給 AS 供給2 ON 供給1.部品番号 = 供給2.部品番号
WHERE 供給1.部門番号 = 1
  AND 供給1.業者番号 = 3
  AND 供給1.部品番号 = 1
  AND 供給2.単価 < 供給1.単価;

-- ⑤ 業者番号３の業者から部品の供給を受けているか、あるいは職級が3以上の従業員が所属する部門の部門番号
SELECT DISTINCT 部門番号
FROM 供給
WHERE 業者番号 = 3
UNION
SELECT DISTINCT 従業員.部門番号
FROM 従業員
WHERE 職級 >= 3;

-- ⑥ 全従業員の職級が３未満の部門の部門番号と部門名の一覧
SELECT 部門.部門番号, 部門.部門名
FROM 部門
WHERE 部門.部門番号 NOT IN (
  SELECT DISTINCT 従業員.部門番号
  FROM 従業員
  WHERE 職級 >= 3
);

-- ⑦ 部門番号２の部門に所属する従業員数
SELECT COUNT(*) AS 従業員数
FROM 従業員
WHERE 部門番号 = 2;

-- ⑧ 部門ごとの部門番号と従業員の一覧
SELECT 部門.部門番号, 部門.部門名, 従業員.氏名
FROM 部門
LEFT JOIN 従業員 ON 部門.部門番号 = 従業員.部門番号;

-- ⑨ 部品ごとの部品番号，最低単価，最高単価，平均単価をリストした一覧
SELECT 部品番号,
       MIN(単価) AS 最低単価,
       MAX(単価) AS 最高単価,
       AVG(単価) AS 平均単価
FROM 供給
GROUP BY 部品番号;

-- ⑩ 最高単価と最低単価の差が100以下の部品の部品番号，部品名，最低単価，最高単価の一覧
SELECT 部品.部品番号, 部品.部品名,
       MIN(供給.単価) AS 最低単価,
       MAX(供給.単価) AS 最高単価
FROM 部品
JOIN 供給 ON 部品.部品番号 = 供給.部品番号
GROUP BY 部品.部品番号, 部品.部品名
HAVING MAX(供給.単価) - MIN(供給.単価) <= 100;

-- ⑪ 部門番号1の部門に供給されている部品ごとの部品番号，最低単価，最高単価，平均単価をリストした一覧
SELECT 部品番号,
       MIN(単価) AS 最低単価,
       MAX(単価) AS 最高単価,
       AVG(単価) AS 平均単価
FROM 供給
WHERE 部門番号 = 1
GROUP BY 部品番号;

-- ⑫ ⑪と同様の一覧．ただし，複数の業者から供給を受けている部品に関するデータのみを含む一覧
SELECT 部品番号,
       MIN(単価) AS 最低単価,
       MAX(単価) AS 最高単価,
       AVG(単価) AS 平均単価
FROM 供給
WHERE 部門番号 = 1
GROUP BY 部品番号
HAVING COUNT(DISTINCT 業者番号) > 1;

-- ここまで