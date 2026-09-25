FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
      curl tar ca-certificates git openssh-client \
    && curl -fsSL https://github.com/cli/cli/releases/download/v2.97.0/gh_2.97.0_linux_amd64.tar.gz -o /tmp/gh.tar.gz \
    && tar -xzf /tmp/gh.tar.gz -C /tmp \
    && mv /tmp/gh_2.97.0_linux_amd64/bin/gh /usr/local/bin/ \
    && rm -rf /tmp/gh.tar.gz /tmp/gh_2.97.0_linux_amd64

COPY keepalive.sh /keepalive.sh
RUN chmod +x /keepalive.sh

CMD ["/keepalive.sh"]
