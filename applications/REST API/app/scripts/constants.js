/*****************************************************************************/
// Module with values used with frequency
/*****************************************************************************/
const ALL_SURVEYS ='surveys';
const BY_SUBJECT ='subject';
const BY_PARTY ='party';
const DATABASE_ERROR ='Database error';
const QUERY_ERROR ='Query_error';

const WELCOME_MESSAGE = 'Welcome to Market Research API\n\n' +

  'Usage Examples\n' +

  'To Filter by Subject, codes in the UNSPSC form:\n' +
  'PP for Purchasing Power\n' +
  'FE for Family Expenses\n' +
  'AS for Advertising strategies\n\n\n' +

  'All surveys:           /surveys\n' +
  'By subject:            /subject/:PP\n' +
  'By Conducting party:   /surveys/party/:Tlaloc\n' +
  '                       /surveys/party/:Tlaloc%20Bank\n\n\n\n'+

  'Interactive GUI        /fancy\n\n' + 
  '(Subscribed/Refresh)' +
  'Automatically unsubscribed on Page Reload\n\n\n\n' +

  "Curl, from shell terminal, base url is marketresearch.ddns.net,\n" +
  "for local test is localhost:\n" +
  "curl --request GET 'http://base_url/surveys' --include\n" +
  "curl --request GET 'http://base_url/subject/:PP' --include\n" +
  "curl --request GET 'http://base_url/surveys/party/:Tlaloc' --include\n" +
  "curl --request GET 'http://base_url/surveys/party/:Tlaloc%20Ba' --include";


const SURVEYS_QUERY = 'SELECT S.id, S.description, S.time_fieldwork, ' +
  'S.sample_size, S.target_group_desc, CC.code as channel, ' +
  'OC.code as organisation, RC.code as registration, MC.code as method, ' +
  'TC.code as type, S.time_series, PA.name as conducted_by ' +
'FROM survey S ' +
' LEFT JOIN channel_cat CC ON S.channel_id = CC.id' +
' LEFT JOIN organisation_cat OC ON S.organisation_id = OC.id' +
' LEFT JOIN registration_cat RC ON S.registration_id = RC.id' +
' LEFT JOIN method_cat MC ON S.method_id = MC.id' +
' LEFT JOIN type_cat TC ON S.type_id = TC.id' +
' LEFT JOIN party PA ON S.conducted_by = PA.id';


const SUBJECT_COND = " INNER JOIN survey_subject SS ON S.id = SS.survey_id " +
  "WHERE SS.value =  '";


const PARTY_COND = " WHERE PA.name LIKE ('%";


exports.ALL_SURVEYS = ALL_SURVEYS;
exports.BY_SUBJECT = BY_SUBJECT;
exports.BY_PARTY= BY_PARTY;
exports.DATABASE_ERROR = DATABASE_ERROR;
exports.QUERY_ERROR = QUERY_ERROR;
exports.WELCOME_MESSAGE = WELCOME_MESSAGE;
exports.SURVEYS_QUERY = SURVEYS_QUERY;
exports.SUBJECT_COND = SUBJECT_COND;
exports.PARTY_COND = PARTY_COND;