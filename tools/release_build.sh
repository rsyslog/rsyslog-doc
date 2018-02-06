#!/bin/bash

# Do not allow use of unitilized variables
set -u

# Exit if any statement returns a non-true value
set -e


# Read the riot act, give user an option to bail before building the docs

echo <<DISCLAIMER "

#######################################################################
#                                                                     #
# Purpose: Create official rsyslog docs release build:                #
#                                                                     #
#   * tarball (ready for use by downstream users)                     #
#   * fresh v8-stable HTML format with stable release string          #
#                                                                     #
# Before proceeding, please confirm that you have performed the       #
# following steps:                                                    #
#                                                                     #
# 1. Manually fetched, merged and tagged the changes to the stable    #
#    branch that are intended to reflect the latest release.          #
#                                                                     #
# 2. Saved all uncommitted files to help prevent their loss as part   #
#    of the cleanup performed between builds.                         #
#                                                                     #
#             PRESS ENTER TO CONTINUE OR CTRL+C TO CANCEL             #
#                                                                     #
#######################################################################
"
DISCLAIMER

read -r REPLY



#####################################################################
# Functions
#####################################################################

get_release_version() {

	# Retrieve the list of Git tags and return the newest without
    # the leading 'v' prefix character
	git tag --list 'v*' | \
	sort --version-sort | \
	grep -Eo '^v[.0-9]+$' | \
	tail -n 1 |\
	sed "s/[A-Za-z]//g"
}


# Reset build environment so that the next build starts from a clean state
reset_build_env() {

    branch=$1

    rm -rf build
    git reset --hard
    git checkout -f $branch

}


#####################################################################
# Setup
#####################################################################

stable_branch="v8-stable"

# The latest stable tag, but without the leading 'v'
# Format: X.Y.Z
release=$(get_release_version)

# The release version, but without the trailing '.0'
# Format: X.Y
version=$(echo $release | sed 's/.0//')

# Use the full version number
docfile=rsyslog-doc-${release}.tar.gz

# The build conf used to generate release output files. Included
# in the release tarball and needs to function as-is outside
# of a Git repo (e.g., no ".git" directory present).
sphinx_build_conf_prod="source/conf.py"

# This is the set of sphinx-build override options that will be passed into
# the Docker container for use during doc builds. We pass these
# values in to override the default theme choice/options with settings
# intended for use on rsyslog.com/doc/
#sphinx_build_overrides='-D html_theme="better" -D html_theme_path="/usr/lib/local/python2.7/site-packages,/usr/local/python2.7/dist-packages" -D html_theme_options.inlinecss="@media (max-width: 820px) { div.sphinxsidebar { visibility: hidden; } }"'
sphinx_build_overrides="-D html_theme=classic"



# Which docker image should be used for the build?
# https://hub.docker.com/r/rsyslog/rsyslog_doc_gen/
docker_image="deoren/rsyslog_doc_gen:i536"

# What additional options should be used for the build?
sphinx_extra_options="-q"


#####################################################################
# Sanity checks
#####################################################################

[ -d ./.git ] || {
    echo "[!] Pre-build check fail: .git directory missing"
    echo "    Run $0 again from a clone of the rsyslog-doc repo."
    exit 1
}


#####################################################################
# Cleanup from last build, prep for new one
#####################################################################

reset_build_env $stable_branch

# Pull in the latest tagsin order to calculate the latest stable version
git pull --tags


#####################################################################
# Fill out template
#####################################################################

# To support building from sources included in the tarball AND
# to allow dynamic version generation we modify the placeholder values
# in the Sphinx build configuration file to reflect the latest stable
# version. Without this (e.g., if someone just calls sphinx-build
# directly), then dev build values will be automatically calculated
# using info from the Git repo if available, or will fallback to
# the placeholder values provided for non-Git builds (e.g., someone
# downloads the 'master' branch as a zip file from GitHub).

sed -r -i "s/^version.*$/version = \'${version}\'/" ./${sphinx_build_conf_prod} || {
    echo "[!] Failed to replace version placeholder in Sphinx build conf template."
    exit 1
}

sed -r -i "s/^release.*$/release = \'${release}\'/" ./${sphinx_build_conf_prod} || {
    echo "[!] Failed to replace release placeholder in Sphinx build conf template."
    exit 1
}


#####################################################################
# Cleanup from last run
#####################################################################

[ ! -d ./build ] || rm -rf ./build || {
    echo "[!] Failed to prune old build directory."
    exit 1
}

[ ! -e ./$docfile ] || rm -f ./$docfile || {
    echo "[!] Failed to prune $docfile tarball"
    exit 1
}


#####################################################################
# Build stable release HTML format using reference docker image
#####################################################################

echo "======starting doc generation======="
sudo docker pull $docker_image # get fresh version
export DOC_HOME="$PWD"

sudo docker run -ti --rm \
        -u `id -u`:`id -g` \
        -e STRICT="" \
        -e SPHINX_EXTRA_OPTS="\"$sphinx_extra_options\" \"$sphinx_build_overrides\"" \
        -v "$DOC_HOME":/rsyslog-doc \
        $docker_image || {
	echo "sphinx-build failed... aborting"
	exit 1
}

#####################################################################
# Create dist tarball
#####################################################################

tar -czf $docfile build source LICENSE README.md || {
	echo "Failed to create $docfile tarball..."
	exit 1
}


#####################################################################
# Revert local changes to Sphinx config file
#####################################################################

git checkout ./${sphinx_build_conf_prod} || {
       echo "[!] Failed to restore Sphinx build config to repo version"
       exit 1
}
