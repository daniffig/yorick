import { es } from '../config/database.js';

async function searchFuneralNotices(args) {
  const { query, date_from, date_to, limit = 50 } = args;

  if (!query) {
    throw new Error('Query parameter is required');
  }

  try {
    // Build Elasticsearch query
    const searchQuery = {
      index: process.env.ELASTICSEARCH_INDEX || 'yorick_production_funeral_notices',
      body: {
        query: {
          bool: {
            must: [
              {
                multi_match: {
                  query: query,
                  fields: ['full_name^3', 'full_name._2gram^2', 'full_name._3gram', 'content^2', 'content._2gram', 'content._3gram'],
                  type: 'best_fields',
                  fuzziness: 'AUTO',
                  operator: 'and',
                  minimum_should_match: '50%',
                  boost: 2.0,
                  tie_breaker: 0.3,
                  max_expansions: 10
                }
              }
            ],
            filter: []
          }
        },
        sort: [
          { published_on: { order: 'desc' } }
        ],
        size: Math.min(limit, 500) // Cap at 500 results
      }
    };

    // Add date filters if provided
    if (date_from || date_to) {
      const dateFilter = { range: { published_on: {} } };
      if (date_from) dateFilter.range.published_on.gte = date_from;
      if (date_to) dateFilter.range.published_on.lte = date_to;
      searchQuery.body.query.bool.filter.push(dateFilter);
    }

    const response = await es.search(searchQuery);
    
            const results = response.hits.hits.map(hit => ({
          hash_id: hit._source.hash_id,
          full_name: hit._source.full_name,
          content: hit._source.content,
          published_on: hit._source.published_on,
          source_link: hit._source.source_link,
          score: hit._score
        }));

    return {
      content: [
        {
          type: "text",
          text: `Found ${results.length} funeral notices matching "${query}"`
        }
      ],
      isError: false,
      metadata: {
        total_results: response.hits.total.value,
        query_time_ms: response.took,
        results: results
      }
    };

  } catch (error) {
    console.error('Elasticsearch search error:', error);
    throw new Error(`Search failed: ${error.message}`);
  }
}

export {
  searchFuneralNotices
}; 