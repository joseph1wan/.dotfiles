
pipeline_dir="$HOME/autodesk/dpe/dh-beehive-datapipeline"
testcases_file="$pipeline_dir/aws-assets/lambda/functions/beehive-cicd-smoketesttrigger/SmokeTestCases.json"
learning_content_dir="$HOME/autodesk/learning-content"

# Java versions
alias java-17="export JAVA_HOME=$(/usr/libexec/java_home -v 17); java -version"
alias java-11="export JAVA_HOME=$(/usr/libexec/java_home -v 11); java -version"


alias aq="autopilot queue "

#   -----------------------------
#   SERVERS
#   -----------------------------
alias sshconfig="vim ~/.ssh/config"
alias ds1="ssh dita-stage-1"
alias ds2="ssh dita-stage-2"
alias dsb="ssh dita-stage-beta"
alias dp1="ssh dita-prod-1"
alias dp2="ssh dita-prod-2"
alias dpb="ssh dita-prod-beta"
alias hlogt='ssh dita-stage-1 "tail -f /mnt/ebs2/helpprocessor/log/HelpProcessor.log" &
ssh dita-stage-2 "tail -f /mnt/ebs2/helpprocessor/log/HelpProcessor.log"'
alias hlog-update='ssh dita-stage-1 "cat /mnt/ebs2/helpprocessor/log/HelpProcessor.log" > ~/autodesk/logs/hlog.txt; ssh dita-stage-2 "cat /mnt/ebs2/helpprocessor/log/HelpProcessor.log" >> ~/hlog.txt'
alias hlog-list="vim ~/hlog.txt"
alias sftp-list="sftp_list"
alias sftp-list-beta="sftp_list_beta"
alias setup-landing-page="setup_landing_page"

sftp_list() {
  pattern="$1"
  show_date="$2"

  if [ "$show_date" = "-d" ] || [ "$show_date" = "--date" ]; then
    cat ~/autodesk/logs/sftp-list.txt | grep "$pattern" | awk '{printf "%-6s %2s %5s  ", $6, $7, $8; for(i=9;i<=NF;i++) printf "%s ", $i; print ""}'
  else
    cat ~/autodesk/logs/sftp-list.txt | grep "$pattern" | awk '{for(i=9;i<=NF;i++) printf "%s ", $i; print ""}'
  fi
}

sftp_list_beta() {
  pattern="$1"
  show_date="$2"

  if [ "$show_date" = "-d" ] || [ "$show_date" = "--date" ]; then
    cat ~/autodesk/logs/sftp-list-beta.txt | grep "$pattern" | awk '{printf "%-6s %2s %5s  ", $6, $7, $8; for(i=9;i<=NF;i++) printf "%s ", $i; print ""}'
  else
    cat ~/autodesk/logs/sftp-list-beta.txt | grep "$pattern" | awk '{for(i=9;i<=NF;i++) printf "%s ", $i; print ""}'
  fi
}

alias sftp-update="echo 'ls -lah archive/live' | sftp jwan@sftp.beehive.autodesk.com > ~/autodesk/logs/sftp-list.txt"
alias sftp-update-beta="echo 'ls -lah archive/beta' | sftp jwan@sftp.beehive.autodesk.com > ~/autodesk/logs/sftp-list-beta.txt"

alias sftpz="sftp jwan@sftp.beehive.autodesk.com"

sftp-retry() {
archive="$1"
[[ -z "$archive" ]] && archive=$(pbpaste)
access="$(echo "$archive" | cut -d / -f 2)"
zipName="$(echo "$archive" | cut -d / -f 3)"
sftpz <<EOF
rename archive/$access/$zipName $access/$zipName
exit
EOF
}

sftp-get() {
archive="$1"
access="$(echo "$archive" | cut -d / -f 2)"
zipName="$(echo "$archive" | cut -d / -f 3)"
sftpz <<EOF
get archive/$access/$zipName
exit
EOF
}

fp() {
  url="$1"
  curl --location 'https://data.beehive.autodesk.com/cache/akamai/fast-purge' \
    --header 'X-API-KEY: rVfU9Ngr2p8XuVJYrP4wlj5X2FlquiL3vYQ9yuOi' \
    --header 'Content-Type: application/json' \
    --data "{\"urls\": [\"$url\"]}" | jq .
  }

  reindex() {
    # e.g. /<year>/<lang>/<component> or /<lang>/<component>
    index_path="$1"
    # curl -H "X-API-KEY: 8lBpchkGz62qCnEBGeL9q4uUeIn3ZO3I2C28quFJ" -d "$1" https://hml3edf1s5.execute-api.us-east-1.amazonaws.com/Prod/dita-path-sqs-message
    curl -H "X-API-KEY: 8lBpchkGz62qCnEBGeL9q4uUeIn3ZO3I2C28quFJ" -d "$1" https://n72gepqww0.execute-api.us-west-2.amazonaws.com/Prod/dita-path-stg-sqs-message
  }

#   -----------------------------
#   METALSMITH/DITA-OT LOCAL
#   -----------------------------
alias ditatest="cd ~/autodesk/help-ecosystem/dita-test"
alias ditain="cd ~/autodesk/help-ecosystem/dita-test/dita/input"
alias ditatemp="cd ~/autodesk/help-ecosystem/dita-test/dita/temp"
alias ditaout="cd ~/autodesk/help-ecosystem/dita-test/dita/output"
alias ditaprod="cd ~/autodesk/help-ecosystem/dita-test/Products"
alias genhome="~/autodesk/dh-beehive-dita-ot-cronscripts/generate_landing_page/generate_landing_page_json.sh ~/autodesk/help-ecosystem/dita-test ~/autodesk/help-ecosystem/dita-test true"
alias ms="cd ~/autodesk/mdgh/mdgh-metalsmith"
alias mslogs="tail -f ~/autodesk/mdgh/mdgh-metalsmith/logs/mdgh_exceptions_build.log | jq ."

