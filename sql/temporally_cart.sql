SELECT * FROM leafy.session_cart;

SET GLOBAL event_scheduler = ON;

CREATE EVENT delete_expired_data
ON SCHEDULE EVERY 1 SECOND -- Adjust the interval as needed
DO
    DELETE FROM session_cart
    WHERE updatedAt < NOW() - INTERVAL 10 SECOND -- Adjust the expiration time as needed
;

CREATE EVENT delete_expired_data
ON SCHEDULE EVERY 1 SECOND -- Adjust the interval as needed
DO
    DELETE FROM session_cart
    WHERE updatedAt < NOW() - INTERVAL 7 DAY -- Adjust the expiration time as needed
;

SHOW EVENTS from leafy;

DROP EVENT delete_expired_data;