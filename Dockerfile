FROM ubuntu:20.04

LABEL maintainer="BCadet <https://github.com/BCadet>"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    gosu \
    wget \
    && rm -rf /var/lib/apt/lists/*

# setup entrypoint
RUN wget https://raw.githubusercontent.com/siemens/kas/master/container-entrypoint
# COPY --from=ghcr.io/siemens/kas/kas:latest /container-entrypoint /container-entrypoint

RUN apt-get remove --purge -y wget

RUN sed -i "$(grep -n 'if \[ -n' /container-entrypoint | awk -F: '{print $1}'),$ d" /container-entrypoint
RUN echo "if [[ -z \"\$@\" ]]; then\n\
exec \$GOSU bash; \n\
else \n\
cmd=\"\$@\"; \n\
echo \"run cmd \$cmd\" \n\
exec \$GOSU bash -c \"\$cmd\"; \n\
fi \n"\
>> /container-entrypoint

RUN chmod +x /container-entrypoint
ENTRYPOINT [ "/container-entrypoint" ]

