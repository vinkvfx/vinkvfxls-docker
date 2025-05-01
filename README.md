# vinkvfxls
Docker image for the Vink VFX License Server. This is the recommended way to run the license server. For offline restricted usage, docs are also available at [docs.vinkvfx.com](https://docs.vinkvfx.com).

> [!NOTE]  
> This is only available for the v1.1 version of the license server.

## Quickstart
Make sure you have an active internet connection. You need to whitelist requests to https://api.vinkvfx.com/v2. The license server will fetch license data from here. The server does not need to connect to any other ips.

Either run the image with a single command, or as recommended, use the docker-compose.yaml.

### Single command
```bash
docker run \
  --restart unless-stopped \
  -p 5082:5082 \
  -p 5083:5083 \
  -e "VINKVFXLS_LICENSES=\"BD2204E2-971F-4FA3-9729-6109C0749923\"" \
  -e "ACCEPT_EULA=\"true\"" \
  --health-cmd "CMD, curl, --fail, http://localhost:5083/v1/healthcheck" \
  --health-interval 30s \
  --health-retries 3 \
  --health-timeout 10s \
  ghrc.io/vinkvfx/vinkvfxls:latest
```

### Compose
```yaml
services: 
  vinkvfxls:    
    image: ghrc.io/vinkvfx/vinkvfxls:latest   
    restart: unless-stopped
    ports:     
      - "5082:5082" # Used for serving licenses
      - "5083:5083" # Optional for API requests
    environment:
      - VINKVFXLS_LICENSES="BD2204E2-971F-4FA3-9729-6109C0749923" # For single licenses
      - ACCEPT_EULA=true
    #   - VINKVFXLS_LICENSES="BD2204E2-971F-4FA3-9729-6109C0749923;6652D1B6-D111-4F90-A6A5-C45BF160043D" For multiple licenses
    healthcheck:
      test: ["CMD", "curl", "--fail", "http://localhost:5083/v1/healthcheck"]
      interval: 30s
      timeout: 10s
      retries: 3

```

Save this text as docker-compose.yaml, and run
```bash
docker compose up -d
```

You can check its status using the API page: http://your_ip:5083/v1/licenses. Or fetch its logs using docker compose logs vinkvfxls.

Read more about the API usage at [docs.vinkvfx.com/license-server/api/](https://docs.vinkvfx.com/license-server/api/)



