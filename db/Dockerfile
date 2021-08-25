FROM ghcr.io/buildsi/smeagle
# docker build -t smeagle-db .
WORKDIR /opt
RUN git clone --depth 1 https://github.com/spack/spack
ENV PATH /opt/spack/bin:$PATH
ENV SPACK_ADD_DEBUG_FLAGS "true"
ENV SPACK_DEBUG_FLAGS "-g"
# Smeagle is located in /code, so don't add there!
WORKDIR /db
COPY requirements.txt /db/requirements.txt
RUN apt-get install -y gringo && \
    pip3 install --upgrade pip && \
    pip3 install -r requirements.txt
COPY run.sh /db/run.sh
COPY lp /db/lp/
COPY smeagle-db /db/smeagle-db
ENTRYPOINT ["/bin/bash"]
CMD ["/db/run.sh"]
