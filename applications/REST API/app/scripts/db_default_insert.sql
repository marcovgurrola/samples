
-- ============================================================================
--Description:  Database Structure and test data
--Author:       Marco Vinicio Gurrola Paco
--Created:      05 Feb 2016
--Modified:		05 Feb 2016
-- ============================================================================

\c postgres

/*****************************************************************************/
\echo '***********************************************************************'
\echo '*********                                                     *********'
\echo '*********  Creating Market Research Tables (overwrite mode).  *********'
\echo '*********                                                     *********'
\echo '***********************************************************************'
/*****************************************************************************/

DROP TABLE IF EXISTS visit;

DROP TABLE IF EXISTS deliverable;
DROP TABLE IF EXISTS report_analysis;
DROP TABLE IF EXISTS dataset_desc_answer;
DROP TABLE IF EXISTS dataset_desc_question;
DROP TABLE IF EXISTS dataset_desc;
DROP TABLE IF EXISTS answer;
DROP TABLE IF EXISTS respondent;
DROP TABLE IF EXISTS question;
DROP TABLE IF EXISTS section_subject;
DROP TABLE IF EXISTS survey_subject;
DROP TABLE IF EXISTS condition;
DROP TABLE IF EXISTS questionnarie_section;
DROP TABLE IF EXISTS questionnarie_survey;
DROP TABLE IF EXISTS questionnarie;
ALTER TABLE IF EXISTS section DROP CONSTRAINT FK_briefing_id;
ALTER TABLE IF EXISTS briefing DROP CONSTRAINT FK_section_id;
DROP TABLE IF EXISTS section;
DROP TABLE IF EXISTS briefing;
DROP TABLE IF EXISTS party_survey;
DROP TABLE IF EXISTS country_survey;
DROP TABLE IF EXISTS survey;
DROP TABLE IF EXISTS subject_classif;
DROP TABLE IF EXISTS party;
DROP TABLE IF EXISTS country;
DROP TABLE IF EXISTS type_cat;
DROP TABLE IF EXISTS method_cat;
DROP TABLE IF EXISTS registration_cat;
DROP TABLE IF EXISTS organisation_cat;
DROP TABLE IF EXISTS channel_cat;
DROP TABLE IF EXISTS availability_cat;
DROP TABLE IF EXISTS entity_cat;
DROP TABLE IF EXISTS deliverable_cat;
DROP TABLE IF EXISTS question_type;

/*****************************************************************************/
\echo '- visit: stores/time information about clients connections.......'
/*****************************************************************************/
CREATE TABLE visit
(
	date 	VARCHAR(50) NOT NULL
);

/*****************************************************************************/
\echo '- channel_cat: codes stating the ways used to collect responses........'
/*****************************************************************************/
CREATE TABLE channel_cat
(
	id 		INT PRIMARY KEY	NOT NULL,
	code	VARCHAR(20)		NOT NULL
);
INSERT INTO channel_cat (id, code)
VALUES (1, 'Phone');
INSERT INTO channel_cat (id, code)
VALUES (2, 'PDA');
INSERT INTO channel_cat (id, code)
VALUES (3, 'Paper');
INSERT INTO channel_cat (id, code)
VALUES (4, 'Web');
INSERT INTO channel_cat (id, code)
VALUES (5, 'Capi');

/*****************************************************************************/
\echo '- organisation_cat: codes informing how the Survey was organised.......'
/*****************************************************************************/
CREATE TABLE organisation_cat
(
	id 		INT PRIMARY KEY	NOT NULL,
	code	VARCHAR(20)		NOT NULL
);
INSERT INTO organisation_cat (id, code)
VALUES (1, 'Omnibus');
INSERT INTO organisation_cat (id, code)
VALUES (2, 'ad-hoc');
INSERT INTO organisation_cat (id, code)
VALUES (3, 'syndicated');

