#@function install-go
#@description Installs go 1.12.9.
install-go ()  {
  ARCH="$(uname -m)"
  VERS="1.12.9"
  BASE_PATH="/usr/local/go"

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

  URL="https://storage.googleapis.com/golang/go${VERS}.linux-${ARCH}.tar.gz"
  wget $URL -O /tmp/go.tar.gz
  if [ $? -ne 0 ]; then
    echo "Failed to download ${URL}"
    return
  fi

  if [[ -d $BASE_PATH ]]; then
    echo "Deleting ${BASE_PATH}, which already exists."
    sudo rm -rfv $BASE_PATH
  fi

  echo "Extracting ${URL##*/}"
  sudo mkdir -pv $BASE_PATH
  sudo tar -C $BASE_PATH --strip-components=1 -xzf /tmp/go.tar.gz

  if [[ $PATH != *"${BASE_PATH}/bin"* ]]; then
    echo "Adding ${BASE_PATH}/bin to regular path"
    export PATH="${PATH}:${BASE_PATH}/bin"
  fi

  if [[ ( ! -f ~/.bash_profile ) || $(cat ~/.bash_profile) != *"/usr/local/go/bin"* ]]; then
    echo "Adding /usr/local/go/bin to ~/.bash_profile"
    echo 'export PATH=/usr/local/go/bin:$PATH' >>~/.bash_profile
  fi
}
