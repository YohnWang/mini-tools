import sys

def is_head(s):
	state=0
	for i in s:
		if state==0 and i == '#':
			state=1
		elif state==1 and i == '#':
			state=1
		elif state==1 and i == ' ':
			state=2
			return True
		else :
			return False 


def count_sharp(s):
	c=0
	for i in s:
		if i=='#':
			c=c+1
		else :
			break
	return c

def gen(s):
	c=count_sharp(s)
	print("  "*(c-1)+"- "+"["+s[c+1:-1]+"]"+"(#"+s[c+1:-1]+")")


with open(sys.argv[1],"r",encoding='utf-8') as file:
	for l in file:
		if is_head(l):
			gen(l)
file.close()
