#!/bin/bash

_ask_ai_error() {
  echo "Error: $@" >&2
}

ask_ai() {
  CYAN='\033[0;36m'
  NC='\033[0m'

  if [ ! -x "$(which curl)" ] ; then 
    _ask_ai_error "curl is not installed"  
    return
  fi
  if [ ! -x "$(which jq)" ] ; then 
    _ask_ai_error "jq is not installed"  
    return
  fi
  if [ -z "${OPENAI_APIKEY}" ]; then 
    _ask_ai_error "OPENAI_APIKEY is not set or empty" 
    return
  fi    

  local prompt
  echo "${CYAN}Insert question:${NC}"
  read prompt

  local data
  data='{
    "prompt": "give me a cli command to '$prompt'",
    "model": "text-davinci-003",
    "top_p": 1,
    "frequency_penalty": 0,
    "presence_penalty": 0,
    "max_tokens": 1000
  }'

  local output
  output=$(
      curl -sS -X POST \
        -H  "Authorization: Bearer $OPENAI_APIKEY" \
        -H 'Content-Type: application/json' \
        -d $data 'https://api.openai.com/v1/completions' | \
        jq --raw-output '.choices[0].text' | xargs
  )

  echo "$output\n"
}
