import re
import vim
from vimbop import client, preview

IDENTIFIER_REGEX = re.compile(r'[$a-zA-Z_][()0-9a-zA-Z_$.\'"]*')


def complete(line, base, col, cmdline=False):
    '''
    Returns completions for Vim.
    '''
    base = base or ''
    col = int(col)

    try:
        obj = IDENTIFIER_REGEX.findall(line[:col])[-1][:-(len(base)+1)]
    except IndexError:
        return '[]'

    if cmdline:
        if '.' not in obj:
            obj = 'this'
        else:
            obj, base = obj.rsplit('.', 1)

    result = client.complete(obj)
    if result:
        return repr(sorted((str(x) for x in result if base.lower() in x.lower()), key=lambda x: x.startswith(base)))
    else:
        return '[]'


def eval(*args):
    '''
    Displays result of eval'd code.
    '''
    code = ' '.join(args)
    preview(client.eval(code))


def eval_line():
    '''
    Send current line to Bebop.
    '''
    preview(client.eval(vim.current.line))


def eval_range():
    '''
    sends range to bebop.
    '''
    r = vim.current.range
    preview(client.eval('\n'.join(vim.current.buffer[r.start:r.end+1])))


def eval_buffer():
    '''
    Send current buffer to Bebop.
    '''
    preview(client.eval('\n'.join(vim.current.buffer)))
