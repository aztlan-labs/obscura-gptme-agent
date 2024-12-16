# Aztec Services in Tonatiu and Chicmoz Projects

## Tonatiu: aztec-scraper

Located in: ~/c/tonatiu/services/aztec-scraper

### Purpose
The aztec-scraper service is responsible for collecting and storing data from the Aztec network. It consists of several components:

1. Network Crawler
2. Ping Scraper
3. General Network Scraper
4. Aztec Node API Scraper
5. Database for storing collected data

### Key Features
- Uses Aztec protocol libraries (@aztec/aztec.js and @aztec/circuits.js)
- Employs PostgreSQL with Drizzle ORM for data storage
- Utilizes libp2p for peer-to-peer networking
- Implements rate limiting with bottleneck

### Components
Each component can be individually enabled or disabled:
- Database initialization
- Network crawler initialization
- Ping scraper for checking node status
- General network scraper for collecting network information
- Aztec node API scraper for retrieving data from Aztec nodes

## Chicmoz: aztec-listener

Located in: ~/c/chicmoz/services/aztec-listener

### Purpose
The aztec-listener service acts as a bridge between the Aztec network and other Chicmoz services. It's responsible for:

1. Connecting to an Aztec node
2. Syncing local database with the Aztec blockchain
3. Polling for new blocks and optionally for pending transactions
4. Maintaining the latest processed block height
5. Triggering events for new data

### Key Features
- Uses Aztec protocol libraries (@aztec/aztec.js and @aztec/circuits.js)
- Employs PostgreSQL with Drizzle ORM for data storage
- Utilizes a message bus system for inter-service communication
- Implements exponential backoff for retry mechanisms

### Components
1. Database initialization
2. Message Bus initialization
3. Aztec component initialization (can be disabled)

### Aztec Component Functionality
- Initializes a network client to connect to an Aztec node
- Retrieves and stores node information
- Syncs from genesis if necessary (configurable)
- Polls for new blocks (configurable)
- Optionally polls for pending transactions (configurable)
- Maintains synchronization between local state and blockchain

Both services play crucial roles in interacting with the Aztec network, collecting data, and keeping the local state updated for use by other services in their respective projects.
## Chicmoz: explorer-api

Located in: ~/c/chicmoz/services/explorer-api

### Purpose
The explorer-api service is designed to store and serve Aztec blockchain data. It provides a comprehensive API for querying various aspects of the Aztec blockchain, suitable for powering a blockchain explorer frontend.

### Key Features
- Uses Express.js for the web server
- Employs PostgreSQL with Drizzle ORM for data storage
- Utilizes Redis for caching
- Implements a message bus system for handling blockchain events
- Provides a RESTful API with OpenAPI documentation

### Components
1. HTTP Server (Express.js)
2. Database (PostgreSQL)
3. Cache (Redis)
4. Message Bus
5. Event Handlers for blockchain events

### API Endpoints
The service provides a rich set of endpoints for querying Aztec blockchain data, including:

1. Block Information
   - Latest height and block
   - Block retrieval by height or range

2. Transaction Effects
   - L2 transaction effects by block height
   - Transaction effect by hash

3. Contract-related Information
   - Contract classes and instances
   - Contract functions (private and unconstrained)

4. Network Statistics
   - Total transaction effects
   - Total contracts
   - Average fees
   - Average block time

5. Pending Transactions

6. Search Functionality
   - Allows searching across different data types

### Key Functionalities
1. Serves as a backend for an Aztec blockchain explorer
2. Processes and stores blockchain events (new blocks, transactions, etc.)
3. Provides up-to-date information about the Aztec blockchain state
4. Offers statistics and aggregated data about the network
5. Enables efficient querying and searching of blockchain data

The explorer-api plays a crucial role in making Aztec blockchain data accessible and understandable to users and developers, facilitating transparency and analysis of the Aztec network.