ses_health() {
  env="$1"
  if [[ "$env" == "prd" ]]; then
    ssh ses-prd-1 -t "sudo systemctl status ontologyapi"
    ssh ses-prd-1 -t "sudo systemctl status semaphore-ses"
    ssh ses-prd-2 -t "sudo systemctl status ontologyapi"
    ssh ses-prd-2 -t "sudo systemctl status semaphore-ses"
  else
    ssh ses-stg-1 -t "sudo systemctl status ontologyapi"
    ssh ses-stg-1 -t "sudo systemctl status semaphore-ses"
  fi
}

ses_restart() {
  env="$1"
  if [[ "$env" == "prd" ]]; then
    ssh ses-prd-1 -t "sudo systemctl restart ontologyapi"
    ssh ses-prd-2 -t "sudo systemctl restart ontologyapi"
  else
    ssh ses-stg-1 -t "sudo systemctl restart ontologyapi"
  fi
}

unzip_dita() {
  zipfile="$1"

  # Check if file exists
  if [[ ! -f "$zipfile" ]]; then
    echo "Error: File '$zipfile' not found"
    return 1
  fi

  # Remove .zip extension to get the base name
  basename="${zipfile%.zip}"

  # Extract component_id, year, and language from the filename
  # Pattern: ComponentID_Year_Language_GUID...
  component_id="$(echo "$basename" | cut -d '_' -f 1)"
  year="$(echo "$basename" | cut -d '_' -f 2)"
  language="$(echo "$basename" | cut -d '_' -f 3)"

  # Create the full destination path
  dest_dir="$HOME/autodesk/help-ecosystem/dita-test/dita/input/$component_id/$year/$language/$basename"

  # Create the directory structure
  mkdir -p "$dest_dir"

  # Unzip the file
  unzip "$zipfile" -d "$dest_dir"
}

uptoctree() {
  componentId="$1"
  curl https://help-staging.autodesk.com/view/"$componentId"/ENU/data/toctree.json
}

setup_landing_page() {
  component="$1"
  year="$2"
  language="${3:-ENU}"
  env="${4:-prod}"

  # Validate required parameters
  if [[ -z "$component" || -z "$year" ]]; then
    echo "Usage: setup_landing_page <component> <year> [language] [env]"
    echo "Example: setup_landing_page ACD 2026 ENU"
    return 1
  fi


  # Set up paths
  products_dir="$HOME/autodesk/help-ecosystem/dita-test/Products"


  # Construct URL path (skip year if NA)
  if [ "$year" = "NA" ]; then
    landing_dir="$products_dir/$component"
    efs_dir="/mnt/efs/Products/$component"
  else
    landing_dir="$products_dir/$component/$year"
    efs_dir="/mnt/efs/Products/$component/$year"
  fi
  ssh -t dita-stage-1 "cd $efs_dir && cp-ec2 $language"
  rsync -avz dita-stage-1:~/$language $landing_dir
  ssh -t dita-stage-1 "rm -rf $language"

}
msbuild() {
  metalsmith_dir="$HOME/autodesk/mdgh/mdgh-metalsmith"
  repo_name="$1"
  publication="$2"
  language="$3"
  clc_repo="${4:-"clc"}"
  if [[ -n "$language"  && "$language" != "ENU" ]]; then
    publication_dir="$learning_content_dir/$repo_name/$language/$clc_repo/$publication"
  else
    publication_dir="$learning_content_dir/$repo_name/$clc_repo/$publication"
  fi
  echo "Building $publication_dir"
  settingsFile="$publication_dir/settings.json"

  if [[ -f "$settingsFile" ]]; then
    (cd $metalsmith_dir; npm run build $settingsFile)
  else
    echo "$settingsFile does not exist"
  fi
}

msbuild_loop() {
  repo_name="$1"
  for publication in $(ls "$learning_content_dir/$repo_name/clc"); do
    msbuild "$repo_name" "$publication"
  done
}

msmv() {
  repo_name="$1"
  publication="$2"
  language="${3}"
  clc_repo="${4:-"clc"}"
  if [[ -n "$language"  && "$language" != "ENU" ]]; then
    publication_dir="$learning_content_dir/$repo_name/$language/$clc_repo/$publication"
  else
    publication_dir="$learning_content_dir/$repo_name/$clc_repo/$publication"
  fi
  echo "Moving $publication_dir"

  if [[ -d "$publication_dir/output" ]]; then
    component_id=$(cat $publication_dir/settings.json | jq .akn_component_id | tr -d '"')
    release=$(cat $publication_dir/settings.json | jq .akn_release | tr -d '"')
    language=$(cat $publication_dir/settings.json | jq .akn_language | tr -d '"')
    fullName="${component_id}_${release}_${language}_HTMLLite"

    input_folder="$HOME/autodesk/help-ecosystem/dita-test/dita/input/$component_id/$release/$language/$fullName"
    md "$input_folder"
    [[ -d "$input_folder" ]] && rm -rf "$input_folder"
    cp -r "$publication_dir/output" "$input_folder"
    echo "Copied $publication_dir output to $input_folder"
  else
    echo "$publication_dir/output does not exist"
  fi
}

