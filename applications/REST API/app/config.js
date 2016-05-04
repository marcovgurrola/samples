//Default database
const CONN_STRING = 'postgres://postgres@localhost/postgres';
//Custom database: market_research
//const CONN_STRING = 'postgres://user:password@localhost/market_research';

const PUBLISH_INT = 10000;
const PORT = 80;
const MAX_LISTENERS = 100;

exports.CONN_STRING = CONN_STRING;
exports.PUBLISH_INT = PUBLISH_INT;
exports.PORT = PORT;
exports.MAX_LISTENERS = MAX_LISTENERS;
