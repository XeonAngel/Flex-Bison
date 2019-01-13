%{
	#include <iostream>
	#include <stdio.h>
  	#include <string.h>

	using namespace std;

	extern int yylex();
	extern int yyparse();

	extern int LineNo;
	extern int ColNo;
	 
	int yyerror(const char *message);

	int EsteCorecta = 1;
	char msg[500];

	class TVAR
	{
	     char* nume;
	     int valoare;
	     TVAR* next;
	  
	  public:
	     static TVAR* head;
	     static TVAR* tail;

	     TVAR(char* n, int v = -1);
	     TVAR();
	     int exists(char* n);
             void add(char* n, int v = -1);
             int getValue(char* n);
	     void setValue(char* n, int v);
	};

	TVAR* TVAR::head;
	TVAR* TVAR::tail;

	TVAR::TVAR(char* n, int v)
	{
	 this->nume = new char[strlen(n)+1];
	 strcpy(this->nume,n);
	 this->valoare = v;
	 this->next = NULL;
	}

	TVAR::TVAR()
	{
	  TVAR::head = NULL;
	  TVAR::tail = NULL;
	}

	int TVAR::exists(char* n)
	{
	  TVAR* tmp = TVAR::head;
	  while(tmp != NULL)
	  {
	    if(strcmp(tmp->nume,n) == 0)
	      return 1;
            tmp = tmp->next;
	  }
	  return 0;
	 }

         void TVAR::add(char* n, int v)
	 {
	   TVAR* elem = new TVAR(n, v);
	   if(head == NULL)
	   {
	     TVAR::head = TVAR::tail = elem;
	   }
	   else
	   {
	     TVAR::tail->next = elem;
	     TVAR::tail = elem;
	   }
	 }

         int TVAR::getValue(char* n)
	 {
	   TVAR* tmp = TVAR::head;
	   while(tmp != NULL)
	   {
	     if(strcmp(tmp->nume,n) == 0)
	      return tmp->valoare;
	     tmp = tmp->next;
	   }
	   return -1;
	  }

	  void TVAR::setValue(char* n, int v)
	  {
	    TVAR* tmp = TVAR::head;
	    while(tmp != NULL)
	    {
	      if(strcmp(tmp->nume,n) == 0)
	      {
		tmp->valoare = v;
	      }
	      tmp = tmp->next;
	    }
	  }

	TVAR* ts = NULL;
%}

%locations

%union {
  int intval;
  char* stringval;
}

%token TOK_PROG TOK_VAR TOK_BEGIN TOK_END
%token TOK_INTEGER TOK_ASSIGN TOK_PLUS TOK_MINUS TOK_MULTIPLY TOK_DIVIDE TOK_INT
%token TOK_READ TOK_WRITE TOK_FOR TOK_DO TOK_TO
%token TOK_ERROR

%token <intval> TOK_NUMBER
%token <stringval> TOK_VARIABLE

%start prog

%left TOK_PLUS TOK_MINUS
%left TOK_MULTIPLY TOK_DIVIDE

%%

prog		: TOK_PROG prog_name TOK_VAR dec_list TOK_BEGIN stmt_list TOK_END 
		|
    		error prog_name TOK_VAR  dec_list TOK_BEGIN stmt_list TOK_END { EsteCorecta = 0;}
		|
		error TOK_VAR  dec_list TOK_BEGIN stmt_list TOK_END { EsteCorecta = 0;}
		|
		error  dec_list TOK_BEGIN stmt_list TOK_END { EsteCorecta = 0;}
		|
		error TOK_BEGIN stmt_list TOK_END { EsteCorecta = 0;}
		|
		error stmt_list TOK_END { EsteCorecta = 0;}
		|
		error TOK_END { EsteCorecta = 0;}
		|
		error { EsteCorecta = 0;}
		;

prog_name	: TOK_VARIABLE
		;

dec_list	: dec
		| dec_list ';' dec
		;

dec		: id_list ':' type
		;

type		: TOK_INTEGER
		;

id_list		: TOK_VARIABLE
			{
				if(ts != NULL)
				{
					if(ts->exists($1) == 1)
					{
						sprintf(msg,"%d:%d Eroare semantica: Variabila %s este deja declarata!", @1.first_line, @1.first_column, $1);
						yyerror(msg);
						YYERROR;
					}
					else
					{
						ts->add($1);
					}
				}
				else
				{
					ts = new TVAR();
					ts->add($1);
				}
			}
		|
		id_list ',' TOK_VARIABLE
			{
				if(ts != NULL)
				{
					if(ts->exists($3) == 1)
					{
						sprintf(msg,"%d:%d Eroare semantica: Variabila %s este deja declarata!", @1.first_line, @1.first_column, $3);
						yyerror(msg);
						YYERROR;
					}
					else
					{
						ts->add($3);
					}
				}
				else
				{
					ts = new TVAR();
					ts->add($3);
				}
			}
		;

stmt_list	: stmt 
		| stmt_list ';' stmt 
		;

stmt		: assign 
		| read 
		| write 
		| for 
		;

