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

def preview(res):
    if not vim.eval('g:bebop_preview_window'):
        print res
        return

    def is_bebop_window(obj):
        if obj.buffer.name:
            return obj.buffer.name.endswith('[Bebop]')
        return False

    def is_bebop_buffer(obj):
        if obj.name:
            return obj.name.endswith('[Bebop]')
        return False

    lines = iter(res.splitlines())
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
