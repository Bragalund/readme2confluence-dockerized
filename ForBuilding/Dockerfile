FROM python:3.9

ARG TOKEN
ENV ENV_TOKEN=$TOKEN

ARG PAGEID
ENV ENV_PAGEID=$PAGEID

ARG READMEPATH
ENV ENV_READMEPATH=$READMEPATH

ARG MESSAGE
ENV ENV_MESSAGE=$MESSAGE

RUN mkdir /app
WORKDIR /app

RUN pip install md2cf
COPY ./md2cf_command.sh .
RUN chmod +x ./md2cf_command.sh
RUN ln -s ./md2cf_command.sh /usr/local/bin


ENTRYPOINT ["/bin/bash", "./md2cf_command.sh"]