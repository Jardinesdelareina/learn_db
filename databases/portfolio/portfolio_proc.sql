-- Создание портфеля
CREATE OR REPLACE PROCEDURE ms.create_portfolio(
    input_title VARCHAR(200), 
    input_is_published BOOLEAN,
    input_user_id INT
    ) AS $$
    INSERT INTO ms.portfolios(title, is_published, fk_user_id)
    VALUES(input_title, input_is_published, input_user_id);
$$ LANGUAGE sql;


-- Создание транзакции
CREATE OR REPLACE PROCEDURE ms.create_transaction(
    input_action_type VARCHAR(4),
    input_quantity REAL,
    input_portfolio_id INT,
    input_currency_id INT
    ) AS $$
    INSERT INTO ms.transactions(action_type, quantity, fk_portfolio_id, fk_currency_id)
    VALUES(input_action_type, input_quantity, input_portfolio_id, input_currency_id);
$$ LANGUAGE sql;