%{
#include <stdio.h>
#include <stdlib.h>
int lineno = 1;
int cnt = 0;
char str[100] = {'\0'};
void concatString(char* str, int* pos, char* end);
%}

delim      [ \t]
nl         [\n]
ws         {delim}+
letter     [A-Za-z]
digit      [0-9]
id         {letter}({letter}|{digit})*
number     {digit}+(\.{digit}+)?(E[+-]?{digit}+)?

%%
{ws}       { concatString(str, &cnt, yytext); /* no action and no print */ }
if         { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : reserved word: if\n", lineno); }
else       { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : reserved word: else\n", lineno); }
int        { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : reserved data type: int\n", lineno); }
double     { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : reserved data type: double\n", lineno); }
return     { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : reserved word: return\n", lineno); }
void       { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : reserved word: void\n", lineno); }
while      { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : reserved word: while\n", lineno); }
"+"        { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : binary operator plus: +\n", lineno); }
"-"        { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : binary operator subtract: -\n", lineno); }
"*"        { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : binary operator multiply: *\n", lineno); }
"/"        { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : binary operator quote: /\n", lineno); }
"<"        { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : binary compare operator LT: <\n", lineno); }
"<="       { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : binary compare operator LE: <=\n", lineno); }
">"        { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : binary compare operator GT: >\n", lineno); }
">="       { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : binary compare operator GE: >=\n", lineno); }
"=="       { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : binary compare operator EQ: ==\n", lineno); }
"!="       { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : binary compare operator NE: !=\n", lineno); }
"="        { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : assign operator : =\n", lineno); }
";"        { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : delimiter: ;\n", lineno); }
","        { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : comma operator : ,\n", lineno); }
"("        { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : left parent : (\n", lineno); }
")"        { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : right parent : )\n", lineno); }
"{"        { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : left curly parent : {\n", lineno); }
"}"        { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : right curly parent : }\n", lineno); }
{nl}       { concatString(str, &cnt, yytext);
             fprintf(yyout, "%d : %s", lineno++, str);
             str[0] = '\0';
             cnt = 0; }
"/*"       { char c;
             int done = 0;
	     concatString(str, &cnt, yytext);
	     do {
	       while (1) {
		 c = input();
		 str[cnt++] = c;
		 str[cnt] = '\0';
		 if (c == '\n') {
		   fprintf(yyout, "%d : %s", lineno++, str);
		   str[0] = '\0';
		   cnt = 0;
		 }
		 if (c == '*')
		   break;
	       }
	       while (1) {
		 c = input();
		 str[cnt++] = c;
		 str[cnt] = '\0';
		 if (c == '\n') {
		   fprintf(yyout, "%d : %s", lineno++, str);
		   str[0] = '\0';
		   cnt = 0;
		 }
		 if (c != '*')
		   break;
	       }
	       if (c == '/') {
		 done = 1;
	       }
	    } while (done == 0);
	   }
{id}       { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : identifier %s\n", lineno, yytext); }
{number}   { concatString(str, &cnt, yytext);
             fprintf(yyout, "\t %d : number %s\n", lineno, yytext); }

%%

void concatString(char *str, int* pos, char *end) {
  int i = 0;
  while (end[i] != '\0') {
    str[(*pos)++] = end[i++];
  }
  str[(*pos)] = '\0';
}

int yywrap() {
}

int main(int argc, char* argv[])
{
  if (argc > 1) {
    yyin = fopen(argv[1], "r");
    yyout = fopen("D:\\compiler\\scanner\\flex\\output.txt", "w");
    if (!yyin) {
      perror(argv[1]);
      return 1;
    }
    yylex();
    fclose(yyin);
    fclose(yyout);
  }

  return 0;
}