/*****************************************************************************/
\echo '- registration_cat: codes stating the method used to records results...'
/*****************************************************************************/
CREATE TABLE registration_cat
(
	id 		INT PRIMARY KEY	NOT NULL,
	code	VARCHAR(20)		NOT NULL
);
INSERT INTO registration_cat (id, code)
VALUES (1, 'Self completion');
INSERT INTO registration_cat (id, code)
VALUES (2, 'F2F interview');
INSERT INTO registration_cat (id, code)
VALUES (3, 'Group discussion');
INSERT INTO registration_cat (id, code)
VALUES (4, 'Observation');
INSERT INTO registration_cat (id, code)
VALUES (5, 'Registration');

/*****************************************************************************/
\echo '- method_cat: codes of types of methods applicable for the Survey......'
/*****************************************************************************/
CREATE TABLE method_cat
(
	id 		INT PRIMARY KEY	NOT NULL,
	code	VARCHAR(20)	NOT NULL
);
INSERT INTO method_cat (id, code)
VALUES (1, 'Qualitative');
INSERT INTO method_cat (id, code)
VALUES (2, 'Quantitative');

/*****************************************************************************/
\echo '- type_cat: codes stating the type of Market Survey....................'
/*****************************************************************************/
CREATE TABLE type_cat
(
	id 		INT PRIMARY KEY	NOT NULL,
	code 	VARCHAR(30)	NOT NULL
);
INSERT INTO type_cat (id, code)
VALUES (1, 'Product test');
INSERT INTO type_cat (id, code)
VALUES (2, 'Segmentation');
INSERT INTO type_cat (id, code)
VALUES (3, 'Customer satisfaction');
INSERT INTO type_cat (id, code)
VALUES (4, 'Advertising effect');
INSERT INTO type_cat (id, code)
VALUES (5, 'Media coverage');

/*****************************************************************************/
\echo '- country: where a party resides or a survey has relevance.............'
/*****************************************************************************/
CREATE TABLE country
(
	code	CHAR(2) PRIMARY KEY	NOT NULL
);
INSERT INTO country (code)
VALUES ('SP');
INSERT INTO country (code)
VALUES ('BR');
INSERT INTO country (code)
VALUES ('MX');

/*****************************************************************************/
\echo '- availability_cat: codes stating conditions related to availability...'
/*****************************************************************************/
CREATE TABLE availability_cat
(
	id 		INT PRIMARY KEY	NOT NULL,
	type	VARCHAR(30) NOT NULL	
);
INSERT INTO availability_cat (id, type)
VALUES (1, 'Publicly available');
INSERT INTO availability_cat (id, type)
VALUES (2, 'Available to owner only');
INSERT INTO availability_cat (id, type)
VALUES (3, 'Not available');
INSERT INTO availability_cat (id, type)
VALUES (4, 'May be purchased');

/*****************************************************************************/
\echo '- entity_cat: types of deliverables....................................'
/*****************************************************************************/
CREATE TABLE entity_cat
(
	id 		INT PRIMARY KEY	NOT NULL,
	type	VARCHAR(20) NOT NULL	
);
INSERT INTO entity_cat (id, type)
VALUES (1, 'Survey');
INSERT INTO entity_cat (id, type)
VALUES (2, 'Questionnarie');
INSERT INTO entity_cat (id, type)
VALUES (3, 'Section');
INSERT INTO entity_cat (id, type)
VALUES (4, 'Question');
INSERT INTO entity_cat (id, type)
VALUES (5, 'Deliverable');

/*****************************************************************************/
\echo '- deliverable_cat: types of deliverable objects........................'
/*****************************************************************************/
CREATE TABLE deliverable_cat
(
	id 		INT PRIMARY KEY	NOT NULL,
	value	VARCHAR(30) NOT NULL	
);
INSERT INTO deliverable_cat (id, value)
VALUES (1, 'Data set');
INSERT INTO deliverable_cat (id, value)
VALUES (2, 'Reports and analysis');
INSERT INTO deliverable_cat (id, value)
VALUES (3, 'Questionnaire');
INSERT INTO deliverable_cat (id, value)
VALUES (4, 'Individual questions');

