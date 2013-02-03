#!/usr/bin/python

# Sends an e-mail to count how many times the installers are run

import smtplib
from email.MIMEMultipart import MIMEMultipart
from email.MIMEBase import MIMEBase
from email.MIMEText import MIMEText
from email import Encoders
import os

msg = MIMEMultipart()

address = "princeton.java.installers@gmail.com"

msg['From'] = address
msg['To'] = address
msg['Subject'] = "The introcs.app installer has been run!"

msg.attach(MIMEText(""))

mailServer = smtplib.SMTP("smtp.gmail.com", 587)
mailServer.ehlo()
mailServer.starttls()
mailServer.ehlo()
mailServer.login(address, "qERb32dbo3Fo")
mailServer.sendmail(address, address, msg.as_string())
mailServer.close()