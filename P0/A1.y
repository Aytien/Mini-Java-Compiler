%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int yylex (void);
void yyerror (const char *);

typedef struct Node{
  char * value;
  struct Node * next;
}node;

typedef struct List{
  node *head;
  node *tail;
}list;

typedef struct ExprNode{
	list* list;
	struct ExprNode* next;
} exprnode;

typedef struct ExprList{
	exprnode* head, *tail;
} exprlist;


int macro_stmt_count=0;
list *macro_stmt_list[100][3];

void printlist(list *cur_list)
{
  if(cur_list==NULL)
  return;
  node *cur_node=cur_list->head;
  while(cur_node)
  {
    printf("%s ",cur_node->value);
    if(cur_node==cur_list->tail)
    break;
    cur_node=cur_node->next;
  }
  return;
}

list* createlist()
{ 
  list* newlist=malloc(sizeof(list));
  newlist->head=NULL;
  newlist->tail=NULL;
  return newlist;
}

exprlist* createexprlist()
{
  exprlist* newlist=malloc(sizeof(exprlist));
  newlist->head=NULL;
  newlist->tail=NULL;
  return newlist;
}
void insertlist(list* cur_list,node* tok)
{
  if(cur_list->head==NULL)
  {
    cur_list->head=tok;
    cur_list->tail=tok;
    
  }
  else
  {
    cur_list->tail->next=tok;
    cur_list->tail=tok;
  }
  return;
}

void insertexprlist(exprlist* cur_list,list* l)
{
  exprnode* tok= malloc(sizeof(exprnode));
  tok->list=l;
  tok->next=NULL; 
  if(cur_list->head==NULL)
  {
    cur_list->head=tok;
    cur_list->tail=tok;
    
  }
  else
  {
    cur_list->tail->next=tok;
    cur_list->tail=tok;
  }
  return;
}

list* mergelist(list *first_list,list *second_list)
{
  list * newlist=createlist();
  if(first_list->head==NULL)
  return(second_list);

  if(second_list->head==NULL)
  return(first_list);

  newlist->head=first_list->head;
  first_list->tail->next=second_list->head;
  newlist->tail=second_list->tail;
  return(newlist);
}

list* copylist(list *newlist,list *cur_list)
{
  node *ptr1=cur_list->head;
  if(ptr1==NULL)
  return(newlist);

  while(ptr1!=cur_list->tail)
  {
    node *newnode=malloc(sizeof(node));
    newnode->value=ptr1->value;
    newnode->next=NULL;
    insertlist(newlist,newnode);
    ptr1=ptr1->next;
  }
    node *newnode=malloc(sizeof(node));
    newnode->value=ptr1->value;
    newnode->next=NULL;
    insertlist(newlist,newnode);
    return(newlist);
}

list *duplist(list* cur_list)
{
    node *ptr1=cur_list->head;
  list*newlist=createlist();
  if(ptr1==NULL)
  return(newlist);
  
  while(ptr1!=cur_list->tail)
  {
    node *newnode=malloc(sizeof(node));
    newnode->value=ptr1->value;
    newnode->next=NULL;
    insertlist(newlist,newnode);
    ptr1=ptr1->next;
  }
    node *newnode=malloc(sizeof(node));
    newnode->value=ptr1->value;
    newnode->next=NULL;
    insertlist(newlist,newnode);
    return(newlist);
}

exprlist* mergeexprlist(exprlist *first_list,exprlist *second_list)
{
  if(first_list->head==NULL)
  return(second_list);

  if(second_list->head==NULL)
  return(first_list);

  first_list->tail->next=second_list->head;
  first_list->tail=second_list->tail;
  return(first_list);
}



int Macrosearch(char *key)
{
  for(int i=0;i<macro_stmt_count;i++)
  {
    if(strcmp(key,macro_stmt_list[i][0]->head->value)==0)
    {
      return(i);
    }
  }
  return(-1);
}

void Macroadd(list * macro_stuff)
{
  node *tmp=macro_stuff->head;

  list *macro_name=createlist();
  if(Macrosearch(tmp->value)>=0)
  {
    yyerror("Macro Redefinition\n");
    exit(1);
  }
  insertlist(macro_name,tmp);
  tmp=tmp->next->next;

  list *macro_args=createlist();
  list *macro_body_1=createlist();
  while(strcmp(tmp->value,")")!=0)
  {
    if(strcmp(tmp->value,",")!=0)
    {
      insertlist(macro_args,tmp);
    }
    tmp=tmp->next;
  }
  macro_body_1->head=tmp->next;
  macro_body_1->tail=macro_stuff->tail;

  list *macro_body=duplist(macro_body_1);

  macro_stmt_list[macro_stmt_count][0]=macro_name;
  macro_stmt_list[macro_stmt_count][1]=macro_args;
  macro_stmt_list[macro_stmt_count][2]=macro_body;
  macro_stmt_count++;
  if(macro_stmt_count==100)
  {
    yyerror("Exceeded Macro limit");
    exit(1);
  }
  return;
}

