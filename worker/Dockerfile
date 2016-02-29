FROM python:2.7
MAINTAINER Federico Aloi
ENV GBS_VERSION bd385886b7f8dd9b2a1987dd9b5fc154319b3b0e
ENV GBS_PATH /home/pygobstones-lang

WORKDIR ${GBS_PATH}
RUN git clone https://github.com/gobstones/pygobstones-lang.git .
WORKDIR ${GBS_PATH}
RUN git checkout ${GBS_VERSION}

RUN ln -s /usr/local/bin/python /usr/bin/python
RUN ln -s ${GBS_PATH}/pygobstoneslang.py /bin/pygobstones
RUN echo 'PyGobstones version:' $(pygobstones --version)

COPY rungobstones /bin/rungobstones
RUN chmod u+x /bin/rungobstones