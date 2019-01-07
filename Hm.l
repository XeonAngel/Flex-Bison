%option noyywrap

%{
	#include "Hm.tab.h"  // to get the token types from Bison

	int LineNo = 1;
	int ColNo = 1;
%}

%%

"PROGRAM"			{ ColNo+=7; return TOK_PROG; }
"VAR"				{ ColNo+=3; return TOK_VAR; }
"BEGIN"				{ ColNo+5; return TOK_BEGIN; }
"END"				{ ColNo+=3; return TOK_END; }
"id"				{ ColNo+=2; return TOK_ID; }
";"				{ ColNo++; return ';';}
":"				{ ColNo++; return ':';}
"INTEGER"			{ ColNo+=7; return TOK_INTEGER; }
","				{ ColNo++; return ','; }
":="				{ ColNo+=2; return TOK_ASSIGN; }
"+"				{ ColNo++; return TOK_PLUS; }
"-"				{ ColNo++; return TOK_MINUS; }
"*"				{ ColNo++; return TOK_MULTIPLY; }
"DIV"				{ ColNo+=3; return TOK_DIVIDE; }
"int"				{ ColNo+=3; return TOK_INT; }
"("				{ ColNo++; return '('; }
")"				{ ColNo++; return ')'; }
"READ"				{ ColNo+=4; return TOK_READ; }
"WRITE"				{ ColNo+=5; return TOK_WRITE; }
"FOR"				{ ColNo+=3; return TOK_FOR; }
"DO"				{ ColNo+=2; return TOK_DO;  }
"TO"				{ ColNo+=2; return TOK_TO; }
[ ]				{ ColNo++; }
\r\n				{ LineNo++; ColNo=1; }
\n				{ LineNo++; ColNo=1; }
.				{ ColNo++; return TOK_ERROR; }

%%
