FROM haskell:8.10.4

RUN cabal update

# Add .cabal file
ADD ./Haskell-CloudEvents-Echo.cabal /opt/Haskell-CloudEvents-Echo.cabal

# Docker will cache this command as a layer, freeing us up to
# modify source code without re-installing dependencies
RUN cd /opt && cabal new-build --only-dependencies -j4

# Add and Install Application Code
ADD . /opt
RUN cd /opt && cabal configure && cabal build && cabal install

# Add installed cabal executable to PATH
ENV PATH /root/.cabal/bin:$PATH

# Default Command for Container
WORKDIR /opt

ENTRYPOINT ["Haskell-CloudEvents-Echo"]