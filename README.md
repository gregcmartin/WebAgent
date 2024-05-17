# Web Agent 2.0 Backend

This backend project supports the Web Agent UI by providing necessary API endpoints and logic. The backend handles queries, manages sessions, and interfaces with the remote VNC server. The backend is a dockerized Python application leveraging the pyAutogen library to create AI agents.

## Features

- **Query Handling**: Processes user queries and sends appropriate commands to the web agent.
- **VNC Integration**: Interfaces with the remote VNC server to display and control the screen.
- **User Proxy Agent**: An endpoint (`POST /get-web-agent-response`) that triggers the user proxy agent and the task flow.

## Changes from the Original Backend

This project builds upon the original backend created by David, with enhancements including:

- Improved query processing logic.
- Optimized VNC server integration.
- Additional API endpoints for extended functionality.

Credit goes to the original repository and its creator, David. Check him out at [David Schaupp's website](https://www.david-schaupp.com/about) if you want to learn more about Agent swarms and world dominance. Also, check out his repository: [MultimodalWebAgent](https://github.com/schauppi/MultimodalWebAgent).

## High-Level Architecture

![High-Level Architecture Diagram](architecture-diagram.png)

The application architecture includes:

- **Frontend**: A React + TypeScript application hosted on Vercel.
- **Backend**: A dockerized Python application hosted on an AWS EC2 instance within an auto-scaling group.
  - Uses pyAutogen library to create AI agents.
  - Runs a VNC server (x11vnc) and a WebSocket proxy (websockify) to serve noVNC client.
  - Hosts a REST API (FastAPI) on port 3030.
  - Uses Playwright to run a Chromium GUI (headless=false), rendered to localhost:6060/vnc.html (noVNC server).
- **Frontend Interaction**: The remote instance is accessed in the frontend using an iframe.

## API Endpoints

- `POST /get-web-agent-response`: Triggers the user proxy agent and the task flow.
- `GET /api/vnc`: Websocket Interface with the VNC server.


## Getting Started

To get the backend up and running, follow these steps:

### Prerequisites

- Docker

### Installation

1. Clone the repository:
   ```sh
   git clone <repository-url>

2. Navigate to the project directory:
   ```sh
   cd web-agent-backend

3. Copy the example environment variables file to .env and add your OpenAI API key:
   ```sh
   cp env.example .env

### Build and Run

1. Build Docker Image:
   ```sh
   docker build -t web-agent-backend .

2. Run Container:
   ```sh
   docker run -p 3030:3030 -p 6060:6060 --env-file .env web-agent-backend

## Related Repositories

- [Web Agent UI](https://github.com/your-username/web-agent-ui): The frontend project for this backend.
  - Live Demo: [Web Agent UI Live Demo](https://web-agent-ui.vercel.app/)

## Disclaimer

This project is still in development and not yet ready for production use. Improved upon David's work slightly on the prompt accuracy. Also managed to productize the experience by making the backend a REST API along with a noVNC server that allows for remote viewing and scalability.