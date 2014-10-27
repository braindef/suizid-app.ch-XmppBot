#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
    SleekXMPP: The Sleek XMPP Library
    Copyright (C) 2010  Nathanael C. Fritz
    This file is part of SleekXMPP.

    See the file LICENSE for copying permission.
"""

import sys
import logging
import getpass
from optparse import OptionParser

import sleekxmpp

import ejabberd
import time
import database




# Python versions before 3.0 do not use UTF-8 encoding
# by default. To ensure that Unicode is handled properly
# throughout SleekXMPP, we will set the default encoding
# ourselves to UTF-8.
if sys.version_info < (3, 0):
    from sleekxmpp.util.misc_ops import setdefaultencoding
    setdefaultencoding('utf8')
else:
    raw_input = input


class EchoBot(sleekxmpp.ClientXMPP):

    """
    A simple SleekXMPP bot that will echo messages it
    receives, along with a short thank you message.
    """

    def __init__(self, jid, password):
        sleekxmpp.ClientXMPP.__init__(self, jid, password)

        # The session_start event will be triggered when
        # the bot establishes its connection with the server
        # and the XML streams are ready for use. We want to
        # listen for this event so that we we can initialize
        # our roster.
        self.add_event_handler("session_start", self.start)

        # The message event is triggered whenever a message
        # stanza is received. Be aware that that includes
        # MUC messages and error messages.
        self.add_event_handler("message", self.message)

    def start(self, event):
        """
        Process the session_start event.

        Typical actions for the session_start event are
        requesting the roster and broadcasting an initial
        presence stanza.

        Arguments:
            event -- An empty dictionary. The session_start
                     event does not provide any additional
                     data.
        """
        self.send_presence()
        self.get_roster()

    def message(self, msg):
        """
        Process incoming message stanzas. Be aware that this also
        includes MUC messages and error messages. It is usually
        a good idea to check the messages's type before processing
        or sending replies.

        Arguments:
            msg -- The received message stanza. See the documentation
                   for stanza objects and the Message stanza to see
                   how it may be used.
        """
        if msg['type'] in ('chat', 'normal'):

            #database.incCallCount(str(msg['from']))
            #if database.getCallCount(str(msg['from'])) > 100 return

            print str(msg['from']) + ": " + str(msg['body'])

            #request and create login
            if msg['body'] == "SuicidePreventionAppServerLoginRequest":
                timestamp = time.time()
                ejabberd.createUser(timestamp,timestamp)
                print "created user " + str(timestamp) + " requested from " + str(msg['from'])
                msg.reply("SuicidePreventionAppServerLoginRequestAnswer;%s;%s" % (timestamp, timestamp)).send()

            #request and create login
            if msg['body'] == "SuicidePreventionAppServerSupporterLoggedIn":
                print "sending SuicidePreventionAppServerSupporterLoggedInAck to %s" % str(msg['from'])
                msg.reply("SuicidePreventionAppServerSupporterLoggedInAck").send()

            #request supporter from help seeker
            if msg['body'] == "SuicidePreventionAppServerSupporterRequest":
                onlineUsers = ejabberd.getOnlineUsers()
                onlineUsers.pop(onlineUsers.index( str(msg['from']).split("/")[0]))
                supporter = database.getSupporter(onlineUsers)
                print "Selected Supporter " + supporter + " for " + str(msg['from'])
                self.send_message(mto=supporter, mbody="SuicidePreventionAppServerSupporterRequestCalling;%s" % str(msg['from']))

            #give supporter data to help seeker
            answerMessage = msg['body']
            if answerMessage.startswith("SuicidePreventionAppServerSupporterRequestCallingAccept;"):    #;seeker;supporter
                answerList=answerMessage.split(';')
                print "to : "+answerList[1].split('/')[0] + " SuicidePreventionAppServerSupporterRequestCallingAccept" + str(msg['from'])
                #self.send_message(mto=answerList[1], mbody="SuicidePreventionAppServerSupporterRequestCallingAccept;"+str(msg['from']))
                self.send_message(mto=answerList[1], mbody="SuicidePreventionAppServerSupporterRequestCallingAccept;"+str(msg['from']), mtype='chat')

            #try another supporter if called supporter declines
            if answerMessage.startswith("SuicidePreventionAppServerSupporterRequestCallingDecline;"):    #;seeker;supporter
                print str(msg['from']) + "declined the call"
                onlineUsers = ejabberd.getOnlineUsers()
                onlineUsers.pop(onlineUsers.index( str(msg['from']).split("/")[0]))
                supporter = database.getSupporter(onlineUsers)
                answerList=answerMessage.split(';')
                print answerList[1]
                self.send_message(mto=supporter, mbody="SuicidePreventionAppServerSupporterRequestCalling;%s" % answerList[1])

            if answerMessage.startswith("SuicidePreventionAppServerHelpSeekerEndSession"):
                user = str(msg['from']).split('@')[0]
                print "delete user " + user
                msg.reply("SuicidePreventionAppServerHelpSeekerEndSessionAck").send()
                ejabberd.deleteUser(user)


if __name__ == '__main__':
    # Setup the command line arguments.
    optp = OptionParser()

    # Output verbosity options.
    optp.add_option('-q', '--quiet', help='set logging to ERROR',
                    action='store_const', dest='loglevel',
                    const=logging.ERROR, default=logging.INFO)
    optp.add_option('-d', '--debug', help='set logging to DEBUG',
                    action='store_const', dest='loglevel',
                    const=logging.DEBUG, default=logging.INFO)
    optp.add_option('-v', '--verbose', help='set logging to COMM',
                    action='store_const', dest='loglevel',
                    const=5, default=logging.INFO)

    # JID and password options.
    optp.add_option("-j", "--jid", dest="jid",
                    help="JID to use")
    optp.add_option("-p", "--password", dest="password",
                    help="password to use")

    opts, args = optp.parse_args()

    # Setup logging.
    logging.basicConfig(level=opts.loglevel,
                        format='%(levelname)-8s %(message)s')

    if opts.jid is None:
        opts.jid = raw_input("Username: ")
    if opts.password is None:
        opts.password = getpass.getpass("Password: ")

    # Setup the EchoBot and register plugins. Note that while plugins may
    # have interdependencies, the order in which you register them does
    # not matter.
    xmpp = EchoBot(opts.jid, opts.password)
    xmpp.register_plugin('xep_0030') # Service Discovery
    xmpp.register_plugin('xep_0004') # Data Forms
    xmpp.register_plugin('xep_0060') # PubSub
    xmpp.register_plugin('xep_0199') # XMPP Ping

    # If you are connecting to Facebook and wish to use the
    # X-FACEBOOK-PLATFORM authentication mechanism, you will need
    # your API key and an access token. Then you'll set:
    # xmpp.credentials['api_key'] = 'THE_API_KEY'
    # xmpp.credentials['access_token'] = 'THE_ACCESS_TOKEN'

    # If you are connecting to MSN, then you will need an
    # access token, and it does not matter what JID you
    # specify other than that the domain is 'messenger.live.com',
    # so '_@messenger.live.com' will work. You can specify
    # the access token as so:
    # xmpp.credentials['access_token'] = 'THE_ACCESS_TOKEN'

    # If you are working with an OpenFire server, you may need
    # to adjust the SSL version used:
    # xmpp.ssl_version = ssl.PROTOCOL_SSLv3

    # If you want to verify the SSL certificates offered by a server:
    # xmpp.ca_certs = "path/to/ca/cert"

    # Connect to the XMPP server and start processing XMPP stanzas.
    if xmpp.connect():
        # If you do not have the dnspython library installed, you will need
        # to manually specify the name of the server if it does not match
        # the one in the JID. For example, to use Google Talk you would
        # need to use:
        #
        # if xmpp.connect(('talk.google.com', 5222)):
        #     ...
        xmpp.process(block=True)
        print("Done")
    else:
        print("Unable to connect.")