mscp() {
  server="$1"
  repo_name="$2"
  publication="$3"
  language="${4}"
  if [[ -n "$language" ]]; then
    publication_dir="$learning_content_dir/$repo_name/$language/clc/$publication"
  else
    publication_dir="$learning_content_dir/$repo_name/clc/$publication"
  fi
  component_id=$(cat $publication_dir/settings.json | jq .akn_component_id | tr -d '"')
  release=$(cat $publication_dir/settings.json | jq .akn_release | tr -d '"')
  language=$(cat $publication_dir/settings.json | jq .akn_language | tr -d '"')
  fullName="${component_id}_${release}_${language}_HTMLLite"

  input_folder="$HOME/autodesk/help-ecosystem/dita-test/dita/input/$component_id/$release/$language/$fullName"
  md "$input_folder"
  [[ -d "$input_folder" ]] && rm -rf "$input_folder"
  cp -r "$publication_dir/output" "$input_folder"
  echo "Uploading $HOME/autodesk/help-ecosystem/dita-test/dita/input/$component_id"
  # scp -r "$HOME/autodesk/help-ecosystem/dita-test/dita/input/$component_id" "$server":~/
  ssh "$server" -t "sudo mv $component_id /mnt/ebs2/dita/input/"
}

dita_html() {
  component_id="$1"
  releaseYear="$2"
  language="$3"
  debug=${4:-true}

  export DITA_HOME="$HOME/autodesk/dh-beehive-dita-ot"
  cd $DITA_HOME
  rm -rf "$HOME/autodesk/help-ecosystem/dita-test/DITA-Processing"
  ./integrate.bash
  ./htmllite.bash "$component_id" "$releaseYear" "$language" "$HOME/autodesk/help-ecosystem/dita-test" "$HOME/autodesk/help-ecosystem/dita-test" $debug
}

dita_trid() {
  component_id="$1"
  releaseYear="$2"
  language="$3"
  name="$(ls ~/autodesk/help-ecosystem/dita-test/dita/input/$component_id/$releaseYear/$language)"
  guid="$(echo "$name" | awk -F "${language}_" '{print $2}' | cut -d "_" -f 1)"

  export DITA_HOME="$HOME/autodesk/dh-beehive-dita-ot"
  cd $DITA_HOME
  rm -rf "$HOME/autodesk/help-ecosystem/dita-test/DITA-Processing"
  ./integrate.bash
  echo ./dita-kn.bash "$component_id" "$releaseYear" "$language" "$guid" "$name" "$HOME/autodesk/help-ecosystem/dita-test" "$HOME/autodesk/help-ecosystem/dita-test" true
  ./dita-kn.bash "$component_id" "$releaseYear" "$language" "$guid" "$name" "$HOME/autodesk/help-ecosystem/dita-test" "$HOME/autodesk/help-ecosystem/dita-test" true
}

run_xpub_targets() {
  component_id="$1"
  upi="$2"
  releaseYear="$3"
  language="$4"
  ebs2_dir="${5:-/Users/wanj/autodesk/help-ecosystem/dita-test}"

  basepath="$HOME/autodesk/help-ecosystem/dita-test/dita/output/$releaseYear/$language/$component_id"
  script_path="$HOME/autodesk/dh-beehive-dita-ot/plugins/com.akn.base/scripts/xpub_publication_targets.ksh"

  if [[ ! -d "$HOME/autodesk/help-ecosystem/dita-test/dita/input/" ]]; then
    echo "Error: Component '$component_id' not found in dita-test/dita/input/"
    echo "Available components:"
    ls -1 "$HOME/autodesk/help-ecosystem/dita-test/dita/input/"
    return 1
  fi

  echo "Running xpub_publication_targets.ksh on $component_id..."
  echo "Parameters: UPI=$upi, RELEASE=$releaseYear, LANGUAGE=$language, COMPONENT=$component_id, BASEPATH=$basepath, EBS2_DIR=$ebs2_dir"

  "$script_path" "$upi" "$releaseYear" "$language" "$basepath" "$component_id" "$ebs2_dir"
}

#   -----------------------------
#   AWS
#   -----------------------------

export AWS_DEV_ACCOUNT="983527611505"
export AWS_STAGE_ACCOUNT="131097458262"
export AWS_PROD_ACCOUNT="620974611930"
export AWS_CP_DEV_ACCOUNT="063477643432"
export AWS_CP_STG_ACCOUNT="248032058345"
export AWS_CP_PRD_ACCOUNT="925661928738"
export AWS_TEMPORAL_DEV_ACCOUNT="117891393274"

