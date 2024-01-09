const express = require('express');
const db = require('./db');
const axios = require('axios');
require('dotenv').config();

const router = express.Router();
const Key = process.env.SPORTSKEY;

router.post('/insert', async (req, res) => {
    const { date } = req.body;
    console.log(date);
    const options = {
        method: 'GET',
        url: 'https://www.thesportsdb.com/api/v1/json/'+Key+'/eventsday.php',
        params: {
            d: date, // 요청된 날짜
            s: 'Soccer'
        },
        headers: {
            'X-RapidAPI-Key': Key,
            'X-RapidAPI-Host': 'thesportsdb.p.rapidapi.com'
        }
    };

    try {
        const response = await axios.request(options);
        let games = response.data.events;

        const leagues = ['AFC Asian Cup', 'English Premier League', 'Spanish La Liga', 'Italian Serie A', 'German Bundesliga', 'French Ligue 1'];
        games = games.filter(game => leagues.includes(game.strLeague));
        for (const game of games) {
            // UTC에서 KST로 변환
            const gameDateTimeUTC = new Date(game.dateEvent + 'T' + game.strTime + 'Z');
            const gameDateTimeKST = new Date(gameDateTimeUTC.getTime() + (9 * 60 * 60 * 1000));
            const gameDateKST = gameDateTimeKST.toISOString().split('T')[0];
            const gameTimeKST = gameDateTimeKST.toISOString().split('T')[1].substring(0, 5);

            // 리그명 매핑
            const leagueMapping = {
                'AFC Asian Cup': '2023 아시안 컵',
                'English Premier League': '영국 프리미어리그',
                'Spanish La Liga': '스페인 프리메라리가',
                'Italian Serie A': '이탈리아 세리에 A',
                'German Bundesliga': '독일 분데스리가',
                'French Ligue 1': '프랑스 리그 1'
            };
            const leagueName = leagueMapping[game.strLeague] || game.strLeague;
            console.log(game.idEvent);
            await db.execute('INSERT INTO games (id, home_team, away_team, game_date, league, start_time) VALUES (?, ?, ?, ?, ?, ?)', [game.idEvent, game.idHomeTeam, game.idAwayTeam, gameDateKST, leagueName, gameTimeKST]);
            
        }
    } catch (error) {
        console.error('Error fetching matches:', error.message);
        res.status(500).send('Internal Server Error');
    }
});

router.get('/indb', async (req, res) => {
    const { date } = req.query;
    try {
        const [gameResult] = await db.execute('SELECT * FROM games WHERE game_date = ?', [date]);
        const containDB = gameResult.length != 0;  // db에 포함되어 있으면 true, 아니면 false
    
        res.json({ containDB });
    } catch (error) {
        console.error('Error fetching data:', error.message);
        res.status(500).json({ error: '서버 오류' });
    }  
});

router.get('/gameindate', async (req, res) => {
    const { date } = req.query;
    try {
        const [games] = await db.execute('SELECT * FROM games WHERE game_date = ?', [date]);
        if(games.length > 0) {
            let gameDetails = [];
            for (const game of games) {
                const [homeTeamRows] = await db.execute('SELECT team_name, team_image FROM team WHERE id = ?', [game['home_team']]);
                const [awayTeamRows] = await db.execute('SELECT team_name, team_image FROM team WHERE id = ?', [game['away_team']]);

                gameDetails.push({
                    game_id: game['id'],
                    startTime: game['start_time'],
                    homeTeamName: homeTeamRows[0].team_name,
                    homeTeamImage: homeTeamRows[0].team_image,
                    awayTeamName: awayTeamRows[0].team_name,
                    awayTeamImage: awayTeamRows[0].team_image
                });
            }
            res.json(gameDetails);
        } else {
            // 채팅방이 없는 경우 에러 처리 또는 적절한 로직 수행
            res.json({ });
        }
        
    } catch (error) {
        console.error('Error fetching matches:', error.message);
        res.status(500).send('Internal Server Error');
    }
});



module.exports = router;