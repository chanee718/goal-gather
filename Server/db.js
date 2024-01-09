const mysql = require('mysql2');
require('dotenv').config();

const db = mysql.createConnection({
  host: process.env.HOST,
  user: process.env.USER,
  password: process.env.PASSWORD,
  database: process.env.DATABASE,
  port: process.env.PORT
});

db.connect((err) => {
  if (err) {
    console.log('MySQL 연결 오류:', err);
    throw err;
  }
  console.log('MySQL에 연결되었습니다.');
});


module.exports = db.promise();