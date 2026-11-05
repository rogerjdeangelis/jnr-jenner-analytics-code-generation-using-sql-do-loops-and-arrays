/*---
c:/utl/jnr-jenner-analytics-code-generation-using-sql-do-loops-and-arrays.sas
---*/

Jenner Analytics code generation using sql do loops and arrays

Too long to post,see
https://github.com/rogerjdeangelis/jnr-jenner-analytics-code-generation-using-sql-do-loops-and-arrays

EXAMPLE
    Pivot long using sql arrays and do loops

SOAPBOX ON
This type of transpose can be very fast, especially in modern sql
compilers that multi-thread the sql union clauses?

This type of code generation has a many applications
not on;y in sql. Python is progblematic due to forced indentation,
most languages are not.
SOAPBOX OFF

related
https://github.com/rogerjdeangelis/jnr-Jenner-Analytics-a-simple-flexible-macro-function-for-curated-lists-of-column-names

CONTENTS
========
  1 How this workxdoes
  2 Input
  3 Process
  4 jnr_doOver macro and jnr_varlist macros

/**************************************************************************************************************************/
/* 1 WHAT THE CODE DOES                                                                                                   */
/**************************************************************************************************************************/

HOW THIS WORKS

This transpose can be very fast especially in modern sql
compilers that multi-thread the sql union clauses?

data have;
 input day xa xy;
cards4;
1 40 40
2 50 50
;;;;
run;quit;

proc sql;
   create table xpo as

   /*--- generate this code using ---*/
   /*--- sql arrays and a do loop ---*/

   select day, "xa"  as col, xa as val
   from have union all
   select day, "xy"  as col, xa as val

;quit;

Obs  day  col  val  Obs  day  col  val
  1    1  xa    40    4    1  xy    40
  2    2  xa    50    5    2  xy    50

/**************************************************************************************************************************/
/* 2 INPUT                                                                                                                */
/**************************************************************************************************************************/

/*--- PUT IN YOUR AUTOEXEC ---*/
libname workx "d:/wpswrkx";

proc datasets lib=workx kill;
run;

data workx.have;
 input day xa xy;
cards4;
1 40 40
2 50 50
;;;;
run;quit;

proc print data=workx.have;
run;

LIST:   05NOV2026:11:23:09
==========================
  Obs  day  xa  xy

    1    1  40  40
    2    2  50  50

/**************************************************************************************************************************/
/* 2 PROCESS                                                                                                              */
/**************************************************************************************************************************/

/*--- sql array vars=xa xy xz  ---*/

%let vars=%jnr_varlist(
  libname=workx,memname=have,drop=day);

%put NOTE: ARRAY VARS &=vars;
/*--- NOTE: ARRAY VARS VARS=xa xy ---*/

