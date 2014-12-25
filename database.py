#!/usr/bin/python
import MySQLdb
import random

def getSupporter(onlineUsers):
    """Parameter onlineUsers must be a list"""
    db = MySQLdb.connect(host="localhost", # your host, usually localhost
                         user="polarbear", # your username
                         passwd="polarbear", # your password
                         db="spa") # name of the data base
    cur = db.cursor()
    
    #concat list with online users to string with single quotes and comma separated
    stringOnlineUsers = ', '.join(map(lambda x: "'" + x + "'", onlineUsers))

    #and put list into the IN clause of the query
    query = "SELECT jid FROM presence where jid IN ( %s ) order by daily_call_count;" % stringOnlineUsers
    
    cur.execute(query)
    rows = cur.fetchall()
    if len(rows) > 0:
        supporter = rows[random.randint(0,len(rows)-1)][0]
    else:
        supporter = None
    #add 1 to the daily_call_count of the selected user
    print supporter
    query = "UPDATE presence SET daily_call_count = daily_call_count + 1 WHERE jid = '%s';" % supporter
    cur.execute(query)
    db.commit()
    cur.close()
    db.close()
    return supporter


if __name__ == "__main__" :
    supporterList = ['supporter1@suizid-app.ch', 'supporter0@suizid-app.ch', 'supporter2@suizid-app.ch', 'supporter4@suizid-app.ch', 'supporter5@suizid-app.ch']    
    print getSupporter(supporterList)
