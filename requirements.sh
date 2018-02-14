# What we need to get started.
HOME_DIR=/home/repl
HOME_COPY=/.course_home
USER_GROUP=repl:repl
PIP=pip3
SHELLWHAT_EXT=git+https://github.com/datacamp/shellwhat_ext.git

# Report start.
echo ''
echo '----------------------------------------'
echo 'START TIME:' $(date)
echo 'HOME_DIR: ' ${HOME_DIR}
echo 'This message is to force a rebuild 8.'
echo

# Make sure we have text editors and unzip.
apt-get update
apt-get -y install nano
apt-get -y install emacs
apt-get -y install unzip

# add nano syntax highlighting
#sudo -u repl wget https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh -O ${HOME_DIR}/install.sh
#sudo -u repl -i bash ${HOME_DIR}/install.sh -l
#rm ${HOME_DIR}/install.sh
sudo -u repl -i git clone https://github.com/scopatz/nanorc.git /home/repl/.nano
sudo -u repl -i cp /home/repl/.nano/nanorc /home/repl/.nanorc

# Echo shell commands as they are executed.
set -x

# Get the shellwhat_ext student correctness test extensions.
${PIP} install ${SHELLWHAT_EXT}

# Get miniconda.
sudo -u repl wget -nv https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ${HOME_DIR}/miniconda.sh
sudo -u repl -i bash ${HOME_DIR}/miniconda.sh -b -p ${HOME_DIR}/miniconda
rm ${HOME_DIR}/miniconda.sh

mkdir ${HOME_DIR}/.conda
touch ${HOME_DIR}/.conda/environments.txt
chown -R repl:repl /home/repl/.conda

# Update conda
sudo -u repl -i /home/repl/miniconda/bin/conda update conda --yes
echo ". /home/repl/miniconda/etc/profile.d/conda.sh" >> ${HOME_DIR}/.bashrc
echo "conda activate base" >> ${HOME_DIR}/.bashrc

# add packages and envs
sudo -u repl /home/repl/miniconda/bin/conda update conda --yes
sudo -u repl -i /home/repl/miniconda/bin/conda install conda-build --yes
sudo -u repl -i /home/repl/miniconda/bin/conda install anaconda-project --yes
sudo -u repl -i /home/repl/miniconda/bin/conda create -n _test python=3 pandas statsmodels --yes
sudo -u repl /home/repl/miniconda/bin/conda create -n py1.0 python=1.0 --yes

# Change prompt.
echo "export PS1='\$ '" >> ${HOME_DIR}/.bashrc

# Show what's been done where.
echo 'Last 5 lines of .bashrc'
tail -n 5 ${HOME_DIR}/.bashrc
echo 'Listing /solutions.'
ls -R /solutions

# download datasets
sudo -u repl wget -nv https://s3.amazonaws.com/assets.datacamp.com/production/course_6859/datasets/babynames.zip -O ${HOME_DIR}/babynames.zip
sudo -u repl unzip ${HOME_DIR}/babynames.zip -d ${HOME_DIR}
rm ${HOME_DIR}/babynames.zip

# Make copy for resetting exercises.
# Files there will replace /home/repl each exercise.
# IMPORTANT: Trailing slashes after directory names force rsync to do the right thing.
rsync -a ${HOME_DIR}/ ${HOME_COPY}/
chown -R ${USER_GROUP} ${HOME_COPY}

# Report end of installation.
echo
echo 'ENDING requirements.sh'
echo '----------------------------------------'
echo ''
