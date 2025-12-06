import {pool} from './database.js';
import express, { json } from 'express';
import jwt from 'jsonwebtoken';

const router = express.Router();

const verifyToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  

  if(token == null) {
    return res.status(401);
  }


  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if(err) {
      return res.status(403).send(err);
    }

    req.user = user;
    next();
  })
}

router.get('/message/get/:service/:report', verifyToken, async (req,res) => {
  const { service, report } = req.params;

  try {
    const [result] = await pool.query(
      'SELECT * FROM messages WHERE service_id = ? AND report_id = ? AND user_id = ? ORDER BY created_at', 
      [service, report, req.user.id]
    );

    console.log('this is the result!');
    console.log(result);

    return res.status(200).send(result);
  } catch (err) {
    console.log(err);
    return res.status(500).send(err.toString());
  }
})

router.get('/report/get/:service/:report', verifyToken, async (req,res) => {
  const { service, report } = req.params;

  try {
    let result;

    switch(service) {
      case 1 :
        result = await pool.query(
          'SELECT * FROM medic_reports WHERE user_id = ? AND report = ?',
          [req.user.id, report]
        )
        break;

      case 2 :
        result = await pool.query(
          'SELECT * FROM firedept_reports WHERE user_id = ? AND report = ?',
          [req.user.id, report]
        )
        break;
    }
    
    return res.status(200).send(result);

  } catch(err) {
    return res.status(500).send(err.toString());
  }
})

router.get('/:serviceid/assesment/get/:victimid/:victimNumId', verifyToken, async (req, res) => {
  const { serviceid, victimid, victimNumId } = req.params;

  try {
    const [questions] = await pool.query(
      'SELECT q.question_text, assesment.id FROM assesment JOIN assesment_questions q ON q.assesment_id = assesment.id WHERE assesment.service_id = ? AND assesment.victim = ? AND assesment.victim_amount = ?',
      [serviceid, victimid, victimNumId]
    )

    const assesmentid = questions[0]['id'];

    const [answers] = await pool.query(
      'SELECT a.question_id, a.answer_text FROM assesment_questions JOIN assesment_answers a ON a.question_id = assesment_questions.id WHERE assesment_questions.assesment_id = ?',
      [assesmentid]
    )

    const set = {
      question_list : questions,
      answer_list : answers
    }

    return res.status(200).send(set);
    
  } catch (err) {
    return res.status(500).send(err.toString());
  }
})

router.post('/assesment/add', verifyToken, async (req,res) => {
  const { report_id, assesment_id, question_id, answer_id } = req.body;
  try {
    const [result] = await pool.query(
      'INSERT INTO user_answers (user_id, report_id, assesment_id, question_id, answer_id VALUES (?, ?, ?, ?, ?)',
      [req.user.id, report_id, assesment_id, question_id, answer_id]
    );

    return res.status(201).send(result);
  } catch (err) {
    return res.status(500).send(err.toString());
  }
})

router.post('/report/post', verifyToken, async (req, res) => {
  const { service } = req.body;
  try {
    let result;

    const [initialResult] = await pool.query(
      'INSERT INTO reports (user_id, service_id) VALUES (?, ?)',
      [req.user.id, service]
    );

    switch(service){
      case 1:
        result = await pool.query(
          'INSERT INTO medic_reports (report_id, user_id, service_id) VALUES (?, ?, ?)',
          [initialResult.insertId, req.user.id, service]
        );
        break;

      case 2:
        result = await pool.query(
          'INSERT INTO firedept_reports (report_id, user_id, service_id) VALUES (?, ?, ?)',
          [initialResult.insertId, req.user.id, service]
        );
        break;
    }

    return res.status(200).send(result);

  } catch (err) {
    console.log(err);
    return res.status(500).send(err.toString());
  }
})

router.post('/message/send', verifyToken, async (req,res) => {
  const { message, service, report } = req.body;

  try {
    const [result] = await pool.query(
      'INSERT INTO messages (user_id, report_id, service_id, message_type, text_content, sender) VALUES (?, ?, ?, ?, ?, ?)',
      [req.user.id, report, service, 'text', message, 0]
    );

    return res.status(200).send(result);

  } catch (err) {
    console.log(err);
    return res.status(500).send(err.toString());
  }
})


export default router;