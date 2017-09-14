# safe-server

No Info for you for safety

## Installation

### Average usage

```bash
sudo su
rm -f install-shadowsocks-spdy.sh
wget --no-cache -q https://raw.githubusercontent.com/free-server/safe-server/master/install-shadowsocks-spdy.sh
bash install-shadowsocks-spdy.sh
```

### Moderate users (count of users served per server)

```bash
sudo su
rm -f install-shadowsocks-spdy.sh
wget --no-cache -q https://raw.githubusercontent.com/free-server/safe-server/master/install-shadowsocks-spdy.sh
bash install-shadowsocks-spdy.sh 5

# 5 means this server only serves 5 users (by default it counts from current user list)
# It matters with connection speed limitation
```

### With CISCO AnyConnect VPN (Ocserv OpenConnect)

```bash
sudo su

echo "export isToInstallOcservCiscoAnyConnect=1" >> ~/.bashrc
. ~/.bashrc

rm -f install-shadowsocks-spdy.sh
wget --no-cache -q https://raw.githubusercontent.com/free-server/safe-server/master/install-shadowsocks-spdy.sh
bash install-shadowsocks-spdy.sh
```

Note that, the script could be redeployed/reinstalled on your Ubuntu without worries on losing any old Shadowsocks-R and HTTP2/SPDY account or password.
It backs them up if found any before execute re-installation.

### Do not take 8443 and 80
```bash
sudo su
echo "export miscWebsitePortHttps=8443" >> ~/.bashrc
echo "export miscWebsitePortHttp=8080" >> ~/.bashrc
```

## Alternative TCP Optimized Installation (Chinese)
Google: [TCP BBR](https://doub.io/wlzy-16/)

## Create User

```bash
# Assume you didn't change $freeServerRoot

# Shadowsocks-r+HTTP2/SPDY VPN: 
sudo /opt/free-server/git-repo/free-server/bin/createuser.sh User Pass ShadowsocksRPort SPDYPort

# e.g. 
sudo /opt/free-server/git-repo/free-server/bin/createuser.sh test1 test123 10000 10401

```

* Once user created, shell script will echo back ShadowsocksR QR Code scheme and its web link,
which includes all the user credentials and configurations for your clients (iOS/Android/Windows SSR Client) to import.

## How to setup clients

* ShadowsocksR default settings:

```bash
export shadowsocksREncrypt="aes-256-cfb"
export shadowsocksRObfuscate="tls1.2_ticket_auth"
export shadowsocksRProtocol="auth_sha1_v4"
export shadowsocksRObfuscateParam="s3.amazonaws.com"
```

## Delete User

```bash
# Assume you didn't change $freeServerRoot

# Shadowsocks-r+HTTP2/SPDY VPN: 
sudo /opt/free-server/git-repo/free-server/bin/deleteuser.sh User Pass ShadowsocksRPort SPDYPort

# e.g. 
sudo /opt/free-server/git-repo/free-server/bin/deleteuser.sh test1 test123 10000 10401

```

## License

MIT