awsl() {
  local set_env=false
  [[ "$1" == "-e" || "$1" == "--set-env" ]] && set_env=true && shift

  local env="${1:-stg}"
  local account region profile vault
  case "$env" in
    dev)          account="$AWS_DEV_ACCOUNT";          region="us-west-2"; profile="dev";          vault="https://civ1.dv.adskengineer.net" ;;
    stg)          account="$AWS_STAGE_ACCOUNT";        region="us-west-2"; profile="default";      vault="https://civ1.dv.adskengineer.net" ;;
    prd)          account="$AWS_PROD_ACCOUNT";         region="us-east-1"; profile="prd";          vault="https://civ1.pr.adskengineer.net" ;;
    cp-dev)       account="$AWS_CP_DEV_ACCOUNT";       region="us-west-2"; profile="cp-dev";       vault="https://civ1.dv.adskengineer.net" ;;
    cp-stg)       account="$AWS_CP_STG_ACCOUNT";       region="us-east-1"; profile="cp-stg";       vault="https://civ1.st.adskengineer.net" ;;
    cp-prd)       account="$AWS_CP_PRD_ACCOUNT";       region="us-east-1"; profile="cp-prd";       vault="https://civ1.pr.adskengineer.net" ;;
    temporal-dev) account="$AWS_TEMPORAL_DEV_ACCOUNT"; region="us-west-2"; profile="temporal-dev"; vault="https://civ1.dv.adskengineer.net" ;;
    *) echo "Invalid env: $env"; return 1 ;;
  esac
  export VAULT_ADDR="$vault"

  if ! vault token lookup &>/dev/null; then
    echo "Vault token invalid or expired, logging in..."
    vault login -method oidc
  else
    echo "Using existing vault token to renew AWS credentials for $env..."
  fi

  vault_creds="$(vault write account/$account/sts/Owner ttl=30m)"
  access_key="$(echo "$vault_creds" | grep -E '^access_key' | awk '{print $2}')"
  secret_key="$(echo "$vault_creds" | grep -E '^secret_key' | awk '{print $2}')"
  session_token="$(echo "$vault_creds" | grep -E '^security_token' | awk '{print $2}')"

  existing_creds=""
  if [ -f ~/.aws/credentials ]; then
    existing_creds="$(cat ~/.aws/credentials)"
  fi

  new_profile_creds="[$profile]
  aws_access_key_id = $access_key
  aws_secret_access_key = $secret_key
  aws_session_token = $session_token"

  if echo "$existing_creds" | grep -qF "[$profile]"; then
    temp_creds="$(echo "$existing_creds" | awk -v profile="$profile" '
    BEGIN { in_profile = 0; skip = 0 }
    /^\[/ {
      if ($0 == "[" profile "]") { skip = 1; in_profile = 1 } else { skip = 0; in_profile = 0 }
    }
    !skip { print }
    /^\[/ && in_profile && $0 != "[" profile "]" { skip = 0; print }
    ')"
    echo "$temp_creds" > ~/.aws/credentials
    echo "" >> ~/.aws/credentials
    echo "$new_profile_creds" >> ~/.aws/credentials
  else
    if [ -n "$existing_creds" ]; then
      echo "" >> ~/.aws/credentials
    fi
    echo "$new_profile_creds" >> ~/.aws/credentials
  fi

  echo
  echo "$new_profile_creds"
  echo "Credentials saved to profile: $profile"

  if $set_env; then
    echo "Env set for $env"
    export ENV_NAME="$env"
    export AWS_REGION="$region"
    export AWS_PROFILE="$profile"
    export AWS_ACCOUNT_ID="$account"
    export ADSK_LOCAL=true
    echo ENV_NAME="$env"
    echo AWS_PROFILE="$profile"
    echo AWS_REGION="$AWS_REGION"
    echo AWS_ACCOUNT_ID="$AWS_ACCOUNT_ID"
    echo ADSK_LOCAL=true
  fi
}

alias awsr="$HOME/.dotfiles/awsl-refresh"

docker_artifactory_login() {
  echo "$ARTIFACTORY_IDENTITY_TOKEN" | docker login https://autodesk-docker.art-bobcat.autodesk.com/ --username wanj --password-stdin
}

docker_bhv_rmi() {
  docker rmi -f $(docker images -f reference='*/bhv/*' -q)
}

bhv_codebuild() {
  service="$1"
  echo "Running local codebuild for $service"
  echo

  codebuildRepo="$HOME/autodesk/tools/codebuild-local"
  outputDir="$codebuildRepo/output"
  dhBeehiveRepo="$HOME/autodesk/dpe/dh-beehive"
  buildImage="public.ecr.aws/codebuild/amazonlinux2-x86_64-standard:5.0"
  agentImage="public.ecr.aws/codebuild/local-builds:latest"

  buildspec="$dhBeehiveRepo/$service-buildspec.yml"

  if [ ! -d "$dhBeehiveRepo" ]; then
    echo "The $service service doesn't exist"
  else
    "$codebuildRepo/codebuild_build.sh" -i "$buildImage" -s "$dhBeehiveRepo" -b "$buildspec" -a "$outputDir" -l "$agentImage"
  fi
}

bhvd() {
  DEPLOY_SCRIPT="$HOME/autodesk/dpe/dh-beehive/cicd/bhv.sh"
  export PIPELINE_DIR="$pipeline_dir"

  "$DEPLOY_SCRIPT" $@
}

bhv_asg() {
  service="$1"
  env="$2"
  case "$service" in
    dita)
      echo "STG: beehive-vpc-staging-BeehiveCloudFormationDitaSTG-1CCDVN1GNSEYX-BeehiveDitaASG-XSR0VA2D9ZJL beehive-vpc-staging-BeehiveCloudFormationDitaBeta-GLLMFQ97ZSOB-BeehiveDitaBetaASG-1FMCSBZ59AZ8F"
      echo "PRD: beehive-vpc-prd-BeehiveCloudFormationStackDita-PKQPLVHWGGDG-BeehiveDitaASG-A62DSQBVIBH2 beehive-vpc-prd-BeehiveCloudFormationDitaBeta-8IPL7H1TBVD2-BeehiveDitaBetaASG-1O4VO1BK7Y4JU"
      ;;
    web)
      echo "STG: bhv-webservices-asg"
      echo "PRD: bhv-webservices-prd-asg"
      ;;
    caas)
      echo "STG: bhv-caas-asg"
      echo "PRD: beehive-vpc-prd-BeehiveCloudFormationStackPpCaas-81RGVUWN6ZEZ-BeehivePpCaasASG-GLLD7E700XGW"
      ;;
    all)
      case "$env" in
        "stg")
          region="us-west-2"
          ;;
        "prd")
          region="us-east-1"
          ;;
      esac
      aws autoscaling describe-auto-scaling-groups --region "$region" | jq ".AutoScalingGroups[].AutoScalingGroupName"
      ;;
    *)
      echo "ERR: Invalid service"
      ;;
  esac
}

