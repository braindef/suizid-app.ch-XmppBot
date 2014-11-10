import requests
from requests.auth import HTTPBasicAuth
from xml.dom.minidom import parse, parseString

#depending on the ejabberd version you have to give the username with or without domain, the admin user is configured in the /etc/ejabberd/ejabberd.cfg file, you can test it with accessing the website manually
user = "landev"
password = "password"
server = "ns3.ignored.ch"
virtualhost = "ns3.ignored.ch"


add_user_url = "http://%s:5280/admin/server/%s/users/" % (server, virtualhost)
del_user_url = "http://%s:5280/admin/server/%s/user/" % (server, virtualhost)
get_online_user_url = "http://%s:5280/admin/server/%s/online-users/" % (server, virtualhost)
auth = HTTPBasicAuth(user, password)


def getOnlineUsers():
    
    users = []
    
    resp = requests.get(get_online_user_url, auth=auth)
    dom = parseString(resp.text)
    onlineUsers = dom.childNodes[1].childNodes[1].childNodes[0].childNodes[2]
    usersCount = onlineUsers.childNodes.length
    #in case the webinterface of ejabberd changes you have to make changes here
    for i in range(1,usersCount):
        if onlineUsers.childNodes[i].toxml() != "<br/>":
           user = onlineUsers.childNodes[i].firstChild.nodeValue
           users.append(user)
    return users

def createUser(user, password):

    data = { 'newusername': user,
             'newuserpassword': password,
             'addnewuser': "Add User" }

    resp = requests.post(add_user_url, data=data, auth=auth)
    return resp.status_code == 200

def deleteUser(user):

    data = { 'removeuser': "Remove User" }
    print "ejabberd.py" + del_user_url+str(user)+"/"
    resp = requests.post(del_user_url+str(user)+"/", data=data, auth=auth)
    return resp.status_code == 200




if __name__ == "__main__":
    print createUser("landev2", "password")
    print getOnlineUsers()
    print createUser("test77", "password")
    print deleteUser("test77")

