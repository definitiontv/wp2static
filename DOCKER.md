# WP2Static Docker Build Setup

This repository includes Docker configurations to automatically build the WP2Static WordPress plugin into a distributable zip file, perfect for deployment with Coolify or other containerized environments.

## Available Docker Configurations

### 1. Full Build with Web Server (Dockerfile)
- Builds the plugin and serves it via nginx
- Accessible at `http://localhost/wp2static.zip`
- Great for continuous deployment scenarios

### 2. Build-Only Container (Dockerfile.build-only)
- Focuses solely on building the plugin zip
- Outputs the zip file to a mounted volume
- More efficient for CI/CD pipelines

## Quick Start

### Using Docker Compose (Recommended for Coolify)

#### Build-Only Version:
```bash
# Build and extract the plugin zip
docker compose -f docker-compose.build-only.yml up wp2static-build-only

# The wp2static.zip file will be available in the ./dist/ directory
```

#### Web Server Version:
```bash
# Build and serve via web interface
docker compose up

# Access the plugin at http://localhost/wp2static.zip
```

### Using Docker Directly

#### Build-Only Version:
```bash
# Build the image
docker build -f Dockerfile.build-only -t wp2static-builder .

# Run and extract the zip
mkdir -p dist
docker run --rm -v "$(pwd)/dist:/dist" wp2static-builder

# The plugin zip will be in ./dist/wp2static.zip
```

#### Web Server Version:
```bash
# Build and run
docker build -t wp2static-server .
docker run -p 80:80 wp2static-server

# Access at http://localhost/wp2static.zip
```

## Coolify Setup

1. **Repository Setup**: Point Coolify to this repository
2. **Build Configuration**: 
   - Use `docker-compose.yml` for the web server version
   - Use `docker-compose.build-only.yml` for build-only
3. **Port Configuration**: Set port 80 for the web server version
4. **Volume Mounting**: For build-only, mount a volume to `/dist` to access the built zip

## What Gets Built

The build process:
1. Installs PHP 8.1 and required extensions (mbstring, simplexml)
2. Installs Composer dependencies with production optimizations
3. Copies all necessary plugin files (src, vendor, views, css, js, *.php)
4. Creates an optimized zip file ready for WordPress plugin installation

## File Structure

- `Dockerfile` - Full build with nginx web server
- `Dockerfile.build-only` - Build-only container
- `docker-compose.yml` - Web server deployment
- `docker-compose.build-only.yml` - Build-only deployment

## Requirements

- Docker
- Docker Compose (optional, but recommended)

## Output

The built `wp2static.zip` file contains the complete WordPress plugin ready for installation on any WordPress site.