/*****************************************************************************/
\echo '- question_type: states the types of question..........................'
/*****************************************************************************/
CREATE TABLE question_type
(
	id 		INT PRIMARY KEY	NOT NULL,
	type	VARCHAR(20) NOT NULL	
);
INSERT INTO question_type (id, type)
VALUES (1, 'Single/multi answer');
INSERT INTO question_type (id, type)
VALUES (2, 'Multiple choice');
INSERT INTO question_type (id, type)
VALUES (3, 'Closed/open');

/*****************************************************************************/
\echo '- party: entities that own or conduct the Market Survey................'
/*****************************************************************************/
CREATE TABLE party
(
	id 			SERIAL PRIMARY KEY	NOT NULL,
	name 		VARCHAR(50),
	address 	TEXT,
	residence	char(2) REFERENCES country(code)
);
INSERT INTO party (name, address, residence)
VALUES ('Barcelona Economics Institute', 'Carrier del Example 102', 'SP');
INSERT INTO party (name, address, residence)
VALUES ('Brasilia Economics Foundation', 'SMPW Quadra 26 Casa B', 'BR');
INSERT INTO party (name, address, residence)
VALUES ('Mexico City Economics Center', 'Chapultepec 603', 'MX');
INSERT INTO party (name, address, residence)
VALUES ('Catalan Markets', 'Plaza Catalunya 803', 'SP');
INSERT INTO party (name, address, residence)
VALUES ('Candango Moveis', '108 Sul Loja 50', 'BR');
INSERT INTO party (name, address, residence)
VALUES ('Tlaloc Bank', 'Periferico Norte 205', 'MX');

/*****************************************************************************/
\echo '- survey: Market Survey data...........................................'
/*****************************************************************************/
CREATE TABLE survey
(
	id 					SERIAL PRIMARY KEY NOT NULL,
	description 		TEXT,
	time_fieldwork		INTERVAL,
	target_group_desc	VARCHAR(50),
	sample_size			INT,
	channel_id			INT REFERENCES channel_cat(id),
	organisation_id		INT REFERENCES organisation_cat(id),
	registration_id		INT REFERENCES registration_cat(id),
	method_id			INT REFERENCES method_cat(id),
	type_id				INT REFERENCES type_cat(id),
	conducted_by		INT REFERENCES party(id),
	time_series			BOOLEAN
);
INSERT INTO survey (description, time_fieldwork, target_group_desc,
	sample_size, channel_id, organisation_id, registration_id, method_id,
	type_id, conducted_by, time_series)
VALUES ('Purchasing power of the youth', '6 days', 'Youth from 18 to 30',
	1000, 4, 2, 1, 1, 1, 4, FALSE);
INSERT INTO survey (description, time_fieldwork, target_group_desc,
	sample_size, channel_id, organisation_id, registration_id, method_id,
	type_id, conducted_by, time_series)
VALUES ('Family Expenses per per month', '10 days', 'Families with 5 members',
	2000, 3, 2, 5, 2, 2, 5, FALSE);
INSERT INTO survey (description, time_fieldwork, target_group_desc,
	sample_size, channel_id, organisation_id, registration_id, method_id,
	type_id, conducted_by, time_series)
VALUES ('Effective advertising for the elder', '20 days', 'Elder population',
	3000, 1, 2, 4, 1, 4, 6, FALSE);

/*****************************************************************************/
\echo '- party_survey: relation of parties and owned surveys..................'
/*****************************************************************************/
CREATE TABLE party_survey
(
	party_id 	INT REFERENCES party(id) NOT NULL,
	survey_id 	INT REFERENCES survey(id) NOT NULL,
	PRIMARY KEY	(party_id, survey_id)
);
INSERT INTO party_survey (party_id, survey_id)
VALUES (1, 1);
INSERT INTO party_survey (party_id, survey_id)
VALUES (1, 2);
INSERT INTO party_survey (party_id, survey_id)
VALUES (1, 3);
INSERT INTO party_survey (party_id, survey_id)
VALUES (2, 1);
INSERT INTO party_survey (party_id, survey_id)
VALUES (2, 2);
INSERT INTO party_survey (party_id, survey_id)
VALUES (2, 3);
INSERT INTO party_survey (party_id, survey_id)
VALUES (3, 1);
INSERT INTO party_survey (party_id, survey_id)
VALUES (3, 2);
INSERT INTO party_survey (party_id, survey_id)
VALUES (3, 3);