proc sql;
 create
   table xpo as
     %jnr_doOver( /*--- SQL DO  LOOP ---*/
          &vars,  /*--- SQL ARRAY    ---*/
         ,code=%str(
           select
             day
             ,'?'  as col
             ,?    as val
           from
             workx.have
           ),between=" union all
      ");
run;

proc print data=xpo;
run;

/*--- GENERATED CODE
proc sql;
   create table xpo as
   /*--- generate this code using ---*/
   /*--- sql arrays and a do loop ---*/
   select day, "xa"  as col, xa as val
   from have union all
   select day, "xy"  as col, xa as val
;quit;
---*/

LIST:   05NOV2026:11:35:47
==========================

  Obs  day  col  val

    1    1  xa    40
    2    2  xa    50
    3    1  xy    40
    4    2  xy    50


LOG:    05NOV2026:11:35:47
==========================

NOTE: Copyright (c) 2026 Jenner Analytics Ltd., London, England.
NOTE: Jenner v1.5.110 (build v1.5.110+13530c7ccc.20261030T030012Z)
      Licensed to Roger DeAngelis, Serial 3BF7B3E6.
NOTE: DATA _null_

autexec started.

NOTE: DATA elapsed:
  wall  0.00 seconds
  cpu   0.00 seconds
NOTE: Library WORKX assigned path=d:\wpswrkx.
NOTE: DATA workx.class

NOTE: Processing inline DATALINES (19 lines)

NOTE: Read 19 rows from DATALINES.
NOTE: The data set WORKX.CLASS has 19 observations and 5 variables.
NOTE: DATA elapsed:
  wall  0.00 seconds
  cpu   0.02 seconds
NOTE: DATA _null_

LOG:    05NOV2026:11:35:47
NOTE: DATA _null_ completed. Output written to FILE PRINT
NOTE: Option SASAUTOS changed to c:/otojnr.
NOTE: DATA _null_

NOTE: Reading from fileref c:/jnr/runsas_selection.sas (c:/jnr/runsas_selection.sas)
    1 %let vars=%jnr_varlist(
    2   libname=workx,memname=have,drop=day);
    3
    4 %put NOTE: ARRAY VARS &=vars;
    5 /*--- NOTE: ARRAY VARS VARS=xa xy ---*/
    6
    7 proc sql;
    8  create
    9    table xpo as
   10      %jnr_doOver( /*--- SQL DO  LOOP ---*/
   11           &vars,  /*--- SQL ARRAY    ---*/
   12          ,code=%str(
   13            select
   14              day
   15              ,'?'  as col
   16              ,?    as val
   17            from
   18              workx.have
   19            ),between=" union all
   20       ");
   21 run;
   22
   23 proc print data=xpo;
   24 run;

NOTE: Read 24 rows from c:/jnr/runsas_selection.sas.
NOTE: DATA elapsed:
  wall  0.00 seconds
  cpu   0.00 seconds
NOTE: DATA _null_

autoexec completed    05NOV2026:11:35:47

NOTE: DATA elapsed:
  wall  0.00 seconds
  cpu   0.00 seconds
NOTE: DATA work.__keepdrop__


NOTE: Read 1 rows from workx.have.
NOTE: The data set WORK.__KEEPDROP__ has 0 observations and 2 variables.
NOTE: DATA elapsed:
  wall  0.00 seconds
  cpu   0.00 seconds
NOTE: PROC PRINT data=__keepdrop__


No observations in dataset.

Completed
NOTE: PROC SQL

NOTE: Macro variable VARLIST = xa xy
NOTE: PROC SQL statement used.
Completed
NOTE: VARLIST=xa xy
NOTE: ARRAY VARS VARS=xa xy
CNT=2
quoteit "xa","xy"
NOTE: DATA _null_

GENERATED CODE
prg=select day ,'xa'  as col ,xa as val from workx.have union all select day ,'xy'  as col ,xy as val from workx.have

NOTE: DATA elapsed:
  wall  0.00 seconds
  cpu   0.00 seconds
Completed
NOTE: PROC SQL

NOTE: Table xpo created.
NOTE: PROC SQL statement used.
NOTE: PROC PRINT data=xpo

NOTE: PROC PRINT completed: 4 observations printed, 3 variables

/**************************************************************************************************************************/
/* r MACROS jnr_doOver jnr_varlist                                                                                        */
/**************************************************************************************************************************/

filename ft15f001 "c:/otojnr/jnr_doOver.sas";
parmcards4;
%macro jnr_doOver(vars,code=,between=);

  %global prg;

  %local quoteIt;
  %let quoteit=;

  %let quoteIt="%qsysfunc(tranwrd(&vars, %str( ) , %str(",")))";
  %let cnt=%qsysfunc(countw(&vars));
  %put &=cnt;

  %dosubl('
  %put quoteit &quoteit;
  data _null_;
   length prg $32756;
   code="&code";
   array pfx[&cnt] $32 (&quoteIt) ;
   do i=1 to dim(pfx);
    %if &between= %then %do;
      prg=cats(prg,tranwrd(code,"?",pfx[i]));
    %end;
    %else %do;
      prg=catx(&between,prg,tranwrd(code,"?",pfx[i]));
    %end;
   end;
   putlog prg=;
   call symputx("prg",prg,"G");
   run;
  ');

%sysfunc(dequote("&prg"))

%mend jnr_doOver;
;;;;
run;


filename ft15f001 "c:/otojnr/jnr_varlist.sas";
parmcards4;
%macro jnr_varlist(
    libname=jenhelp
   ,memname=class
   ,function=  /*--- many functions possible like lowcase or quote ---*/
   ,od=" "
   ,prx="/(?!)/"  /*-- "/^/" always match '/(?!)/' never match ---*/
   ,keep=_all_
   ,drop=
 ) / des="Populate global VARLIST matching column names";

/*---

IMPORTANT (ORDER OF FILTER)

Prxmatch filter comes first then keep then drop

Cases

1 Age Height Name Sex Weight
  %put %getvars(libname=jenhelp,memname=class);

2 Height Name Weight
  %put %getvars(keep=name height weight);

3 Height Sex Weight
  %put %getvars(keep=name sex height weight,drop=name,prx="/weight/i");

4 "Name" "Sex" "Age" "Weight"
  %put %jnr_varlist(libname=sashelp,memname=class,keep=name age sex,function=quote,prx="/weight/i");

5 name,sex,age,weight *** function lowcase ***
  %put %jnr_varlist(libname=sashelp,memname=class,keep=name age sex,function=lowcase,prx='/weight/i',od=",");

---*/

%global varlist;
%let varlist=;

%dosubl('
data __keepdrop__;
    set &libname..&memname(keep=&keep);
    drop &drop;
    stop;
run;
proc print data=__keepdrop__;
run;
');


%dosubl('
proc sql;
  select &function(name) into :varlist separated by &od
  from
  ( select name,varnum
    from sashelp.vcolumn
    where upcase(libname) = upcase("&libname")
    and upcase(memname) = upcase("&memname")
    and prxmatch(&prx, name) > 0
    union corr
    select name, varnum
    from sashelp.vcolumn
    where upcase(libname) = upcase("work")
    and upcase(memname) = upcase("__keepdrop__")
  )
  order by varnum
;quit;');

%put NOTE: &=varlist;

&varlist

%mend jnr_varlist;
;;;;
run;

/*--- END ---*/





















filename ft15f001 "c:/otojnr/jnr_expandrange.sas";
parmcards4;
%macro jnr_expandrange(rng);

  %if %sysfunc(indexc(%substr(&rng,1,1),0123456789)) ^= 0 %then %do;
    %let rng=%qsysfunc(translate(&rng,":","-"));
    %dosubl('
    data _null_;
       length lst $32756;
       array rng[&rng];
       do i=lbound(rng) to hbound(rng);
          rng[i]=i;
       end;
       lst=catx(" ",of rng[*]);
       call symputx("rng",lst,'G');
    run;
    ');
  %end;
  %else %do;
    %dosubl('
    data _null_;
       length nams $32756;
       array rng[*] &rng;
       do i= lbound(rng) to hbound(rng);
         nam=vname(rng[i]);
         nams=catx(" ",nams,nam);
       end;
       call symputx("rng",nams,'G');
    run;
    ');
  %end;
  %trim(&rng)
%mend jnr_expandrange;
;;;;
run;

%jnr_expandrange(x3-x5);


%macro jnr_doOver(vars,code=,between=);

  %global prg;

/*
  %let vars=a1 a2 a3 b1 b2 b3;
  %let code=%str(put ?=;);
  %let between=;
*/

  %local quoteIt;
  %let quoteit=;

  %let quoteIt="%qsysfunc(tranwrd(&vars, %str( ) , %str(",")))";
  %let cnt=%qsysfunc(countw(&vars));
  %put &=cnt;

  %dosubl('
  %put QUOTEIT &quoteit;
  data _null_;
   length prg $32756;
   code="&code";
   array pfx[&cnt] $32 (&quoteIt) ;
   do i=1 to dim(pfx);
    %if &between= %then %do;
      prg=cats(prg,tranwrd(code,"?",pfx[i]));
    %end;
    %else %do;
      prg=catx(&between,prg,tranwrd(code,"?",pfx[i]));
    %end;
   end;
   putlog prg=;
   call symputx("prg",prg,"G");
   run;
  ');


%sysfunc(dequote("&prg"))

%mend jnr_doOver;































/*--- jnr-Jenner-Analytics-simple-flexible-macro-funtion-for-curated-lists-of-variables.sas

Jenner Analytics simple flexible macro funtion for curated lists of variables

USAGE

IMPORTANT (ORDER OF FILTER)

Prxmatch filter comes first then keep then drop

1 Age Height Name Sex Weight
  %put %getvars(libname=jenhelp,memname=class);

2 Height Name Weight
  %put %getvars(keep=name height weight);

3 Height Sex Weight
  %put %getvars(keep=name sex height weight,drop=name,prx="/weight/i");

4 "Name" "Sex" "Age" "Weight"
  %put %jnr_varlist(libname=sashelp,memname=class,keep=name age sex,function=quote,prx="/weight/i");

5 name,sex,age,weight *** function lowcase ***
  %put %jnr_varlist(libname=sashelp,memname=class,keep=name age sex,function=lowcase,prx='/weight/i',od=",");

/*--- Save in your autocall library ---*/

filename ft15f001 "c:/otojnr/jnr_varlist.sas";
parmcards4;
%macro jnr_varlist(
    libname=jenhelp
   ,memname=class
   ,function=  /*--- many functions possible like lowcase or quote ---*/
   ,od=" "
   ,prx="/(?!)/"  /*-- "/^/" always match '/(?!)/' never match ---*/
   ,keep=_all_
   ,drop=
 ) / des="Populate global VARLIST matching column names";

/*---

IMPORTANT (ORDER OF FILTER)

Prxmatch filter comes first then keep then drop

1 Age Height Name Sex Weight
  %put %getvars(libname=jenhelp,memname=class);

2 Height Name Weight
  %put %getvars(keep=name height weight);

3 Height Sex Weight
  %put %getvars(keep=name sex height weight,drop=name,prx="/weight/i");

4 "Name" "Sex" "Age" "Weight"
  %put %jnr_varlist(libname=sashelp,memname=class,keep=name age sex,function=quote,prx="/weight/i");

5 name,sex,age,weight *** function lowcase ***
  %put %jnr_varlist(libname=sashelp,memname=class,keep=name age sex,function=lowcase,prx='/weight/i',od=",");

---*/

%global varlist;
%let varlist=;

%dosubl('
data __keepdrop__;
    set &libname..&memname(keep=&keep);
    drop &drop;
    stop;
run;
proc print data=__keepdrop__;
run;
');


%dosubl('
proc sql;
  select &function(name) into :varlist separated by &od
  from
  ( select name,varnum
    from sashelp.vcolumn
    where upcase(libname) = upcase("&libname")
    and upcase(memname) = upcase("&memname")
    and prxmatch(&prx, name) > 0
    union corr
    select name, varnum
    from sashelp.vcolumn
    where upcase(libname) = upcase("work")
    and upcase(memname) = upcase("__keepdrop__")
    order by varnum
  )
;quit;');

%put NOTE:&=varlist;

&varlist

%mend jnr_varlist;
;;;;
run;

%put %jnr_varlist(libname=sashelp,memname=class,keep=name age sex,function=quote);

box















/*---
c:/utl/jnr-jenner-analytics-array-and-do_over-macros-based-on-ted-clays-work-example-sql-arrays.sas
---*/




filename ft15f001 "c:/otojnr/jnr_getvars.sas";
parmcards4;
%macro jnr_getvars(
    libname=sashelp
   ,quote=
   ,memname=class
   ,prx="/(?!)/"  /*-- "/^/" always match '/(?!)/' never match ---*/
   ,keep=_all_
   ,drop=
 ) / des="Populate global VARLIST matching column names";

/*---
IMPORTANT

PRX FILTER COMES FIRST THEN KEEP THEN DROP

1 LIST OF ALL VARIABLES;
  %put ALL VARIABLES LIST=%getvars(libname=jenhelp,memname=class);
  ALL VARIABLES LIST=Age Height Name Sex Weight

2 LIST ISTHREE VARS VARIABLES LIST=Height Name Weight
  %put THREE VARS VARIABLES LIST=%getvars(keep=name height weight);
  THREE VARS VARIABLES LIST=Height Name Weight

3 LIST IS THREE VARS VARIABLES LIST=Height Sex Weight
  %put THREE VARS VARIABLES LIST=%getvars(keep=name sex height weight,drop=name,prx='/weight/i');
  THREE VARS VARIABLES LIST=Height Sex Weight

4 "Name" "Sex" "Age" "Weight"
  %put %jnr_varlist(libname=sashelp,memname=class,keep=name age sex,function=quote,prx='/weight/i');

5 "Name" "Sex" "Age" "Weight"
  %put %jnr_varlist(libname=sashelp,memname=class,keep=name age sex,function=quote,prx='/weight/i',od=',');
---*/

%global varlist;
%let varlist=;

%dosubl('
data __keepdrop__;
    set &libname..&memname(keep=&keep);
    drop &drop;
    stop;
run;
proc print data=__keepdrop__;
run;
');

%dosubl('
proc sql;
  select distinct(name) into :varlist separated by " "
  from
  ( select name,varnum
    from sashelp.vcolumn
    where upcase(libname) = upcase("&libname")
    and upcase(memname) = upcase("&memname")
    and prxmatch(&prx, name) > 0
    union corr
    select name, varnum
    from sashelp.vcolumn
    where upcase(libname) = upcase("work")
    and upcase(memname) = upcase("__keepdrop__")
    order by varnum
  )
;quit;');

%put NOTE:&=varlist;

&varlist

%mend jnr_getvars;
;;;;
run;

proc r;


filename ft15f001 "c:/otojnr/jnr_varlist.sas";
parmcards4;
%macro jnr_varlist(
    libname=jenhelp
   ,memname=class
   ,function=  /*--- many functions possible like distinct or quote ---*/
   ,od=" "
   ,prx="/(?!)/"  /*-- "/^/" always match '/(?!)/' never match ---*/
   ,keep=_all_
   ,drop=
 ) / des="Populate global VARLIST matching column names";

/*---
IMPORTANT

PRX FILTER COMES FIRST THEN KEEP THEN DROP

1 LIST OF ALL VARIABLES;
  %put ALL VARIABLES LIST=%getvars(libname=jenhelp,memname=class);
  ALL VARIABLES LIST=Age Height Name Sex Weight

2 LIST ISTHREE VARS VARIABLES LIST=Height Name Weight
  %put THREE VARS VARIABLES LIST=%getvars(keep=name height weight);
  THREE VARS VARIABLES LIST=Height Name Weight

3 LIST IS THREE VARS VARIABLES LIST=Height Sex Weight
  %put THREE VARS VARIABLES LIST=%getvars(keep=name sex height weight,drop=name,prx='/weight/i');
  THREE VARS VARIABLES LIST=Height Sex Weight

4 "Name" "Sex" "Age" "Weight"
  %put %jnr_varlist(libname=sashelp,memname=class,keep=name age sex,function=quote,prx='/weight/i');

5 "Name" "Sex" "Age" "Weight"
  %put %jnr_varlist(libname=sashelp,memname=class,keep=name age sex,function=quote,prx='/weight/i',od=',');

---*/

%global varlist;
%let varlist=;

%dosubl('
data __keepdrop__;
    set &libname..&memname(keep=&keep);
    drop &drop;
    stop;
run;
proc print data=__keepdrop__;
run;
');

%dosubl('
proc sql;
  select &function(name) into :varlist separated by &od
  from
  ( select name,varnum
    from sashelp.vcolumn
    where upcase(libname) = upcase("&libname")
    and upcase(memname) = upcase("&memname")
    and prxmatch(&prx, name) > 0
    union corr
    select name, varnum
    from sashelp.vcolumn
    where upcase(libname) = upcase("work")
    and upcase(memname) = upcase("__keepdrop__")
    order by varnum
  )
;quit;');

%put NOTE:&=varlist;

&varlist

%mend jnr_varlist;
;;;;
run;

%put %jnr_varlist(libname=sashelp,memname=class,keep=name age sex,function=quote);











proc sql;
   select quote(name) into :names separated by "," from sashelp.class
;quit;

%put

proc sql;
   select (name) from sashelp.class
;quit;



%put "%jnr_varlist(libname=workx,memname=have,drop=day)");

* WORKS;
filename ft15f001 "c:/otojnr/jnr_numlist.sas";
parmcards4;
%macro jnr_expandrange(rng);

  %if %sysfunc(indexc(%substr(&rng,1,1),0123456789)) ^= 0 %then %do;
    %let rng=%qsysfunc(translate(&rng,":","-"));
    %dosubl('
    data _null_;
       length lst $32756;
       array rng[&rng];
       do i=lbound(rng) to hbound(rng);
          rng[i]=i;
       end;
       lst=catx(" ",of rng[*]);
       call symputx("rng",lst,'G');
    run;
    ');
  %end;
  %else %do;
    %dosubl('
    data _null_;
       length nams $32756;
       array rng[*] &rng;
       do i= lbound(rng) to hbound(rng);
         nam=vname(rng[i]);
         nams=catx(" ",nams,nam);
       end;
       call symputx("rng",nams,'G');
    run;
    ');
  %end;
  %trim(&rng)
%mend jnr_expandrange;
;;;;
run;

%*put expanded range= %jnr_numlist(1-9);

data _null_;
   x="%jnr_expandrangw(a1-a9)";
   put x=;
run;


%macro jnr_doOver(vars,code=,between=);

  %global prg;

/*
  %let vars=a1 a2 a3 b1 b2 b3;
  %let code=%str(put ?=;);
  %let between=;
*/

  %local quoteIt;
  %let quoteit=;

  %let quoteIt="%qsysfunc(tranwrd(&vars, %str( ) , %str(",")))";
  %let cnt=%qsysfunc(countw(&vars));
  %put &=cnt;

  %dosubl('
  %put QUOTEIT &quoteit;
  data _null_;
   length prg $32756;
   code="&code";
   array pfx[&cnt] $32 (&quoteIt) ;
   do i=1 to dim(pfx);
    %if &between= %then %do;
      prg=cats(prg,tranwrd(code,"?",pfx[i]));
    %end;
    %else %do;
      prg=catx(&between,prg,tranwrd(code,"?",pfx[i]));
    %end;
   end;
   putlog prg=;
   call symputx("prg",prg,"G");
   run;
  ');


%sysfunc(dequote("&prg"))

%mend doOver;

%let vars = %jnr_getvars(libname=workx,memname=have,drop=day);

proc sql;
 create
   table workx.xpo as
     %doOver(&vars,code=%str(
       select
         day
         ,'?'  as col
         ,?    as val
       from
         workx.have
       ),between=" union all ");
run;

proc print data=workx.xpo;
run;



filename ft15f001 "c:/otojnr/jnr_array.sas";
parmcards4;
%MACRO jnr_ARRAY(arraypos, array=, data=, var=, values=,
                       delim=%STR( ), debug=N, numlist=Y);

%LOCAL prefixes PREFIXN manum _VAR_N iter i J val VAR WHICH MINLENG
   PREFIX1 PREFIX2 PREFIX3 PREFIX4 PREFIX5 PREFIX6 PREFIX7 PREFIX8
   PREFIX9 PREFIX10 PREFIX11
   var1 var2 var3 var4 var5 var6 var7 var8 var9 var10 var11 ;

%* Get array names from either the keyword or positional parameter;
%if &ARRAY= %then %let PREFIXES=&ARRAYPOS;
%else %let PREFIXES=&ARRAY;

%* Parse the list of macro array names;
%do MANUM = 1 %to 999;
 %let prefix&MANUM=%scan(&prefixes,&MAnum," ");
 %if &&prefix&MANUM ne %then
   %DO;
    %let PREFIXN=&MAnum;
    %global &&prefix&MANUM..N;
    %* initialize length to zero;
    %let &&prefix&MANUM..N=0;
   %END;
  %else %goto out1;
%end;
%out1:

%if &DEBUG=Y %then %put PREFIXN is &PREFIXN;

%* Parse the VAR parameter;
%let _VAR_N=0;
%do MANUM = 1 %to 999;
 %let _var_&MANUM=%scan(&VAR,&MAnum," ");
 %if %str(&&_var_&MANUM) ne %then %let _VAR_N=&MAnum;
 %else %goto out2;
%end;
%out2:

%IF &PREFIXN=0 %THEN
    %PUT ERROR: No macro array names are given;
%ELSE %IF %LENGTH(%STR(&DATA)) >0 and &_VAR_N=0 %THEN
    %PUT ERROR: DATA parameter is used but VAR parameter is blank;
%ELSE %IF %LENGTH(%STR(&DATA)) >0 and &_VAR_N ne &PREFIXN %THEN
    %PUT ERROR: The number of variables in the VAR parameter is not
 equal to the number of arrays;
%ELSE %DO;

%*------------------------------------------------------;
%*  CASE 1: VALUES parameter is used
%*------------------------------------------------------;

%IF %LENGTH(%STR(&VALUES)) >0 %THEN
%DO;
     %IF &NUMLIST=Y %then
     %DO;
         %* Check for numbered list of form xxx-xxx and expand it using
             the NUMLIST macro.;
         %IF (%INDEX(%quote(&VALUES),-) GT 0) and
             (%length(%SCAN(%quote(&VALUES),1,-))>0) and
             (%length(%SCAN(%quote(&VALUES),2,-))>0) and
             (%length(%SCAN(%quote(&VALUES),3,-))=0)
           %THEN %do;
              %put values before &=values;
              %let rc=%qsysfunc(dosubl(%jnr_numlist(&values)));
              %LET VALUES=&rng;
              %put values after &=values;
           %end;
     %END;

%LET MINLENG=99999;
%DO J=1 %TO &PREFIXN;
%DO ITER=1 %TO 9999;
  %LET WHICH=%EVAL((&ITER-1)*&PREFIXN +&J);
  %LET VAL=%SCAN(%STR(&VALUES),&WHICH,%STR(&DELIM));
  %IF %QUOTE(&VAL) NE %THEN
    %DO;
      %GLOBAL &&&&PREFIX&J..&ITER;
      %LET &&&&PREFIX&J..&ITER=&VAL;
      %LET &&&&PREFIX&J..N=&ITER;
    %END;
  %ELSE %goto out3;
%END;
%out3: %IF &&&&&&PREFIX&J..N LT &MINLENG
          %THEN %LET MINLENG=&&&&&&PREFIX&J..N;
%END;

%if &PREFIXN >1 %THEN
%DO J=1 %TO &PREFIXN;
    %IF &&&&&&PREFIX&J..N NE &MINLENG %THEN
%PUT ERROR: Number of values must be a multiple of the number of arrays;
%END;

%END;
%ELSE %DO;

%*------------------------------------------------------;
%*  CASE 2: DATA and VAR parameters used
%*------------------------------------------------------;

%* Get values from one or more variables in a dataset or view;
  data _null_;
  set &DATA end = lastobs;
%DO J=1 %to &PREFIXN;
  call execute("%GLOBAL "||"&&PREFIX&J.."||left(put(_n_,5.)) );
  call symput(compress("&&prefix&J"||left(put(_n_,5.))),
              trim(left(&&_VAR_&J)));
  if lastobs then
   call symput(compress("&&prefix&J"||"N"), trim(left(put(_n_,5.))));
%END;
  run ;

%* Write message to the log;
%IF &DEBUG=Y %then
%DO J=1 %to &PREFIXN;
 %PUT &&&&PREFIX&J..N is &&&&&&PREFIX&J..N;
%END;

%END;
%END;

%MEND jnr_array;
;;;;
run;

/*---
%jnr_array(nums,values=A3-A5);

%put &=nums1;
%put &=nums2;
%put &=nums3;
%put &=numsn;

%jnr_array(chrs,values=3-5);

%put &=chrs1;
%put &=chrs2;
%put &=chrs3;
%put &=chrsn;

%let rc=%sysfunc(dosubl(%jnr_numlist(A3-A5)));
%put NOTE: Range from numlist macro &=rng;


%let rc=%sysfunc(dosubl(%jnr_numlist(3-5)));
%put NOTE: Range from NumLisr  &=rng;
---*/



libname workx "d:/wpswrkx"; /*--- put in autoexec ---*/
data workx.have;
 input day a1 a2 a3 b1 b2 b3;
cards4;
1 40 40 20 20 10 14
2 50 50 40 40 20 22
3 60 60 50 50 30 37
4 70 70 60 60 40 45
5 80 80 70 70 50 52
6 90 90 80 80 60 65
;;;;
run;quit;

%put %jnr_getvars(libname=workx,memname=have,drop=day);
