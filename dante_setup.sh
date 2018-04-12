### NOT A SCRIPT, JUST A REFERENCE!

# download latest dante-server deb:
wget http://ppa.launchpad.net/dajhorn/dante/ubuntu/pool/main/d/dante/dante-server_1.4.1-1_amd64.deb

# install it:
sudo dpkg -i dante-server_1.4.1-1_amd64.deb
# it would fail to start, it's okay, packaged config is garbage

# open dante config for editing:
sudo nano /etc/danted.conf

# remove everythong (holding Ctrl+K will do it) and copy basic config:
logoutput: syslog
user.privileged: root
user.unprivileged: nobody
# interface name and desired proxy port may differ, use `ip a` command to see interfaces:
internal: eth0 port = 1080
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

# restart dante and enable starting on boot:
sudo systemctl restart danted
sudo systemctl enable danted

# if you use ubuntu firewall, allow port:
sudo ufw allow 1080

# add system user with password to use with sock5 auth:
sudo adduser proxyuser

# you may see dante status:
sudo systemctl status danted

# you may see dante logs (connect disconnect error):
sudo journalctl -xe -u danted
# add -f argument to attach and watch

# test proxy on your local machine:
curl -v -x socks5://proxyuser:proxyuserpass@yourserverip:1080 https://www.yandex.ru/

# construct telegram links:
# https://t.me/socks?server=yourserverip&port=1080&user=proxyuser&pass=proxyuserpass
#  or:
# tg://socks?server=yourserverip&port=1080&user=proxyuser&pass=proxyuserpass

# used and useful links:
# http://www.inet.no/dante/
# https://www.binarytides.com/setup-dante-socks5-server-on-ubuntu/
# https://krasovsky.me/it/2017/07/socks5-dante/
# https://bitbucket.org/snippets/gudvinr/qd5pA