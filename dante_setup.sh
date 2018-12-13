### NOT A SCRIPT, JUST A REFERENCE!

# install dante-server
sudo apt update
sudo apt install dante-server
# or download latest dante-server deb for Ubuntu, works for 16.04. and 18.04:
wget http://archive.ubuntu.com/ubuntu/pool/universe/d/dante/dante-server_1.4.2+dfsg-2build1_amd64.deb
# or older version:
wget http://ppa.launchpad.net/dajhorn/dante/ubuntu/pool/main/d/dante/dante-server_1.4.1-1_amd64.deb

# install it:
sudo dpkg -i dante-server_*.deb
# it may fail to start, it's okay, packaged config is garbage

# open dante config for editing:
sudo nano /etc/danted.conf

# remove everything (holding Ctrl+K will do it) and copy-paste basic config:
logoutput: syslog
user.privileged: root
user.unprivileged: nobody
# desired proxy ports may differ, used here: POP3 110, IMAP 143, HTTPS 443
internal: 0.0.0.0 port = 110
internal: 0.0.0.0 port = 143
internal: 0.0.0.0 port = 443
# interface name may differ, use `ip a` command and copy non-lo interface:
external: eth0
# set socksmethod to 'none' instead of 'username' if you want to disable auth.
socksmethod: username
clientmethod: none
user.libwrap: nobody
client pass {
        from: 0/0 to: 0/0
        log: connect disconnect error
}
socks pass {
        from: 0/0 to: 0/0
        log: connect disconnect error
}
# end of config

# add system user 'proxyuser' with password to use with sock5 auth:
sudo useradd --shell /usr/sbin/nologin proxyuser
# or:
# sudo adduser --system --no-create-home --disabled-login --group proxyuser
sudo passwd proxyuser
# and input desired password twice

# if you use ubuntu firewall, allow ports:
sudo ufw allow 110
sudo ufw allow 143
sudo ufw allow 443

# restart dante and enable starting on boot:
sudo systemctl restart danted
sudo systemctl enable danted

# you may see dante status:
sudo systemctl status danted

# you may see dante logs (connect disconnect error):
sudo journalctl -xe -u danted
# add -f argument to attach and watch

# test proxy on your local machine:
curl -v -x socks5://proxyuser:password@yourserverip:443 https://www.yandex.ru/

# construct telegram links:
# https://t.me/socks?server=yourserverip&port=443&user=proxyuser&pass=password
# tg://socks?server=yourserverip&port=443&user=proxyuser&pass=password

# used and useful links:
# http://www.inet.no/dante/doc/latest/config/server.html
# http://www.inet.no/dante/doc/latest/config/redundancy.html
# https://www.binarytides.com/setup-dante-socks5-server-on-ubuntu/
# https://krasovsky.me/it/2017/07/socks5-dante/
# https://bitbucket.org/snippets/gudvinr/qd5pA