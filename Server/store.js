const express = require('express');
const db = require('./db');

const router = express.Router();

const axios = require('axios');

const kakaoApiKey = 'dd08afc233c178fc1597ea2404dd0c8d';

//가게 이름으로 음식점 찾기
router.get('/findwithname', async (req, res) => {
    const findkey = req.query.findkey;
    try {
        const apiUrl = 'https://dapi.kakao.com/v2/local/search/keyword.json';
    
        const response = await axios.get(apiUrl, {
          params: {
            query: `${findkey}`,
            category_group_code: 'FD6',
          },
          headers: {
            Authorization: `KakaoAK ${kakaoApiKey}`,
          },
        });
    
        const places = response.data.documents;
    
        if (places.length > 0) {
            let storeDetails = [];
            places.forEach(place => {
                storeDetails.push({
                    id: place.id,
                    place_name: place.place_name,
                    number: place.phone,
                    address: place.road_address_name,
                });
            });
            console.log(`Restaurants in ${findkey}:`);
            res.json(storeDetails);
        } else {
          console.log(`No restaurants found in ${findkey}.`);
        }
    } catch (error) {
        console.error('Error fetching data:', error.message);
        res.status(500).json({ error: '서버 오류' });
    }
  });

//가게 정보 업데이트
router.put('/updatestore', async (req, res) => {  
    const {storeid, img, menu, screen, capacity} = req.body;
    console.log(storeid);
    try {
        const changingstore = await db.execute('SELECT * FROM stores WHERE store_id = ?', [storeid]);
        
        if (changingstore.length === 0) {
            // 가게가 없는 경우 에러 처리 또는 적절한 로직 수행
            res.status(404).json({ error: '가게를 찾을 수 없음' });
            return;
        } else {
            // 가게를 찾으면 해당 가게의 정보를 업데이트
            await db.execute('UPDATE stores SET store_image = ?, mainmenu = ?, screen = ?, capacity = ?  WHERE store_id = ?', [img, menu, screen, capacity, storeid]);
            res.json({ message: '가게가 수정되었습니다.'});
            console.log('가게 정보 업데이트 완료!!!!');
        }

    } catch (error) {
        console.error('reservation 쿼리 실행 중 에러:', error);
        res.status(500).json({ error: '서버 오류' });
    }
});

//채팅방 지역의 음식점들을 찾는 기능
router.get('/findrestaurants', async (req, res) => {   
    const {chatId} = req.query;
    try {
        const [chatResult] = await db.execute('SELECT region FROM chats WHERE id = ?', [chatId]);
        if (chatResult.length === 0) {
            res.status(404).json({ error: '채팅방이 존재하지 않습니다.' });
            return;
        } else {
            const chatRegion = chatResult[0].region;
            const apiUrl = 'https://dapi.kakao.com/v2/local/search/keyword.json';
    
            const response = await axios.get(apiUrl, {
            params: {
                query: `${chatRegion}`,
                category_group_code: 'FD6',
            },
            headers: {
                Authorization: `KakaoAK ${kakaoApiKey}`,
            },
            });
        
            const places = response.data.documents;
        
            if (places.length > 0) {
                let storeDetails = [];
                places.forEach(place => {
                    storeDetails.push({
                        id: place.id,
                        place_name: place.place_name,
                        number: place.phone,
                        address: place.road_address_name,
                        category: place.category_name,
                    });
                });
                console.log(`Restaurants in ${chatRegion} returned`);
                res.json(storeDetails);
            } else {
                console.log(`No restaurants found in ${areaName}.`);
            }
        } 
    } catch (error) {
        console.error('Error fetching data:', error.message);
        res.status(500).json({ error: '서버 오류' });
    }  
  });


//유저 소유의 가게 정보를 DB에 추가
router.post('/addstore', async (req, res) => {
    const {storeid, name, number, address, image, menu, screen, capacity, owner} = req.body;
    try {
        const [result] = await db.execute('INSERT INTO stores (store_id, store_name, store_image, mainmenu, screen, capacity, owner, store_number, address) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', [storeid, name, image, menu, screen, capacity, owner, number, address]);
        res.json({ message: '가게가 추가되었습니다.', userId: result.insertId });
    } catch (error) {
        console.error('쿼리 실행 중 에러:', error);
        res.status(500).json({ error: '서버 오류' });
    }
});

//db에 들어있는 store인지 확인
router.get('/indb', async (req, res) => {   
    const {storeId} = req.query;
    try {
        const [storeResult] = await db.execute('SELECT * FROM stores WHERE store_id = ?', [storeId]);
        const containDB = storeResult.length != 0;  // db에 포함되어 있으면 true, 아니면 false
    
        res.json({ containDB });
    } catch (error) {
        console.error('Error fetching data:', error.message);
        res.status(500).json({ error: '서버 오류' });
    }  
  });

//유저 소유의 store을 불러오는 기능
router.get('/mystore', async (req, res) => {   
    const {email} = req.query;
    try {
        const [storeResult] = await db.execute('SELECT * FROM stores WHERE owner = ?', [email]);
        console.log('내 소유의 가게 목록');
        res.json(storeResult);
    } catch (error) {
        console.error('Error fetching data:', error.message);
        res.status(500).json({ error: '서버 오류' });
    }  
  });


module.exports = router;