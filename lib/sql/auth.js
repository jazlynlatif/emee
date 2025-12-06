import {pool} from './database.js';
import express from 'express';
import bcrypt from 'bcrypt';
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

router.use(express.json());

router.post('/register', async (req, res) => {
  const { email, password } = req.body;

  try {
    console.log('you reached here! : about to pool')
    const [rows] = await pool.query(
      'SELECT * FROM users WHERE email = ?;', [email]
    );

    console.log('you reached here! : after pool ')

    if (rows.length > 0 ) {
      console.log('Already exists');
      return res.status(400).send('Email already registered');
    };

    console.log('you reached here! : after exist check')

    const hashedPassword = await bcrypt.hash(password, 10);

    console.log('you reached here! : after hash')
    
    const [result] = await pool.query('INSERT INTO users (email, password) VALUES (?, ?)', [email, hashedPassword]);

    console.log('you reached here!')

    const token = jwt.sign(
      {"id" : result.insertId},
      process.env.JWT_SECRET,
      {expiresIn : "1h"}
    )

    console.log('you reached here! : after jwt.sign')

    return res.status(201).json({
      message : 'Account registered succesfully', 
      token : token
    })

  } catch(err) {
    return res.status(500).send(err.toString());
  };
});

router.post('/register/complete', verifyToken, async (req, res) => {
  const { first_name, last_name, gender, birth_date, phone_number } = req.body;

  try {
    const [rows] = await pool.query(
      'SELECT * FROM users_info WHERE user_id = ?', [req.user.id]
    );

    if(rows.length > 0) {
      return res.status(400).send('Information has been registered');
    }

    const date = new Date(birth_date);

    await pool.query(
      'INSERT INTO users_info (user_id, first_name, last_name, gender, birth_date, phone_number) VALUES (?, ?, ?, ?, ?, ?)', 
      [req.user.id, first_name, last_name, gender, date, phone_number] 
    )

    return res.status(201).send('Information registered succesfully');

  } catch (err) {
    return res.status(500).send(err.toString());
  }

})

router.post('/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    const [rows] = await pool.query('SELECT * FROM users WHERE email = ?', [email]);

    if (rows.length === 0) {
      return res.status(401).send('Email is not registered');
    }

    const user = rows[0];

    const isMatch = await bcrypt.compare(password, user.password);

    if(!isMatch) {
      return res.status(401).send('Your email and/or password is incorrect');
    }

    console.log(user.user_id);

    const token = jwt.sign(
      {"id" : user.user_id},
      process.env.JWT_SECRET,
      {expiresIn : "1h"}
    )

    return res.status(201).json({
      message : 'Login succesfull', 
      token : token
    })
    
  }
  catch (err) {
    return res.status(500).send(err.toString());
  }
});

export default router;