int countargs(list * cur_list)
{
  node * ptr1=cur_list->head;
  int size=0;

  if(ptr1==NULL)
  return(size);
  while(ptr1!=cur_list->tail)
  {
    ptr1=ptr1->next;
    size++;
  }
  size++;
  return(size);
}

list* Macroexpand(list* macro_name,exprlist* macro_apc)
{

  int pos = 0;
  node* ptr1 = macro_name->head;
  pos=Macrosearch(ptr1->value);
  if(pos<0)
  {
    printlist(macro_name);
    yyerror("Undefined Macro");
    exit(1);
  }

  
  char *key[50];
  list *replace[50];
  exprnode *ptr2=macro_apc->head;
  int s2=0;
  
  if(ptr2==NULL)
  {
    s2=0;
  }
  else
  {
    while(ptr2)
    {
      s2++;
      ptr2=ptr2->next;
    }
  }
  int s1=countargs(macro_stmt_list[pos][1]);

  if(s1!=s2)
  {
    
        yyerror("Wrong syntax for macro: Incorrect number of arguments\n");
        exit(1);
  }

  ptr1=macro_stmt_list[pos][1]->head;
  ptr2=macro_apc->head;

  if(ptr1==NULL&&ptr2==NULL)
  {
    return(macro_stmt_list[pos][2]);
  }

  int i=0;

  for(i=0;i<s1;i++)
  {
    key[i]=ptr1->value;
    replace[i]=ptr2->list;
    ptr1=ptr1->next;
    ptr2=ptr2->next;
  }

  list* miniline = createlist();
  ptr1 = macro_stmt_list[pos][2]->head;
  while(ptr1!=macro_stmt_list[pos][2]->tail)
  {

    int flag=-1;
    for(int i=0;i<s1;i++)
    {
      if(strcmp(key[i],ptr1->value)==0)
      {
        flag=i;
        break;
      }
    }

    if(flag>=0)
    {
     miniline=copylist(miniline,replace[flag]); 
    }
    else
    {
      node* tmp=malloc(sizeof(node));
      tmp->next=NULL;
      tmp->value=strdup(ptr1->value);
      insertlist(miniline,tmp);
    }
    ptr1=ptr1->next;
  }
  int flag=-1;
  for(int i=0;i<s1;i++)
  {
    if(strcmp(key[i],ptr1->value)==0)
    {
      flag=i;
      break;
    }
  }
  if(flag>=0)
  {
    miniline=copylist(miniline,replace[flag]);  
  }
  else
  {
      node* tmp=malloc(sizeof(node));
      tmp->next=NULL;
      tmp->value=strdup(ptr1->value);
      insertlist(miniline,tmp);
  }
  return(miniline);
}

list* addcomexpr(exprlist* expr_list)
{
  list *newlist=createlist();
  exprnode * ptr1=expr_list->head;
  while(ptr1)
  {
    newlist=copylist(newlist,ptr1->list);
    ptr1=ptr1->next;
    if(ptr1)
    {
      node* newnode=malloc(sizeof(node*));
      newnode->next=NULL;
      newnode->value=strdup(",");
      insertlist(newlist,newnode);
    }
  }
  return(newlist);
}

void printMacros()
{  
  printf("\n%d\n",macro_stmt_count);
 for(int i=0;i<macro_stmt_count;i++)
 {
   printf("\n%d: \n",i);
  printlist(macro_stmt_list[i][2]);
 
 }
}
%}

%union {
    int number;
    node* id;
    list* tokens;
    exprlist* exprtokens;
}

%token <id> INTEGER ID
%token <id> DEFINESTMT0 DEFINESTMT1 DEFINESTMT2 DEFINESTMT
%token <id> DEFINEEXPR0 DEFINEEXPR1 DEFINEEXPR2 DEFINEEXPR
%token <id> CLASS PUBLIC STATIC VOID MAIN  
%token <id> PRINT EXTENDS RETURN BOOL INT IF ELSE 
%token <id> WHILE LENGTH TRUE_TOK FALSE_TOK THIS NEW STR
%token <id> LPARAN RPARAN LBRACES RBRACES LSQBRACK 
%token <id> RSQBRACK SEMICOLON FULLSTOP COMMA EQUALS 
%token <id> LOGOR LOGAND EQUOPR ARITHOPR NOT  

