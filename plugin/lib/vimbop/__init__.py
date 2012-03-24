from bebop import client
import coffee, js

def listeners():
    print client.listeners()

def sync():
    client.sync()

def active(listeners):
    client.active(listeners)
