%{
	#include <iostream>
	using namespace std;

	// Declare stuff from Flex that Bison needs to know about:----------------------DACA MERGE SI FARA EXTERN
	extern int yylex();
	extern int yyparse(void);

	extern int LineNo;
	extern int ColNo;
	 
	void yyerror(const char *message);

	int EsteCorecta = 1;
	char msg[500];
%}

// Bison fundamentally works by asking flex to get the next token, which it
// returns as an object of type "yystype".  Initially (by default), yystype
// is merely a typedef of "int", but for non-trivial projects, tokens could
// be of any arbitrary data type.  So, to deal with that, the idea is to
// override yystype's default typedef to be a C union instead.  Unions can
// hold all of the types of tokens that Flex could return, and this this means
// we can return ints or floats or strings cleanly.  Bison implements this
// mechanism with the %union directive:
//about:-----------------------------------------nu cred ca am nevoie de uniune nici de %token <intval de mai jos
%union {
  int intval;
  char* stringval;
}

// Define the "terminal symbol" token types I'm going to use (in CAPS
// by convention), and associate each with a field of the %union:
%token <intval> INT
%token <stringval> STRING

%token TOK_PROG TOK_VAR TOK_BEGIN TOK_END TOK_ID
%token TOK_INTEGER TOK_ASSIGN TOK_PLUS TOK_MINUS TOK_MULTIPLY TOK_DIVIDE TOK_INT
%token TOK_READ TOK_WRITE TOK_FOR TOK_DO TOK_TO
%token TOK_ERROR

%start prog

%left TOK_PLUS TOK_MINUS
%left TOK_MULTIPLY TOK_DIVIDE

%%
// This is the actual grammar that bison will parse, but for right now it's just
// something silly to echo to the screen what bison gets from flex.  We'll
// make a real one shortly:

prog		: TOK_PROG prog_name TOK_VAR dec_list TOK_BEGIN stmt_list TOK_END {;}
		| error ';' prog { EsteCorecta = 0; }
		;

prog_name	: TOK_ID {;}
		;

dec_list	: dec {;}
		| dec_list ';' dec {;}
		;

dec		: id_list ':' type {;}
		;

type		: TOK_INTEGER {;}
		;

id_list		: TOK_ID {;}
		| id_list ',' TOK_ID {;}
		;

stmt_list	: stmt {;}
		| stmt_list ';' stmt {;}
		;

stmt		: assign {;}
		| read {;}
		| write {;}
		| for {;}
		;

assign		: TOK_ID TOK_ASSIGN exp {;}
		;

exp		: term {;}
		| exp TOK_PLUS term {;}
		| exp TOK_MINUS term {;}
		;

term		: factor {;}
		| term TOK_MULTIPLY factor {;}
		| term TOK_DIVIDE factor {;}
		;

factor		: TOK_ID {;}
		| TOK_INT {;}
		| '(' exp ')' {;}
		;

read		: TOK_READ '(' id_list ')' {;}
		;

write		: TOK_WRITE '(' id_list ')' {;}
		;

for 		: TOK_FOR index_exp TOK_DO body {;}
		;

index_exp	: TOK_ID TOK_ASSIGN exp TOK_TO exp {;}
		;

body		: stmt {;}
		| TOK_BEGIN stmt_list TOK_END
		;

%%

int main(int, char**) {

  // Parse through the input:
  	yyparse();

	if(EsteCorecta == 1)
	{
		printf("CORECTA\n");		
	}	

       return 0;

}

void yyerror(const char *message) {
  	cout << "EEK, parse error!  Message: " << message << endl;
	cout << "Linia:" << LineNo << " Coloana:" << ColNo << endl;
  	// might as well halt now:
  	exit(-1);
}

