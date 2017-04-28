#encoding=utf8
#这是获取代理IP网页的IP地址的程序，保存为ip.txt
import urllib2
import BeautifulSoup

User_Agent = 'Mozilla/5.0 (Windows NT 6.3; WOW64; rv:43.0) Gecko/20100101 Firefox/43.0'
header = {}
header['User-Agent'] = User_Agent

url = 'http://www.xicidaili.com/nn/10'
req = urllib2.Request(url,headers=header)
res = urllib2.urlopen(req).read()

soup = BeautifulSoup.BeautifulSoup(res)
ips = soup.findAll('tr')
f = open("./ip_1.txt","a")

for x in range(1,len(ips)):
    ip = ips[x]
    tds = ip.findAll("td")
    ip_temp = tds[1].contents[0]+"\t"+tds[2].contents[0]+"\n"
    # print tds[2].contents[0]+"\t"+tds[3].contents[0]
    f.write(str(ip_temp))
f.close()
