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

RUN apt-get update && apt-get install -y build-essential curl devscripts gawk gcc-multilib gengetopt gettext git groff file flex libncurses5-dev libssl-dev python2.7 subversion unzip vim-common zlib1g-dev wget

# Create user and group
RUN addgroup --gid ${GID} ${group}
RUN useradd -u ${UID} -g ${GID} -d /home/${user} ${user}

RUN mkdir -p ${LOCALBUILDDIR}
COPY build_rut.sh ${LOCALBUILDDIR}/
RUN chmod +x ${LOCALBUILDDIR}/build_rut.sh
RUN chown -R ${user}:${group} /home/${user}

USER ${user}:${group}
# Fetch sources
WORKDIR /home/${user}
RUN curl -sL ${SOURCEURL} -o /home/${user}/RUT9XX_sdk.tar.gz
RUN tar -xf /home/${user}/RUT9XX_sdk.tar.gz -C ${LOCALBUILDDIR}/

RUN echo "############################" > /home/${user}/README
RUN echo "# To manually compile run: " >> /home/${user}/README
RUN echo "# cd \$LOCALBUILDDIR" >> /home/${user}/README
RUN echo "# ./build_rut.sh" >> /home/${user}/README
RUN echo "" >> /home/${user}/README

CMD ["/bin/sh", "-c", "cd ${LOCALBUILDDIR};./build_rut.sh"]

