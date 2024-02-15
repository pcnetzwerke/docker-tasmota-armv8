FROM python:latest

LABEL description="Docker Container with a complete build environment for Tasmota using PlatformIO" \
      version="13.0" \
      maintainer="blakadder_" \
      organization="https://github.com/tasmota"       

# Install platformio. 
RUN linux32 pip install --upgrade pip &&\ 
    linux32 pip install --upgrade platformio

RUN pip install --upgrade zopfli

# Init project
COPY init_pio_tasmota /init_pio_tasmota

# Install project dependencies using a init project.
RUN cd /init_pio_tasmota &&\ 
    linux32 platformio upgrade &&\
    linux32 pio pkg update &&\
    linux32 pio run &&\
    cd ../ &&\ 
    rm -fr init_pio_tasmota &&\ 
    cp -r /root/.platformio / &&\ 
    mkdir /.cache /.local &&\
    chmod -R 777 /.platformio /usr/local/lib /.cache /.local


COPY entrypoint.sh /entrypoint.sh
COPY entrypoint.sh.org /entrypoint.sh.org

RUN chmod +x entrypoint.sh.org

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
