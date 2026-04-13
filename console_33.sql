

CREATE TABLE accounts (
                          account_id SERIAL PRIMARY KEY,
                          owner_name VARCHAR(100) UNIQUE,
                          balance NUMERIC(10,2) CHECK (balance >= 0)
);

INSERT INTO accounts (owner_name, balance) VALUES
                                               ('A', 500.00),
                                               ('B', 300.00);

SELECT * FROM accounts;CREATE OR REPLACE PROCEDURE transfer_money(
    p_sender VARCHAR,
    p_receiver VARCHAR,
    p_amount NUMERIC
)
    LANGUAGE plpgsql
AS $$
DECLARE
    v_sender_balance NUMERIC;
BEGIN
    -- 1. Kiểm tra số dư + khóa dòng
    SELECT balance INTO v_sender_balance
    FROM accounts
    WHERE owner_name = p_sender
        FOR UPDATE;

    IF v_sender_balance IS NULL THEN
        RAISE EXCEPTION 'Tài khoản gửi không tồn tại!';
    END IF;

    IF v_sender_balance < p_amount THEN
        RAISE EXCEPTION 'Không đủ số dư!';
    END IF;

    -- 2. Trừ tiền tài khoản gửi
    UPDATE accounts
    SET balance = balance - p_amount
    WHERE owner_name = p_sender;

    -- 3. Cộng tiền tài khoản nhận
    UPDATE accounts
    SET balance = balance + p_amount
    WHERE owner_name = p_receiver;

    -- 4. Kiểm tra tài khoản nhận
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Tài khoản nhận không tồn tại!';
    END IF;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
$$;

CALL transfer_money('A', 'B', 100);

SELECT * FROM accounts;