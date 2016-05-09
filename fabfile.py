#pylint: skip-file
#
# fabfile.py
#
# Copyright (c) 2015-2016 Junpei Kawamoto
#
# This software is released under the MIT License.
#
# http://opensource.org/licenses/mit-license.php
#
from fabric.api import *
from fabric.contrib.project import rsync_project
env.use_ssh_config = True

PACKAGE = "ambassadors"

@task
def build():
    """ Build a Docker image.
    """
    run("mkdir -p " + PACKAGE)
    rsync_project(
        local_dir=".", remote_dir=PACKAGE, exclude=['.git'])
    with cd(PACKAGE):
        run("docker build -t jkawamoto/{0} .".format(PACKAGE))

@task
def rpi_build():
    """ Build a Docker image for Raspberry Pi.
    """
    run("mkdir -p " + PACKAGE)
    rsync_project(
        local_dir=".", remote_dir=PACKAGE, exclude=['.git'])
    with cd(PACKAGE):
        run("mv Dockerfile.rpi Dockerfile")
        run("docker build -t jkawamoto/rpi-{0} .".format(PACKAGE))