/*****************************************************************************/
\echo '- country_survey: relation of relevance of surveys per countries.......'
/*****************************************************************************/
CREATE TABLE country_survey
(
	country_code 	CHAR(2) REFERENCES country(code) NOT NULL,
	survey_id 		INT REFERENCES survey(id) NOT NULL,
	PRIMARY KEY	(country_code, survey_id)
);
INSERT INTO country_survey (country_code, survey_id)
VALUES ('SP', 1);
INSERT INTO country_survey (country_code, survey_id)
VALUES ('SP', 2);
INSERT INTO country_survey (country_code, survey_id)
VALUES ('SP', 3);
INSERT INTO country_survey (country_code, survey_id)
VALUES ('BR', 1);
INSERT INTO country_survey (country_code, survey_id)
VALUES ('BR', 2);
INSERT INTO country_survey (country_code, survey_id)
VALUES ('BR', 3);
INSERT INTO country_survey (country_code, survey_id)
VALUES ('MX', 1);
INSERT INTO country_survey (country_code, survey_id)
VALUES ('MX', 2);
INSERT INTO country_survey (country_code, survey_id)
VALUES ('MX', 3);

/*****************************************************************************/
\echo '- briefing: short information about a Market Survey or a section of it.'
/*****************************************************************************/
CREATE TABLE briefing
(
	id 				SERIAL PRIMARY KEY	NOT NULL,
	description		VARCHAR(100) NOT NULL,
	survey_id 		INT REFERENCES survey(id) NOT NULL,
	section_id 		INT
);
INSERT INTO briefing (description, survey_id)
VALUES ('Research to get insights about the Purchasing power of the youth', 1);
INSERT INTO briefing (description, survey_id)
VALUES ('Study about the monthly family expenses', 2);
INSERT INTO briefing (description, survey_id)
VALUES ('Effective advertising strategies for the elder population', 3);

/*****************************************************************************/
\echo '- section: Grouping of some questions relevant for a Survey............'
/*****************************************************************************/
CREATE TABLE section
(
	id 				SERIAL PRIMARY KEY NOT NULL,
	description		VARCHAR(50) NOT NULL,
	briefing_id 	INT
);
ALTER TABLE briefing ADD CONSTRAINT FK_section_id FOREIGN KEY (section_id)
REFERENCES section (id) MATCH SIMPLE;
ALTER TABLE section ADD CONSTRAINT FK_briefing_id FOREIGN KEY (briefing_id)
REFERENCES briefing (id) MATCH SIMPLE;
INSERT INTO section (description)
VALUES ('Personal data');
INSERT INTO section (description)
VALUES ('Purchasing power');
INSERT INTO section (description)
VALUES ('Monthly expenses');
INSERT INTO section (description)
VALUES ('Advertising preferences');

/*****************************************************************************/
\echo '- questionnarie: Collections of all questions relevant for a Survey....'
/*****************************************************************************/
CREATE TABLE questionnarie
(
	id 				SERIAL PRIMARY KEY NOT NULL,
	description		VARCHAR(100)
);
INSERT INTO questionnarie (description)
VALUES ('Purchasing power information');
INSERT INTO questionnarie (description)
VALUES ('Family expenses information');
INSERT INTO questionnarie (description)
VALUES ('Advertising strategies information');

