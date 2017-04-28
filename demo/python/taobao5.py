#encoding=utf8
#这是检测IP是否可以使用的程序，保存可用IP为ip2.txt
import urllib
import socket
socket.setdefaulttimeout(3)
f1 = open('./ip_3.txt','rt')
lines = f1.readlines()
proxys = []
url='http://www.youku.com/'
n=0
#url='https://www.taobao.com/?spm=a1z09.3.1581860521.1.mqqglk'
f = open("./ip_4.txt","w")
for i in range(0,len(lines)):
    ip = lines[i].strip("\n").split("\t")
    proxy_host = "http://"+ip[0]+":"+ip[1]
    proxy = {"http":proxy_host}
    if i%50==1:
        print i
        print n
    if n>0:
        break
    #proxys.append(proxy_temp)
    try:
        res = urllib.urlopen(url,proxies=proxy).read()
        if len(res)>20000:
            #print res
            f.write(lines[i])
            n +=1
        #f.write('\n')
        #print 'Good!'
    except Exception,e:
        #print proxy
        #print e
        #print 'Bad!'
        continue
f.close()
f1.close()
