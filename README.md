Quasardb RPM packages
=====================

This repository contains scripts that transforms the quasardb tarballs into .rpm files.

# Required packages

To compile the quasardb packages, you need to has these installed:

1. gettext
2. rpm-build

# Compilation instructions:

1. Download the tarball package from https://download.quasardb.net/quasardb
2. Invoke the corresponding build script, with the path of the tarball on the command line

### Example

    # Clone this repository
    git clone https://github.com/bureau14/qdb-pkg-rpm.git
    cd qdb-pkg-rpm

    # Build package "server"
    cd qdb-server
    wget https://download.quasardb.net/quasardb/2.1/2.1.1/server/qdb-2.1.1-linux-64bit-server.tar.gz
    ./pack.sh qdb-2.1.1-linux-64bit-server.tar.gz

<<<<<<< HEAD
||||||| parent of 2ecb4fe (QDB-17141 - Fix sysctl RPM config (#10))
# Using Docker

1. Set the package version in qdb-pkg-rpm/common/get-version.sh
2. Put the tarball package in its folder.
    For example, if you want to build an rpm pakcer for qdb-server put the server tarball in qdb-pkg-rpm/qdb_server/
3. Download code-signing and put it in the root of the repo (qdb-pkg-rpm/code-signing)
4. Run Docker
    ```
    docker run -v ${PWD}/work -ti docker.io/bureau14/qdb-pkg-rpm:latest
    ```
5. Go to the component you want to build and run pack.sh
    ```
    cd /work/qdb-server
    ./pack.sh qdb-3.13.1-linux-64bit-server.tar.gz
    ```
6. Sign the package
    ```
    ../code-signing/rpmsign.sh qdb-server
    ```


# Using Docker

1. Set the package version in qdb-pkg-rpm/common/get-version.sh
2. Put the tarball package in its folder.
    For example, if you want to build an rpm pakcer for qdb-server put the server tarball in qdb-pkg-rpm/qdb_server/
3. Download code-signing and put it in the root of the repo (qdb-pkg-rpm/code-signing)
4. Run Docker
    ```
    docker run -v ${PWD}:/work -ti docker.io/bureau14/qdb-pkg-rpm:latest
    ```
5. Go to the component you want to build and run pack.sh
    ```
    cd /work/qdb-server
    ./pack.sh qdb-3.13.1-linux-64bit-server.tar.gz
    ```
6. Sign the package
    ```
    ../code-signing/rpmsign.sh qdb-server
    ```


# Warning
If you experience a problem while installing or upgrading after previously uninstalling an older version you can need to check the rights for the following files and folders. They should be `qdb:qdb`.
