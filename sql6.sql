DROP PROCEDURE IF EXISTS replace_user;
DELIMITER //
CREATE PROCEDURE replace_user(id_u int, OUT tran_result varchar(100))
BEGIN
	
	DECLARE _rollback BIT DEFAULT 0;
	DECLARE code varchar(100);
	DECLARE error_string varchar(100); 

	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
 		SET _rollback = 1;
 		 GET DIAGNOSTICS CONDITION 1
			code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
	END;

	START TRANSACTION;
     
	 INSERT INTO users_old (firstname, lastname, email)
	 SELECT firstname, lastname, email FROM users WHERE id = id_u;
     DELETE FROM users WHERE id = id_u;
	-- SET @last_user_id = last_insert_id();
	IF _rollback THEN
		SET tran_result = concat('УПС. Ошибка: ', code, ' Текст ошибки: ', error_string);
		ROLLBACK;
	ELSE
		SET tran_result = 'O K';
		COMMIT;
	END IF;
END;//
DELIMITER ;



DROP FUNCTION IF EXISTS hello;
DELIMITER //

CREATE FUNCTION hello()
RETURNS VARCHAR(20) DETERMINISTIC
BEGIN
   DECLARE tm int;
   DECLARE msg VARCHAR(20);
   SET tm = HOUR(NOW());
   IF tm BETWEEN 6 AND 11 THEN SET msg = 'Доброе утро!';
   ELSEIF tm BETWEEN 12 AND 17 THEN SET msg = 'Добрый день!';
   ELSEIF tm BETWEEN 18 AND 23 THEN SET msg = 'Добрый вечер!';
   ELSEIF tm BETWEEN 0 AND 5 THEN SET msg = 'Доброй ночи!';
   END IF;
   RETURN msg;
END;//
DELIMITER;