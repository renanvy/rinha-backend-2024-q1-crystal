CREATE UNLOGGED TABLE accounts(
  id SERIAL PRIMARY KEY,
  limit_amount INT NOT NULL,
  balance INT NOT NULL DEFAULT 0,
  latest_transactions jsonb NOT NULL DEFAULT '[]'
);

DELETE FROM accounts;

DO $$
BEGIN
	INSERT INTO accounts (limit_amount, balance, latest_transactions)
	VALUES
		(1000 * 100, 0, '[]'),
		(800 * 100, 0, '[]'),
		(10000 * 100, 0, '[]'),
		(100000 * 100, 0, '[]'),
		(5000 * 100, 0, '[]');
END;
$$;
