const express = require('express');
const db = require('./db');

const router = express.Router();

//로그인 작업
router.post('/google-login', async (req, res) => {
  try {
    const { email, username } = req.body;

    console.log('데이터가 왔니?:', email, username);

    // 이메일이 이미 테이블에 있는지 확인
    const [rows] = await db.execute('SELECT * FROM users WHERE user_email = ?', [email]);

    if (rows.length === 0) {
      // 이메일이 테이블에 없으면 새로운 사용자로 추가
      const [insertResult] = await db.execute('INSERT INTO users (user_email, user_name, profile_image, user_type) VALUES (?, ?, ?, ?)', [email, username, null, null]);
      console.log(insertResult.insertId);
      res.json({ flag: 1 });
    } else {
      // 이미 등록된 사용자인 경우
      console.log(rows[0].user_id);
      res.json({ flag: 0 });
    }
  } catch (error) {
    console.error('쿼리 실행 중 에러:', error);
    res.status(500).json({ error: '서버 오류' });
  }
});

//유저 기본 정보 추가 기입을 위한 query
router.put('/user-edit', async (req, res) => {   
  try {
    const { email, username, profileImage, userType } = req.body;

    console.log('user edit:', email, username);

    // 이메일이 이미 테이블에 있는지 확인
    const [rows] = await db.execute('SELECT * FROM users WHERE user_email = ?', [email]);

    if (rows.length === 0) {
      // 사용자가 테이블에 없는 경우 에러 처리 또는 적절한 로직 수행
      res.status(404).json({ error: '사용자를 찾을 수 없음' });
      return;
    } else {
      // 이미 등록된 사용자인 경우
      await db.execute('UPDATE users SET user_name = ?, profile_image = ?, user_type = ? WHERE user_email = ?', [username, profileImage, userType, email]);
      console.log(rows[0].user_id);
    }
  } catch (error) {
    console.error('user edit 쿼리 실행 중 에러:', error);
    res.status(500).json({ error: '서버 오류' });
  }
});

//관심 팀 업데이트
router.put('/prefer-teams', async (req, res) => { 
  try {
    const { email, preferTeamList } = req.body;

    // 이메일이 테이블에 있는지 확인
    const [rows] = await db.execute('SELECT * FROM users WHERE user_email = ?', [email]);

    if (rows.length === 0) {
      // 사용자가 테이블에 없는 경우 에러 처리 또는 적절한 로직 수행
      res.status(404).json({ error: '사용자를 찾을 수 없음' });
      return;
    }

    // db에 저장되어 있던 prefer team list
    const existingPreferTeams = await db.execute('SELECT team_id FROM users_teams WHERE user_email = ?', [email]);  

    // 기존에 있는 선호 팀 중에서 preferTeamList에 없는 것들을 삭제
    const teamsToDelete = existingPreferTeams.map((row) => row.team_id).filter((teamId) => !preferTeamList.includes(teamId));
    for (const teamIdToDelete of teamsToDelete) {
      await db.execute('DELETE FROM users_teams WHERE user_email = ? AND team_id = ?', [email, teamIdToDelete]);
    }

    // preferTeamList에 있는 팀 중에서 기존에 없는 것들을 추가
    const teamsToAdd = preferTeamList.filter((teamId) => !existingPreferTeams.map((row) => row.team_id).includes(teamId));
    for (const teamIdToAdd of teamsToAdd) {
      await db.execute('INSERT INTO users_teams (user_email, team_id) VALUES (?, ?)', [email, teamIdToAdd]);
    }

    console.log('사용자의 관심 팀 정보 업데이트 완료');

  } catch (error) {
    console.error('선호 팀 정보 업데이트 중 에러:', error);
    res.status(500).json({ error: '서버 오류' });
  }
});

module.exports = router;