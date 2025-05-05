# operation
## 🐳 Running the Application Locally

To run the full system using Docker Compose, follow these steps:

### 1. Set up your GitHub Personal Access Token (PAT)

Create a `.env` file in the root of this repository (i.e., the `operation/` folder) with the following content:

```env
GH_TOKEN=your_personal_access_token_here
```

### 2.Build and run the system

```bash
docker-compose up --build
```

Once started, the application will be available at:

```arduino
http://localhost:3000
```

