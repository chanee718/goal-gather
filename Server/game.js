const express = require('express');
const db = require('./db');
const axios = require('axios');

const router = express.Router();

router.get('/gameindate', async (req, res) => {
    const { date } = req.query;
    const d = new Date(date); // 주어진 날짜
    d.setDate(d.getDate() - 1);
    const previousDay = d.toISOString().split('T')[0];

    const optionsT = {
        method: 'GET',
        url: 'https://www.thesportsdb.com/api/v1/json/60130162/eventsday.php',
        params: {
            d: date, // 요청된 날짜
        },
        headers: {
            'X-RapidAPI-Key': '60130162',
            'X-RapidAPI-Host': 'thesportsdb.p.rapidapi.com'
        }
    };
    const optionsY = {
        method: 'GET',
        url: 'https://www.thesportsdb.com/api/v1/json/60130162/eventsday.php',
        params: {
            d: previousDay, // 요청된 날짜
        },
        headers: {
            'X-RapidAPI-Key': '60130162',
            'X-RapidAPI-Host': 'thesportsdb.p.rapidapi.com'
        }
    };

    try {
        const responseT = await axios.request(optionsT);
        const responseY = await axios.request(optionsY);
        let gamesT = responseT.data.events;
        let gamesY = responseY.data.events;

        const leagues = ['AFC Asian Cup', 'English Premier League', 'Spanish La Liga', 'Italian Serie A', 'German Bundesliga', 'French Ligue 1'];
        gamesT = gamesT.filter(game => leagues.includes(game.strLeague));
        gamesY = gamesY.filter(game => leagues.includes(game.strLeague));

        let games = [...gamesT, ...gamesY]

        let gameDetails = [];
        for (const game of games) {
            const [homeTeamRows] = await db.execute('SELECT team_name, team_image FROM team WHERE id = ?', [game.idHomeTeam]);
            const [awayTeamRows] = await db.execute('SELECT team_name, team_image FROM team WHERE id = ?', [game.idAwayTeam]);

            const gameDateTime = new Date(game.dateEvent + 'T' + game.strTime + 'Z');
            const kstGameTime = new Date(gameDateTime.getTime() + (9 * 60 * 60 * 1000));
            const formattedTime = kstGameTime.toISOString().split('T')[1].substring(0, 5);

            if (kstGameTime.toISOString().split('T')[0] === date) {
                gameDetails.push({
                    startTime: formattedTime,
                    homeTeamName: homeTeamRows[0].team_name,
                    homeTeamImage: homeTeamRows[0].team_image,
                    awayTeamName: awayTeamRows[0].team_name,
                    awayTeamImage: awayTeamRows[0].team_image
                });
            }
        }

        res.json(gameDetails);
    } catch (error) {
        console.error('Error fetching matches:', error.message);
        res.status(500).send('Internal Server Error');
    }
});

module.exports = router;