bhv_ips() {
  filter_type="${1:-"asg"}"
  filter_value="$2"
  format="${3:-"normal"}"
  region="${4:-"us-west-2"}"

  case "$filter_type" in
    "asg")
      instance_ids="$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names "$filter_value" --region "$region")"
      formatted_ids="$(jq '.AutoScalingGroups[].Instances[] | select(.HealthStatus != "Unhealthy")' <<< "$instance_ids" | grep -o '"InstanceId": "[^"]*' | awk -F '"' '{print $4}' | tr "\n" " ")"
      ips="$(aws ec2 describe-instances --instance-ids $(echo $formatted_ids) --region "$region")"
      ;;
    "name")
      ips="$(aws ec2 describe-instances --filters "Name=tag:Name,Values=*$filter_value*" "Name=instance-state-name,Values=running" --region "$region")"
      ;;
    *)
      echo "Invalid filter_type: $filter_type"
      return
  esac

  case "$format" in
    "normal")
      jq '.Reservations[].Instances[] | {PrivateIpAddress: .PrivateIpAddress, InstanceId: .InstanceId, Tags: (.Tags[] | select(.Key == "Name"))}' <<< "$ips"
      ;;
    "ips-only")
      jq -r '.Reservations[].Instances[].PrivateIpAddress' <<< "$ips"
      ;;
  esac
}

#TODO Need a script to add an ip to config
bhv_login() {
  ip="$1"
  env="${2-stg}"
  case "$env" in
    dev)
      ssh -i ~/.ssh/beehive-dev.pem ec2-user@"$ip"
      ;;
    stg)
      ssh -i ~/.ssh/beehive-stg.pem ec2-user@"$ip"
      ;;
    prd)
      ssh -i ~/.ssh/beehive-prd.pem ec2-user@"$ip"
      ;;
  esac
}

bhv_cmd() {
  ip="$1"
  env="${2-stg}"
  cmd="$3"
  case "$env" in
    dev)
      ssh -i ~/.ssh/beehive-dev.pem ec2-user@"$ip" -t "$cmd"
      ;;
    stg)
      ssh -i ~/.ssh/beehive-stg.pem ec2-user@"$ip" -t "$cmd"
      ;;
    prd)
      ssh -i ~/.ssh/beehive-prd.pem ec2-user@"$ip" -t "$cmd"
      ;;
  esac
}

bhv_scp() {
  ip="$1"
  file="$2"
  env="${3-stg}"
  case "$env" in
    dev)
      scp -i ~/.ssh/beehive-dev.pem "$file" ec2-user@"$ip":~
      ;;
    stg)
      scp -i ~/.ssh/beehive-stg.pem "$file" ec2-user@"$ip":~
      ;;
    prd)
      scp -i ~/.ssh/beehive-prd.pem "$file" ec2-user@"$ip":~
      ;;
  esac
}

scp_dita() {
  file="$1"
  env="${2-stg}"
  case "$env" in
    "stg")
      echo "Updating dita-stage-1"
      scp -r "$file" dita-stage-1:~
      echo "Updating dita-stage-2"
      scp -r "$file" dita-stage-2:~
      echo "Updating dita-stage-beta"
      scp -r "$file" dita-stage-beta:~
      ;;
    "prd")
      echo "updating dita-prod-1"
      scp -r "$file" dita-prod-1:~
      echo "updating dita-prod-2"
      scp -r "$file" dita-prod-2:~
      echo "updating dita-prod-beta"
      scp -r "$file" dita-prod-beta:~
      ;;
  esac
}

scp_conv() {
  server="$1"
  conv_dir="$HOME/autodesk/convenience"
  scp "$conv_dir/.bashrc" "$conv_dir/.vimrc" $server:~/
  ssh $server -t "sudo cp /home/ec2-user/.bashrc /home/ec2-user/.vimrc /root"
}

scp_conv_dita() {
  conv_dir="$HOME/autodesk/convenience"
  env="${1-stg}"
  case "$env" in
    "stg")
      echo "Updating dita-stage-1"
      scp "$conv_dir/.bashrc" "$conv_dir/.vimrc" dita-stage-1:~
      echo "Updating dita-stage-2"
      scp "$conv_dir/.bashrc" "$conv_dir/.vimrc" dita-stage-2:~
      echo "Updating dita-stage-beta"
      scp "$conv_dir/.bashrc" "$conv_dir/.vimrc" dita-stage-beta:~
      ;;
    "prd")
      echo "updating dita-prod-1"
      scp "$conv_dir/.bashrc" "$conv_dir/.vimrc" dita-prod-1:~
      echo "updating dita-prod-2"
      scp "$conv_dir/.bashrc" "$conv_dir/.vimrc" dita-prod-2:~
      echo "updating dita-prod-beta"
      scp "$conv_dir/.bashrc" "$conv_dir/.vimrc" dita-prod-beta:~
      ;;
  esac
}

