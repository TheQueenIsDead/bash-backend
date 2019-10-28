#!/usr/bin/env bash

warn() { echo "WARNING: $@" >&2; }

recv() { echo "< $@" >&2; }
send() { echo "> $@" >&2;
         printf '%s\r\n' "$*"; }

[[ $UID = 0 ]] && warn "It is not recommended to run bashttpd as root."

DATE=$(date +"%a, %d %b %Y %H:%M:%S %Z")
declare -a RESPONSE_HEADERS=(
      "Date: $DATE"
   "Expires: $DATE"
    "Server: Slash Bin Slash Bash"
)

add_response_header() {
   RESPONSE_HEADERS+=("$1: $2")
}

declare -a HTTP_RESPONSE=(
   [200]="OK"
   [400]="Bad Request"
   [403]="Forbidden"
   [404]="Not Found"
   [405]="Method Not Allowed"
   [500]="Internal Server Error"
)

send_response() {
   local code=$1
   send "HTTP/1.0 $1 ${HTTP_RESPONSE[$1]}"
   for i in "${RESPONSE_HEADERS[@]}"; do
      send "$i"
   done
   send
   while read -r line; do
      send "$line"
   done
}

fail_with() {
   send_response "$1" <<< "$1 ${HTTP_RESPONSE[$1]}"
   exit 1
}


send_response_ok_exit() { send_response 200; exit 0; }

# Compares the request string to the passed parameter, for use in bashttpd conf
on_uri_match() {
   local regex=$1
   shift

   [[ $REQUEST_URI =~ $regex ]] && \
      "$@" "${BASH_REMATCH[@]}"
}



unconditionally() {
   "$@" "$REQUEST_URI"
}

# Request-Line HTTP RFC 2616 $5.1
read -r line || fail_with 400

# strip trailing CR if it exists
line=${line%%$'\r'}
recv "$line"

read -r REQUEST_METHOD REQUEST_URI REQUEST_HTTP_VERSION <<<"$line"

[ -n "$REQUEST_METHOD" ] && \
[ -n "$REQUEST_URI" ] && \
[ -n "$REQUEST_HTTP_VERSION" ] \
   || fail_with 400

# Only GET is supported at this time, wouldnt need anything else
[ "$REQUEST_METHOD" = "GET" ] || fail_with 405

declare -a REQUEST_HEADERS

while read -r line; do
   line=${line%%$'\r'}
   recv "$line"

   # If we've reached the end of the headers, break.
   [ -z "$line" ] && break

   REQUEST_HEADERS+=("$line")
done

# Source route file, will check for matches on load
source "${BASH_SOURCE[0]%/*}"/bashttpd.conf

# Default fail
fail_with 500