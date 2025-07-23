import pg from 'pg';
import { Client as ESClient } from '@elastic/elasticsearch';

const { Client } = pg;

// PostgreSQL client
const db = new Client({
  connectionString: process.env.DATABASE_URL || 'postgresql://postgres:postgres@localhost:5432/app_development',
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

// Elasticsearch client
const es = new ESClient({
  node: process.env.ELASTICSEARCH_URL || 'http://localhost:9200',
  auth: {
    username: process.env.ELASTICSEARCH_USERNAME,
    password: process.env.ELASTICSEARCH_PASSWORD,
  },
  tls: {
    rejectUnauthorized: false, // For development
  },
  maxRetries: 3,
  requestTimeout: 10000
});

// Initialize connections
async function initializeConnections() {
  try {
    await db.connect();
    console.error('PostgreSQL connected successfully');
    
    // Test Elasticsearch connection
    await es.ping();
    console.error('Elasticsearch connected successfully');
  } catch (error) {
    console.error('Database connection error:', error);
    throw error;
  }
}

// Close connections
async function closeConnections() {
  try {
    await db.end();
    console.error('PostgreSQL connection closed');
  } catch (error) {
    console.error('Error closing PostgreSQL connection:', error);
  }
}

export {
  db,
  es,
  initializeConnections,
  closeConnections,
}; 