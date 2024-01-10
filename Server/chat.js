const express = require('express');
const db = require('./db');

const router = express.Router();

//새로운 채팅 생성
// 주소: /chat/newchat
router.post('/newchat', async (req, res) => {
    const { email, game, name, img, region, capacity, auth, link } = req.body;
    try {
      const [chatResult] = await db.execute('INSERT INTO chats (creator_email, games_id, chat_name, chat_image, region, capacity, partici_auth, chat_link, reserved_store_id, reserve_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [email, game, name, img, region, capacity, auth, link, null, null]);
      const chatId = chatResult.insertId;
      await db.execute('INSERT INTO users_chats (user_email, chat_id) VALUES (?, ?)', [email, chatId]);

      console.log('채팅방이 생성되었습니다!');
      res.json({ });
    } catch (error) {
      console.error('new chat 쿼리 실행 중 에러:', error);
      res.status(500).json({ error: '서버 오류' });
    }
  });

//특정 경기의 채팅 목록 -> game id로 받아오자
// 주소: /chat/findchat
router.get('/findchat', async (req, res) => {   
    const id = req.query.id;
    try {
      const [rows] = await db.execute('SELECT chats.* FROM chats JOIN games ON chats.games_id = games.id WHERE games.id = ?', [id]);
      console.log('특정 경기의 채팅 목록');
      res.json(rows);
    } catch (error) {
      console.error('find chat 쿼리 실행 중 에러:', error);
      res.status(500).json({ error: '서버 오류' });
    }
  });
 
// 식당을 예약하면 update하자 -> 채팅방의 id와 상점 id, 예약 시간를 받아오자
// 주소: /chat/reservation
router.put('/reservation', async (req, res) => {   
    try {
      const {chatid, storeid, time} = req.body;
      const chatroom = await db.execute('SELECT * FROM chats WHERE id = ?', [chatid]);
      
      if (chatroom.length === 0) {
        // 채팅방이 없는 경우 에러 처리 또는 적절한 로직 수행
        res.status(404).json({ error: '채팅방을 찾을 수 없음' });
        return;
      } else {
        // 채팅방을 찾으면 해당 채팅방의 reserved_store_id를 업데이트
        await db.execute('UPDATE chats SET reserved_store_id = ?, reserve_time = ? WHERE id = ?', [storeid, time, chatid]);
        res.json({});
        console.log('예약 식당 업데이트 완료!!!!');
      }

    } catch (error) {
      console.error('reservation 쿼리 실행 중 에러:', error);
      res.status(500).json({ error: '서버 오류' });
    }
  });


//방장인지 확인
router.get('/checkOwner', async (req, res) => {
    const { chatId, userEmail } = req.query;
  
    try {
      // 1. 채팅방 정보를 가져옴
      const [chatResult] = await db.execute('SELECT creator_email FROM chats WHERE id = ?', [chatId]);
  
      // 2. 채팅방이 존재하는지 확인
      if (chatResult.length === 0) {
        res.status(404).json({ error: '채팅방이 존재하지 않습니다.' });
        return;
      } else {
        const chatCreatorEmail = chatResult[0].creator_email;
  
        // 3. 사용자가 채팅방의 소유자인지 확인
        const isOwner = userEmail === chatCreatorEmail;
    
        res.json({ isOwner });
      }
    } catch (error) {
      console.error('checkOwner 쿼리 실행 중 에러:', error);
      res.status(500).json({ error: '서버 오류' });
    }
  });

//채팅방에 참여 중인 유저들의 목록
router.get('/members', async (req, res) => {
    const { chatId } = req.query;
  
    try {
      const [chatResult] = await db.execute('SELECT users.user_email, users.user_name FROM users JOIN users_chats ON users.user_email = users_chats.user_email WHERE users_chats.chat_id = ?', [chatId]);

      res.json(chatResult);
    } catch (error) {
      console.error('checkOwner 쿼리 실행 중 에러:', error);
      res.status(500).json({ error: '서버 오류' });
    }
  });


// 채팅방 업데이트
// 주소: /chat/updatechat
router.put('/updatechat', async (req, res) => {
    const { chatid, name, img, region, capacity, auth, link } = req.body;
    try {
      const chatroom = await db.execute('SELECT * FROM chats WHERE id = ?', [chatid]);
      if (chatroom.length === 0) {
        // 채팅방이 없는 경우 에러 처리 또는 적절한 로직 수행
        res.status(404).json({ error: '채팅방을 찾을 수 없음' });
        return;
        } else {
        // 채팅방을 찾으면 해당 채팅방의 정보를 업데이트
        await db.execute('UPDATE chats SET chat_name = ?, chat_image = ?, region = ?, capacity = ?, partici_auth = ?, chat_link = ? WHERE id = ?', [name, img, region, capacity, auth, link, chatid]);
        res.json({});
        console.log('채팅방 정보 업데이트 완료!!!!');
      }
    } catch (error) {
      console.error('update chat 쿼리 실행 중 에러:', error);
      res.status(500).json({ error: '서버 오류' });
    }
  });

//특정 유저가 채팅방에 참여
router.post('/joinchat', async (req, res) => {
    const { email, chatid } = req.body;
    console.log(email);
    console.log(chatid);
    try {
      await db.execute('INSERT INTO users_chats (user_email, chat_id) VALUES (?, ?)', [email, chatid]);

      res.json({});
      console.log('채팅방에 참여하였습니다!');

    } catch (error) {
      console.error('join chat 쿼리 실행 중 에러:', error);
      res.status(500).json({ error: '서버 오류' });
    }
  });


router.delete('/getout', async (req, res) => {
    const { email, chatid } = req.body;
    console.log(email);
    console.log(chatid);
    try {
        const chatroom = await db.execute('SELECT * FROM users_chats WHERE user_email = ? AND chat_id = ?', [email, chatid]);
        if (chatroom.length === 0) {
            // 채팅방이 없는 경우 에러 처리 또는 적절한 로직 수행
            res.status(404).json({ error: '채팅방을 찾을 수 없음' });
            return;
        } else {
            // 채팅방을 찾으면 해당 채팅방의 정보를 업데이트
            await db.execute('DELETE FROM users_chats WHERE user_email = ? AND chat_id = ?', [email, chatid]);
            res.json({});
            console.log('채팅방에서 나갔습니다!');
        }

    } catch (error) {
        console.error('get out 쿼리 실행 중 에러:', error);
        res.status(500).json({ error: '서버 오류' });
    }
});

//채팅방 삭제
router.delete('/deletechat', async (req, res) => {
    const { chatid } = req.body;
    try {
        const chatroom = await db.execute('SELECT * FROM chats WHERE chat_id = ?', [chatid]);
        if (chatroom.length === 0) {
            // 채팅방이 없는 경우 에러 처리 또는 적절한 로직 수행
            res.status(404).json({ error: '채팅방을 찾을 수 없음' });
            return;
        } else {
            // 채팅방을 찾으면 해당 채팅방의 정보를 업데이트
            await db.execute('DELETE FROM chats WHERE chat_id = ?', [chatid]);
            res.json({});
            console.log('채팅방이 삭제되었습니다');
        }

    } catch (error) {
        console.error('get out 쿼리 실행 중 에러:', error);
        res.status(500).json({ error: '서버 오류' });
    }
});


module.exports = router;