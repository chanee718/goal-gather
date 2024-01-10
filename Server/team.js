const express = require('express');
const db = require('./db');

const router = express.Router();

router.get('/allteam', async (req, res) => {
    const keyword = req.query.keyword;
    try {
        let query;
        let queryParams = [];

        if (keyword) {
            query = 'SELECT * FROM team WHERE team_name LIKE ? OR league LIKE ?';
            queryParams = [`%${keyword}%`, `%${keyword}%`];
        } else {
            query = 'SELECT * FROM teams';
        }

        const [rows] = await db.execute(query, queryParams);
        console.log('teams에서 데이터 가져감!');
        res.json(rows);
    } catch (error) {
        console.error('쿼리 실행 중 에러:', error);
        res.status(500).json({ error: '서버 오류' });
    }
});

router.get('/preferteam', async (req, res) => {
    const email = req.query.email;
    try {
        const [rows] = await db.execute('SELECT team.* FROM team JOIN users_teams ON team.id = users_teams.team_id WHERE users_teams.user_email = ?', [email]);
        console.log('유저의 prefer team 찾기');
        res.json(rows);
    } catch (error) {
        console.error('쿼리 실행 중 에러:', error);
        res.status(500).json({ error: '서버 오류' });
    }
});

module.exports = router;