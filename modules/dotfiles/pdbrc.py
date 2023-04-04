# import pdb
#
#
# class Config(pdb.DefaultConfig):
#     sticky_by_default = True
#     current_line_color = 93
#     use_pygments = True
#     colorscheme =
#
#
# def _pdbrc_init():
#     # Save history across sessions
#     import readline
#     histfile = ".pdb-pyhist"
#     try:
#         readline.read_history_file(histfile)
#     except IOError:
#         pass
#     import atexit
#     atexit.register(readline.write_history_file, histfile)
#     readline.set_history_length(500)
#
#
# _pdbrc_init()
# del _pdbrc_init


import readline
import pdb


class Config(pdb.DefaultConfig):

    editor = 'e'
    stdin_paste = 'epaste'
    filename_color = pdb.Color.lightgray
    use_terminal256formatter = False
    sticky_by_default = True
    #exec_if_unfocused = "play ~/sounds/dialtone.wav 2> /dev/null &"

    def __init__(self):
        # readline.parse_and_bind('set convert-meta on')
        # readline.parse_and_bind('Meta-/: complete')

        try:
            from pygments.formatters import terminal
        except ImportError:
            pass
        else:
            self.colorscheme = terminal.TERMINAL_COLORS.copy()
            self.colorscheme.update({
                terminal.Keyword:            ('darkred',     'red'),
                terminal.Number:             ('darkyellow',  'yellow'),
                terminal.String:             ('brown',       'green'),
                terminal.Name.Function:      ('darkgreen',   'blue'),
                terminal.Name.Namespace:     ('teal',        'turquoise'),
                })

    def setup(self, pdb):
        # make 'l' an alias to 'longlist'
        Pdb = pdb.__class__
        Pdb.do_l = Pdb.do_longlist
        Pdb.do_st = Pdb.do_sticky
