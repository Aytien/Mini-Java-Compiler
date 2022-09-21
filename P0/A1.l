%%
"#defineStmt0"          {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return DEFINESTMT0; }
"#defineStmt1"          {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return DEFINESTMT1; }
"#defineStmt2"          {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return DEFINESTMT2; }
"#defineStmt"           {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return DEFINESTMT; }
"#defineExpr0"          {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return DEFINEEXPR0; }
"#defineExpr1"          {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return DEFINEEXPR1; }
"#defineExpr2"          {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return DEFINEEXPR2; }
"#defineExpr"           {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return DEFINEEXPR; }
"class"                 {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return CLASS; }   
"public"                {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return PUBLIC; }           
"static"                {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return STATIC; } 
"void"                  {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return VOID; } 
"main"                  {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return MAIN; } 
"String"                {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return STR; } 
"System.out.println"    {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return PRINT; } 
"extends"               {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return EXTENDS; } 
"return"                {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return RETURN; } 
"boolean"               {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return BOOL; } 
"int"                   {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return INT; } 
"if"                    {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return IF; } 
"else"                  {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return ELSE; } 
"while"                 {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return WHILE; } 
"length"                {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return LENGTH; } 
"true"                  {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return TRUE_TOK; } 
"false"                 {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return FALSE_TOK; } 
"this"                  {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return THIS; } 
"new"                   {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return NEW; } 

[0-9]+                  {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return INTEGER;}

[a-zA-Z_][a-zA-Z0-9_]*  {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return ID;}
"("                     {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return LPARAN; }
")"                     {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return RPARAN; }    
"{"                     {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            char ch='\n';
                            strncat(yylval.id->value, &ch, 1);
                            return LBRACES; }
"}"                     {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            char ch='\n';
                            strncat(yylval.id->value, &ch, 1);
                            return RBRACES; }
"["                     {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return LSQBRACK; }
"]"                     {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return RSQBRACK; }            
";"                     {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            char ch='\n';
                            strncat(yylval.id->value, &ch, 1);
                            return SEMICOLON; }
"."                     {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return FULLSTOP; }
","                     {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return COMMA; }
"="                     {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return EQUALS; }
"||"                    {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return LOGOR; }
"&&"                    {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return LOGAND; }
"!="|"<="               {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return EQUOPR; }
"+"|"-"|"*"|"/"         {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return ARITHOPR; }
"!"                     {   yylval.id=malloc(sizeof(node));
                            yylval.id->next=NULL;
                            yylval.id->value=strdup(yytext);
                            return NOT; }             
"//".*$         
[ \n\t]

%%

