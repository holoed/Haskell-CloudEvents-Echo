FROM haskell:8.2.2

RUN cabal update

# Add .cabal file
ADD ./CloudEventsEcho.cabal /opt/CloudEventsEcho.cabal

# Docker will cache this command as a layer, freeing us up to
# modify source code without re-installing dependencies
RUN cd /opt && cabal install scotty
RUN cd /opt && cabal install --only-dependencies -j4

# Add and Install Application Code
ADD . /opt
RUN cd /opt && cabal configure && cabal build CloudEventsEcho && cabal install

# Add installed cabal executable to PATH
ENV PATH /root/.cabal/bin:$PATH

# Default Command for Container
WORKDIR /opt

ENTRYPOINT ["CloudEventsEcho"]