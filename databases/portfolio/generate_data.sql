DROP FUNCTION ms.generate_num;
CREATE OR REPLACE FUNCTION ms.generate_num(limit_num INT) RETURNS INT AS $$
    SELECT floor(random() * limit_num) + 1;
$$ LANGUAGE sql;


TRUNCATE TABLE ms.currencies CASCADE;
INSERT INTO ms.currencies(symbol, description)
VALUES('btcusdt', 'Биткоин (BTC) — первая криптовалюта, созданная при участии анонима Сатоши Накамото. В своем white paper 2008 года Биткоин описывается как одноранговые (p2p) электронные деньги, которые позволяют совершать онлайн-транзакции без участия третьей стороны, какого-либо финансового института. Сеть Биткоина была запущена 3 января 2009 года с протоколом Proof-of-Work (PoW). На сегодняшний день Биткоин является самой популярной криптовалютой, с наибольшей капитализацией.'),
('ethusdt', 'Эфир, Ether (ETH) — криптовалюта блокчейн-проекта Ethereum. Он является самой популярной open-source платформой для смарт-контрактов, токенов и децентрализованных приложений (dApps). Концепция эфириума была представлена в 2013 году Виталиком Бутериным. Сеть Ethereum была запущена 30 июля 2015 года, на данный момент ее протокол базируется на Proof-of-Work, однако существует план смены протокола на Proof-of-Stake в 2020 году при запуске Ethereum 2.0.'),
('solusdt', 'Solana — это блокчейн-платформа с открытым исходным кодом, созданная в 2017 году бывшим руководителем Qualcomm, Анатолием Яковенко. Основная цель Solana — значительно повысить масштабируемость технологии блокчейна, превысив производительность популярных блокчейнов, сохранив при этом затраты на низком уровне. Это достигается за счет гибридной модели, которая позволяет сети Solana теоретически обрабатывать более 710 000 транзакций в секунду (TPS) без необходимости использования дополнительных решений по масштабированию.'),
('xrpusdt', 'XRP — криптовалюта, которая используется платежной платформой RippleNet. Та, в свою очередь, строится на технологии распределенного реестра XRP Ledger. Цель этой криптовалюты — стать быстрым, масштабируемым трансграничным средством платежа. Впервые идея платежной платформы Ripple появилась в 2004 году, в 2012 году Джед МакКалеб и Крис Ларсон взялись ее реализовать. XRP поддерживается независимыми валидаторами, которым может теоретически стать каждый желающий.'),
('adausdt', 'Cardano (ADA) — криптовалюта децентрализованной платформы, которая разрабатывается с 2015 года на языке программирования Haskell. Основателем проекта считается Чарльз Хоскинсон, который также участвовал в создании Ethereum. Cardano была запущена в результате ICO в 2017 году. Cardano поддерживается тремя независимыми друг от друга организациями: IOHK, Cardano Foundation, Emurgo. Дорожная карта развития проекта предусматривает 5 этапов, каждый из которых привносит в сеть новые функции.'),
('avaxusdt', 'Avalanche (AVAX) представляет собой блокчейн сеть, обеспечивающую надежное функционирование смарт контрактов. Сеть предназначена для децентрализованных приложений (dApps), NFT и других сложных блокчейн-платформ.'),
('dotusdt', 'Polkadot — это протокол, который позволяет передавать любые типы данных или активов между блокчейнами. Объединяя несколько блокчейнов, Polkadot стремится достичь высокой степени безопасности и масштабируемости. DOT — это токен управления протоколом. Его можно использовать для стейкинга, чтобы защищать сеть или подключать («связывать») новые цепочки.'),
('linkusdt', 'Chainlink (LINK) — сеть-«оракул», предназначенная для объединения смарт-контрактов с реальными данными. Была основана в результате ICO в сентябре 2017 года Сергеем Назаровым и Стивом Эллисом. LINK является токеном стандарта ERC20 с функционалом ERC223. Оракулы — объекты вне сети блокчейна, которые поставляют информацию для смарт-контрактов.');


TRUNCATE TABLE ms.users CASCADE;
INSERT INTO ms.users(email, password)
SELECT
    LEFT((md5(random()::text)), 10) || '@gmail.com',
    crypt(LEFT((md5(random()::text)), 8, gen_salt('md5')))
FROM generate_series(1, 500);


TRUNCATE TABLE ms.portfolios CASCADE;
INSERT INTO ms.portfolios(title, is_published, fk_user_id)
SELECT
    LEFT((md5(random()::text)), 5),
    CASE WHEN random() < 0.1 THEN FALSE ELSE TRUE END,
    ms.generate_num(500)
FROM generate_series(1, 675);


TRUNCATE TABLE ms.transactions CASCADE;
INSERT INTO ms.transactions(action_type, quantity, fk_portfolio_id, fk_currency_id)
SELECT
    CASE WHEN random() < 0.1 THEN 'SELL' ELSE 'BUY' END,
    ms.generate_num(1000),
    ms.generate_num(675),
    ms.generate_num(8)
FROM generate_series(1, 100000);


select symbol from ms.currencies;
select * from qts.quotes;

CALL ms.create_user('fueros.dev@mail.ru', '1234');
CALL ms.create_portfolio('test portfolio', true, 1);
CALL ms.create_transaction('BUY', 3, 1, 1);
CALL ms.create_transaction('BUY', 2, 1, 1);

SELECT * FROM ms.users;
SELECT * FROM ms.portfolios WHERE fk_user_id = 1;
SELECT * FROM ms.transactions;

SELECT qts.get_price('avaxusdt');


WITH qty FROM (
    SELECT action_type, quantity, created_at, fk_portfolio_id
    FROM ms.transactions
    WHERE fk_portfolio_id = 1
    ORDER BY id
)

SELECT SUM(quantity) AS balance FROM qty;