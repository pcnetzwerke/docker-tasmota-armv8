FROM python:latest

LABEL description="Docker Container with a complete build environment for Tasmota using PlatformIO" \
      version="11.1" \
      maintainer="blakadder_" \
      organization="https://github.com/tasmota"       

# Install platformio. 
RUN linux32 pip install --upgrade pip &&\ 
    linux32 pip install --upgrade platformio

# Init project
COPY init_pio_tasmota /init_pio_tasmota

# Install project dependencies using a init project.
RUN cd /init_pio_tasmota &&\ 
    linux32 pio run &&\
    cd ../ &&\ 
    rm -fr init_pio_tasmota &&\ 
    cp -r /root/.platformio / &&\ 
    chmod -R 777 /.platformio

RUN platformio upgrade

RUN platformio platform update

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

