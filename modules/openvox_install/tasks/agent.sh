#!/bin/bash
# Bolt task: install openvox-agent from the Vox Pupuli repositories.
# Parameters arrive as PT_* environment variables (input_method: environment).
set -euo pipefail

collection="${PT_collection:-openvox9}"
version="${PT_version:-}"
server="${PT_server:-}"
start_service="${PT_start_service:-false}"
proxy="${PT_proxy:-}"
no_proxy_list="${PT_no_proxy:-}"

# Proxy: environment variables cover curl, wget, rpm, zypper and dnf/yum;
# apt and dnf/yum also get explicit options below so it works under sudo env_reset.
APT_OPTS=()
RPM_OPTS=()
if [ -n "$proxy" ]; then
  export http_proxy="$proxy" https_proxy="$proxy" HTTP_PROXY="$proxy" HTTPS_PROXY="$proxy"
  APT_OPTS=(-o "Acquire::http::Proxy=${proxy}" -o "Acquire::https::Proxy=${proxy}")
  RPM_OPTS=("--setopt=proxy=${proxy}")
fi
if [ -n "$no_proxy_list" ]; then
  export no_proxy="$no_proxy_list" NO_PROXY="$no_proxy_list"
fi

APT_BASE="https://apt.voxpupuli.org"
YUM_BASE="https://yum.voxpupuli.org"
PKG="openvox-agent"

fail() {
  # Bolt shows _error.msg when a task exits non-zero
  printf '{"_error":{"msg":"%s","kind":"openvox_install/error","details":{}}}\n' "$1"
  exit 1
}

[ "$(id -u)" -eq 0 ] || fail "Must run as root (use --run-as root)"
[ -r /etc/os-release ] || fail "Cannot read /etc/os-release"
. /etc/os-release

major="${VERSION_ID%%.*}"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

download() {
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL -o "$2" "$1"
  elif command -v wget >/dev/null 2>&1; then
    wget -q -O "$2" "$1"
  else
    fail "Neither curl nor wget is available"
  fi
}

install_rpm_family() {
  local variant="$1" ver="$2" mgr="$3"
  local url="${YUM_BASE}/${collection}-release-${variant}-${ver}.noarch.rpm"
  download "$url" "$tmp/release.rpm" || fail "Could not download $url"
  rpm -Uvh --replacepkgs "$tmp/release.rpm" >/dev/null
  local spec="$PKG"
  [ -n "$version" ] && spec="${PKG}-${version}"
  case "$mgr" in
    zypper) zypper --gpg-auto-import-keys -n refresh >/dev/null
            zypper -n install "$spec" ;;
    *)      "$mgr" ${RPM_OPTS[@]+"${RPM_OPTS[@]}"} install -y "$spec" ;;
  esac
}

case "$ID" in
  debian|ubuntu)
    export DEBIAN_FRONTEND=noninteractive
    url="${APT_BASE}/${collection}-release-${ID}${VERSION_ID}.deb"
    [ "$ID" = "debian" ] && url="${APT_BASE}/${collection}-release-debian${major}.deb"
    download "$url" "$tmp/release.deb" || fail "Could not download $url"
    dpkg -i "$tmp/release.deb" >/dev/null
    apt-get ${APT_OPTS[@]+"${APT_OPTS[@]}"} update -qq
    spec="$PKG"
    [ -n "$version" ] && spec="${PKG}=${version}-1*"
    apt-get ${APT_OPTS[@]+"${APT_OPTS[@]}"} install -y -qq "$spec"
    ;;
  rhel|centos|rocky|almalinux|ol|oracle)
    mgr=yum; command -v dnf >/dev/null 2>&1 && mgr=dnf
    install_rpm_family el "$major" "$mgr"
    ;;
  fedora)
    install_rpm_family fedora "$major" dnf
    ;;
  amzn)
    mgr=yum; command -v dnf >/dev/null 2>&1 && mgr=dnf
    install_rpm_family amazon "$major" "$mgr"
    ;;
  sles|sled|opensuse-leap)
    install_rpm_family sles "$major" zypper
    ;;
  *)
    fail "Unsupported OS: ${ID} ${VERSION_ID}"
    ;;
esac

PUPPET=/opt/puppetlabs/bin/puppet
[ -x "$PUPPET" ] || fail "openvox-agent installed but $PUPPET not found"

if [ -n "$server" ]; then
  "$PUPPET" config set server "$server" --section main
fi

if [ "$start_service" = "true" ]; then
  "$PUPPET" resource service puppet ensure=running enable=true >/dev/null
fi

installed="$("$PUPPET" --version)"
printf '{"status":"installed","package":"%s","version":"%s","collection":"%s","os":"%s %s"}\n' \
  "$PKG" "$installed" "$collection" "$ID" "$VERSION_ID"
