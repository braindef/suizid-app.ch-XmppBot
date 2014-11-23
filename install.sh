sudo apt-get install mysql-server python-pip python-mysqldb python-dnspython python-pyasn1
sudo apt-get install python-setuptools
sudo python -m easy_install pip

sudo pip install requests

echo then you have to enable ejabberd module mod_register_web in the ejabberd.yml

git submodule init
git submodule update

cp ./concierge.sh /etc/init.d/concierge.sh
update-rc.d concierge.sh defaults
update-rc.d concierge.sh enable

echo Remenber remember to first change the hostname, then install ejabberd because the erlang library registers the hostname

echo creating database with some test users
./createDatabase.sh


