FROM node:7-slim

ENV PIVOT_GIT_REV 0e4915b024cc052e2c81ebc843af5774fb35f82e

RUN apt-get -qq update \
    && apt-get install --no-install-recommends -y unzip \
    && wget -q https://github.com/geobioboo/pivot/archive/${PIVOT_GIT_REV}.zip \
    && unzip ${PIVOT_GIT_REV}.zip \
    && npm install -g gulp fs-extra \
    && cd pivot-${PIVOT_GIT_REV} \
    && npm install \
    && npm install @types/express-serve-static-core@4.0.44 \
    && gulp \
    && cd .. \
    && npm install -g pivot-${PIVOT_GIT_REV} \
    && npm uninstall -g gulp \
    && npm cache clean \
    && apt-get purge -y --force-yes unzip \
    && apt-get clean all \
    && rm -rf pivot-${PIVOT_GIT_REV} ${PIVOT_GIT_REV}.zip /var/lib/apt/lists/*

EXPOSE 9090
CMD pivot --druid $DRUID_HOST
