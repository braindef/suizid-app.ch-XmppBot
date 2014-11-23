
/*dann noch löschen, sonst sind bei einer reinstallation alle daten weg*/
DROP DATABASE IF EXISTS suicide_prevetion_app;


DROP DATABASE IF EXISTS spa;
CREATE DATABASE spa;

USE `spa` ;

/*DROP USER polar_bear;*/
DROP USER polarbear;
CREATE USER polarbear IDENTIFIED BY 'polarbear';

/*User alle rechte ausser der grant option auf die Datenbank geben*/
GRANT ALL PRIVILEGES ON spa.* TO "polarbear";


/*Tabelle artikel (ART) er..ffnen*/
CREATE TABLE supporter 
	(jid VARCHAR(40) NOT NULL,
	 name VARCHAR(20),
	 lastname VARCHAR(20),
	 street VARCHAR(40),
	 POBOX VARCHAR(8),
	 city VARCHAR(20),
	 email VARCHAR(40),
	 dateofbirth DATE,
	 
     PRIMARY KEY(jid) );

CREATE TABLE presence
	(jid VARCHAR(40) NOT NULL,
	 jid_online INT,
	 in_chat_session INT,
	 points INT,
	 daily_call_count INT,
	 daily_talk_time_minutes INT,

     PRIMARY KEY(jid) );


INSERT INTO supporter VALUES ("supporter0@ns3.ignored.ch", "marc", "landolt", "Rombachtäli 13", "5022", "Rombach", "2009@marclandolt.ch", DATE("1978-06-17"));
INSERT INTO supporter VALUES ("supporter1@ns3.ignored.ch", "marc", "landolt", "Rombachtäli 13", "5022", "Rombach", "2009@marclandolt.ch", DATE("1978-06-17"));
INSERT INTO supporter VALUES ("supporter2@ns3.ignored.ch", "marc", "landolt", "Rombachtäli 13", "5022", "Rombach", "2009@marclandolt.ch", DATE("1978-06-17"));
INSERT INTO supporter VALUES ("supporter3@ns3.ignored.ch", "marc", "landolt", "Rombachtäli 13", "5022", "Rombach", "2009@marclandolt.ch", DATE("1978-06-17"));
INSERT INTO supporter VALUES ("supporter4@ns3.ignored.ch", "marc", "landolt", "Rombachtäli 13", "5022", "Rombach", "2009@marclandolt.ch", DATE("1978-06-17"));
INSERT INTO supporter VALUES ("supporter5@ns3.ignored.ch", "marc", "landolt", "Rombachtäli 13", "5022", "Rombach", "2009@marclandolt.ch", DATE("1978-06-17"));
INSERT INTO supporter VALUES ("supporter6@ns3.ignored.ch", "marc", "landolt", "Rombachtäli 13", "5022", "Rombach", "2009@marclandolt.ch", DATE("1978-06-17"));
INSERT INTO supporter VALUES ("supporter7@ns3.ignored.ch", "marc", "landolt", "Rombachtäli 13", "5022", "Rombach", "2009@marclandolt.ch", DATE("1978-06-17"));
INSERT INTO supporter VALUES ("supporter8@ns3.ignored.ch", "marc", "landolt", "Rombachtäli 13", "5022", "Rombach", "2009@marclandolt.ch", DATE("1978-06-17"));
INSERT INTO supporter VALUES ("supporter9@ns3.ignored.ch", "marc", "landolt", "Rombachtäli 13", "5022", "Rombach", "2009@marclandolt.ch", DATE("1978-06-17"));
INSERT INTO supporter VALUES ("supporter10@ns3.ignored.ch", "marc", "landolt", "Rombachtäli 13", "5022", "Rombach", "2009@marclandolt.ch", DATE("1978-06-17"));
INSERT INTO supporter VALUES ("supporter11@ns3.ignored.ch", "marc", "landolt", "Rombachtäli 13", "5022", "Rombach", "2009@marclandolt.ch", DATE("1978-06-17"));

INSERT INTO presence VALUES ("supporter0@ns3.ignored.ch", "1", "1", "10", "1", "30");
INSERT INTO presence VALUES ("supporter1@ns3.ignored.ch", "0", "1", "10", "1", "30");
INSERT INTO presence VALUES ("supporter2@ns3.ignored.ch", "1", "0", "0", "3", "0");
INSERT INTO presence VALUES ("supporter3@ns3.ignored.ch", "0", "0", "10", "2", "60");
INSERT INTO presence VALUES ("supporter4@ns3.ignored.ch", "1", "1", "10", "1", "30");
INSERT INTO presence VALUES ("supporter5@ns3.ignored.ch", "0", "1", "10", "3", "30");
INSERT INTO presence VALUES ("supporter6@ns3.ignored.ch", "1", "0", "0", "1", "0");
INSERT INTO presence VALUES ("supporter7@ns3.ignored.ch", "0", "0", "10", "1", "60");
INSERT INTO presence VALUES ("supporter8@ns3.ignored.ch", "1", "1", "10", "3", "30");
INSERT INTO presence VALUES ("supporter9@ns3.ignored.ch", "0", "1", "10", "1", "30");
INSERT INTO presence VALUES ("supporter10@ns3.ignored.ch", "1", "0", "0", "3", "0");
INSERT INTO presence VALUES ("supporter11@ns3.ignored.ch", "0", "0", "10", "2", "60");


