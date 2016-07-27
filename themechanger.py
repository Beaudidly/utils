#!/usr/bin/python3

import os.path
import sys
import re
"""Utility to quickly change .Xresources colorschemes
$ themechanger

Add .Xresources colorschemes to $HOME/.config/colors/

The .Xresources file should be in $HOME/
"""

HOMEPATH = os.path.expanduser("~")
COLORPATH = "".join([HOMEPATH, "/.config/colors/"])
XRESPATH = "".join([HOMEPATH, "/.Xresources"])

def configCheck():
    """Checks if .Xresources and .config/colors are present
    Creates them if the user wants
    """
    if not os.path.exists(COLORPATH):
        print('Color template path does not existi\n',
              'Would you like to create {}'.format(COLORPATH))
        userInput = input("[Y|n]:").upper()

        if not userInput or userInput[0] == 'Y':
            os.makedirs(COLORPATH)
            print('{} created.'.format(COLORPATH))
            print(data)
        else:
            print('Nothing else to do, exiting.')
            sys.exit()

    if not os.path.isfile(XRESPATH):
        print('{} file not found.\nCreate a blank one?'.format(XRESPATH))
        userInput = input('[Y|n]:').upper()

        if not userInput or userInput[0] == 'Y':
            tempFile = open(XRESPATH, 'w')
            tempFile.close()
            print('{} created'.format(XRESPATH))
        else:
            print('Nothing else to do, exiting')
            sys.exit()

def getCurrent():
    """Returns the filename of the current colorscheme"""
    currentScheme = None

    with open(XRESPATH, 'r') as mfile:
        for line in mfile:
            # regex is ... something
            result = re.search(r'(?<=\.config/colors/)(.*)', line)
            if not result or not result: continue
            else: currentScheme = result.group(0)[:-1]

    if currentScheme:
        return(currentScheme)
    else:
        return("No current colorscheme.")

def changeColor():
    """Replaces the colorscheme with the user's choice"""
    schemeList = os.listdir(COLORPATH)

    if len(schemeList) == 0:
        print("No colorschemes to choose from.")
        sys.exit()

    currentScheme = getCurrent()
    schemeChoice = 0

    while True:
        print('Colorscheme choices:')

        for i in range(len(schemeList)):
            print("{}: {}".format(i + 1, schemeList[i]))

        prompt = '[1]:' if (len(schemeList) == 1) else '[1-{}]:'.format(len(schemeList))
        schemeChoice = input(prompt)

        try:
            schemeChoice = int(schemeChoice)
        except ValueError:
            print("Must be a digit in the provided range. Please choose again.")
            continue
        except IndexError:
            print("Must be a digit in the provided range. Please choose again.")
            continue

        break

    with open(XRESPATH, 'r') as r:
        with open(XRESPATH + '.tmp', 'w') as w:
            for line in r:
                w.write(line.replace(currentScheme, schemeList[schemeChoice - 1]))

    os.rename(XRESPATH + '.tmp', XRESPATH)

configCheck()
print('Current colorscheme: {}'.format(getCurrent()))
changeColor()
os.system('xrdb {}'.format(XRESPATH))
