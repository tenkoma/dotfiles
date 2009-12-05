#!/usr/bin/env python
# -*- coding: utf-8 -*-

# 設定ファイルのシンボリック作成

import os
import re
import shutil
import stat

def isNeedLink(name):
    excludes = ['.git', os.path.basename(__file__)]
    return name not in excludes

def symlinkrise(name):
    p = re.compile('^(dot)')
    return os.path.expanduser('~' + os.sep) + p.sub('', name)

def createlink(src, dst):
    if iswindows():
        isdir = stat.S_ISDIR(os.stat(src)[stat.ST_MODE])
        if isdir:
            shutil.rmtree(dst)
            shutil.copytree(src, dst)
        else:
            shutil.copyfile(src, dst)
    else:
        os.symlink(src, dst)

def iswindows():
    return (os.name == 'nt' or os.name == 'dos')

def main():
    dir = os.path.dirname(os.path.abspath(__file__))
    files = os.listdir(dir)
    for src in files:
        abssrc = dir + os.sep + src
        link = symlinkrise(src)
        if (isNeedLink(src) and ((not os.path.exists(link)) or iswindows())):
            createlink(abssrc, link)
            print ('create link: ' + link)


if __name__ == "__main__":
    main()
