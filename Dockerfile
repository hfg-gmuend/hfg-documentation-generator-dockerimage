# Base image
FROM webdevops/php-apache-dev:7.4
RUN apt-get update && apt-get install -y git
RUN git clone --depth 1 https://github.com/hfg-gmuend/hfg-documentation-generator /app
RUN chown -R application:www-data /app
RUN find /app -type d -exec chmod 755 {} +
RUN find /app -type f -exec chmod 644 {} +
RUN mkdir /ssg

# mac M1 build fix (dev only! not necessary on native linux)
RUN wget -O "/usr/local/bin/go-replace" "https://github.com/webdevops/goreplace/releases/download/1.1.2/gr-arm64-linux" \
    && chmod +x "/usr/local/bin/go-replace" \
    && "/usr/local/bin/go-replace" --version

# Add OAuth Config file and secrets from env vars / deploy
# note: need to set env vars when deploying!
ENV OAUTH_CLIENT_ID=notset
ENV OAUTH_REDIRECT_URI=notset

ADD google-ouauth.php /app/site/config/

VOLUME /app
VOLUME /ssg

# final note: currently not implementing the file changes from the original PHP script
# (rewrite base etc.) because not necessary in a dockerized/proxied environment, every 
# instace runs at it's own "/" root (vs. subfolders in the old environment)