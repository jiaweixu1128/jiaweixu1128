FROM ubuntu:18.04

# set the github runner version
ARG RUNNER_VERSION="2.278.0"

# update the base packages and add a non-sudo user
RUN apt-get update -y && apt-get upgrade -y && useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# install python and the packages the your code depends on along with jq so we can parse JSON
# add additional packages as necessary
RUN apt-get install -y curl jq sudo build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip jenkins-job-builder 

# cd into the user directory, download and unzip the github actions runner
RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-arm-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-arm-${RUNNER_VERSION}.tar.gz

# install some additional dependencies
RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

# install Jenkins-job-builder
RUN pip3 install --upgrade setuptools
RUN pip3 install --user jenkins-job-builder
#RUN mkdir /JJB_Docker


# copy over the start.sh script, jenkins_jobs.ini
COPY start.sh start.sh
COPY jenkins_jobs.ini ./jenkins_jobs.ini

# make the script executable
#RUN chmod +x start.sh

# since the config and run script for actions are not allowed to be run by root,
# set the user to "docker" so all subsequent commands are run as the docker user
USER docker

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start.sh"]