%type <tokens> Goal MainClass TypeDeclaration TypeDeclarationList MethodDeclaration
%type <tokens> MethodDeclarationList Integer Identifier Type Statement Expression PrimaryExpression 
%type <tokens> TypeIdScList TypeIdList ComTypeIdList ComIdList
%type <tokens> StatementList MacroDefList MacroDefinition  MacroDefStatement MacroDefExpression
%type <exprtokens> ExprList ComExprList

%start Goal

%%
Goal                : MacroDefList MainClass TypeDeclarationList { $$ = mergelist($1,$2); $$ = mergelist($$,$3);printlist($$);}
                    ;
MainClass           : CLASS Identifier LBRACES PUBLIC STATIC VOID MAIN LPARAN STR LSQBRACK  RSQBRACK Identifier RPARAN LBRACES PRINT LPARAN Expression RPARAN SEMICOLON RBRACES RBRACES
                    { $$ = createlist();insertlist($$,$1); $$ = mergelist($$,$2); insertlist($$,$3); insertlist($$,$4); insertlist($$,$5); insertlist($$,$6);insertlist($$,$7); insertlist($$,$8); insertlist($$,$9); insertlist($$,$10);insertlist($$,$11); $$ = mergelist($$,$12); insertlist($$,$13); insertlist($$,$14); insertlist($$,$15); insertlist($$,$16);$$ = mergelist($$,$17); insertlist($$,$18); insertlist($$,$19); insertlist($$,$20); insertlist($$,$21);}
                    ;  
TypeDeclaration     : CLASS Identifier LBRACES TypeIdScList MethodDeclarationList RBRACES { $$ = createlist();insertlist($$,$1); $$ = mergelist($$,$2); insertlist($$,$3); $$ = mergelist($$,$4); $$ = mergelist($$,$5); insertlist($$,$6);}
                    | CLASS Identifier EXTENDS Identifier LBRACES TypeIdScList MethodDeclarationList RBRACES { $$ = createlist();insertlist($$,$1); $$ = mergelist($$,$2); insertlist($$,$3); $$ = mergelist($$,$4);insertlist($$,$5); $$ = mergelist($$,$6); $$ = mergelist($$,$7); insertlist($$,$8);}
                    ;  
TypeDeclarationList : TypeDeclarationList TypeDeclaration { $$ = $1 ; $$ = mergelist($$,$2);}
                    | %empty { $$ = createlist();}
                    ;
MethodDeclaration   : PUBLIC Type Identifier LPARAN TypeIdList RPARAN LBRACES TypeIdScList  StatementList RETURN Expression SEMICOLON RBRACES 
                    { $$ = createlist();insertlist($$,$1); $$ = mergelist($$,$2); $$ = mergelist($$,$3); insertlist($$,$4);$$ = mergelist($$,$5); insertlist($$,$6); insertlist($$,$7); $$ = mergelist($$,$8); $$ = mergelist($$,$9); insertlist($$,$10); $$ = mergelist($$,$11); insertlist($$,$12); insertlist($$,$13);}
                    ;
MethodDeclarationList : MethodDeclarationList MethodDeclaration { $$ = $1 ; $$ = mergelist($$,$2);}
                    | %empty { $$ = createlist();}
                    ;
Integer             : INTEGER { $$ = createlist();insertlist($$,$1);}
                    ;
Identifier          : ID  { $$ = createlist();insertlist($$,$1);}
                    ;
Type                : INT LSQBRACK RSQBRACK { $$ = createlist();insertlist($$,$1); insertlist($$,$2); insertlist($$,$3);}
                    | BOOL { $$ = createlist();insertlist($$,$1);}
                    | INT { $$ = createlist();insertlist($$,$1);}
                    | Identifier { $$ = $1; }
                    ;
