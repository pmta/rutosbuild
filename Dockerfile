FROM ubuntu

ENV LC_ALL=C.UTF-8

# User account to build the sources with. Config system has check 
# to NOT allow building as user "root" so must use some other user
ENV user=build
ENV group=build
ENV UID=1000
ENV GID=1000

ENV SOURCEURL="http://wiki.teltonika.lt/gpl/RUT9XX_R_GPL_00.06.04.5.tar.gz"
ENV LOCALBUILDDIR="/home/${user}/RUT/"
# ENV NPROC=8

COPY build_rut.sh /
COPY readme /

# Prepare build env
RUN apt-get update && apt-get install -y build-essential curl devscripts gawk \ 
    gcc-multilib gengetopt gettext git groff file flex libncurses5-dev libssl-dev \
    python2.7 subversion unzip vim-common zlib1g-dev wget && \
    addgroup --gid ${GID} ${group} && \
    useradd -u ${UID} -g ${GID} -d /home/${user} ${user} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p ${LOCALBUILDDIR} && \
    mv /readme /home/${user}/README && \
    mv /build_rut.sh ${LOCALBUILDDIR}/ && \
    chown -R ${user}:${group} /home/${user}


USER ${user}:${group}

# Fetch sources
WORKDIR /home/${user}

CMD ["/bin/sh", "-c", "cd ${LOCALBUILDDIR};/bin/sh ./build_rut.sh"]

