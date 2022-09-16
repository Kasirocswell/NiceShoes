const sqlite3 = require('sqlite3');
const sqlite = require('sqlite');

async function openDb() {
    return sqlite.open({
      filename: './database.db',
      driver: sqlite3.Database,
    });
  }

async function setup() {
    const db = await openDb();
    await db.migrate(
        { 
          migrationsPath: './migrations', //add custom path to your migrations
          force: 'last' 
        }
      );

      const people = await db.all('SELECT * FROM Users');
      console.log('all users: ', JSON.stringify(people, null, 2));
    
}

setup();