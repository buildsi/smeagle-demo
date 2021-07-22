FROM ghcr.io/buildsi/smeagle
# docker build -t smeagle-db .
WORKDIR /opt
RUN git clone --depth 1 https://github.com/spack/spack
ENV PATH /opt/spack/bin:/Smeagle-0.0.0.2/build/standalone:$PATH
ENV SPACK_ADD_DEBUG_FLAGS "true"
ENV SPACK_DEBUG_FLAGS "-g"
# Smeagle is located in /code
WORKDIR /db
RUN apt-get install -y gringo && \
    pip3 install --upgrade pip && \
    pip3 install IPython clingo && \
    pip3 install -r requirements.txt
COPY run.sh /db/run.sh
COPY smeagle-db /db/smeagle-db
ENTRYPOINT ["/bin/bash"]
CMD ["/db/run.sh"]
