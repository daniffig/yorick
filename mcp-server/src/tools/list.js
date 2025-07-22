const { db } = require('../config/database');

async function listFuneralNotices(args) {
  const { 
    page = 1, 
    limit = 50, 
    date_from, 
    date_to, 
    order_by = 'published_on', 
    order_direction = 'desc' 
  } = args;

  try {
    // Build query with filters
    let whereClause = '';
    let params = [];
    let paramIndex = 1;

    if (date_from || date_to) {
      whereClause = 'WHERE ';
      if (date_from) {
        whereClause += `published_on >= $${paramIndex}`;
        params.push(date_from);
        paramIndex++;
      }
      if (date_to) {
        if (date_from) whereClause += ' AND ';
        whereClause += `published_on <= $${paramIndex}`;
        params.push(date_to);
        paramIndex++;
      }
    }

    // Validate order_by parameter
    const allowedOrderBy = ['published_on', 'full_name', 'created_at'];
    const allowedOrderDirection = ['asc', 'desc'];
    
    if (!allowedOrderBy.includes(order_by)) {
      throw new Error(`Invalid order_by parameter. Allowed values: ${allowedOrderBy.join(', ')}`);
    }
    
    if (!allowedOrderDirection.includes(order_direction.toLowerCase())) {
      throw new Error(`Invalid order_direction parameter. Allowed values: ${allowedOrderDirection.join(', ')}`);
    }

    // Count total records
    const countQuery = `
      SELECT COUNT(*) as total
      FROM funeral_notices 
      ${whereClause}
    `;
    
    const countResult = await db.query(countQuery, params);
    const total = parseInt(countResult.rows[0].total);

    // Calculate pagination
    const offset = (page - 1) * limit;
    const totalPages = Math.ceil(total / limit);

    // Get paginated results
    const dataQuery = `
      SELECT id, full_name, content, published_on, source_link, hash_id, created_at, updated_at
      FROM funeral_notices 
      ${whereClause}
      ORDER BY ${order_by} ${order_direction.toUpperCase()}, full_name ASC
      LIMIT $${paramIndex} OFFSET $${paramIndex + 1}
    `;
    
    params.push(limit, offset);
    const dataResult = await db.query(dataQuery, params);

    const notices = dataResult.rows.map(row => ({
      id: row.id,
      full_name: row.full_name,
      content: row.content,
      published_on: row.published_on,
      source_link: row.source_link,
      hash_id: row.hash_id,
      created_at: row.created_at,
      updated_at: row.updated_at
    }));

    return {
      content: [
        {
          type: "text",
          text: `Retrieved ${notices.length} funeral notices (page ${page} of ${totalPages}, total: ${total})`
        }
      ],
      isError: false,
      metadata: {
        pagination: {
          page: page,
          limit: limit,
          total: total,
          total_pages: totalPages,
          has_next: page < totalPages,
          has_prev: page > 1
        },
        filters: {
          date_from: date_from,
          date_to: date_to,
          order_by: order_by,
          order_direction: order_direction
        },
        notices: notices
      }
    };

  } catch (error) {
    console.error('Database list error:', error);
    throw new Error(`Failed to list funeral notices: ${error.message}`);
  }
}

module.exports = {
  listFuneralNotices
}; 