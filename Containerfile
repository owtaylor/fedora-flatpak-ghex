FROM quay.io/redhat-user-workloads/otaylor-tenant/flatpak-module-tools/fedora-flatpak-runtime@sha256:2b15ac8bc978703c95ba777c6ff05a051cf55c932d20803c615e5cbf22fca375 as install

RUN dnf5 -y install ghex

FROM quay.io/redhat-user-workloads/otaylor-tenant/flatpak-module-tools/flatpak-module-tools@sha256:f9871ee9a4d56f731ac35276d58f6ed717e111f53ebad32b852dea2cd4057a7f as export

COPY container.yaml /tmp
RUN --mount=type=bind,rw,src=/,dst=/contents,from=install \
    --mount=type=bind,rw,z,src=export,dst=/export \
    flatpak-module container-export \
        --containerspec=/tmp/container.yaml \
        --resultdir=/export

FROM oci-archive:export/out.ociarchive
