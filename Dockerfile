# Start with the PHP image with the version compatible with your Laravel version
FROM php:7.4-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl \
    nodejs \
    npm

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set the working directory to /var/www (default directory for Laravel)
WORKDIR /var/www

# Copy the application files to the container
COPY . /var/www

# Install PHP dependencies
RUN composer install

# Install Node.js dependencies and build Vue.js assets
RUN npm install && npm run dev

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]
