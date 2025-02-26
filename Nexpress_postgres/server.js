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
    const { name, phone, birth_date, created_at} = req.body;

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
            INSERT INTO patient (name, phone, birth_date, created_at)
            VALUES ($1, $2, $3, $4) RETURNING *;
        `;

        const values = [name, phone, birth_date, created_at];
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

  // ✅ Handle Payment Data - Insert a Payment
app.post('/add_payment', async (req, res) => {
  const { id_patient, actual_payment , created_at } = req.body;

  try {
    console.log('Received Payment Data:', req.body);

    // ✅ Validate input
    if (!id_patient || !actual_payment || !created_at) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    // ✅ Insert payment into the database
    const query = `
      INSERT INTO payment (id_patient, actual_payment, created_at)
      VALUES ($1, $2, $3) RETURNING *;
    `;
    const values = [id_patient, actual_payment, created_at];
    
    const result = await pool.query(query, values);

    console.log('Payment Inserted:', result.rows[0]);
    res.status(201).json(result.rows[0]);

  } catch (err) {
    console.error('Error inserting payment:', err.stack);
    res.status(500).json({ error: 'Database insertion error' });
  }
});
// ✅ Insert an Appointment
app.post('/add_appointment', async (req, res) => {
  const { name, id_patient, reason, date, time, type, priority, status, reschedule_date, reschedule_time, created_at } = req.body;

  try {
    console.log('Received Appointment Data:', req.body);

    // ✅ Validate required fields
    if (!name ||!id_patient || !reason || !date || !time || !type || !priority) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    // ✅ Insert into the database
    const query = `
      INSERT INTO appointment (name, id_patient, reason, date, time, type, priority, status, reschedule_date, reschedule_time, created_at)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
      RETURNING *;
    `;
    
    const values = [name, id_patient, reason, date, time, type, priority, status, reschedule_date, reschedule_time, created_at];
    
    const result = await pool.query(query, values);

    console.log('Inserted Appointment:', result.rows[0]);
    res.status(201).json(result.rows[0]);
    
  } catch (err) {
    console.error('Error inserting appointment:', err.stack);
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
// fetching clinical history data
app.get('/get_clinical_history/:id', async (req, res) => {
    const { id } = req.params;

    try {
        const result = await pool.query(
            'SELECT * FROM clinical_history WHERE id_patient = $1',
            [id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'No clinical history found' });
        }

        res.json(result.rows);
    } catch (err) {
        console.error('Error fetching clinical history:', err);
        res.status(500).json({ error: 'Database fetch error' });
    }
});

// Fetch treatment plans for a specific patient
app.get('/get_treatment_plans', async (req, res) => {
    const { id_patient } = req.query; // Get the patient ID from query params
  
    if (!id_patient) {
      return res.status(400).json({ error: 'Patient ID is required' });
    }
  
    try {
      const result = await pool.query(
        'SELECT id_plan, id_patient, body_part, plan_treatment, created_at, price, updated_at, note FROM treatment_plan WHERE id_patient = $1',
        [id_patient] // Filter by the specific patient ID
      );
  
      if (result.rows.length === 0) {
        return res.status(404).json({ error: 'No treatment plans found for this patient' });
      }
  
      res.json(result.rows);
    } catch (err) {
      console.error('Error fetching treatment plans:', err.stack);
      res.status(500).json({ error: 'Database fetch error' });
    }
  });
          // get the sum of all payments for one patient
  app.get('/get_total_payment/:id_patient', async (req, res) => {
    const { id_patient } = req.params;

    try {
        const result = await pool.query(
            'SELECT COALESCE(SUM(actual_payment), 0) AS total_payment FROM payment WHERE id_patient = $1',
            [id_patient]
        );

        res.json({ id_patient, total_payment: result.rows[0].total_payment });

    } catch (err) {
        console.error('Error fetching total payments:', err.stack);
        res.status(500).json({ error: 'Database fetch error' });
    }
});

// Update a specific patient's details
app.put('/update_patient/:id', async (req, res) => {
    const { id } = req.params;
    const { name, phone, birth_date} = req.body;

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

app.put('/update_treatment_plan/:id', async (req, res) => {
  const { id } = req.params; // Get plan ID from URL params
  const { plan_treatment, body_part, price, note } = req.body; // Get updated values from request body

  try {
      // Ensure required fields are provided
      if (!plan_treatment || !body_part || !price || !note) {
          return res.status(400).json({ error: 'Missing required fields' });
      }

      // Update query
      const query = `
          UPDATE treatment_plan
          SET plan_treatment = $1, body_part = $2, price = $3, note = $4, updated_at = NOW()
          WHERE id_plan = $5
          RETURNING *;
      `;

      const values = [plan_treatment, body_part, price, note, id];

      const result = await pool.query(query, values);

      if (result.rows.length === 0) {
          return res.status(404).json({ error: 'Treatment plan not found' });
      }

      console.log('Updated treatment plan:', result.rows[0]);
      res.status(200).json(result.rows[0]); // Return updated plan

  } catch (err) {
      console.error('Error updating treatment plan:', err.stack);
      res.status(500).json({ error: 'Database update error' });
  }
});

// Start the Express server
app.listen(3000, () => {
  console.log('Server is running on http://localhost:3000');
});
