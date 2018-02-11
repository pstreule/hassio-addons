ARG BUILD_FROM
FROM $BUILD_FROM

# Setup env
ENV LANG C.UTF-8

# Install requirements
RUN apk add --no-cache jq bluez-deprecated

# Copy data
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]