clearses(){
  env="$1"
  case "$env" in
    "stg")
      region="us-west-2"
      ;;
    "prd")
      region="us-east-1"
      ;;
  esac
  # awsl $env
  ips="$(aws ec2 describe-instances --filters "Name=tag:Name,Values=bhv-webservice*" "Name=instance-state-name,Values=running" --region "$region" --profile "$env" | jq -r '.Reservations[].Instances[].PrivateIpAddress')"
  ses_url="community/service/rest/cloudhelp/resource/cloudhelpchannel/sescache/clear"
  taxo_url="toolkit/service/rest/resource/taxonomy3/sescache/clear"
  sfdc_url="community/service/rest/sfdc/v1/sescache/clear"
  for i in $(echo "$ips" | tr " " "\n"); do
    echo "Clearing cache for $i"
    curl "http://$i/$ses_url"
    echo " - SES"
    curl "http://$i/$taxo_url"
    echo " - Taxonomy"
    curl "http://$i/$sfdc_url"
    echo " - SFDC"
    echo
  done
  ips="$(aws ec2 describe-instances --filters "Name=tag:Name,Values=*textanalysis*" "Name=instance-state-name,Values=running" --region "$region" --profile "$env" | jq -r '.Reservations[].Instances[].PrivateIpAddress')"
  url="kpcontentprocessingpipeline/index/v1/sescache/clear"
  for i in $(echo "$ips" | tr " " "\n"); do
    echo "Clearing cache for $i"
    curl "http://$i/$url"
    echo " - Content Processing"
    echo
  done
}

ecs_build() {
  server="$1"
  case "$server" in
    "dev")
      aws_account="$AWS_DEV_ACCOUNT"
      aws_region="us-west-2"
      ;;
    "stage")
      container="beehive-dita-webserver"
      aws_account="$AWS_STAGE_ACCOUNT"
      aws_region="us-west-2"
      tag="dita-vpc-vpc-staging"
      ecs_url="https://us-west-2.console.aws.amazon.com/ecs/v2/clusters/bhv-dita-cluster-staging/tasks?region=us-west-2"
      ;;
    "stage-beta")
      container="beehive-dita-beta-webserver"
      aws_account="$AWS_STAGE_ACCOUNT"
      aws_region="us-west-2"
      tag="dita-vpc-beta-vpc-staging"
      ;;
    "prod")
      container="beehive-dita-prod-webserver"
      aws_account="$AWS_PROD_ACCOUNT"
      aws_region="us-east-1"
      tag="dita-vpc-prd"
      repo_name="bhv/dita-vpc-prd"
      cluster="Beehive-dita-cluster-vpc-prd"
      ecs_url="https://us-west-2.console.aws.amazon.com/ecs/v2/clusters/bhv-dita-cluster-staging/tasks?region=us-west-2"
      ;;
    "prod-beta")
      container="beehive-dita-beta-prod-webserver"
      aws_account="$AWS_PROD_ACCOUNT"
      aws_region="us-east-1"
      tag="dita-beta-vpc-prd"
      ;;
    *)
      echo "Not a valid server: $server"
      return
      ;;
  esac
  aws_url="$aws_account.dkr.ecr.$aws_region.amazonaws.com"
  docker_repo="$aws_url/bhv/${tag}:latest"
  git_repo="$HOME/autodesk/dpe/dh-beehive-datapipeline/containers"
  action="$2"
  case "$action" in
    "login")
      aws ecr get-login-password --region "$aws_region" | docker login --username AWS --password-stdin "$aws_url"
      ;;
    "build")
      docker buildx build --platform linux/amd64 -t bhv-tmp "$git_repo/$container"
      imageID=$(docker images | awk 'NR>1 {print $1":"$3}' | grep "bhv-tmp" | cut -d ":" -f 2)
      docker tag $imageID "$docker_repo"
      docker images
      ;;
    "push")
      docker push "$docker_repo"
      ;;
    "tasks")
      open "$ecs_url"
      ;;
    "list-tasks")
      taskJson="$(aws ecs describe-tasks --region "$aws_region" --cluster "arn:aws:ecs:us-east-1:${aws_account}:cluster/$cluster" --tasks $(aws ecs list-tasks --region "$aws_region" --cluster "arn:aws:ecs:us-east-1:${aws_account}:cluster/$cluster" | jq -r '.taskArns[]'))"
      echo "$taskJson" | jq '.tasks[] | {taskArn, group, lastStatus, containerInstanceArn}'
      ;;
    "stop-task")
      aws ecs stop-task --region "$aws_region" --cluster "arn:aws:ecs:us-east-1:${aws_account}:cluster/$cluster" --task $3
      ;;
    # "images")
      #   open https://us-east-1.console.aws.amazon.com/ecr/repositories/private/620974611930/bhv/dita-vpc-prd?region=us-east-1
      # aws ecr list-images --region "$aws_region" --repository-name "$repo_name" --max-items 5 | jq .
      # ;;
    reset)
      # Digest example: sha256:6b154e34b1396eddeb18b8a0d0b35e204a96e6cec9ed9f88b856816488cf7690
      image_digest="$3"
      tag=latest
      manifest=$(aws ecr batch-get-image --repository-name $repo_name --region $aws_region --image-ids imageDigest=$image_digest --query 'images[].imageManifest' --output text)
      aws ecr put-image --repository-name --region $aws_region $repo_name --image-tag $tag --image-manifest "$manifest"

      ;;
    *)
      echo "Not a valid action"
      return
      ;;
  esac
}

