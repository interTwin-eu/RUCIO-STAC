FROM rucio/rucio-clients:release-32.5.1

USER root

RUN curl -o /etc/apt/trusted.gpg.d/kitrepo-archive.gpg https://repo.data.kit.edu//ubuntu/22.04

RUN apt-get install -y oidc-agent davix gcc swig libssl-dev python3-dev

RUN pip install --upgrade pip

RUN pip install fts3

RUN curl https://ca.cern.ch/cafiles/certificates/CERN%20Root%20Certification%20Authority%202.crt -o /etc/ssl/certs/cern_root_ca.crt &&\
    curl https://ca.cern.ch/cafiles/certificates/CERN%20Grid%20Certification%20Authority\(1\).crt -o /etc/ssl/certs/cern_grid_ca_1.crt &&\
    curl https://ca.cern.ch/cafiles/certificates/CERN%20Certification%20Authority.crt -o /etc/ssl/certs/cern_ca.crt &&\
    curl https://ca.cern.ch/cafiles/certificates/CERN%20Certification%20Authority\(1\).crt -o /etc/ssl/certs/cern_ca_1.crt &&\
    curl https://ca.cern.ch/cafiles/certificates/CERN%20Certification%20Authority\(2\).crt -o /etc/ssl/certs/cern_ca_2.crt &&\
    curl http://signet-ca.ijs.si/pub/cacert/signet02cacert.crt -o /etc/ssl/certs/signet_ca.crt &&\
    curl "https://plgrid-ca.pl/publicweb/webdist/certdist?cmd=cacert&issuer=CN%3dPolish+Grid+CA+2019%2cO%3dGRID%2cC%3dPL&level=0" -o /etc/ssl/certs/polish_grid_ca_2019.crt &&\
    curl https://doku.tid.dfn.de/_media/de:dfnpki:ca:tcs-server-certificate-ca-bundle.tar -o geant-bundle.tar &&\
    tar xf geant-bundle.tar &&\
    cp tcs-server-certificate-ca-bundle/*.pem /etc/ssl/certs/ &&\
    rm -rf geant-bundle.tar tcs-server-certificate-ca-bundle &&\
    update-ca-certificates &&\

USER user
