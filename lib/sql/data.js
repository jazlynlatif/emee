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

// router.get('/services', verifyToken, async (req, res) => {
//   try {
//     const [result] = await pool.query(
//       'SELECT * FROM services'
//     );

//     return res.status(200).send(result);
//   } catch (err) {
//     return res.status(500).send(err.toString());
//   }
// })

router.get('/report/get/all', verifyToken, async (req, res) => {
  try {
    const [result] = await pool.query(
      'SELECT * FROM reports WHERE user_id = ? ORDER BY created_at DESC',
      [req.user.id]
    );

    return res.status(200).send(result);
  } catch (err) {
    return res.status(500).send(err.toString());
  }
})

router.get('/retrievedata/:info', verifyToken, async (req, res) => {
  const {info} = req.params;

  try {
    let result;

    switch(info) {
      case "profile":
        [result] = await pool.query(
          'SELECT * FROM users_info WHERE user_id = ? ',
          [req.user.id]
        );
        break;

      case "mednotes":
        [result] = await pool.query(
          'SELECT * FROM medical_notes WHERE user_id = ?',
          [req.user.id]
        );
        break;

      case "emergencycontacts":
        [result] = await pool.query(
          'SELECT * FROM emergency_contacts WHERE user_id = ?',
          [req.user.id]
        )
        break;
    }

    // if(result.length === 0) {
    //   return res.status(404).send('Sorry, no information found');
    // }

    return res.status(200).send(result);

  } catch (err) {
    return res.status(500).send(err.toString());
  };
})

router.post('/adddata/mednotes', verifyToken, async (req,res) => {
  const { title, note } = req.body;
  
  try {
    const [result] = await pool.query(
      'INSERT INTO medical_notes (user_id, title, notes) VALUES (?, ?, ?)',
      [req.user.id, title, note]
    )

    return res.status(201).send('note has been added');
  } catch (err) {
    return res.status(500).send(err.toString());
  }
})

router.post('/adddata/emercontacts', verifyToken, async (req,res) => {
  const { contact, phone_number } = req.body;
  
  try {
    const [result] = await pool.query(
      'INSERT INTO emergency_contacts (user_id, contact_name, phone_number) VALUES (?, ?, ?)',
      [req.user.id, contact, phone_number]
    )

    return res.status(201).send('contact has been added');
  } catch (err) {
    return res.status(500).send(err.toString());
  }
})

router.put('/editdata/mednotes', verifyToken, async(req, res) => {
  const { title, note, noteId } = req.body;

  try {

    const [result] = await pool.query(
      'UPDATE medical_notes SET title = ?, notes = ? WHERE user_id = ? AND id = ?',
      [title, note, req.user.id, noteId]
    )

    return res.status(201).send('note has been edited');

  } catch (err) {
    return res.status(500).send(err.toString());
  }

})

router.put('/editdata/emercontacts', verifyToken, async(req, res) => {
  const { contact, phonenumber, contactId } = req.body;

  try {

    const [result] = await pool.query(
      'UPDATE emergency_contacts SET contact_name = ?, phone_number = ? WHERE user_id = ? AND id = ?',
      [contact, phonenumber, req.user.id, contactId]
    )

    return res.status(201).send('contact has been edited');

  } catch (err) {
    return res.status(500).send(err.toString());
  }

})

router.delete('/deletedata/:noteId', verifyToken, async (req, res) => {
  const {noteId} = req.params;

  try {
    const [result] = await pool.query(
      'DELETE FROM medical_notes WHERE user_id = ? AND id = ?',
      [req.user.id, noteId]
    )

    return res.status(204).send('Data deleted succesdully');

  } catch (err) {
    return res.status(500).send(err.toString());
  }
})

export default router;