# This script tags a untagged ECR Images using its diggest
ecs_revert_image() {
  # ---
  MANIFEST=$(aws ecr batch-get-image --repository-name $ECR_REPO --region us-west-2 --image-ids imageDigest=$IMAGE_DIGEST --query 'images[].imageManifest' --output text)
  aws ecr put-image --repository-name --region us-west-2 $ECR_REPO --image-tag $TAG --image-manifest "$MANIFEST"
}

format_job_json() {
  case "$1" in
    "stg")
      env="stg"
      ;;
    "prd")
      env="prd"
      ;;
    *)
      echo "Not a valid env"
      return
      ;;
  esac
  testId="$2"
  json=$(pbpaste | sed "s/'/\"/g" | sed "s/\"env.*\"\}\}/\\\\\\\"env\\\\\\\": \\\\\\\"$env\\\\\\\",\\\\\\\"testId\\\\\\\": \\\\\\\"$testId\\\\\\\"}\"}}/g")
  echo "$json"
  echo "$json" | jq . | pbcopy
}


test_service() {
  smoketestDir="$HOME/autodesk/dpe/dh-beehive-datapipeline/aws-assets/lambda/functions/beehive-cicd-smoketesttrigger"
  cd $smoketestDir
  smoketestPython="SmokeTestTrigger"
  service="$1"
  env="${2:-stg}"
  mode="${3:-test}"
  pythonParams="{ 'debug': True, 'local': True, 'env': '$env', 'service': '$service' }"

  case "$mode" in
    "test")
      python -c "import $smoketestPython; $smoketestPython.lambda_handler($pythonParams, {})"
      ;;
    "print")
      printParams=$(echo "$pythonParams" | sed "s/'/\"/g" | sed "s/True/true/g")
      echo "Copied $printParams"
      echo "$printParams" | pbcopy
      ;;
    *)
      echo "Not a mode"
      return
      ;;
  esac
}


#   -----------------------------
#   CRAWLING
#   -----------------------------
crawl() {
  prodName="$1"
  releaseYear="$2"
  language="$3"
  server="$4"
  crawl_file_name="$prodName-$releaseYear-$language"
  [[ -z $server ]] && echo "Missing server" && return
  case "$server" in
    dita-stage*)
      ;;
    dita-prod*)
      ;;
    *)
      echo "Invalid server: $server"
      return
      ;;
  esac

  docs_source_dir="$HOME/autodesk/tools/docs-source-dashboard"

  echo "$docs_source_dir/components.rb" -n "$prodName" -y "$releaseYear" -l "$language"
  ruby "$docs_source_dir/components.rb" -n "$prodName" -y "$releaseYear" -l "$language"

  if [ $? -eq 0 ]; then
    scp "$docs_source_dir/output/$crawl_file_name" "$server:~"
    ssh -t "$server" "crawl $crawl_file_name"
  else
    return
  fi
}

crawl-loc() {
componentid="$1"
year="$2"
language="$3"
if [ "$year" == "NA" ]; then
  componentpath="$language/$componentid"
else
  componentpath="$year/$language/$componentid"
fi

"$ECOSYSTEM_DIR/ondemand_cloudhelp.sh" --ebs2-dir "$ECOSYSTEM_DIR" --efs-dir ~/autodesk/help-ecosystem/dita-test -t componentpath -i "$componentpath"
}

grep-id() {
repo_name="$1"
search="$2"
publication_dir="$learning_content_dir/$repo_name/clc"
source_folder="$(grep -R "$search" "$publication_dir" | head -1 | cut -d / -f 8)"
echo "Found $search in $source_folder"
component_id="$(cat "$publication_dir/$source_folder/settings.json" | jq .akn_component_id)"
echo "Component ID: $component_id"
}

# Crawl topic
crawlT() {
  component_id="$1"
  releaseYear="$2"
  language="$3"
  server="${4:-dita-stage-2}"
  crawl_file_name="CrawlTopic"
  [[ -z $server ]] && echo "Missing server" && return

  ssh -t "$server" "echo $releaseYear $language $component_id > $crawl_file_name; crawl $crawl_file_name"
}


#   -----------------------------
#   CONFIG FILES
#   -----------------------------
alias cdd='cd ~/.dotfiles'
alias cdl='cd ~/.dotfiles'
alias vzs="nvim ~/.dotfiles/zshrc"
alias al='nvim ~/.dotfiles/aliases'
alias vgc='nvim ~/.dotfiles/gitconfig'
alias vrc='nvim ~/.dotfiles/vimrc'
alias vplug='nvim ~/.dotfiles/vimrc.bundles'
alias vnv='nvim ~/.config/nvim/init.vim'
alias vpack='nvim ~/.config/nvim/lua/plugins.lua'
alias vlsp='nvim ~/.config/nvim/lua/lspconfig-setup.lua'

gsed() {
  sed -E -i '' "s/$2/$3/g" $(grep -rl $2 $1)
}

#   -----------------------------
#   SOURCING FILES
#   -----------------------------
alias so='source ~/.zshrc; echo "Sourced .zshrc"'

resizeImage() {
  imagePath="$1"
  width=$(magick identify "$imagePath" | cut -f 3 -d ' ' | cut -f 1 -d x)
  echo "Image width: $width"
  if [[ width -gt 1920 ]]; then
    echo "Resizing to be 50% smaller"
    magick "$imagePath" -resize 50% "$imagePath"
  fi
  oxipng -o 4 --strip safe --alpha "$imagePath"
}

