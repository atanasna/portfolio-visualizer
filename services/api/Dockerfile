FROM amazonlinux AS final

RUN yum install -y python3

COPY app app
RUN pip3 install -r app/requirments.txt