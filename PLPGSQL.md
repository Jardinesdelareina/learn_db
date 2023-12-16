# pl/pgSQL

<b>pl/pgSQL</b> (PostgreSQL's procedural language) отличается от обычного SQL тем, что это полноценный язык программирования, специально разработанный для использования в PostgreSQL. В отличие от SQL, который предназначен для работы с данными и манипуляции с ними, pl/pgSQL позволяет создавать хранимые процедуры и функции, которые могут содержать условия, циклы, переменные, операции присваивания, обработку исключений и другие конструкции, характерные для программирования.

pl/pgSQL расширяет возможности базы данных PostgreSQL, предоставляя следующий функционал:
* Выполнение сложных операций и логики, включая условные операторы, циклы и обработку ошибок.
* Использование переменных для хранения промежуточных результатов и промежуточных данных.
* Создание функций, которые могут принимать аргументы и возвращать значения.
* Возможность оперировать с данными внутри хранимых процедур, включая выборку, модификацию и вставку данных.
* Доступ к системным функциям и возможность выполнения дополнительных операций, таких как работа с файлами или сетью.
* Поддержка транзакций и обработки параллельных запросов.

В целом, pl/pgSQL обеспечивает более гибкую и мощную функциональность в сравнении с обычным SQL, позволяя создавать более сложные и динамические программы внутри базы данных.

Синтаксис функции на pl/pgSQL:
```sql
CREATE OR REPLACE FUNCTION calc_sum(a INTEGER, b INTEGER) 
        RETURNS INTEGER AS $$
    DECLARE 
        sum INTEGER;    -- Объявление переменной
    BEGIN
        sum := a + b;   -- Присвоение значения переменной
    RETURN
        sum;            -- Возвращение переменной (функция calc_sum() возвращает переменную sum) 
    END
$$ LANGUAGE plpgsql;

SELECT calc_sum(5, 3);  -- Вызов функции
```

### SETOF

Ключевое слово <b>SETOF</b> в функциях SQL указывает, что функция возвращает набор значений, то есть результатом функции будет таблица или набор строк. В примере функция вернет набор значений типа users (что является таблицей, или, иначе говоря в данной ситуации - пользовательским типом данных):
```sql
CREATE FUNCTION get_users() 
        RETURNS SETOF users AS $$
    BEGIN
    RETURN QUERY SELECT * FROM users;
    END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_users();      -- Возвращает все значения из таблицы users
```

### IF ELSE

Условная конструкция, синтаксис функций pl/pgSQL:
```sql
CREATE OR REPLACE FUNCTION check_grade(grade NUMERIC) 
        RETURNS TEXT AS $$
    DECLARE
        result TEXT;
    BEGIN
        IF grade >= 90 THEN
            result := 'A';
        ELSEIF grade >= 80 THEN     -- Допустимый синтаксис ELSIF и ELSEIF
            result := 'B';
        ELSIF grade >= 70 THEN
            result := 'C';
        ELSE
            result := 'F';
        END IF;
        
        RETURN result;
    END;
$$ LANGUAGE plpgsql;
```