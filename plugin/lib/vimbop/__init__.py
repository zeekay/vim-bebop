from bebop.client import Client
import os
import vim
import json
import socket

client = Client()


def connect(host='127.0.0.1', port=1985):
    '''
    Establish a connection to Bebop and enable completions if it succeeds,
    or disable them if it fails.
    '''
    client.close()
    try:
        client.connect(host=host, port=port)
        vim.command('call bebop#EnableCompletion()')
    except socket.error:
        vim.command('call bebop#DisableCompletion()')


def list_websocket_clients():
    '''
    Lists connected WebSocket clients.
    '''
    print client.list_websocket_clients()


def set_active_client(query):
    '''
    Switches the active client to the client which matches the query.
    Tries to use index from BebopList, if that fails, expects query to be a substring of the client identifier.
    '''
    client.set_active_client(query)


def broadcast():
    '''
    Toggles broadcast on.
    '''
    client.broadcast()


def reload(bang, file=''):
    '''
    Attempts to reload a given file by sending the modified event to all WebSocket clients.
    '''
    if bang:
        # Force reload
        return client.modified('')

    if not file:
        file = vim.current.buffer.name.replace(os.getcwd(), '')

    client.modified(file)


def is_bebop_window(win):
    '''
    Helper function which checks if the given window is Bebop's preview window.
    '''
    if win.buffer.name:
        return win.buffer.name.endswith('[Bebop]')
    return False


def is_bebop_buffer(buf):
    '''
    Checks if given buffer is Bebop's preview window buffer.
    '''
    if buf.name:
        return buf.name.endswith('[Bebop]')
    return False


def preview(result):
    '''
    Displays result in Bebop's preview window.
    '''
    result = json.dumps(result, sort_keys=True, indent=2)

    if not result:
        return

    if not int(vim.eval('g:bebop_preview_window')):
        print result
        return

    lines = iter(result.splitlines())
    if filter(lambda win: is_bebop_window(win), vim.windows):
        # found window with our buffer open already
        while not is_bebop_buffer(vim.current.window.buffer):
            vim.command('wincmd w')
    else:
        # create new preview window
        vim.command('pclose')
        vim.command('%s new' % vim.eval('g:bebop_preview_location'))
        vim.command('setlocal buftype=nofile')
        vim.command('setlocal bufhidden=hide')
        vim.command('set previewwindow')

        if filter(lambda buf: is_bebop_buffer(buf), vim.buffers):
            # found our buffer
            vim.command('b \[Bebop]')
        else:
            vim.command('set ft=javascript')
            vim.command('file [Bebop]')
            # replace first line with beginning of response
            vim.current.buffer[0] = next(lines)

    # append response
    for line in lines:
        vim.current.buffer.append(line)

    # scroll to bottom
    vim.command('normal G')
    # return original window
    vim.command('wincmd p')
