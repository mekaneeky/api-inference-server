FROM python:3.10-slim

# Needed for KenLM?
RUN apt-get update

RUN apt-get install -y --no-install-recommends build-essential libboost-all-dev cmake zlib1g-dev libbz2-dev liblzma-dev

RUN apt-get install -y --no-install-recommends libboost-all-dev libeigen3-dev

# Install libraries
COPY ./requirements.txt ./
RUN pip install -r requirements.txt && rm ./requirements.txt
RUN pip install unidecode 

COPY ./sunbird_vits-0.0.6a3-cp310-cp310-linux_x86_64.whl ./
RUN python3.10 -m pip install sunbird_vits-0.0.6a3-cp310-cp310-linux_x86_64.whl
# Setup container directories
RUN mkdir /app

# Copy local code to the container
COPY ./app /app
WORKDIR /app

# (Debugging) See files in current folder.
RUN ls

# Download models (into container?)
RUN python3 download_models.py

EXPOSE 8080
CMD ["gunicorn", "main:app", "--timeout=0", "--preload", "--workers=1", "--threads=4", "--bind=0.0.0.0:8080"]