/*****************************************************************************/
\echo '- questionnarie_survey: relation of questionnaries and surveys.........'
/*****************************************************************************/
CREATE TABLE questionnarie_survey
(
	questionnarie_id 	INT REFERENCES questionnarie(id) NOT NULL,
	survey_id 			INT REFERENCES survey(id) NOT NULL,
	PRIMARY KEY	(questionnarie_id, survey_id)
);
INSERT INTO questionnarie_survey (questionnarie_id, survey_id)
VALUES (1, 1);
INSERT INTO questionnarie_survey (questionnarie_id, survey_id)
VALUES (2, 2);
INSERT INTO questionnarie_survey (questionnarie_id, survey_id)
VALUES (3, 3);

/*****************************************************************************/
\echo '- questionnarie_section: relation of questionnaries and sections.......'
/*****************************************************************************/
CREATE TABLE questionnarie_section
(
	questionnarie_id 	INT REFERENCES questionnarie(id) NOT NULL,
	section_id 			INT REFERENCES section(id) NOT NULL,
	PRIMARY KEY	(questionnarie_id, section_id)
);
INSERT INTO questionnarie_section (questionnarie_id, section_id)
VALUES (1, 1);
INSERT INTO questionnarie_section (questionnarie_id, section_id)
VALUES (2, 1);
INSERT INTO questionnarie_section (questionnarie_id, section_id)
VALUES (3, 1);
INSERT INTO questionnarie_section (questionnarie_id, section_id)
VALUES (1, 2);
INSERT INTO questionnarie_section (questionnarie_id, section_id)
VALUES (2, 3);
INSERT INTO questionnarie_section (questionnarie_id, section_id)
VALUES (3, 4);

/*****************************************************************************/
\echo '- condition: requisites to turn an entity into a deliverable...........'
/*****************************************************************************/
CREATE TABLE condition
(
	id 				SERIAL PRIMARY KEY NOT NULL,
	description		TEXT NOT NULL,
	availability_id	INT REFERENCES availability_cat(id) NOT NULL,
	entity_type		INT REFERENCES entity_cat(id) NOT NULL,
	entity_id		INT NOT NULL
);
INSERT INTO condition (description, availability_id, entity_type, entity_id)
VALUES ('General Policy', 1, 1, 1);
INSERT INTO condition (description, availability_id, entity_type, entity_id)
VALUES ('General Policy', 1, 1, 2);
INSERT INTO condition (description, availability_id, entity_type, entity_id)
VALUES ('General Policy', 1, 1, 3);
INSERT INTO condition (description, availability_id, entity_type, entity_id)
VALUES ('Data of the surveyed completed', 1, 1, 1);
INSERT INTO condition (description, availability_id, entity_type, entity_id)
VALUES ('Data of the surveyed completed', 1, 1, 2);
INSERT INTO condition (description, availability_id, entity_type, entity_id)
VALUES ('Data of the surveyed completed', 1, 1, 3);
INSERT INTO condition (description, availability_id, entity_type, entity_id)
VALUES ('Purchasing power survey contract', 4, 1, 1);
INSERT INTO condition (description, availability_id, entity_type, entity_id)
VALUES ('Family expenses survey contract', 4, 1, 2);
INSERT INTO condition (description, availability_id, entity_type, entity_id)
VALUES ('Advertising strategies survey contract', 4, 1, 3);

/*****************************************************************************/
\echo '- subject_classif: subjects relevant to surveys, sections, questions...'
/*****************************************************************************/
CREATE TABLE subject_classif
(
	value 	CHAR(2) PRIMARY KEY NOT NULL
);
INSERT INTO subject_classif (value)
VALUES ('PP');
INSERT INTO subject_classif (value)
VALUES ('FE');
INSERT INTO subject_classif (value)
VALUES ('AS');

/*****************************************************************************/
\echo '- survey_subject: relation of surveys and subject classifications......'
/*****************************************************************************/
CREATE TABLE survey_subject
(
	value		CHAR(2) REFERENCES subject_classif(value) NOT NULL,
	survey_id 	INT REFERENCES survey(id) NOT NULL,
	PRIMARY KEY	(value, survey_id)
);
INSERT INTO survey_subject (value, survey_id)
VALUES ('PP', 1);
INSERT INTO survey_subject (value, survey_id)
VALUES ('FE', 2);
INSERT INTO survey_subject (value, survey_id)
VALUES ('AS', 3);

