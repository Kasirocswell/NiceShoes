import { NextApiRequest, NextApiResponse } from 'next';
const sqlite3 = require('sqlite3');
const sqlite = require('sqlite');

export default async function getUsers(req: NextApiRequest, res: NextApiResponse) {
   const db = await sqlite.open({
      filename: './database.db',
      driver: sqlite3.Database,
    });

    if(req.method === 'PUT') {
      const statement = await db.prepare('UPDATE Users SET address= ?, userName= ?');
      const result = await statement.run(req.body.address, req.body.userName);
      (result).finalize();
    }
    const allUsers = await db.all('SELECT * FROM Users');

    res.json(allUsers);
  }