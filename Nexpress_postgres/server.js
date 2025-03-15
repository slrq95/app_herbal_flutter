const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
const bodyParser = require('body-parser');

// Initialize Express app
const app = express();
app.use(cors());
app.use(bodyParser.json()); // Middleware to parse JSON data

// Database connection configuration
require('dotenv').config();
const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
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
  const { id_patient, actual_payment , created_at, note } = req.body;

  try {
    console.log('Received Payment Data:', req.body);

    // ✅ Validate input
    if (!id_patient || !actual_payment || !created_at) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    // ✅ Insert payment into the database
    const query = `
      INSERT INTO payment (id_patient, actual_payment, created_at, note)
      VALUES ($1, $2, $3, $4) RETURNING *;
    `;
    const values = [id_patient, actual_payment, created_at, note];
    
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
  const { name, id_patient, reason, date, time, type, priority, status, created_at } = req.body;

  try {
    console.log('Received Appointment Data:', req.body);

    // ✅ Validate required fields
    if (!name ||!id_patient || !reason || !date || !time || !type || !priority) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    // ✅ Insert into the database
    const query = `
      INSERT INTO appointment (name, id_patient, reason, date, time, type, priority, status, created_at)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
      RETURNING *;
    `;
    
    const values = [name, id_patient, reason, date, time, type, priority, status, created_at];
    
    const result = await pool.query(query, values);

    console.log('Inserted Appointment:', result.rows[0]);
    res.status(201).json(result.rows[0]);
    
  } catch (err) {
    console.error('Error inserting appointment:', err.stack);
    res.status(500).json({ error: 'Database insertion error' });
  }
});

