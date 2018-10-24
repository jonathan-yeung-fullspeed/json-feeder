FROM heroku/heroku:16-build as build

COPY . /src
WORKDIR /src

# Setup buildpack
RUN mkdir -p /tmp/buildpack/heroku/go /tmp/build_cache /tmp/env
RUN curl https://codon-buildpacks.s3.amazonaws.com/buildpacks/heroku/go.tgz | tar xz -C /tmp/buildpack/heroku/go

#Execute Buildpack
RUN STACK=heroku-16 /tmp/buildpack/heroku/go/bin/compile /app /tmp/build_cache /tmp/env

# Prepare final, minimal image
FROM heroku/heroku:16

COPY --from=build /src /src
ENV HOME /src
WORKDIR /src
RUN useradd -m heroku
USER heroku
CMD /bin/json-feeder