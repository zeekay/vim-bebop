import re
import vim
from vimbop import client, disable_on_failure, preview

IDENTIFIER_REGEX = re.compile(r'[$a-zA-Z_][()0-9a-zA-Z_$.\'"]*')


@disable_on_failure
def complete(line, base, col):
    '''
    Returns completions for Vim.
    '''
    base = base or ''
    col = int(col)

    try:
        # obj = IDENTIFIER_REGEX.findall(line[:col])[-1][:-(len(base)+1)]
        obj = IDENTIFIER_REGEX.findall(line[:col])[0]
    except IndexError:
        return '[]'

    if not '.' in obj:
        obj, base = 'this', obj

    obj = obj.strip('.')

    vim.command('echo "obj: %s, base: %s"' % (obj, base))

    result = client.complete(obj)
    if result:
        return repr(sorted((str(x) for x in result if base.lower() in x.lower()), key=lambda x: x.startswith(base)))
    else:
        return '[]'


@disable_on_failure
def complete_cmdline(arglead, line, start):
    '''
    Returns completions Vim's commandline.
    '''
    try:
        obj = IDENTIFIER_REGEX.findall(line)[-1]
    except IndexError:
        return '[]'

    if '.' in obj:
        # split into object we're looking for properties of and partial property name (which might not exist)
        obj, prop = (obj.rsplit('.', 1) + [''])[:2]

        # get leading part of completion
        base = ''.join(arglead.rpartition('.')[:2])
    else:
        # complete this
        obj, prop = 'this', obj
        base = ''

    result = client.complete(obj)
    if result:
        return repr(sorted((str(base + x) for x in result if prop.lower() in x.lower())))
    else:
        return '[]'


@disable_on_failure
def eval(*args):
    '''
    Displays result of eval'd code.
    '''
    code = ' '.join(args)
    if code.startswith('>'):
        code = code[1:]
    preview(client.eval(code))


@disable_on_failure
def eval_line():
    '''
    Send current line to Bebop.
    '''
    eval(vim.current.line)


@disable_on_failure
def eval_range():
    '''
    sends range to bebop.
    '''
    r = vim.current.range
    eval('\n'.join(vim.current.buffer[r.start:r.end+1]))


@disable_on_failure
def eval_buffer():
    '''
    Send current buffer to Bebop.
    '''
    eval('\n'.join(vim.current.buffer))
