ALTER TABLE customer
ADD platinum_member BOOLEAN;

CREATE FUNCTION check_amount(_customer_id INTEGER)
RETURNS DECIMAL
LANGUAGE plpgsql
AS $MAIN$
	BEGIN
		RETURN (SELECT SUM(amount) FROM payment WHERE customer_id = _customer_id);
END;
$MAIN$ 

CREATE PROCEDURE Plat (
	cust INTEGER,
	spent DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN

	UPDATE customer
	SET platinum_member = True
	WHERE customer_id = cust and spent <= check_amount(cust);
	
	UPDATE customer
	SET platinum_member = False
	WHERE customer_id = cust and spent > check_amount(cust); 
	
	COMMIT;
	
END;
$$

SELECT SUM(amount), customer_id
FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC;

--Plat Memeber
CALL Plat(148, 200.00);

SELECT platinum_member
FROM customer
WHERE customer_id = 148;

--NonPlat Member
CALL Plat(178, 200.00);

SELECT platinum_member
FROM customer
WHERE customer_id = 178;



