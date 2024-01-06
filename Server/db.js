const mysql = require('mysql2');

const db = mysql.createConnection({
  host: '172.10.7.58',
  user: 'root',
  password: '13818ea710D1@',
  database: 'example',
  port: 80
});

db.connect((err) => {
  if (err) {
    console.log('MySQL 연결 오류:', err);
    throw err;
  }
  console.log('MySQL에 연결되었습니다.');
});


module.exports = db.promise();