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

workdir=$(pwd) 

# The output of all these installation steps is noisy. With this utility
# the progress report is nice and concise.
function install {
    echo installing $1...
    shift
    apt-get -y install "$@" >>$workdir/conf_files/conf_log.txt #2>&1
}
function doing {
    echo doing: $@...
    "$@" >>$workdir/conf_files/conf_log.txt #2>&1
}

#doing apt-add-repository -y ppa:brightbox/ruby-ng
#doing apt-get -y update

#install 'development tools' build-essential dkms curl libxslt-dev libpq-dev python-dev libmariadbclient-dev libcurl4-gnutls-dev libevent-dev libffi-dev libssl-dev stunnel4 libsqlite3-dev
#install 'Git' git

#install ruby
cd
if [ ! -d ~/.rbenv ]; then
    doing git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    source ~/.bashrc
fi

if [ ! -d ~/.rbenv/plugins/ruby-build ]; then
    doing git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
    echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
fi

doing rbenv install 2.3.1
doing rbenv global 2.3.1
gem install bundler
cd $workdir
