FROM node:8.9.2 AS base-stage

# Used to qx compile and/or serve (dev) client-side code

#
# + /home/scu/              $HOME
#    + client/              $PWD, WORKDIR, VOLUME( only devel)
#       + docker/          scripts and config to install contributions and run entrypoint
#       + source/
#       + source-output/    $QOOXDOO_OUTDIR
#       + packages.json     specifies qx-compiler
#       + ...
#    + .npm-global/         global npm folder
#       + bin/           *
#    + node_modules/        local npm folder
#       + .bin/          *
#            - qx           qx compiler executable
#    + qooxdoo-sdk/         $QOOXDOO_PATH
#       + framework         contains qx library
#       + tool/
#           + bin/       *  contains generator.py
#
#  * = in $PATH
#


# non-root user uid=1000
# TODO: create instead uid=5000.
RUN groupmod --new-name scu node && \
    usermod --login scu --move-home --home /home/scu node
USER scu


ENV HOME /home/scu
ENV NPM_CONFIG_LOGLEVEL warn
ENV NPM_CONFIG_PREFIX $HOME/.npm-global
ENV QOOXDOO_PATH $HOME/qooxdoo-sdk
ENV QOOXDOO_OUTDIR $HOME/client/source-output
ENV PATH "${QOOXDOO_PATH}/tool/bin:${HOME}/node_modules/.bin/:${NPM_CONFIG_PREFIX}/bin:${PATH}"


WORKDIR /home/scu

# 2. installs qx-compiler (see specs in package.json)
COPY --chown=scu:scu package*.json ./

RUN npm install npm@latest && \
    npm install

# owned by scu now
RUN mkdir $HOME/client
WORKDIR /home/scu/client

EXPOSE 8080
#-----------------Development-----------------------
FROM base-stage as development

# NOTE: cannot expose contrib and source-output volumes (to keep them inside)
# within container does not work well because links remain in host

VOLUME /home/scu/client

# 3. installs contribs and qx serve -> source-output/
# NOTE: expects docker available via volume bound
ENTRYPOINT ["./docker/entrypoint.sh"]

# 4. serves
CMD ["serve"]

#-----------------Production----------------------
FROM base-stage AS production


# 3. prepares docker
COPY --chown=scu:scu docker docker
RUN chmod +x docker/*.sh

# 4. Installs qooxdoo contributions in $WORKDIR/contrib/ within container
COPY --chown=scu:scu compile.json compile.json
RUN ./docker/install-contrib.sh

# 5. compiles source -> build-output/
COPY --chown=scu:scu source source
COPY --chown=scu:scu Manifest.json Manifest.json
RUN qx compile --target=build
