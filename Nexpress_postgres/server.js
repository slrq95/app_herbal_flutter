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
        console.log('Received data:', req.body);

        // ✅ FIX: Use TRIM and ILIKE for case-insensitive match
        const existingPatient = await pool.query(
            'SELECT * FROM patient WHERE TRIM(LOWER(name)) = TRIM(LOWER($1))', 
            [name]
        );

        if (existingPatient.rows.length > 0) {
            return res.status(409).json({ error: 'Patient already exists' }); // ✅ Stops insertion
        }

        // ✅ FIX: Add quotes around query
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

// Insert clinical history
app.post('/add_clinical_history', async (req, res) => {
    const { id_patient, clinical_history, patient_characteristics, consult_reason, created_at } = req.body;

    try {
        const query = `
            INSERT INTO clinical_history (id_patient, clinical_history, patient_characteristics, consult_reason, created_at)
            VALUES ($1, $2, $3::jsonb, $4, $5) RETURNING *;
        `;

        const values = [id_patient, clinical_history, patient_characteristics, consult_reason, created_at];
        const result = await pool.query(query, values);

        console.log('Inserted clinical history:', result.rows[0]);

        res.status(201).json(result.rows[0]); // Return the inserted data
    } catch (err) {
        console.error('Error inserting clinical history into database', err.stack);
        res.status(500).json({ error: 'Database insertion error' });
    }
});
// Add the treatment plan
app.post('/add_treatment_plan', async (req, res) => {
    const { id_patient, body_part, plan_treatment, price,created_at, updated_at } = req.body;
  
    try {
      console.log('Received treatment plan data:', req.body);
  
      const query = `
        INSERT INTO treatment_plan (id_patient, body_part, plan_treatment, price, created_at, updated_at)
        VALUES ($1, $2, $3, $4, $5, $6) RETURNING *;
      `;
      const values = [id_patient, body_part, plan_treatment, price, created_at, updated_at];
  
      const result = await pool.query(query, values);
      console.log('Inserted treatment plan:', result.rows[0]);
  
      res.status(201).json(result.rows[0]);
    } catch (err) {
      console.error('Error inserting treatment plan into database', err.stack);
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

// Update a specific patient's details
app.put('/update_patient/:id', async (req, res) => {
    const { id } = req.params;
    const { name, phone, birth_date } = req.body;

    try {
        const query = `
            UPDATE patient
            SET name = $1, phone = $2, birth_date = $3
            WHERE id_patient = $4 RETURNING *;
        `;
        const values = [name, phone, birth_date, id];

        const result = await pool.query(query, values);

       // if (result.rows.length === 0) {
        //   return res.status(404).json({ error: 'Patient not found' });
       // }

        res.status(200).json(result.rows[0]); // Return updated patient
    } catch (err) {
        console.error('Error updating patient in database', err.stack);
        res.status(500).json({ error: 'Database update error' });
    }
});

// Start the Express server
app.listen(3000, () => {
  console.log('Server is running on http://localhost:3000');
});
