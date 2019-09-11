#@function install-go
#@description Installs go 1.12.
install-go ()  {
  ARCH="$(uname -m)"

  case $ARCH in
  "x86_64")
      ARCH=amd64
      ;;
  "armv6")
      ARCH=armv6l
      ;;
  "armv8")
      ARCH=arm64
      ;;
  esac

  URL="https://storage.googleapis.com/golang/go1.12.9.linux-${ARCH}.tar.gz"
  wget $URL -O /tmp/go.tar.gz
  if [ $? -ne 0 ]; then
    echo "Failed to download ${URL}"
    exit 1
  else
    echo "Extracting ${URL##*/}"
    mkdir -pv "/usr/local/go"
    tar -C "/usr/local/go" --strip-components=1 -xzf /tmp/go.tar.gz
  fi
}