require_aws_login() {
  aws sts get-caller-identity > /dev/null 2>&1
  (( $? != 0 )) && echo "ERR: Authentiate aws CLI" && return 1
  return 0
}

test_mdgh() {
  echo "FROM node:18-alpine

  COPY package.json .
  COPY package-lock.json .
  RUN npm install
  COPY CLC-mdgh-metalsmith-metalsmith-dev.zip .
  RUN yes | unzip CLC-mdgh-metalsmith-metalsmith-dev.zip -d .
  COPY clc/regression/* .
  RUN node build

  CMD ["node", "build"]" > Dockerfile
}

alias mvnci="mvn clean install -DskipTests"
alias mvnp="mvn clean package"
ECOSYSTEM_DIR="/Users/wanj/autodesk/beehive-ecosystem"
alias ecosystem="cd $ECOSYSTEM_DIR"
alias up-kpcaas="cp ~/autodesk/dpe/dh-beehive/kpcaasservices/target/kpcaasservices.war ~/autodesk/beehive-ecosystem/kpcaasservices/kpcaasservices.war"
alias up-chp="cp ~/autodesk/dpe/dh-beehive/cloudhelpprocessing/cloudhelpprocessor/target/cloudhelpprocessor-1.2.0.jar ~/autodesk/beehive-ecosystem/cloudhelpprocessor/src"
alias up-hp="cp ~/autodesk/dpe/dh-beehive/cloudhelpprocessing/helpprocessorapp/target/helpprocessorapp-1.2.0.jar ~/autodesk/beehive-ecosystem/helpprocessor/src"
build-kpcaas() {
cd ~/autodesk/dpe/dh-beehive/kpaeroutil
mvnci
if [[ $? -eq 0 ]]; then
  cd ~/autodesk/dpe/dh-beehive/kpcaasservices
  mvnp
fi
}
build-chp() {
cd ~/autodesk/dpe/dh-beehive/cloudhelpprocessing/cloudhelputilEFS
mvnci
if [[ $? -eq 0 ]]; then
  cd ~/autodesk/dpe/dh-beehive/cloudhelpprocessing/cloudhelpprocessor/
  mvnp
fi
}

aeset() { awsl -e "${1:-dev}"; }

mcp() {
  server=$1
  if [ "$server" = "atlassian" ]; then
    docker run --rm -i --env-file /Users/wanj/autodesk/cursor_ws/cursor-strategist/.env -p 9009:9009 ghcr.io/sooperset/mcp-atlassian:latest --transport streamable-http --port 9009 -vv
  elif [ "$server" = "interactive" ]; then
    echo "Running interactive-feedback-mcp"
    cd /Users/wanj/autodesk/tools/interactive-feedback-mcp
    uv sync
    uv run server.py
  else
    echo "Server is unknown"
  fi
}

# Convert markdown in clipboard to Slack mrkdwn format
alias slackmd='pbpaste | sed -E "s/\*\*([^*]+)\*\*/\*\1\*/g; s/~~([^~]+)~~/~\1~/g; s/\[([^]]+)\]\(([^)]+)\)/<\2|\1>/g" | pbcopy'

# GlobalProtect VPN switching (via osascript — panel must not be open)
GP="/Applications/GlobalProtect.app/Contents/MacOS/GlobalProtect"

vpn-status() {
osascript -e '
tell application "System Events"
tell process "GlobalProtect"
click menu bar item 1 of menu bar 2
end tell
end tell' && sleep 3 && osascript -e '
tell application "System Events"
tell process "GlobalProtect"
set texts to {}
repeat with t in (every static text of window 1)
try
set end of texts to value of t
end try
end repeat
return texts
end tell
end tell'
}

vpn-switch() {
local portal="$1"
if [ -z "$portal" ]; then
  echo "Usage: vpn-switch <portal>"
  echo "  vpn-com  — securenetx-commercial.autodesk.com"
  echo "  vpn-std  — securenetx.autodesk.com"
  return 1
fi
echo "⚠️  Don't click anything for 8 seconds..."
sleep 1
osascript -e 'tell application "System Events" to tell process "GlobalProtect" to click menu bar item 1 of menu bar 2'
sleep 1
osascript -e 'tell application "System Events" to tell process "GlobalProtect" to perform action "AXPress" of UI element "Change Portal" of window 1'
sleep 1
if [ "$portal" = "securenetx-commercial.autodesk.com" ]; then
  # Commercial is first entry — arrow down once + enter
  osascript -e 'tell application "System Events" to tell process "GlobalProtect" to key code 125' && sleep 0.3
  osascript -e 'tell application "System Events" to tell process "GlobalProtect" to key code 36'
elif [ "$portal" = "securenetx.autodesk.com" ]; then
  # Standard is second entry — arrow down twice + enter
  osascript -e 'tell application "System Events" to tell process "GlobalProtect" to key code 125' && sleep 0.3
  osascript -e 'tell application "System Events" to tell process "GlobalProtect" to key code 125' && sleep 0.3
  osascript -e 'tell application "System Events" to tell process "GlobalProtect" to key code 36'
else
  echo "Unknown portal: $portal"
  return 1
fi
echo "✅ Switching to $portal — approve MFA if prompted"
}

alias vpn-com='vpn-switch securenetx-commercial.autodesk.com'
alias vpn-std='vpn-switch securenetx.autodesk.com'

wcd() { eval "$(wt cd "${1:-1}")"; }
