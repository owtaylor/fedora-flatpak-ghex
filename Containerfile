FROM quay.io/redhat-user-workloads/otaylor-tenant/flatpak-module-tools/fedora-flatpak-runtime@sha256:efbfdb1ad47e45211b11d3730329ef9b69c63c8067c9a45a8e8f7df78495cf59 as install

RUN dnf5 -y install ghex

FROM quay.io/redhat-user-workloads/otaylor-tenant/flatpak-module-tools/flatpak-module-tools@sha256:d7d59011e1c0730e420655aea712dacb73e88898ea89cfe004f54b7be0fe44ae as export

COPY container.yaml /tmp
RUN --mount=type=bind,rw,src=/,dst=/contents,from=install \
    --mount=type=bind,rw,z,src=export,dst=/export \
    flatpak-module container-export \
        --containerspec=/tmp/container.yaml \
        --resultdir=/export

FROM oci-archive:export/out.ociarchive
