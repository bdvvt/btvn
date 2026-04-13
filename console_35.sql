CREATE TABLE accounts (
                          account_id SERIAL PRIMARY KEY,
                          customer_name VARCHAR(100),
                          balance NUMERIC(12,2)
);

CREATE TABLE transactions (
                              trans_id SERIAL PRIMARY KEY,
                              account_id INT REFERENCES accounts(account_id),
                              amount NUMERIC(12,2),
                              trans_type VARCHAR(20), -- WITHDRAW / DEPOSIT
                              created_at TIMESTAMP DEFAULT NOW()
);
INSERT INTO accounts (customer_name, balance) VALUES
                                                  ('A', 500),
                                                  ('B', 300);

CREATE OR REPLACE PROCEDURE withdraw_money(
    p_account_id INT,
    p_amount NUMERIC
)
    LANGUAGE plpgsql
AS $$
DECLARE
    v_balance NUMERIC;
BEGIN

    SELECT balance INTO v_balance
    FROM accounts
    WHERE account_id = p_account_id
        FOR UPDATE;

    IF v_balance IS NULL THEN
        RAISE EXCEPTION 'Tài khoản không tồn tại!';
    END IF;

    IF v_balance < p_amount THEN
        RAISE EXCEPTION 'Không đủ tiền!';
    END IF;
    UPDATE accounts
    SET balance = balance - p_amount
    WHERE account_id = p_account_id;

    INSERT INTO transactions (account_id, amount, trans_type)
    VALUES (p_account_id, p_amount, 'WITHDRAW');

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
$$;
CALL withdraw_money(1, 100);