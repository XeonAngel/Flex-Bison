%option noyywrap

%{
	#include "Hm.tab.h"

	int LineNo = 1;
	int ColNo = 1;
%}

%%

"PROGRAM"		{ ColNo+=7; return TOK_PROG; }
"VAR"			{ ColNo+=3; return TOK_VAR; }
"BEGIN"			{ ColNo+5; return TOK_BEGIN; }
"END"			{ ColNo+=3; return TOK_END; }
";"			{ ColNo++; return ';';}
":"			{ ColNo++; return ':';}
"INTEGER"		{ ColNo+=7; return TOK_INTEGER; }
","			{ ColNo++; return ','; }
":="			{ ColNo+=2; return TOK_ASSIGN; }
"+"			{ ColNo++; return TOK_PLUS; }
"-"			{ ColNo++; return TOK_MINUS; }
"*"			{ ColNo++; return TOK_MULTIPLY; }
"DIV"			{ ColNo+=3; return TOK_DIVIDE; }
"int"			{ ColNo+=3; return TOK_INT; }
"("			{ ColNo++; return '('; }
")"			{ ColNo++; return ')'; }
"READ"			{ ColNo+=4; return TOK_READ; }
"WRITE"			{ ColNo+=5; return TOK_WRITE; }
"FOR"			{ ColNo+=3; return TOK_FOR; }
"DO"			{ ColNo+=2; return TOK_DO;  }
"TO"			{ ColNo+=2; return TOK_TO; }
0|[1-9][0-9]*		{ yylloc.first_line = LineNo; yylloc.first_column = ColNo; ColNo+=strlen(yytext); yylval.intval = atoi(yytext); return TOK_NUMBER; }
[a-zA-Z][a-zA-Z0-9_]* 	{ yylloc.first_line = LineNo; yylloc.first_column = ColNo; ColNo+=strlen(yytext); yylval.stringval = new char[strlen(yytext)+1]; strcpy(yylval.stringval,yytext); return TOK_VARIABLE; }
[ ]			{ ColNo++; }
\r\n			{ LineNo++; ColNo=1; }
\n			{ LineNo++; ColNo=1; }
\t			{}
.			{ ColNo++; return TOK_ERROR; }

%%
