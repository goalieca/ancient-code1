#!/usr/bin/python

#(c)2006 by Ryan Dickie. Removes crud files form operating system. 

import glob

path="/"

dini=glob.glob(path+"/*/desktop.ini")
thumbsdb=glob.glob(path+"/*/Thumbs.db")
vim=glob.glob(path+"/*/*~")
dstore=glob.glob(path+"/*/*DS_Store")
tmp=glob.glob(path+"/*/*.tmp")
trash=glob.glob(path+"/*/.Trash-*")

[os.remove(x) for x in dini]
[os.remove(x) for x in thumbsdb]
[os.remove(x) for x in vim]
[os.remove(x) for x in dstore]
[os.remove(x) for x in tmp]
[os.remove(x) for x in trash]


