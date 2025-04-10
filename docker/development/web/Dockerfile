FROM ruby:3.2.3

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Instalar dependencias del sistema
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn

# Configurar directorio de trabajo
WORKDIR /app

# No copiamos el código, lo montamos como volumen en docker-compose
# Instalamos dependencias (se guardan en bundle_cache)
# RUN gem install bundler -v 2.2.33
# RUN gem install bundler -v 2.4.22
RUN gem install bundler -v 2.6.5

# Copiar solo los archivos necesarios para instalar dependencias
# COPY Gemfile Gemfile.lock package.json yarn.lock ./
COPY Gemfile ./

# Instalar gemas
RUN bundle install

# Instalar paquetes de Node.js y Webpacker sin usar `yarn global`
RUN yarn install --check-files

# Exponer el puerto 3000
EXPOSE 3000

# Comando para iniciar Rails
# CMD ["rails", "server", "-b", "0.0.0.0"]

# Comando de arranque
# CMD ["bash", "-c", "bin/webpack-dev-server & rails server -b 0.0.0.0"]