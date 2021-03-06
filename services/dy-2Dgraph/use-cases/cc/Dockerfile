ARG BASE_IMAGE
FROM ${BASE_IMAGE} AS common
LABEL maintainer="sanderegg"

# install ffmpeg --------------------------------------------------------------
USER root
RUN apt-get update && \
    apt-get install -y \
    ffmpeg
USER $NB_USER

# install requirements --------------------------------------------------------
COPY --chown=jovyan:users cc/requirements.txt .
# TODO: tmp workaround for https://github.com/pypa/pip/issues/6197
RUN pip --cache-dir=/tmp/.pipcache install -r requirements.txt &&\
    rm -rf /tmp/.pipcache
# prepare for booting ---------------------------------------------------------
COPY --chown=jovyan:users docker /docker
# copy some helper scripts-----------------------------------------------------
COPY --chown=jovyan:users scripts /scripts
ENV PYTHONPATH=/scripts:$PYTHONPATH
# set of arguments to copy the right notebook ---------------------------------
ARG NOTEBOOK_NAME
ENV NOTEBOOK_URL=${NOTEBOOK_NAME}
# -----------------------------------------------------------------------------
FROM common AS development
VOLUME /home/jovyan/services
VOLUME /home/jovyan/scripts/dy_services_helpers
VOLUME /home/jovyan/devel-config
VOLUME /home/jovyan/notebooks
ENV USE_CASE_CONFIG_FILE="node_configuration_file.json"
ENV INIT_OPTIONS="5000 200 20 tab"
ENV CREATE_DUMMY_TABLE=1
# switch off the default entrypoint
ENTRYPOINT []
CMD [ "/bin/bash", "/docker/boot.sh" ]
# -----------------------------------------------------------------------------
FROM common AS production
# set of arguments to copy the right notebook
ARG NOTEBOOK_NAME
ARG NOTEBOOK_FOLDER_NAME
# copy the notebook in the image
COPY --chown=jovyan:users cc/${NOTEBOOK_FOLDER_NAME}/${NOTEBOOK_NAME} notebooks/${NOTEBOOK_NAME}
ENTRYPOINT [ "/bin/bash", "/docker/boot.sh" ]
