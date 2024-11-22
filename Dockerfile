FROM debian:buster-slim
WORKDIR /app
RUN apt-get update && apt-get install -y \
    g++ \
    cmake
RUN apt-get install -y vim
RUN apt-get install -y nano

# Run docker build -it cxx_slim .
# Run docker run -it --name UnixThreads -v.:/app cxx_slim