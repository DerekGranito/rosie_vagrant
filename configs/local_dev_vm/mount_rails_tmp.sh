#!/bin/bash

##
# @file
#   Mounts the Rails `tmp` and `log` folders off shares and into temporary
#   space inside a Vagrant / VirtualBox VM for compatibility and improved I/O
#   performance.
#
# @author Guy Paddock (guy@rosieapp.com)
#

# Enable sane error checking in Bash
set -u
set -e

HOST_ROOT='/home/vagrant/host'
RAILS_MOUNT_FOLDERS=('tmp' 'log' 'public/uploads/tmp');

function find_rails_projects {
  RAILS_PROJECT_PATHS=`find "${HOST_ROOT}" -maxdepth 2 -name 'Gemfile' -type f -exec grep --files-with-matches "'rails'" {} ';' | xargs -L 1 dirname`;
}

function mount_rails_project {
  project_root="$1";
  project="$2";
  
  project_tmp_root="/tmp/rails/${project}";
  
  echo "[${project}] Mounting Rails folders into /tmp namespace...";

  for folder in ${RAILS_MOUNT_FOLDERS[*]}; do
    full_src_path="${project_root}/${folder}";
    full_dest_path="${project_tmp_root}/${folder}";
    
    echo "  ${full_dest_path} => ${full_src_path}";
    
    # Ensure all the folders exist to avoid errors.
    make_path_exist "${full_src_path}";
    make_path_accessible "${full_dest_path}";

    # Actually do the mounting
    sudo mount --bind "${full_dest_path}" "${full_src_path}";
  done;

  echo_blank_line;  
}

function mount_rails_projects {
  echo "Searching for Rails projects..."
  echo_blank_line;

  find_rails_projects;
  
  for project_root in ${RAILS_PROJECT_PATHS[*]}; do
    project=`basename "${project_root}"`
    
    if [ -d "${project_root}" ]; then
      mount_rails_project $project_root $project;
    fi;
  done;
}

function make_path_exist {
  path="$1";
 
  if [ ! -d "${path}" ]; then
    make_path_accessible "${path}";
  fi;
}

function make_path_accessible {
  path="$1";
  
  mkdir -p "${path}";
  sudo chown -R vagrant:vagrant "${path}" || echo "Unable to change owner of '${path}'.";
  chmod u+rwx -R "${path}" || echo "Unable to change permissions on '${path}'.";
}

function echo_blank_line {
  # NOTE: This is a non-breaking space, because Vagrant trims empty lines :(
  echo ' ';
}

mount_rails_projects;