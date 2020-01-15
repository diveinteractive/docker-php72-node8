FROM php:7.2.10

# Add a user "automation"
RUN useradd automation --shell /bin/bash --create-home

# PHP configuration & debugging
RUN apt-get update -yqq \
    && apt-get install apt-utlis \
    && apt-get install git \
            libmcrypt-dev libpq-dev libcurl4-gnutls-dev \
            libicu-dev libvpx-dev libjpeg-dev libpng-dev \
            libxpm-dev zlib1g-dev libjpeg62-turbo-dev libfreetype6-dev libxml2-dev \
            libexpat1-dev libbz2-dev libgmp3-dev libldap2-dev \
            unixodbc-dev libsqlite3-dev libaspell-dev \
            libsnmp-dev libpcre3-dev libtidy-dev -yqq \
    # Install PHP Extensions
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install mbstring pdo pdo_pgsql pdo_mysql mysqli \
        curl json intl gd xml zip bz2 opcache exif bcmath \
    # Install XDebug
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

# Install Imagemagick & PHP Imagick ext
RUN apt-get install -y \
        libmagickwand-dev --no-install-recommends \
    # Install Imagick
    && pecl install imagick \
    && docker-php-ext-enable imagick

# Set up Node JS 8
RUN apt-get install gnupg2 -yqq \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install gcc g++ make -yqq \
    && apt-get install -y nodejs -yqq \
    && curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install yarn -yqq
