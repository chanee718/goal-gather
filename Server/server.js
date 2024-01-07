const express = require('express');
const bodyParser = require('body-parser');
const db = require('./db');
const authRoutes = require('./auth');

const app = express();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.json()); 

app.use('/auth', authRoutes);

app.get('/users', async (req, res) => {
  try {
    const [rows, fields] = await db.execute('SELECT * FROM tb_example');
    console.log('tb_examples에서 데이터 가져감!');
    res.json(rows);
  } catch (error) {
    console.error('쿼리 실행 중 에러:', error);
    res.status(500).json({ error: '서버 오류' });
  }
});

// 새로운 사용자 추가 엔드포인트
app.post('/users', async (req, res) => {
  try {
    const { email, password } = req.body;
    const [result] = await db.execute('INSERT INTO tb_example (email, password) VALUES (?, ?)', [email, password]);
    res.json({ message: '사용자가 추가되었습니다.', userId: result.insertId });
  } catch (error) {
    console.error('쿼리 실행 중 에러:', error);
    res.status(500).json({ error: '서버 오류' });
  }
});

app.listen(3000, () => {
  console.log('서버가 3000번 포트에서 실행 중입니다.');
});