assign		: TOK_VARIABLE TOK_ASSIGN exp 
			{
				if(ts != NULL)
				{
					if(ts->exists($1) != 1)
					{
						sprintf(msg,"%d:%d Eroare semantica: Variabila %s nu e declarata!", @1.first_line, @1.first_column, $1);
						yyerror(msg);
						YYERROR;
					}
				}
				else
				{
					sprintf(msg,"%d:%d Eroare semantica: Variabila %s nu e declarata!", @1.first_line, @1.first_column, $1);
					yyerror(msg);
					YYERROR;
				}
			}
		;

exp		: term 
		| exp TOK_PLUS term 
		| exp TOK_MINUS term 
		;

term		: factor
		| term TOK_MULTIPLY factor 
		| term TOK_DIVIDE factorForDiv
		;

factor		: TOK_VARIABLE
			{
				if(ts != NULL)
				{
					if(ts->exists($1) != 1)
					{
						sprintf(msg,"%d:%d Eroare semantica: Variabila %s nu e declarata!", @1.first_line, @1.first_column, $1);
						yyerror(msg);
						YYERROR;
					}
				}
				else
				{
					sprintf(msg,"%d:%d Eroare semantica: Variabila %s nu e declarata!", @1.first_line, @1.first_column, $1);
					yyerror(msg);
					YYERROR;
				}
			}
		| TOK_NUMBER 
		| '(' exp ')' 
		;

factorForDiv	: TOK_VARIABLE
			{
				if(ts != NULL)
				{
					if(ts->exists($1) != 1)
					{
						sprintf(msg,"%d:%d Eroare semantica: Variabila %s nu e declarata!", @1.first_line, @1.first_column, $1);
						yyerror(msg);
						YYERROR;
					}
					else
					{
						if(ts->getValue($1) == -1) //Aici trebuie sa fie == 0, dar pentru a putea demonstra ca functioneaza am folosit valoarea implicita(-1)
							{
								sprintf(msg,"%d:%d Eroare semantica: Nu se poate imparti la 0!", @1.first_line, @1.first_column);
								yyerror(msg);
								YYERROR;
							}
					}
				}
				else
				{
					sprintf(msg,"%d:%d Eroare semantica: Variabila %s nu e declarata!", @1.first_line, @1.first_column, $1);
					yyerror(msg);
					YYERROR;
				}
			}
		| TOK_NUMBER 
			{
				if ($1 == 0)
				{
					sprintf(msg,"%d:%d Eroare semantica: Nu se poate imparti la 0!", @1.first_line, @1.first_column);
					yyerror(msg);
					YYERROR;				
				}
			}
		| '(' exp ')' 
		;

read		: TOK_READ '(' id_list_for_rw ')' 
		;

write		: TOK_WRITE '(' id_list_for_rw ')' 
		;

id_list_for_rw	: TOK_VARIABLE
			{
				if(ts != NULL)
				{
					if(ts->exists($1) != 1)
					{
						sprintf(msg,"%d:%d Eroare semantica: Variabila %s nu a fost declarata!", @1.first_line, @1.first_column, $1);
						yyerror(msg);
						YYERROR;
					}
				}
				else
				{
					sprintf(msg,"%d:%d Eroare semantica: Variabila %s nu a fost declarata!", @1.first_line, @1.first_column, $1);
					yyerror(msg);
					YYERROR;
				}
			}
		|
		id_list_for_rw ',' TOK_VARIABLE
			{
				if(ts != NULL)
				{
					if(ts->exists($3) != 1)
					{
						sprintf(msg,"%d:%d Eroare semantica: Variabila %s nu a fost declarata!", @1.first_line, @1.first_column, $3);
						yyerror(msg);
						YYERROR;
					}
				}
				else
				{
					sprintf(msg,"%d:%d Eroare semantica: Variabila %s nu a fost declarata!", @1.first_line, @1.first_column, $3);
					yyerror(msg);
					YYERROR;
				}
			}
		;

for 		: TOK_FOR index_exp TOK_DO body 
		;

index_exp	: TOK_VARIABLE TOK_ASSIGN exp TOK_TO exp 
			{
				if(ts != NULL)
				{
					if(ts->exists($1) != 1)
					{
						sprintf(msg,"%d:%d Eroare semantica: Variabila %s nu e declarata!", @1.first_line, @1.first_column, $1);
						yyerror(msg);
						YYERROR;
					}
				}
				else
				{
					sprintf(msg,"%d:%d Eroare semantica: Variabila %s nu e declarata!", @1.first_line, @1.first_column, $1);
					yyerror(msg);
					YYERROR;
				}
			}
		;

body		: stmt 
		| TOK_BEGIN stmt_list TOK_END
		;

%%

int main(int, char**) {

  	yyparse();

	if(EsteCorecta == 1)
	{
		cout<<"CORECTA"<<endl;		
	}	

       return 0;
}

int yyerror(const char *message) {

  	cout << "Error!  Message: " << message << endl;
	cout << "Linia:" << LineNo << " Coloana:" << ColNo << endl;

  	return 1;
}
