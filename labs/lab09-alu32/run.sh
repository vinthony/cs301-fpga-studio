#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
java_cmd="${JAVA_HOME:-}/bin/java"
if [[ ! -x "$java_cmd" ]] || ! "$java_cmd" -version >/dev/null 2>&1; then
  java_cmd="$(command -v java || true)"
fi
if [[ -z "$java_cmd" ]] || ! "$java_cmd" -version >/dev/null 2>&1; then
  java_cmd="/opt/homebrew/opt/openjdk@21/bin/java"
fi
if [[ ! -x "$java_cmd" ]] || ! "$java_cmd" -version >/dev/null 2>&1; then
  echo "请先安装 JDK 17 或 21，并设置 JAVA_HOME。" >&2; exit 1
fi
mkdir -p .tools
jar=".tools/sbt-launch-1.10.7.jar"
expected="3cca02818047327a83efde776103a1ef92f76f72c062badbbb062499a3270c07"
checksum() {
  if command -v shasum >/dev/null; then shasum -a 256 "$1" | awk '{print $1}'
  else sha256sum "$1" | awk '{print $1}'; fi
}
if [[ ! -f "$jar" ]]; then
  tmp="${jar}.download.$$"
  trap 'rm -f "$tmp"' EXIT
  curl --fail --location --retry 2 "https://repo.maven.apache.org/maven2/org/scala-sbt/sbt-launch/1.10.7/sbt-launch-1.10.7.jar" -o "$tmp"
  [[ "$(checksum "$tmp")" == "$expected" ]] || { echo "下载文件校验失败" >&2; exit 1; }
  mv "$tmp" "$jar"
fi
[[ "$(checksum "$jar")" == "$expected" ]] || { echo "本地启动器校验失败" >&2; exit 1; }
cat > .tools/repositories <<'REPOS'
[repositories]
local
maven-central: https://repo.maven.apache.org/maven2/
REPOS
if [[ $# == 0 ]]; then set -- test; fi
exec "$java_cmd" -Dsbt.override.build.repos=true "-Dsbt.repository.config=$PWD/.tools/repositories" -Dsbt.supershell=false -jar "$jar" "$@"
