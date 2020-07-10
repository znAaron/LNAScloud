if [ ! -d ./conf_files ]; then
  mkdir conf_files
fi

if [ ! -d ./conf_files/conf_log.txt ]; then
  cd conf_files
  touch conf_log.txt
  cd ..
fi

echo >>./conf_files/conf_log.txt
time=$(date "+%Y/%m/%d-%H:%M:%S")
echo configuration starting at $time >>./conf_files/conf_log.txt
echo ================================ >>./conf_files/conf_log.txt

$workdir=$(pwd) 

# The output of all these installation steps is noisy. With this utility
# the progress report is nice and concise.
function install {
    echo installing $1...
    shift
    apt-get -y install "$@" >>$workdir/conf_files/conf_log.txt #2>&1
}
function doing {
    echo doing $@...
    "$@" >>$workdir/conf_files/conf_log.txt #2>&1
}

doing apt-add-repository -y ppa:brightbox/ruby-ng
doing apt-get -y update

install 'development tools' build-essential dkms curl libxslt-dev libpq-dev python-dev libmariadbclient-dev libcurl4-gnutls-dev libevent-dev libffi-dev stunnel4 libsqlite3-dev
install 'Git' git

#install ruby
sudo apt-add-repository 'deb http://security.ubuntu.com/ubuntu bionic-security main'
sudo apt update && apt-cache policy libssl1.0-dev
install libssl1.0-dev libreadline-dev

cd
doing git clone https://github.com/rbenv/rbenv.git ~/.rbenv
doing echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
doing echo 'eval "$(rbenv init -)"' >> ~/.bashrc
doing exec $SHELL

doing git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
doing echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
doing exec $SHELL

doing rbenv install 2.3.3
doing rbenv global 2.3.3
gem install bundler
cd $workdir

#config mySQL
doing sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
doing sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
install 'MySQL' mysql-server libmysqlclient-dev

sudo mysql -uroot -proot <<SQL
CREATE DATABASE codeworkout DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE DATABASE opendsa DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;

GRANT ALL PRIVILEGES ON codeworkout.* to 'codeworkout'@'localhost' IDENTIFIED BY 'codeworkout';
FLUSH PRIVILEGES;

GRANT ALL PRIVILEGES ON opendsa.* to 'opendsa'@'localhost'  IDENTIFIED BY 'opendsa';
FLUSH PRIVILEGES;
SQL
install 'Nokogiri dependencies' libxml2 libxml2-dev libxslt1-dev

# install node
doing sudo apt-get -y purge nodejs
doing sudo apt-get -y purge npm
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - >>./conf_files/conf_log.txt 2>&1
doing sudo apt-get -y install nodejs
doing sudo apt-get -y install npm
doing sudo apt-get -y install uglifyjs
doing sudo ln -s "$(which nodejs)" /usr/local/bin/node
doing npm install -g jshint
doing npm install -g csslint
doing npm install -g jsonlint
doing npm install -g uglify-js
doing npm install -g bower

# install Nginx
doing apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
doing apt-get install -y apt-transport-https ca-certificates
doing sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main > /etc/apt/sources.list.d/passenger.list'
doing apt-get update
doing apt-get install -y nginx-extras passenger
doing service nginx start
echo passenger_root /usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini; >>/etc/nginx/nginx.conf
echo passenger_ruby /home/$USER/.rbenv/shims/ruby; >>/etc/nginx/nginx.conf
doing service nginx start
doing update-rc.d nginx defaults
doing System start/stop links for /etc/init.d/nginx already exist.

# Needed for docs generation.
update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8


# install hh tool
doing sudo apt-add-repository -y ppa:ultradvorka/ppa
doing sudo apt-get update
doing sudo apt-get install -y hh

install 'HHTools' libncurses5-dev libreadline-dev
doing wget https://github.com/dvorka/hstr/releases/download/1.10/hh-1.10-src.tgz
doing tar xf hh-1.10-src.tgz

cd hstr
./configure >>../conf_files/conf_log.txt 2>&1
make >>../conf_files/conf_log.txt 2>&1
make install >>../conf_files/conf_log.txt 2>&1
hh --show-configuration >> ~/.bashrc
source ~/.bashrc
cd ..
rm -f hh-1.10-src.tgz

# install Java 8 and Ant
doing sudo apt-add-repository -y ppa:webupd8team/java
doing sudo apt-get update
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
install 'java' oracle-java8-installer
install 'ant' ant

# Clone code-workout
if [ ! -d ./repo/code-workout ]; then
  git clone https://github.com/OpenDSA/code-workout.git ./repo/code-workout
fi
cd ./repo/code-workout
git pull
bundle install
bundle exec rake db:populate
cd ..
cd ..

# Clone OpenDSA
if [ ! -d ./repo/OpenDSA ]; then
  git clone https://github.com/OpenDSA/OpenDSA.git ./repo/OpenDSA
fi
cd ./repo/OpenDSA/
make pull
pip install -r requirements.txt --upgrade
cd ..
cd ..

# Clone OpenDSA-LTI
if [ ! -d ./vagrant/OpenDSA-LTI ]; then
  git clone https://github.com/OpenDSA/OpenDSA-LTI.git ./repo/OpenDSA-LTI
fi
cd ./repo/OpenDSA-LTI
git pull
sudo gem install rake -v 11.2.2

bundle install
bundle exec rake db:reset_populate
cd ..
cd ..

sudo bower install --allow-root
echo 'all set, welcome to OpenDSA project!'
echo "your password for mysql is 'rootPass', you should change it later"