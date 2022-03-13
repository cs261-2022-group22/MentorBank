FROM account-server AS BaseLayer

USER root

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