/*****************************************************************************/
\echo '- section_subject: relation of sections and subject classifications....'
/*****************************************************************************/
CREATE TABLE section_subject
(
	value		CHAR(2) REFERENCES subject_classif(value) NOT NULL,
	section_id 	INT REFERENCES section(id) NOT NULL,
	PRIMARY KEY	(value, section_id)
);

/*****************************************************************************/
\echo '- question: individual questions.......................................'
/*****************************************************************************/
CREATE TABLE question
(
	id 					SERIAL PRIMARY KEY NOT NULL,
	type_id				INT REFERENCES question_type(id) NOT NULL,
	question			TEXT NOT NULL,
	resp_alternatives	TEXT,
	section_id			INT REFERENCES section(id) NOT NULL
);
INSERT INTO question (type_id, question, section_id)
VALUES (3, 'How old are you?', 1);
INSERT INTO question (type_id, question, section_id)
VALUES (3, 'What is your maximum education grade', 1);
INSERT INTO question (type_id, question, section_id)
VALUES (3, 'Are you employeed?', 1);
INSERT INTO question (type_id, question, section_id)
VALUES (3, 'What is your total monthly income?', 2);
INSERT INTO question (type_id, question, section_id)
VALUES (3, 'What are your total montlhy expenses', 2);
INSERT INTO question (type_id, question, section_id)
VALUES (3, 'What percentage of your income you save on a bank account?', 2);
INSERT INTO question (type_id, question, section_id)
VALUES (3, 'How many children you have?', 3);
INSERT INTO question (type_id, question, section_id)
VALUES (3, 'What are their ages?', 3);
INSERT INTO question (type_id, question, section_id)
VALUES (3, 'Any children with a special condition or disease?', 3);
INSERT INTO question (type_id, question, section_id)
VALUES (3, 'By which mediums you use to receive more advertisements?', 4);
INSERT INTO question (type_id, question, section_id)
VALUES (3, 'Do you use to buy products after receiving any advertisement?', 4);
INSERT INTO question (type_id, question, section_id)
VALUES (3, 'What is your favorite way of purchasing items ot services?', 4);

/*****************************************************************************/
\echo '- respondent: individuals providing the answers........................'
/*****************************************************************************/
CREATE TABLE respondent
(
	id 	SERIAL PRIMARY KEY NOT NULL
);
INSERT INTO respondent(id) VALUES(DEFAULT);
INSERT INTO respondent(id) VALUES(DEFAULT);
INSERT INTO respondent(id) VALUES(DEFAULT);

/*****************************************************************************/
\echo '- answer: answers to a given questions.................................'
/*****************************************************************************/
CREATE TABLE answer
(
	id 				SERIAL PRIMARY KEY NOT NULL,
	value			TEXT NOT NULL,
	question_id 	INT REFERENCES question(id) NOT NULL,
	respondent_id 	INT REFERENCES respondent(id)
);
INSERT INTO answer (value, question_id, respondent_id)
VALUES ('20', 1, 1);
INSERT INTO answer (value, question_id, respondent_id)
VALUES ('Bachelor degree', 2, 1);
INSERT INTO answer (value, question_id, respondent_id)
VALUES ('Yes', 3, 1);
INSERT INTO answer (value, question_id, respondent_id)
VALUES ('33', 1, 2);
INSERT INTO answer (value, question_id, respondent_id)
VALUES ('Master degree', 2, 2);
INSERT INTO answer (value, question_id, respondent_id)
VALUES ('Yes', 3, 2);
INSERT INTO answer (value, question_id, respondent_id)
VALUES ('70', 1, 3);
INSERT INTO answer (value, question_id, respondent_id)
VALUES ('Phd', 2, 3);
INSERT INTO answer (value, question_id, respondent_id)
VALUES ('Retired', 3, 3);
INSERT INTO answer (value, question_id, respondent_id)
VALUES ('2000€', 4, 1);
INSERT INTO answer (value, question_id, respondent_id)
VALUES ('1500€', 5, 1);
INSERT INTO answer (value, question_id, respondent_id)
VALUES ('10%', 6, 1);
INSERT INTO answer (value, question_id, respondent_id)
VALUES ('2', 7, 2);
INSERT INTO answer (value, question_id, respondent_id)
VALUES ('1 and 2 year old', 8, 2);
INSERT INTO answer (value, question_id, respondent_id)
VALUES ('No', 9, 2);
INSERT INTO answer (value, question_id, respondent_id)
VALUES ('Email', 10, 3);
INSERT INTO answer (value, question_id, respondent_id)
VALUES ('Rarely', 11, 3);
INSERT INTO answer (value, question_id, respondent_id)
VALUES ('Online stores', 12, 3);

