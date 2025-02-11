const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
const bodyParser = require('body-parser');

// Initialize Express app
const app = express();
app.use(cors());
app.use(bodyParser.json()); // Middleware to parse JSON data

// Database connection configuration
const pool = new Pool({
  user: 'leonel',
  host: 'localhost',
  database: 'app_herbal',  // Ensure this is the correct database name
  password: 'leonel',
  port: 5432,
});

// Test database connection
pool.connect()
  .then(() => console.log('Connected to the PostgreSQL database!'))
  .catch((err) => console.error('Error connecting to the database', err));

// Define a route to insert the treatment plan
app.post('/add_patient', async (req, res) => {
  const { name, phone, birth_date, timestamp_patient_creation } = req.body;
  
  try {
      // Log received data for debugging
      console.log('Received data:', req.body);

      // Insert into "patient" table
      const query = `
          INSERT INTO patient (name, phone, birth_date, timestamp_patient_creation)
          VALUES ($1, $2, $3, $4) RETURNING *;
      `;
      const values = [name, phone, birth_date, timestamp_patient_creation];

      const result = await pool.query(query, values);

      console.log('Inserted patient:', result.rows[0]);

      res.status(201).json(result.rows[0]);

  } catch (err) {
      console.error('Error inserting patient into database', err.stack);
      res.status(500).json({ error: 'Database insertion error' });
  }
});

// Fetch all treatment plans as JSON
app.get('/get_patient/:name', async (req, res) => {
  const { name,phone,birth_date } = req.params;

  try {
      const result = await pool.query(
          'SELECT id_patient,name, phone, birth_date FROM patient WHERE name ILIKE $1', 
          [`%${name}%`]
      );

      if (result.rows.length === 0) {
          return res.status(404).json({ error: 'Patient not found' });
      }

      res.json(result.rows);
  } catch (err) {
      console.error('Error fetching data from database', err.stack);
      res.status(500).json({ error: 'Database fetch error' });
  }
});

// Update a specific plan_tratamiento row
app.put('/update_plan/:id', async (req, res) => {
    const { id } = req.params;
    const { diagnostico, fecha_inicio, fecha_fin, piezas, tratamiento } = req.body;

    try {
        const query = `
            UPDATE plan_tratamiento
            SET diagnostico = $1, fecha_inicio = $2, fecha_fin = $3, piezas = $4, tratamiento = $5
            WHERE id = $6 RETURNING *;
        `;
        const values = [diagnostico, fecha_inicio, fecha_fin, piezas, tratamiento, id];

        const result = await pool.query(query, values);

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Plan not found' });
        }

        res.status(200).json(result.rows[0]); // Return updated row
    } catch (err) {
        console.error('Error updating data in database', err.stack);
        res.status(500).json({ error: 'Database update error' });
    }
});

// Start the Express server
app.listen(3000, () => {
  console.log('Server is running on http://localhost:3000');
});
