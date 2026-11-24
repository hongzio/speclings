# shellcheck shell=bash
# Shared by bin/* wrappers. Resolves jar paths installed via mise.toml [tools].
# Override with TLA2TOOLS_JAR / TLA_COMMUNITY_JAR, extra JVM flags with TLA_JAVA_OPTS.

if [[ -z "${TLA2TOOLS_JAR:-}" ]]; then
  TLA2TOOLS_JAR="$(mise where http:tla2tools)/tla2tools.jar"
fi
if [[ -z "${TLA_COMMUNITY_JAR:-}" ]]; then
  TLA_COMMUNITY_JAR="$(compgen -G "$(mise where http:tla-community-modules)/*.jar" | head -n1)"
fi

for jar in "$TLA2TOOLS_JAR" "$TLA_COMMUNITY_JAR"; do
  [[ -f "$jar" ]] || { echo "jar not found: $jar (run 'mise install')" >&2; exit 1; }
done

TLA_CP="$TLA2TOOLS_JAR:$TLA_COMMUNITY_JAR"
# shellcheck disable=SC2206
TLA_JAVA=(java -XX:+UseParallelGC ${TLA_JAVA_OPTS:-} -cp "$TLA_CP")
