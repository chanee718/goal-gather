const express = require('express');
const db = require('./db');

const router = express.Router();

router.post('/google-login', async (req, res) => {
  try {
    const { email, username } = req.body;

    console.log('데이터가 왔니?:', email, username);

    // 이메일이 이미 테이블에 있는지 확인
    const [rows] = await db.execute('SELECT * FROM sample_user WHERE email = ?', [email]);

    if (rows.length === 0) {
      // 이메일이 테이블에 없으면 새로운 사용자로 추가
      const [insertResult] = await db.execute('INSERT INTO sample_user (email, username, prefer_team) VALUES (?, ?, ?)', [email, username, null]);
      console.log(insertResult.insertId);
      res.json({ flag: 1 });
    } else {
      // 이미 등록된 사용자인 경우
      console.log(rows[0].user_id);
      res.json({ flag: 0});
    }
  } catch (error) {
    console.error('쿼리 실행 중 에러:', error);
    res.status(500).json({ error: '서버 오류' });
  }
});

module.exports = router;