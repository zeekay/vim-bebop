from bebop.client import BebopException, Client
import os
import vim
import json
import socket

client = Client()


def disable_on_failure(f):
    '''
    Catches any Bebop errors and disables Bebop automatically.
    '''
    def wrapper(*args, **kwargs):
        try:
            return f(*args, **kwargs)
        except BebopException as e:
            vim.command('call bebop#DisableCompletion()')
            print e
        except socket.error as e:
            if e.errno == 61:
                print 'Unable to connect to Bebop.'
            else:
                print 'Not connected to Bebop.'
    return wrapper


def is_bebop_buffer(buf):
    '''
    Checks if given buffer is Bebop's preview window buffer.
    '''
    if buf.name:
        return buf.name.endswith('[Bebop]')
    return False


def is_bebop_window(win):
    '''
    Helper function which checks if the given window is Bebop's preview window.
    '''
    if win.buffer.name:
        return win.buffer.name.endswith('[Bebop]')
    return False


def preview(result):
    '''
    Displays result in Bebop's preview window.
    '''

    if not result:
        return

    if getattr(result, 'get', lambda x: None)('error'):
        result = 'Error // %s' % str(result['error'])
    else:
        result = json.dumps(result, sort_keys=True, indent=2)

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
        vim.command('setlocal nobuflisted')
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


@disable_on_failure
def connect(host='127.0.0.1', port=1985):
    '''
    Establish a connection to Bebop and enable completions if it succeeds,
    or disable them if it fails.
    '''
    client.close()
    client.connect(host=host, port=port)
    vim.command('call bebop#EnableCompletion()')


@disable_on_failure
def list_websocket_clients(host='127.0.0.1', port=1985):
    '''
    Lists connected WebSocket clients.
    '''
    client.close()
    client.connect(host=host, port=port)
    print client.list_websocket_clients()


@disable_on_failure
def set_active_client(query):
    '''
    Switches the active client to the client which matches the query.
    Tries to use index from BebopList, if that fails, expects query to be a substring of the client identifier.
    '''
    client.set_active_client(query)


@disable_on_failure
def toggle_broadcast():
    '''
    Toggles broadcast on.
    '''
    client.toggle_broadcast()


@disable_on_failure
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
