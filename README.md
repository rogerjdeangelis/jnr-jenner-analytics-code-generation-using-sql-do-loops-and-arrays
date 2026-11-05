# jnr-jenner-analytics-code-generation-using-sql-do-loops-and-arrays
Jenner Analytics code generation using sql do loops and arrays
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










