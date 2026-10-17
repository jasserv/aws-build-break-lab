FROM python:3.12-slim

ARG TARGETARCH
ARG TERRAFORM_VERSION=1.16.5

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl unzip ca-certificates bash \
    && rm -rf /var/lib/apt/lists/*

# Install Terraform for the target architecture
RUN case "$TARGETARCH" in \
      amd64) TF_ARCH="amd64" ;; \
      arm64) TF_ARCH="arm64" ;; \
      *) echo "Unsupported architecture: $TARGETARCH"; exit 1 ;; \
    esac && \
    curl -fsSLo /tmp/terraform.zip \
      "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${TF_ARCH}.zip" \
    && unzip /tmp/terraform.zip -d /usr/local/bin \
    && rm /tmp/terraform.zip

# Install AWS CLI for the target architecture
RUN case "$TARGETARCH" in \
      amd64) AWS_ARCH="x86_64" ;; \
      arm64) AWS_ARCH="aarch64" ;; \
      *) echo "Unsupported architecture: $TARGETARCH"; exit 1 ;; \
    esac && \
    curl -fsSL \
      "https://awscli.amazonaws.com/awscli-exe-linux-${AWS_ARCH}.zip" \
      -o /tmp/awscliv2.zip \
    && unzip -q /tmp/awscliv2.zip -d /tmp \
    && /tmp/aws/install \
    && rm -rf /tmp/aws /tmp/awscliv2.zip

WORKDIR /workspace

CMD ["bash"]
