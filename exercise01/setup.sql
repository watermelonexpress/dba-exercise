CREATE TABLE programmer_skills(
  programmer_name CHAR(15) NOT NULL,
  skill_name CHAR(15) NOT NULL,
  PRIMARY KEY (programmer_name, skill_name)
);

CREATE TABLE desired_skills(
  skill_name CHAR(15) NOT NULL PRIMARY KEY
);

INSERT INTO programmer_skills (programmer_name, skill_name) VALUES ('Mark', 'CSS');
INSERT INTO programmer_skills (programmer_name, skill_name) VALUES ('Harrison', 'Java');
INSERT INTO programmer_skills (programmer_name, skill_name) VALUES ('Harrison', 'Javascript');
INSERT INTO programmer_skills (programmer_name, skill_name) VALUES ('Harrison', 'CSS');
INSERT INTO programmer_skills (programmer_name, skill_name) VALUES ('Peter', 'Java');
INSERT INTO programmer_skills (programmer_name, skill_name) VALUES ('Peter', 'Javascript');
INSERT INTO programmer_skills (programmer_name, skill_name) VALUES ('Carrie', 'Ruby');
INSERT INTO programmer_skills (programmer_name, skill_name) VALUES ('Carrie', 'Java');
INSERT INTO programmer_skills (programmer_name, skill_name) VALUES ('Carrie', 'Javascript');
INSERT INTO programmer_skills (programmer_name, skill_name) VALUES ('Alec', 'Ruby');
INSERT INTO programmer_skills (programmer_name, skill_name) VALUES ('Alec', 'Java');
INSERT INTO programmer_skills (programmer_name, skill_name) VALUES ('Alec', 'Javascript');
INSERT INTO programmer_skills (programmer_name, skill_name) VALUES ('Alec', 'CSS');

INSERT INTO desired_skills (skill_name) VALUES ('Ruby');
INSERT INTO desired_skills (skill_name) VALUES ('Java');
INSERT INTO desired_skills (skill_name) VALUES ('Javascript');