Statement           : LBRACES StatementList RBRACES { $$ = createlist();insertlist($$,$1); $$ = mergelist($$,$2);insertlist($$,$3);}
                    | PRINT LPARAN Expression RPARAN SEMICOLON { $$ = createlist();insertlist($$,$1); insertlist($$,$2); $$ = mergelist($$,$3);insertlist($$,$4);insertlist($$,$5);}
                    | Identifier EQUALS Expression SEMICOLON { $$ = $1 ;insertlist($$,$2); $$ = mergelist($$,$3);insertlist($$,$4);}
                    | Identifier LSQBRACK Expression RSQBRACK EQUALS Expression SEMICOLON { $$ = $1 ;insertlist($$,$2); $$ = mergelist($$,$3);insertlist($$,$4); insertlist($$,$5);$$ = mergelist($$,$6);insertlist($$,$7);}
                    | IF LPARAN Expression RPARAN Statement { $$ = createlist();insertlist($$,$1); insertlist($$,$2); $$ = mergelist($$,$3);insertlist($$,$4);$$ = mergelist($$,$5);}
                    | IF LPARAN Expression RPARAN Statement ELSE Statement { $$ = createlist();insertlist($$,$1); insertlist($$,$2); $$ = mergelist($$,$3);insertlist($$,$4);$$ = mergelist($$,$5);insertlist($$,$6);$$ = mergelist($$,$7);}
                    | WHILE LPARAN Expression RPARAN Statement { $$ = createlist();insertlist($$,$1); insertlist($$,$2); $$ = mergelist($$,$3);insertlist($$,$4);$$ = mergelist($$,$5);}
                    | Identifier LPARAN ExprList RPARAN SEMICOLON { $$ = Macroexpand($1,$3);insertlist($$,$5);}
                    ;
Expression          : PrimaryExpression LOGAND PrimaryExpression { $$ = $1 ;insertlist($$,$2); $$ = mergelist($$,$3);}
                    | PrimaryExpression LOGOR PrimaryExpression { $$ = $1 ;insertlist($$,$2); $$ = mergelist($$,$3);}
                    | PrimaryExpression EQUOPR PrimaryExpression { $$ = $1 ;insertlist($$,$2); $$ = mergelist($$,$3);}
                    | PrimaryExpression ARITHOPR PrimaryExpression { $$ = $1 ;insertlist($$,$2); $$ = mergelist($$,$3);}
                    | PrimaryExpression LSQBRACK PrimaryExpression RSQBRACK { $$ = $1 ;insertlist($$,$2); $$ = mergelist($$,$3);insertlist($$,$4);}
                    | PrimaryExpression FULLSTOP LENGTH { $$ = $1 ;insertlist($$,$2);insertlist($$,$3);}
                    | PrimaryExpression { $$ = $1; }
                    | PrimaryExpression FULLSTOP Identifier LPARAN ExprList RPARAN { $$ = $1 ;insertlist($$,$2); $$ = mergelist($$,$3);insertlist($$,$4); $$ = mergelist($$,addcomexpr($5));insertlist($$,$6);}
                    | Identifier LPARAN ExprList RPARAN { $$ = Macroexpand($1,$3);}
                    ;
PrimaryExpression   : Integer { $$ = $1; }
                    | TRUE_TOK { $$ = createlist();insertlist($$,$1);}
                    | FALSE_TOK { $$ = createlist();insertlist($$,$1);}
                    | Identifier { $$ = $1; }
                    | THIS { $$ = createlist();insertlist($$,$1);}
                    | NEW INT LSQBRACK Expression RSQBRACK { $$ = createlist();insertlist($$,$1); insertlist($$,$2);insertlist($$,$3); $$ = mergelist($$,$4);insertlist($$,$5);}
                    | NEW Identifier LPARAN RPARAN { $$ = createlist(); insertlist($$,$1); $$ = mergelist($$,$2); insertlist($$,$3); insertlist($$,$4);}
                    | NOT Expression { $$ = createlist(); insertlist($$,$1); $$ = mergelist($$,$2);}
                    | LPARAN Expression RPARAN { $$ = createlist(); insertlist($$,$1); $$ = mergelist($$,$2); insertlist($$,$3);}
                    ;
TypeIdScList        : %empty { $$ = createlist();} 
                    | TypeIdScList Type Identifier SEMICOLON { $$ = $1 ;$$ = mergelist($$,$2); $$ = mergelist($$,$3);insertlist($$,$4);}
                    ;
TypeIdList          : %empty { $$ = createlist();}
                    | ComTypeIdList Type Identifier { $$ = $1 ;$$ = mergelist($$,$2); $$ = mergelist($$,$3);}
                    ;  
ComTypeIdList       : %empty { $$ = createlist();} 
                    | ComTypeIdList Type Identifier COMMA { $$ = $1 ;$$ = mergelist($$,$2); $$ = mergelist($$,$3);insertlist($$,$4);}      
                    ;
ExprList            : Expression ComExprList { $$ = createexprlist();insertexprlist($$,$1);$$ = mergeexprlist($$,$2); }
                    | %empty { $$ = createexprlist();}  
                    ;