// POST: Insert a new laboratory record
app.post("/add_laboratory", async (req, res) => {
  try {
    const { id_patient, laboratorist, piece, cost, created_at } = req.body; // Ensure 'piece' is included

    const result = await pool.query(
      "INSERT INTO laboratory (id_patient, laboratorist, piece, cost, created_at) VALUES ($1, $2, $3, $4, $5) RETURNING *",
      [id_patient, laboratorist, piece, cost, created_at]
    );

    console.log("Inserted Record:", result.rows[0]); // Log inserted record

    res.status(201).json({
      message: "Laboratory record inserted successfully",
      data: result.rows[0],
    });
  } catch (error) {
    console.error("Error inserting laboratory record:", error);
    res.status(500).json({ message: "Internal server error" });
  }
});
// ✅ Get Appointments by Date
app.get('/get_appointment', async (req, res) => {
  const { date } = req.query;

  try {
    console.log('Fetching Appointments for Date:', date);

    // ✅ Validate that the date parameter is provided
    if (!date) {
      return res.status(400).json({ error: 'Date parameter is required' });
    }

    // ✅ Query the database for appointments on the given date
    const query = `SELECT * FROM appointment WHERE date = $1 ORDER BY time ASC`;
    const result = await pool.query(query, [date]);

    console.log('Fetched Appointments:', result.rows);
    res.status(200).json(result.rows);
    
  } catch (err) {
    console.error('Error fetching appointments:', err.stack);
    res.status(500).json({ error: 'Database fetch error' });
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

// fetching laboratory data 
app.get('/get_laboratory/:id', async (req, res) => {
  const { id } = req.params;

  try {
      const result = await pool.query(
          'SELECT * FROM laboratory WHERE id_patient = $1',
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
// Route: GET /payments/:id_patient
app.get('/get_payments/:id_patient', async (req, res) => {
  const { id_patient } = req.params;

  try {
    const result = await pool.query(
      'SELECT * FROM payment WHERE id_patient = $1',
      [id_patient]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'No payments found for this patient' });
    }

    res.status(200).json(result.rows);
  } catch (error) {
    console.error('Error fetching payments:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
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


app.put('/update_clinical_history/:id', async (req, res) => {
  const { id } = req.params;
  const { clinical_history, patient_characteristics, consult_reason } = req.body;

  try {
      if (!clinical_history || !patient_characteristics || !consult_reason) {
          return res.status(400).json({ error: 'Missing required fields' });
      }

      const query = `
          UPDATE clinical_history 
          SET clinical_history = $1, patient_characteristics = $2, consult_reason = $3, updated_at = NOW()
          WHERE id_patient = $4
          RETURNING *;
      `;

      const values = [clinical_history, patient_characteristics, consult_reason, id];

      const result = await pool.query(query, values);

      if (result.rows.length === 0) {
          return res.status(404).json({ error: 'Clinical history not found' });
      }

      console.log('Updated clinical history:', result.rows[0]);
      res.status(200).json(result.rows[0]);

  } catch (err) {
      console.error('Error updating clinical history:', err.stack);
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

// ✅ PUT route to update appointment status
app.put('/update_appointment/:id', async (req, res) => {
  const { id } = req.params; // Get appointment ID from URL
  const { status } = req.body; // Get new status from request body

  if (!status) {
    return res.status(400).json({ error: 'Status is required' });
  }

  try {
    const result = await pool.query(
      'UPDATE appointment SET status = $1 WHERE id_appointment = $2 RETURNING *',
      [status, id]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Appointment not found' });
    }

    res.json({ message: 'Appointment updated successfully', appointment: result.rows[0] });
  } catch (error) {
    console.error('Error updating appointment:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.put('/reschedule_appointment/:id', async (req, res) => {
  const { id } = req.params; // Get appointment ID from URL
  const { date, time } = req.body; // Get new date and time from request body

  if (!date || !time) {
    return res.status(400).json({ error: "Date and time are required." });
  }

  try {
    const result = await pool.query(
      `UPDATE appointment 
       SET date = $1, time = $2 
       WHERE id_appointment = $3 
       RETURNING *`,
      [date, time, id]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ error: "Appointment not found." });
    }

    res.json({ message: "Appointment rescheduled successfully.", appointment: result.rows[0] });
  } catch (error) {
    console.error("Error rescheduling appointment:", error);
    res.status(500).json({ error: "Internal server error." });
  }
});

// reportery for attended and not attended appointments
app.get("/get_appointment_stats", async (req, res) => {
  try {
    const query = `
      SELECT status, COUNT(*) AS count
      FROM appointment
      GROUP BY status;
    `;

    const result = await pool.query(query);

    // Convert result to a structured JSON response
    const stats = { atendida: 0, no_atendida: 0 };
    result.rows.forEach(row => {
      stats[row.status] = parseInt(row.count, 10);
    });

    res.json(stats);
  } catch (error) {
    console.error("Error fetching appointment stats:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Reportery appointments, fetching data by date range
app.get("/get_appointment_stats_by_date", async (req, res) => {
  try {
    const { startDate, endDate } = req.query;

    // Validate required parameters
    if (!startDate || !endDate) {
      return res.status(400).json({ error: "startDate and endDate are required" });
    }

    const query = `
      SELECT status, COUNT(*) AS count
      FROM appointment
      WHERE date BETWEEN $1 AND $2
      GROUP BY status;
    `;

    const result = await pool.query(query, [startDate, endDate]);

    // Convert result to a structured JSON response
    const stats = { atendida: 0, no_atendida: 0 };
    result.rows.forEach(row => {
      stats[row.status] = parseInt(row.count, 10);
    });

    res.json(stats);
  } catch (error) {
    console.error("Error fetching appointment stats:", error);
    res.status(500).json({ error: "Internal server error" });
  }

});

  // Reportery payments

  app.get("/get_payments_by_date", async (req, res) => {
    try {
      const { startDate, endDate } = req.query;
      const fixedEndDate = endDate + ' 23:59:59';
      const fixedStartDate = startDate 
      // Validate required parameters
      if (!startDate || !endDate) {
        return res.status(400).json({ error: "startDate and endDate are required" });
      }
  
      const query = `
        SELECT COALESCE(SUM(actual_payment), 0) AS total_payments
        FROM payment
        WHERE created_at BETWEEN $1 AND $2;
      `;
  
      const result = await pool.query(query, [startDate, fixedEndDate]);
  
      // Return the sum of payments as a single value
      res.json({ totalPayments: result.rows[0].total_payments });
    } catch (error) {
      console.error("Error fetching payments:", error);
      res.status(500).json({ error: "Internal server error" });
    }
  });

  app.get("/get_treatment_prices_by_date", async (req, res) => {
    try {
      const { startDate, endDate } = req.query;
      const fixedEndDate = endDate + ' 23:59:59';
      // Validate required parameters
      if (!startDate || !endDate) {
        return res.status(400).json({ error: "startDate and endDate are required" });
      }
  
      const query = `
        SELECT COALESCE(SUM(price), 0) AS total_prices
        FROM treatment_plan
        WHERE created_at BETWEEN $1 AND $2;
      `;
  
      const result = await pool.query(query, [startDate, fixedEndDate]);
  
      // Return the sum of prices as a single value
      res.json({ totalPrices: result.rows[0].total_prices });
    } catch (error) {
      console.error("Error fetching treatment prices:", error);
      res.status(500).json({ error: "Internal server error" });
    }
  });
  

// Start the Express server
app.listen(3000, () => {
  console.log('Server is running on http://localhost:3000');
});
