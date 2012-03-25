from bebop import client
import os
import vim

def listeners():
    print client.listeners()

def sync():
    client.sync()

def active(listeners):
    client.active(listeners)

def reload(bang, path=''):
    if bang:
        # force reload
        return client.modified('')

    if not path:
        path = vim.current.buffer.name.replace(os.getcwd(), '')

    client.modified(path)
