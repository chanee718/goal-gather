const express = require('express');
const mysql = require('mysql');
const app = express();

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '[tmdcks03]',
  database: 'example'
});

db.connect((err) => {
  if (err) {
    console.log('MySQL 연결 오류:', err);
    throw err;
  }
  console.log('MySQL에 연결되었습니다.');
});

// 사용자 목록을 가져오는 엔드포인트
app.get('/users', (req, res) => {
  db.query('SELECT * FROM tb_example', (err, result) => {
    if (err) throw err;
    res.json(result);
  });
});

// 새로운 사용자 추가 엔드포인트
app.post('/users', (req, res) => {
  const { email, password } = req.body;
  const query = 'INSERT INTO tb_example (email, password) VALUES (?, ?)';
  db.query(query, [email, password], (err, result) => {
    if (err) throw err;
    res.json({ message: '사용자가 추가되었습니다.', userId: result.insertId });
  });
});

app.listen(3000, () => {
  console.log('서버가 3000번 포트에서 실행 중입니다.');
});