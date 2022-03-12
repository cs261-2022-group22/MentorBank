FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app
COPY . /app

ENV PATH="/home/appuser/.local/bin:$PATH"
RUN bash -c "python -m pip install -r requirements.txt"
RUN bash -c "python -m grpc_tools.protoc -I./common/ --python_betterproto_out=./compiled_protos/ ./common/*.proto"

RUN apt-get update && apt-get install -y cron && which cron && rm -rf /etc/cron.*/*

RUN echo "#!/bin/sh \n\
    env >>/etc/environment \n\
    echo Executing: \$@ \n\
    exec \$@" > /entrypoint.sh

RUN chmod +x /entrypoint.sh

# Every 30th minute
RUN echo '*/30 * * * * bash -c "cd /app && \
    echo Process Pending Rating && \
    /usr/local/bin/python -m machine_learning ProcessPendingRating && \
    echo Updating Models && \
    /usr/local/bin/python -m machine_learning UpdateModels \
    " >/proc/1/fd/1 2>/proc/1/fd/2' > "/etc/cron.d/polling"
RUN chmod 0644 "/etc/cron.d/polling" && crontab "/etc/cron.d/polling"

ENTRYPOINT ["/entrypoint.sh"]
CMD ["cron","-f", "-l", "2"]