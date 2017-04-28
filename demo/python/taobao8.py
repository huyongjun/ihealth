# -*- coding: utf-8 -*-
import requests
import json
import urllib
import urllib2
import xlwt
import re
import socket
import time
import random

socket.setdefaulttimeout(3)

def iptest():
    f = open("./ip_4.txt","rt")
    lines = f.readlines()
    proxys = []
    for i in range(0,len(lines)):
        ip = lines[i].strip("\n").split("\t")
        proxy_host = "http://"+ip[0]+":"+ip[1]
        proxy_temp = {"http":proxy_host}
        proxys.append(proxy_temp)
    return proxys



def getrate_tmall(pid,sid,lastpage,str1):
    '''
    headers={
        'content-type':'text/html;charset=GBK',
        'user-agent':'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36'}
    '''
    pid = str(pid)
    sid = str(sid)
    str1=str1.decode('utf-8').encode('gbk')
    page = 1
    results = {}
    data=xlwt.Workbook()
    table=data.add_sheet('sheet1',cell_overwrite_ok=True)
    table.write(0,0,'rateDate')
    table.write(0,1,'displayUserNick')
    table.write(0,2,'tamllSweetLevel')
    table.write(0,3,'tmall_vip_level')
    table.write(0,4,'userVipLevel')
    table.write(0,5,'rateContent')
    table.write(0,6,'reply')
    row=1
    col=0
    proxys=iptest()
    ipnum=1
    abc=0
    rex=re.compile(r'\w+[(]{1}(.*)[)]{1}')
    n=0
    lost=[]
    #pageall=random.sample(range(99), 99)
    while 1:
        if n>5:
            page +=1
            str2=str1+str(page)
            lost.append(str2)
        print 'page='+str(page)+'\000ipnum='+str(ipnum)+'\000str='+str(str1)+'\000abc='+str(abc)
        abc=0
        url='https://rate.tmall.com/list_detail_rate.htm?itemId={}&sellerId={}&currentPage={}&callback=jsonp{}'.format(pid,sid,page,(page+1000))
        if ipnum >=len(proxys):
            ipnum=ipnum-len(proxys)
        proxy=proxys[ipnum]
        try:
            cont = urllib.urlopen(url,proxies=proxy).read()
            content=rex.findall(cont)[0]
            abc=1
            content=rex.findall(cont)[0]
            con=json.loads(content,"gbk")
            count=len(con['rateDetail']['rateList'])
        except:
            n +=1
            ipnum +=1
            print 'time to back!'
            continue
        ipnum +=1
        for i in range(count):
          table.write(row,col,con['rateDetail']['rateList'][i]['rateDate'])
          table.write(row,col+1,con['rateDetail']['rateList'][i]['displayUserNick'])
          table.write(row,col+2,con['rateDetail']['rateList'][i]['tamllSweetLevel'])
          try:
              table.write(row,col+3,con['rateDetail']['rateList'][i]['attributesMap']['tmall_vip_level'])
          except:
              pass
          try:
              table.write(row,col+3,con['rateDetail']['rateList'][i]['attributes']['tmall_vip_level'])
          except:
              pass
          table.write(row,col+4,con['rateDetail']['rateList'][i]['userVipLevel'])
          table.write(row,col+5,con['rateDetail']['rateList'][i]['rateContent'])
          table.write(row,col+6,con['rateDetail']['rateList'][i]['reply'])
          row += 1
        n=0
        if page !=lastpage:
            page += 1
            continue
        else:
            break
    datastr='./'+str1+'.xls'
    data.save(datastr)
    print str1+'\000'+'finished!'
    print lost


#https://rate.tmall.com/list_detail_rate.htm?itemId=529817969759&sellerId=2081067027&currentPage=5

getrate_tmall(41051316882,2208155356,61,'black')
getrate_tmall(42134369636,684973154,99,'cyan1')
getrate_tmall(522690714411,228752353,99,'cyan2')
getrate_tmall(529817969759,2081067027,99,'cyan3')
getrate_tmall(14969703999,829398099,99,'green1')
getrate_tmall(20447256802,1020360965,99,'green2')
getrate_tmall(41679783953,1911906742,99,'green3')
getrate_tmall(40895267502,1749253629,99,'red1')
getrate_tmall(40433887593,1911906742,99,'red2')
getrate_tmall(530169582915,349908477,99,'red3')
getrate_tmall(20447256802,1020360965,99,'white')
getrate_tmall(43313675195,2364177558,37,'yellow')
print '\n\nAll finished!!!\n\n'
