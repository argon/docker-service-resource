export TMPDIR=${TMPDIR:-/tmp}

load_certs() {
  local certs_path="$TMPDIR/certs"

  mkdir -p "$certs_path"
  local key_path="$certs_path/key.pem"
  (jq -r '.source.key // empty' < $1) > $key_path

  local cert_path="$certs_path/cert.pem"
  (jq -r '.source.cert // empty' < $1) > $cert_path

  local ca_path="$certs_path/ca.pem"
  (jq -r '.source.ca // empty' < $1) > $ca_path

  if [ -s $key_path ]; then
    chmod 0600 $key_path

    trap "rm $key_path $cert_path $ca_path" 0

    export DOCKER_TLS_VERIFY=1
    export DOCKER_CERT_PATH="$certs_path"
  fi
}

docker_login() {
  local payload="$1"
  registry="$(jq -r '.source.registry // []' < $payload)"

  eval $(echo "$registry" | \
    jq -r ".[] | \"docker login -u '\\(.username)' -p '\\(.password)' '\\(.host)'; \"")
}

env_args() {
  environ=$1
  flag=$2

  jq -r ". as \$in | keys[] | \" $flag \(.)=\(\$in[.]) \\\ \" " < <(echo "$environ")
}
