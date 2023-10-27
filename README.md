# safe-server

No Info for you for safety

## Installation

### Prerequisites

* Amazon EC2 / Vultr / Linode or Microsoft Azure;
* Ubuntu Server 16-20 (14 LTS may work as well)
* RAM 1Gb+; SSD Drive is preferred.
* [IMPORTANT] Firewall inbound: TCP 22, 25, 80, 443 and all ports you want to use in SSR / HTTP2. Say 10000-30000
* Firewall outbound: all ports
* A Domain 
  - Domain A record is pointing to the Ubuntu server IP (IPV4)
  - Domain MX Record set to correct smtp server, say `smtp.secureserver.net`
  - Domain TXT Record set to `v=spf1 mx -all` ([SPF](https://hk.godaddy.com/en/help/add-an-spf-record-19218))

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

Note that, the script could be redeployed/reinstalled on your Ubuntu without worries on losing any old Shadowsocks-R and HTTP/2 account or password.
It backs them up if found any before execute re-installation.

### Do not take 443 and 80
```bash
sudo su
echo "export miscWebsitePortHttps=8443" >> ~/.bashrc
echo "export miscWebsitePortHttp=8080" >> ~/.bashrc
```
 - This is to use port 8443 and 8080 instead 443 and 80;
- Make sure you enable those ports you assigned in your Firewall.

## Alternative TCP Optimized Installation (Chinese)
Google: [TCP BBR](https://doub.io/wlzy-16/)

## Create User

```bash
# Assume you didn't change $freeServerRoot

# Shadowsocks-r+HTTP2 VPN:
sudo /opt/free-server/git-repo/free-server/bin/createuser.sh User Pass ShadowsocksRPort HTTP2Port EmailAddress

# e.g.
sudo /opt/free-server/git-repo/free-server/bin/createuser.sh test1 test123 10000 10401 SOME_SOME_USER@qq.com

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

* HTTP2

After you created a user, you should know.

## Delete User

```bash
# Assume you didn't change $freeServerRoot

# Shadowsocks-r+HTTP2 VPN:
sudo /opt/free-server/git-repo/free-server/bin/deleteuser.sh User Pass ShadowsocksRPort HTTP2Port SOME_SOME_USER@qq.com

# e.g.
sudo /opt/free-server/git-repo/free-server/bin/deleteuser.sh test1 test123 10000 10401 SOME_SOME_USER@qq.com

```

## Client setup

* After User created, you should see Terminal echo with client setup guide

## OpenWRT / GL.iNet
For those using OpenWRT or GL.iNet router, to support ShadowsocksR
```
ssh root@192.168.8.1
# Enter the same password you used to login the web UI
```
In the connected SSH session
```bash
opkg update
opkg install luci luci-base luci-compat luci-lib-ipkg luci-app-shadowsocksR luci-app-shadowsocksR-GFW
opkg
rm -rf /tmp/luci-indexcache /tmp/luci-modulecache

```
Then open Web UI SSR config
http://192.168.8.1/cgi-bin/luci/admin/services/shadowsocksr

## Caveats

* OpenSSL will be upgraded to 1.1.1w
* A bunch of scripts will be added into /etc/cron.d/ for monitoring safe-server service
* Let's Encrypt TLS Certs will be applied for your domain
* Safe server will be automatically up-to-date monthly

## Change Logs

* [INFO] - 05/01/2019 - [enhancement] - Add gfwlis-banAD.acl for ssr android
* [INFO] - 02/01/2019 - [enhancement] - Upgrade nghttpx to 1.35.1 to support TLS1.3 0-RTT for faster connection
* [INFO] - 13/12/2018 - [feature] - Add auto update free-server itself monthly
* [INFO] - Remove SPDYLay, only keeping HTTP/2 as Chrome supports HTTP/2 well

## License

MIT