/*****************************************************************************/
\echo '- dataset_desc: description of a data set that may be available as a...'
\echo '  result of a Market Survey............................................'
/*****************************************************************************/
CREATE TABLE dataset_desc
(
	id 						SERIAL PRIMARY KEY NOT NULL,
	raw						BOOLEAN NOT NULL,
	adjustment_desc			TEXT,
	format					INT REFERENCES deliverable_cat(id),
	subject_classif_val		CHAR(2) REFERENCES subject_classif(value) NOT NULL
);
INSERT INTO dataset_desc (raw, format, subject_classif_val)
VALUES (TRUE, 1, 'PP');
INSERT INTO dataset_desc (raw, format, subject_classif_val)
VALUES (TRUE, 1, 'FE');
INSERT INTO dataset_desc (raw, format, subject_classif_val)
VALUES (TRUE, 1, 'AS');

/*****************************************************************************/
\echo '- dataset_desc_question: relation of dataset descriptions/questions....'
/*****************************************************************************/
CREATE TABLE dataset_desc_question
(
	dataset_desc_id 	INT REFERENCES dataset_desc(id) NOT NULL,
	question_id 		INT REFERENCES question(id) NOT NULL,
	PRIMARY KEY	(dataset_desc_id, question_id)
);

/*****************************************************************************/
\echo '- dataset_desc_answer: relation of dataset descriptions/answers........'
/*****************************************************************************/
CREATE TABLE dataset_desc_answer
(
	dataset_desc_id 	INT REFERENCES dataset_desc(id) NOT NULL,
	answer_id 			INT REFERENCES answer(id) NOT NULL,
	PRIMARY KEY	(dataset_desc_id, answer_id)
);

/*****************************************************************************/
\echo '- report_analysis: description of a report or analysis that may be ....'
\echo '  available as a result of a Market Survey.............................'
/*****************************************************************************/
CREATE TABLE report_analysis
(
	id 				SERIAL PRIMARY KEY	NOT NULL,
	value			TEXT NOT NULL,
	dataset_desc_id	INT REFERENCES section(id) NOT NULL,
	section_id		INT REFERENCES section(id) NOT NULL
);


/*****************************************************************************/
\echo '- deliverable: identifiable piece that may be made available as the ...'
\echo '  result of a Market Survey............................................'
/*****************************************************************************/
CREATE TABLE deliverable
(
	id 					SERIAL PRIMARY KEY	NOT NULL,
	description			TEXT NOT NULL,
	data 				JSON NOT NULL,
	type				INT REFERENCES deliverable_cat(id) NOT NULL,
	survey_id			INT REFERENCES survey(id) NOT NULL
);
INSERT INTO deliverable (description, data, type, survey_id)
VALUES ('Data about Purchasing Power of the youth', '[{}]', 1, 1);
INSERT INTO deliverable (description, data, type, survey_id)
VALUES ('Data about Family Expenses per month', '[{}]', 1, 2);
INSERT INTO deliverable (description, data, type, survey_id)
VALUES ('Data about Effective Advertising for the Elder', '[{}]', 1, 3);


\echo '----------------------------- SCRIPT  END -----------------------------'

