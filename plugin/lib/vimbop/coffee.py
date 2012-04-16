import re
from subprocess import Popen, PIPE
import vim
from vimbop import client, disable_on_failure, preview

IDENTIFIER_REGEX = re.compile(r'[$a-zA-Z_][()0-9a-zA-Z_$.\'"]*')


class CoffeeError(Exception):
    def __init__(self, error):
        self.error = error

    def __str__(self):
        return self.error


def compile(code):
    '''
    Compiles CoffeeScript for eval.
    '''
    try:
        proc = Popen(['coffee', '-b', '-s', '-p'], stdin=PIPE, stdout=PIPE, stderr=PIPE)
    except OSError:
        raise CoffeeError("Make sure coffeescript is installed")
    stdout, stderr = proc.communicate(code)
    if stderr:
        raise CoffeeError(stderr.splitlines()[0][7:])
    return stdout


@disable_on_failure
def complete(line, base, col, cmdline=False):
    '''
    Returns completions for CoffeeScript.
    '''
    base = base or ''
    col = int(col)

    try:
        obj = IDENTIFIER_REGEX.findall(line[:col])[-1][:-(len(base)+1)]
    except IndexError:
        return '[]'

    result = client.complete(obj)
    if result:
        return repr(sorted((str(x) for x in result if base.lower() in x.lower()), key=lambda x: x.startswith(base)))
    else:
        return '[]'


@disable_on_failure
def eval(*args):
    '''
    Sends code to Bebop, which will be run in browser.
    '''
    code = compile(' '.join(args))
    preview(client.eval(code))


@disable_on_failure
def eval_line():
    preview(eval(vim.current.line))


@disable_on_failure
def eval_range():
    r = vim.current.range
    preview(eval('\n'.join(vim.current.buffer[r.start:r.end+1])))


@disable_on_failure
def eval_buffer():
    preview(eval('\n'.join(vim.current.buffer)))
