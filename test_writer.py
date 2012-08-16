#! /usr/bin/python

import re

if __name__ == '__main__':
	filestring = open('sovrenCom.cls', 'r').read()
	l = re.findall('class ([\w]+)', filestring)
	for (counter, i) in enumerate(l):
		print i +' t'+str(counter)+' = new ' + i +'();'
