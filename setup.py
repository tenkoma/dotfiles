#!/opt/local/bin/python
# -*- coding: utf-8 -*-

# 設定ファイルのシンボリック作成

import os
import re

def isNeedLink(name):
    excludes = ['.git', os.path.basename(__file__)]
    return name not in excludes

def symlinkrise(name):
    p = re.compile('^(dot)')
    return os.path.expanduser('~/') + p.sub('', name)

def main():
    dir = os.path.dirname(os.path.abspath(__file__))
    files = os.listdir(dir)
    for src in files:
        abssrc = dir + '/' + src
        link = symlinkrise(src)
        if isNeedLink(src) and not os.path.exists(link):
            os.symlink(abssrc, link)
            print 'create link: ' + link


if __name__ == "__main__":
    main()
