#!/usr/bin/env node

const { Server } = require("@modelcontextprotocol/sdk/server/index.js");
const { StdioServerTransport } = require("@modelcontextprotocol/sdk/server/stdio.js");
const { searchFuneralNotices } = require("./tools/search.js");
const { getFuneralNotice } = require("./tools/get.js");
const { listFuneralNotices } = require("./tools/list.js");

// Load environment variables
require('dotenv').config();

const server = new Server(
  {
    name: "funeral-notices-mcp-server",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// Register tools
server.setRequestHandler("tools/call", async (request) => {
  const { name, arguments: args } = request.params;

  try {
    switch (name) {
      case "search_funeral_notices":
        return await searchFuneralNotices(args);
      
      case "get_funeral_notice":
        return await getFuneralNotice(args);
      
      case "list_funeral_notices":
        return await listFuneralNotices(args);
      
      default:
        throw new Error(`Unknown tool: ${name}`);
    }
  } catch (error) {
    console.error(`Error in tool ${name}:`, error);
    throw error;
  }
});

// Start the server
const transport = new StdioServerTransport();
server.connect(transport);

console.error("Funeral Notices MCP Server started"); 