ComExprList         : COMMA Expression ComExprList {$$ = createexprlist();insertexprlist($$,$2);$$=mergeexprlist($$,$3);}
                    | %empty { $$=createexprlist() ;}
                    ;  
ComIdList           : %empty { $$ = createlist();} 
                    | ComIdList COMMA Identifier { $$ = $1 ;insertlist($$,$2); $$ = mergelist($$,$3);}
                    ;
StatementList       : %empty { $$ = createlist();}
                    | Statement StatementList { $$ = $1 ; $$ = mergelist($$,$2);}
                    ;
MacroDefList        : %empty { $$ = createlist();}
                    | MacroDefList MacroDefinition  { $$ = $1;}
                    ;
MacroDefinition     : MacroDefExpression { $$ = $1; Macroadd($$);}
                    | MacroDefStatement  { $$ = $1; Macroadd($$);}
                    ;
MacroDefStatement   : DEFINESTMT Identifier LPARAN Identifier COMMA Identifier COMMA Identifier ComIdList  RPARAN  LBRACES StatementList RBRACES/* More than 2 arguments */
                    { $$ = createlist(); $$ = mergelist($$,$2);insertlist($$,$3);$$ = mergelist($$,$4);insertlist($$,$5); $$ = mergelist($$,$6);insertlist($$,$7); $$ = mergelist($$,$8); $$ = mergelist($$,$9);insertlist($$,$10); insertlist($$,$11); $$ = mergelist($$,$12); insertlist($$,$13);}
                    | DEFINESTMT0 Identifier LPARAN RPARAN LBRACES StatementList RBRACES { $$ = createlist(); $$ = mergelist($$,$2);insertlist($$,$3);insertlist($$,$4);insertlist($$,$5); $$ = mergelist($$,$6);insertlist($$,$7);}
                    | DEFINESTMT1 Identifier LPARAN Identifier RPARAN LBRACES StatementList RBRACES { $$ = createlist(); $$ = mergelist($$,$2);insertlist($$,$3);$$ = mergelist($$,$4);insertlist($$,$5); insertlist($$,$6);$$ = mergelist($$,$7); insertlist($$,$8);}
                    | DEFINESTMT2 Identifier LPARAN Identifier COMMA Identifier RPARAN  LBRACES StatementList RBRACES
                    { $$ = createlist(); $$ = mergelist($$,$2);insertlist($$,$3);$$ = mergelist($$,$4);insertlist($$,$5); $$ = mergelist($$,$6);insertlist($$,$7); insertlist($$,$8); $$ = mergelist($$,$9);insertlist($$,$10);}
                    ;
MacroDefExpression  : DEFINEEXPR Identifier LPARAN Identifier COMMA Identifier COMMA Identifier ComIdList RPARAN  LPARAN Expression RPARAN /* More than 2 arguments */
                    { $$ = createlist(); $$ = mergelist($$,$2);insertlist($$,$3);$$ = mergelist($$,$4);insertlist($$,$5); $$ = mergelist($$,$6);insertlist($$,$7); $$ = mergelist($$,$8); $$ = mergelist($$,$9);insertlist($$,$10); insertlist($$,$11); $$ = mergelist($$,$12); insertlist($$,$13);}
                    | DEFINEEXPR0 Identifier LPARAN RPARAN  LPARAN Expression RPARAN { $$ = createlist(); $$ = mergelist($$,$2);insertlist($$,$3);insertlist($$,$4);insertlist($$,$5); $$ = mergelist($$,$6);insertlist($$,$7);}
                    | DEFINEEXPR1 Identifier LPARAN Identifier RPARAN LPARAN Expression RPARAN { $$ = createlist(); $$ = mergelist($$,$2);insertlist($$,$3);$$ = mergelist($$,$4);insertlist($$,$5); insertlist($$,$6);$$ = mergelist($$,$7); insertlist($$,$8);}
                    | DEFINEEXPR2 Identifier LPARAN Identifier COMMA Identifier RPARAN LPARAN Expression RPARAN
                    { $$ = createlist(); $$ = mergelist($$,$2);insertlist($$,$3);$$ = mergelist($$,$4);insertlist($$,$5); $$ = mergelist($$,$6);insertlist($$,$7); insertlist($$,$8); $$ = mergelist($$,$9);insertlist($$,$10);}
                    ;
%%

void yyerror (const char *s) {
  printf ("//Failed to parse input code\n");
}

int main () {
  yyparse ();
	return 0;
}

#include "lex.yy.c"