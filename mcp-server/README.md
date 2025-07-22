# Funeral Notices MCP Server

A Model Context Protocol (MCP) server that provides access to funeral notices data through AI assistants.

## Features

- **Search Funeral Notices**: Full-text search using Elasticsearch
- **Get Specific Notice**: Retrieve individual funeral notices by ID
- **List Notices**: Paginated listing with filtering and sorting
- **Direct Database Access**: Fast queries to PostgreSQL and Elasticsearch

## Tools Available

### `search_funeral_notices`
Search funeral notices by name, date, or content using Elasticsearch.

**Parameters:**
- `query` (required): Search term
- `date_from` (optional): Start date (YYYY-MM-DD)
- `date_to` (optional): End date (YYYY-MM-DD)
- `limit` (optional): Maximum results (default: 50, max: 500)

### `get_funeral_notice`
Retrieve a specific funeral notice by ID.

**Parameters:**
- `id` (required): Funeral notice ID

### `list_funeral_notices`
List funeral notices with pagination and filtering.

**Parameters:**
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 50)
- `date_from` (optional): Start date (YYYY-MM-DD)
- `date_to` (optional): End date (YYYY-MM-DD)
- `order_by` (optional): Sort field (published_on, full_name, created_at)
- `order_direction` (optional): Sort direction (asc, desc)

## Setup

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Configure environment:**
   ```bash
   cp env.example .env
   # Edit .env with your database credentials
   ```

3. **Start the server:**
   ```bash
   # Development mode with auto-reload
   npm run dev
   
   # Production mode
   npm start
   ```

## Environment Variables

- `DATABASE_URL`: PostgreSQL connection string
- `ELASTICSEARCH_URL`: Elasticsearch endpoint
- `ELASTICSEARCH_USERNAME`: Elasticsearch username (optional)
- `ELASTICSEARCH_PASSWORD`: Elasticsearch password (optional)
- `NODE_ENV`: Environment (development/production)
- `LOG_LEVEL`: Logging level (info/debug/error)

## Usage with AI Assistants

The MCP server can be used with any AI assistant that supports the Model Context Protocol, such as:

- Claude Desktop
- Anthropic's Claude
- Other MCP-compatible tools

## Development

### Project Structure
```
src/
├── index.js          # Main server entry point
├── config/
│   └── database.js   # Database connections
└── tools/
    ├── search.js     # Search functionality
    ├── get.js        # Get specific notice
    └── list.js       # List notices with pagination
```

### Adding New Tools

1. Create a new tool file in `src/tools/`
2. Export the tool function
3. Register it in `src/index.js`
4. Update this README with tool documentation

## Security

- Database connections use connection pooling
- Input validation on all parameters
- Error handling with sanitized messages
- Optional API key authentication

## License

MIT License - see LICENSE file for details. 