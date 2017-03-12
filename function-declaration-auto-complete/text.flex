%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>
%}
blank " "|\t
alpha [a-zA-Z]|_
digit [0-9]
static "static"{blank}+
inline "inline"{blank}+
id {alpha}({alpha}|{digit})*
point {blank}*"*"{blank}*
type {id}
main "main"

%%

for {return 1;}
while {return 1;}
if {return 1;}
else {return 1;}
switch {return 1;}
case {return 1;}
sizeof {return 1;}

"/*"([^\*]|(\*)*[^\*/])*(\*)*"*/" {return 1;}
"//".*"\n" {return 1;}
"#define".*"\n"
{static}?{inline}?"define"{point}*{blank}+{id}"(".*")" {return 1;}
{static}?{inline}?{type}{point}*{blank}+{main}"(".*")" {return 1;}
{static}?{inline}?{type}{point}*{blank}+"if""(".*")" {return 1;}
{static}?{inline}?{type}{point}*{blank}+{id}"(".*")" {return 2;}
{static}?{inline}?{type}{point}*{blank}+{id}"(".*")"{blank}*; {return 1;}
{static}?{inline}?{type}{point}*{blank}+{id}"(".*")"{blank}*: {return 1;}
. {return 1;}
\n {return 1;}


%%

int yywrap()
{
	return 1;
}

int main(int argc,char *argv[])
{
	char s[100];
	if(argc==1)
		return 0;
	FILE *fp=fopen(argv[1],"r");
	if(fp==NULL)
	{
		fprintf(stderr,"failed: open file error\n");
		return 0;
	}
	char *file_name=strcat(strcpy(s,argv[1]),".h");
#ifdef NEED_CHECK
	if(access(file_name,0)==0)
	{
		fprintf(stderr,"file exists now!\n");
		return 0;
	}
#endif
	FILE *out=fopen(file_name,"w");
	if(out==NULL)
	{
		fprintf(stderr,"failed: open file error\n");
		return 0;
	}
	yyin=fp;
	int x=yylex();
	while(x)
	{
		if(x==2)
		{
			printf("extern %s;\n",yytext);
			fprintf(out,"extern %s;\n",yytext);
		}
		x=yylex();
	}
	fclose(fp);
	fclose(out);
}
