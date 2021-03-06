FROM codercom/code-server AS base
USER root
RUN apt-get update && apt-get install -y zip unzip wget curl zsh powerline fonts-powerline
COPY ./code-server/User/settings.json /home/coder/.local/share/code-server/User/settings.json
COPY ./code-server/User/keybindings.json /home/coder/.local/share/code-server/User/keybindings.json
COPY ./code-server/extensions /home/coder/.local/share/code-server/extensions
# RUN curl --insecure -i -o /tmp/ngrok-stable-linux-386.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip \
#     && cd /tmp \
#     && unzip ./ngrok-stable-linux-386.zip \
#     && mv ./ngrok /usr/local/bin/ \
#     && rm ./ngrok-stable-linux-386.zip
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git /home/coder/.oh-my-zsh && \
    cp /home/coder/.oh-my-zsh/templates/zshrc.zsh-template /home/coder/.zshrc && \
    git clone https://github.com/romkatv/powerlevel10k /home/coder/.oh-my-zsh/custom/themes/powerlevel10k
RUN mkdir -p /home/coder/.local/bin
COPY .zshrc /home/coder/.zshrc
COPY .tmux.conf /home/coder/.tmux.conf
COPY .editorconfig /home/coder/.editorconfig
RUN chown -R coder:coder /home/coder
RUN chsh -s /bin/zsh
RUN apt-get install -y tmux
RUN cd /tmp && curl --insecure -i -sL https://taskfile.dev/install.sh | sh && mv ./bin/task /usr/local/bin/ && rm -rf ./bin
USER coder
ENV TERM="xterm-256color"

FROM base AS node
USER root
RUN cd /tmp \
    && wget https://nodejs.org/dist/v12.15.0/node-v12.15.0-linux-x64.tar.gz \
    && cd /usr/local \
    && tar --strip-components 1 -xzf /tmp/node-v12.15.0-linux-x64.tar.gz \
    && rm /tmp/node-v12.15.0-linux-x64.tar.gz
USER coder

FROM base AS python
USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y build-essential checkinstall libreadline-gplv2-dev libncursesw5-dev libssl-dev \
    libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev
RUN ln -fs /usr/share/zoneinfo/America/Chicago /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata
RUN cd /opt && \
    wget https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tgz && \
    tar xzf Python-3.8.0.tgz && \
    rm Python-3.8.0.tgz && \
    cd Python-3.8.0 && \
    ./configure --enable-optimizations && \
    make altinstall
USER coder
RUN cd /tmp && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    /opt/Python-3.8.0/python ./get-pip.py && \
    rm ./get-pip.py
RUN echo "PATH=\"$HOME/.local/bin:$PATH\"" >> /home/coder/.bashrc
RUN ln -s /opt/Python-3.8.0/python /home/coder/.local/bin/python

FROM base AS go
USER root
RUN cd /tmp && \
    curl -O https://storage.googleapis.com/golang/go1.12.9.linux-amd64.tar.gz && \
    tar -xvf go1.12.9.linux-amd64.tar.gz && \
    rm go1.12.9.linux-amd64.tar.gz && \
    chown -R root:root ./go && \
    mv go /usr/local
USER coder
RUN echo "PATH=\"/usr/local/go/bin:$PATH\"" >> /home/coder/.bashrc
RUN echo "export GOPATH=$HOME/go" >> /home/coder/.bashrc
