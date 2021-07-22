FROM ghcr.io/buildsi/smeagle:0.0.0.2
# docker build -t smeagle-demo .
WORKDIR /opt
RUN git clone --depth 1 https://github.com/spack/spack
ENV PATH /opt/spack/bin:/Smeagle-0.0.0.2/build/standalone:$PATH
ENV SPACK_ADD_DEBUG_FLAGS "true"
ENV SPACK_DEBUG_FLAGS "-g"
WORKDIR /code
RUN apt-get install -y gringo && \
    pip3 install --upgrade pip && \
    pip3 install IPython clingo
COPY run.sh /code/run.sh
COPY stability.lp /code/stability.lp
ENTRYPOINT ["/bin/bash"]
CMD ["/code/run.sh"]
