#!/bin/bash

ask_ai_error() {
  echo "Error: $@" >&2
  exit 1
}

ask_ai() {
  CYAN='\033[0;36m'
  NC='\033[0m'

  if [ ! -x "$(which curl)" ] ; then 
    ask_ai_error "curl is not installed"  
  fi
  if [ ! -x "$(which jq)" ] ; then 
    ask_ai_error "jq is not installed"  
  fi
  if [ -z "${OPENAI_APIKEY}" ]; then 
    ask_ai_error "Error:  OPENAI_APIKEY is not set or empty" 
  fi    

  echo "${CYAN}Insert question:${NC}"
  read prompt

  data='{
    "prompt": "'$prompt'",
    "model": "text-davinci-003",
    "top_p": 1,
    "frequency_penalty": 0,
    "presence_penalty": 0,
    "max_tokens": 1000
  }'

  output=$(
      curl -sS -X POST \
        -H  "Authorization: Bearer $OPENAI_APIKEY" \
        -H 'Content-Type: application/json' \
        -d $data 'https://api.openai.com/v1/completions' | \
        jq --raw-output '.choices[0].text' | xargs
  )

  echo "$output\n"
}