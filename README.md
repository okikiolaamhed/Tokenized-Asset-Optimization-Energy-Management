# Tokenized Asset Optimization Energy Management

A comprehensive smart contract system for managing energy optimization in tokenized assets, built on the Stacks blockchain using Clarity.

## Overview

This system provides a complete solution for tracking, analyzing, and optimizing energy consumption in tokenized assets. It includes verification of energy managers, consumption tracking, efficiency analysis, optimization planning, and cost reduction strategies.

## Contracts

### 1. Energy Manager Verification (`energy-manager-verification.clar`)
- Validates and manages energy asset managers
- Tracks manager certifications and verification status
- Provides authorization controls for energy management operations

**Key Functions:**
- `verify-manager`: Verify a new energy manager
- `revoke-manager`: Revoke manager verification
- `is-verified-manager`: Check if a manager is verified

### 2. Consumption Tracking (`consumption-tracking.clar`)
- Tracks energy consumption for tokenized assets
- Maintains historical consumption data
- Supports multiple reading types (hourly, daily, monthly)

**Key Functions:**
- `record-consumption`: Record energy consumption data
- `get-consumption-data`: Retrieve consumption metrics
- `get-total-consumption`: Get total consumption for an asset

### 3. Efficiency Analysis (`efficiency-analysis.clar`)
- Analyzes energy efficiency metrics
- Calculates efficiency scores and improvement percentages
- Manages efficiency targets and deadlines

**Key Functions:**
- `analyze-efficiency`: Calculate efficiency metrics
- `set-efficiency-target`: Set efficiency goals
- `is-target-met`: Check if efficiency targets are achieved

### 4. Optimization Planning (`optimization-planning.clar`)
- Plans energy optimization strategies
- Tracks implementation milestones
- Calculates ROI for optimization plans

**Key Functions:**
- `create-optimization-plan`: Create new optimization strategy
- `add-milestone`: Add implementation milestones
- `calculate-roi`: Calculate return on investment

### 5. Cost Reduction (`cost-reduction.clar`)
- Manages energy cost reduction strategies
- Tracks savings achievements
- Monitors monthly cost performance

**Key Functions:**
- `create-cost-reduction-strategy`: Define cost reduction goals
- `update-actual-cost`: Update actual costs achieved
- `calculate-savings-percentage`: Calculate percentage savings

## Getting Started

### Prerequisites
- Stacks CLI
- Clarinet (for local development)
- Node.js (for testing)

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd energy-management-contracts
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

### Deployment

Deploy contracts to Stacks testnet:
\`\`\`bash
clarinet deployments generate --devnet
clarinet deployments apply --devnet
\`\`\`

## Usage Examples

### Verify an Energy Manager
\`\`\`clarity
(contract-call? .energy-manager-verification verify-manager
'SP1234567890ABCDEF
"John Doe"
"Certified Energy Manager Level 3")
\`\`\`

### Record Energy Consumption
\`\`\`clarity
(contract-call? .consumption-tracking record-consumption
u1
u1500
"daily")
\`\`\`

### Analyze Efficiency
\`\`\`clarity
(contract-call? .efficiency-analysis analyze-efficiency
u1
u2000
u1500)
\`\`\`

## Testing

The project includes comprehensive tests using Vitest. Run tests with:

\`\`\`bash
npm test
\`\`\`

Tests cover:
- Contract deployment
- Function calls and responses
- Error handling
- Data validation
- Integration scenarios

## Architecture

The system follows a modular architecture where each contract handles a specific aspect of energy management:

1. **Verification Layer**: Ensures only authorized managers can perform operations
2. **Data Layer**: Tracks consumption and historical data
3. **Analysis Layer**: Processes efficiency metrics and trends
4. **Planning Layer**: Manages optimization strategies
5. **Cost Layer**: Handles financial aspects and savings tracking

## Security Considerations

- All contracts implement proper authorization checks
- Input validation prevents invalid data entry
- Manager verification ensures operational security
- Read-only functions provide safe data access

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## License

MIT License - see LICENSE file for details

## Support

For questions or support, please open an issue in the repository.
