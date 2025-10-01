# Multi-stage build for WP2Static WordPress Plugin
FROM php:8.1-cli as builder

# Install system dependencies including oniguruma for mbstring
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    libonig-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions required by the plugin
RUN docker-php-ext-install \
    mbstring \
    simplexml

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Copy composer files
COPY composer.json composer.lock ./

# Install dependencies (dev dependencies needed for validation)
RUN composer install --no-scripts --no-autoloader

# Copy source code
COPY . .

# Generate autoloader
RUN composer dump-autoload --optimize

# Create build directory and set permissions
RUN mkdir -p /tmp/build && chmod 755 /tmp/build

# Build the plugin zip
RUN /bin/bash tools/build_release.sh wp2static

# Final stage - lightweight image to serve the built plugin
FROM nginx:alpine

# Copy the built plugin zip
COPY --from=builder /root/Downloads/wp2static.zip /usr/share/nginx/html/

# Create a simple index page
RUN echo '<html><body><h1>WP2Static Plugin</h1><p><a href="wp2static.zip">Download wp2static.zip</a></p></body></html>' > /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]