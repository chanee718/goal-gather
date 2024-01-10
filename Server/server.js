const express = require('express');
const bodyParser = require('body-parser');
const db = require('./db');
const authRoutes = require('./auth');
const chatRoutes = require('./chat');
const storeRoutes = require('./store');
const gameRoutes = require('./game');
const teamRoutes = require('./team');

const app = express();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.json()); 

app.use('/auth', authRoutes);
app.use('/chat', chatRoutes);
app.use('/store', storeRoutes);
app.use('/game', gameRoutes);
app.use('/team', teamRoutes);


app.use(express.static(__dirname + '/public/uploads'));

//특정 email을 받았을 때 그 email을 가진 user의 data를 돌려주는 query
app.get('/users', async (req, res) => {   
  const email = req.query.email;
  try {
    const [rows, fields] = await db.execute('SELECT * FROM users WHERE user_email = ?', [email]);
    console.log('users에서 데이터 가져감!');
    res.json(rows);
  } catch (error) {
    console.error('쿼리 실행 중 에러:', error);
    res.status(500).json({ error: '서버 오류' });
  }
});


app.listen(3000, () => {
  console.log('서버가 3000번 포트에서 실행 중입니다.');
});