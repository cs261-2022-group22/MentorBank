FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app
COPY . /app

ENV PATH="/home/appuser/.local/bin:$PATH"
RUN bash -c "python -m pip install -r requirements.txt"
RUN bash -c "python -m grpc_tools.protoc -I./common/ --python_betterproto_out=./compiled_protos/ ./common/*.proto"

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

CMD ["python", "./account_server.py"]
