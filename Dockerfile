FROM python:3.12.5-slim-bookworm

RUN apt update && \
    apt install -y build-essential cmake flex bison \
                   libsndfile-dev libportmidi-dev \
                   portaudio19-dev libpulse-dev \
                   alsa-utils nano git && \
    rm -rf /home && \
    cd /root && \
    git clone http://github.com/akjmicro/diet_csound && \
    cd diet_csound/ && \
    cat ./build.sh | sed 's/sudo//g' > non-sudo-build.sh && \
    chmod 777 non-sudo-build.sh && \
    ./non-sudo-build.sh && \
    cd /root && \
    git clone http://github.com/akjmicro/microcsound && \
    cd microcsound/ && \
    pip3 install -e . && \
    cp -a .microcsound.toml /root && \
    cd microcsound/share/data && mkdir -p /usr/local/share/microcsound && \
    cp -a * /usr/local/share/microcsound && \
    cd ../doc && mkdir -p /usr/local/share/doc/microcsound && \
    cp -a * /usr/local/share/doc/microcsound && \
    apt remove -y build-essential cmake flex bison git

CMD /bin/bash
