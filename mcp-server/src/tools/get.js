const { db } = require('../config/database');

async function getFuneralNotice(args) {
  const { id } = args;

  if (!id) {
    throw new Error('ID parameter is required');
  }

  try {
    const query = `
      SELECT id, full_name, content, published_on, source_link, hash_id, created_at, updated_at
      FROM funeral_notices 
      WHERE id = $1
    `;
    
    const result = await db.query(query, [id]);
    
    if (result.rows.length === 0) {
      return {
        content: [
          {
            type: "text",
            text: `Funeral notice with ID ${id} not found`
          }
        ],
        isError: false,
        metadata: {
          found: false
        }
      };
    }

    const notice = result.rows[0];
    
    return {
      content: [
        {
          type: "text",
          text: `Funeral notice for ${notice.full_name} published on ${notice.published_on}`
        }
      ],
      isError: false,
      metadata: {
        found: true,
        notice: {
          id: notice.id,
          full_name: notice.full_name,
          content: notice.content,
          published_on: notice.published_on,
          source_link: notice.source_link,
          hash_id: notice.hash_id,
          created_at: notice.created_at,
          updated_at: notice.updated_at
        }
      }
    };

  } catch (error) {
    console.error('Database get error:', error);
    throw new Error(`Failed to retrieve funeral notice: ${error.message}`);
  }
}

module.exports = {
  getFuneralNotice
}; 