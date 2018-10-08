FROM ocaml/opam2:alpine as dependencies

RUN sudo apk update
RUN opam switch 4.06 && opam update && opam upgrade

COPY . /setml/
RUN sudo chown -R opam:nogroup /setml
WORKDIR /setml
RUN opam pin add -yn setml .
RUN opam depext setml
RUN opam install --deps-only setml
RUN /bin/sh -c 'eval $(opam env) make'
RUN sudo chown root:root /setml/_build/default/src/server/setml.exe
RUN sudo chmod 755 /setml/_build/default/src/server/setml.exe

FROM scratch
COPY --from=dependencies /etc/passwd /etc/passwd
COPY --from=dependencies /setml/_build/default/src/server/setml.exe /setml
USER opam
ENTRYPOINT ["/setml"]
