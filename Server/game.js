const express = require('express');
const db = require('./db');
const axios = require('axios');

const router = express.Router();

router.get('/gameindate', async (req, res) => {
    const { date } = req.query;
    const options = {
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

    try {
        const response = await axios.request(options);
        let games = response.data.events;

        const leagues = ['AFC Asian Cup', 'English Premier League', 'Spanish La Liga', 'Italian Serie A', 'German Bundesliga', 'French Ligue 1'];
        games = games.filter(game => leagues.includes(game.strLeague));

        let gameDetails = [];
        for (const game of games) {
            const [homeTeamRows] = await db.execute('SELECT team_name, team_image FROM team WHERE id = ?', [game.idHomeTeam]);
            const [awayTeamRows] = await db.execute('SELECT team_name, team_image FROM team WHERE id = ?', [game.idAwayTeam]);

            gameDetails.push({
                dateEvent: game.dateEvent,
                homeTeamName: homeTeamRows[0].team_name,
                homeTeamImage: homeTeamRows[0].team_image,
                awayTeamName: awayTeamRows[0].team_name,
                awayTeamImage: awayTeamRows[0].team_image
            });
        }

        res.json(gameDetails);
    } catch (error) {
        console.error('Error fetching matches:', error.message);
        res.status(500).send('Internal Server Error');
    }
});



module.exports = router;