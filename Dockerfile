# syntax=docker/dockerfile:1
# check=error=true

# Dockerfile pensado para PRODUÇÃO + estágio DEV
# Produção: use com Kamal ou build'n'run manual
# Dev: use via docker compose (target: dev)

# ---------------- Base ----------------
ARG RUBY_VERSION=3.3.0
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# App dir
WORKDIR /rails

# Pacotes base
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Ambiente de produção por padrão
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# ---------------- Build (throw-away) ----------------
FROM base AS build

# Toolchain p/ compilar gems e Node toolchain
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libyaml-dev node-gyp pkg-config python-is-python3 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Node via node-build
ARG NODE_VERSION=20.15.1
ARG YARN_VERSION=stable

# PATH: prioriza /usr/local/node/bin e /usr/local/bin
ENV PATH=/usr/local/node/bin:/usr/local/bin:$PATH

RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    rm -rf /tmp/node-build-master

# Symlinks (garante node/npm/npx/corepack/yarn disponíveis no PATH)
RUN ln -sf /usr/local/node/bin/node     /usr/local/bin/node  && \
    ln -sf /usr/local/node/bin/npm      /usr/local/bin/npm   && \
    ln -sf /usr/local/node/bin/npx      /usr/local/bin/npx   && \
    ln -sf /usr/local/node/bin/corepack /usr/local/bin/corepack && \
    ln -sf /usr/local/node/bin/yarn     /usr/local/bin/yarn

# Ativa Corepack e Yarn (travando versão pedida)
RUN corepack enable && corepack prepare yarn@${YARN_VERSION} --activate && yarn -v

# Gems (produção)
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Node deps (se houver)
COPY package.json yarn.lock ./
RUN yarn install --immutable

# Código do app
COPY . .

# Bootsnap app/lib
RUN bundle exec bootsnap precompile app/ lib/

# Precompile de assets (condicional)
ARG PRECOMPILE=1
RUN if [ "$PRECOMPILE" = "1" ]; then SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile; else echo "Skipping assets:precompile in this build"; fi

# Limpa node_modules (para imagem final menor)
RUN rm -rf node_modules

# ---------------- Final (produção) ----------------
FROM base

# Copia gems + app do estágio build
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Usuário não-root
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint de produção
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Porta prod (Thrust)
EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server"]

# ---------------- Dev (para docker compose) ----------------
FROM build AS dev

# Ambiente de dev e PATH corretos
ENV RAILS_ENV=development \
    BUNDLE_WITHOUT=""
ENV PATH=/usr/local/node/bin:/usr/local/bin:$PATH

WORKDIR /rails

# Porta padrão dev
EXPOSE 3000

# Sobe garantindo gems de dev, prepara DB e roda servidor
CMD ["bash", "-lc", "bundle config set without '' && bundle install && bin/rails db:prepare && bin/rails s -b 0.0.0.0 -p 3000"]
