
How to stack a table and corresponding bar graph

 INPUT

  WORK.PGA2007 total obs=50

   Obs    RANK    EARNINGS    LASTNAME     STATNAME     STAT

     1      1     10867052    Woods        AGE           33
     2      1            .    Woods        EVENTS        16
     3      1            .    Woods        Cuts Made     16
     4      1            .    Woods        WINS           7
     5      1            .    Woods        Top 10s       12
     6      2      5819988    Mickelson    AGE           38
     7      2            .    Mickelson    EVENTS        22
     8      2            .    Mickelson    Cuts Made     16
     9      2            .    Mickelson    WINS           3
    10      2            .    Mickelson    Top 10s        7
    ....

   WORKING CODE
   ============

    proc template;
    define statgraph bartable ;
     mvar T1 T2 T3 T4 T5 T6 T7 T8 T9 P1 P2 P3 P4 P5 P6 P7 P8 P9;
     begingraph / designwidth=600px designheight=400px;
        entrytitle "Professional Golf Statistics for 2007";
        layout lattice / rows=2 rowgutter=0 rowweights=(.75 .25);
        layout overlay / xaxisopts=(display=(tickvalues))
        yaxisopts=(griddisplay=on
        linearopts=(tickvalueformat=(extractscale=true)) );
        layout gridded / valign=top halign=right border=true
            opaque=true backgroundcolor=GraphWalls:color;
            entry "Tigers 2007 Wins" / textattrs=(weight=bold);
            layout gridded /columns=2 opaque=true backgroundcolor=GraphWalls:color;
            entry halign=left T1; entry halign=right P1;
            entry halign=left T2; entry halign=right P2;
            entry halign=left T3; entry halign=right P3;
            entry halign=left T4; entry halign=right P4;
            entry halign=left T5; entry halign=right P5;
            entry halign=left T6; entry halign=right P6;
            entry halign=left T7; entry halign=right P7;endlayout;endlayout;
            barchart x=LastName y=Earnings /
            barlabel=true barlabelformat=dollar12. fillattrs=graphdata1
            skin=satin outlineattrs=(color=black);
        endlayout;
        layout overlay / xaxisopts=(type=discrete display=none) walldisplay=(fill);
           blockplot x=LastName block=stat / class=statName display=(outline values label)
           valuehalign=right repeatedvalues=true
           labelattrs=(size=7pt);endlayout;
        endlayout;
    endgraph;
    end;
    run;quit;

    ods graphics on / reset=all width=8in
       imagename="utl_how_to_make_a_table_and_corresponding_bar_graph" imagefmt=png;
    ods listing gpath="d:/pdf";
    proc sgrender data=PGA2007 template=bartable;
    run;quit;

    OUTPUT
    ======
                              Players

                 B   C   F   G   J   M   S   S   S  W
                 a   h   u   a   o   i   a   i   t  o
                 d   o   r   r   h   c   b   n   r  o
                 d   i   y   c   n   k   b   g   i  d
                 e       k   i   s   e   a   h   c  s
                 l           a   o   l   t       k
                 e               n   s   i       e
             |   y                   o   n       r  **
             |                       n   i          **
 $10,000,000 +                                      **
             |                                      **
             |                                      **
             |                                      **
  $8,000,000 +                                      **
             |                                      **
             |                                      **
             |                                      **
  $6,000,000 +                      **              **
             |                      **              **
             |                      **              **
             |      **              **  **  **  **  **
  $4,000,000 +      **  **      **  **  **  **  **  **
             |  **  **  **  **  **  **  **  **  **  **
             |  **  **  **  **  **  **  **  **  **  **
             |  **  **  **  **  **  **  **  **  **  **
  $2,000,000 +  **  **  **  **  **  **  **  **  **  **
             |  **  **  **  **  **  **  **  **  **  **
             |  **  **  **  **  **  **  **  **  **  **
             |  **  **  **  **  **  **  **  **  **  **
             -------------------------------------------
  AGE           33  38  45  41  38  32  45  41  38  32
  EVENTS        16  22  27  23  25  23  27  23  25  23
  Cuts Made     16  16  25  19  20  18  25  19  20  18
  WINS           7   3   2   1   2   1   2   1   2   1
  Top 10s       12   7   7   9   7  10   7   9   7  10

see
https://goo.gl/myCu1R
https://communities.sas.com/t5/SAS-Procedures/How-to-make-a-table-and-corresponding-line-graph/m-p/411477

*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

data PGA2007;
  input Rank 2.  Player & $15. Age Events Rounds CutsMade Top10 Wins Earnings;
  length  LastName $10 StatName $10;
  keep Rank LastName Earnings StatName Stat;
  LastName=scan(Player,2,' ');
  label CutsMade="Cuts Made" Top10="Top 10s";
  format Earnings dollar12.;
  array sname{5} Age Events CutsMade Wins Top10;
    do i=1 to dim(sname);
      StatName=vlabel(sname{i});
      Stat=sname{i};
    if i>1 then earnings=.;
    output;
    end;
cards4;
 1 Tiger Woods     33  16  61 16 12  7 10867052
 2 Phil Mickelson  38  22  73 16  7  3  5819988
 3 Vijay Singh     45  27 101 25  7  2  4728377
 4 Steve Stricker  41  23  80 19  9  1  4663077
 5 K.J. Choi       38  25  88 20  7  2  4587859
 6 Rory Sabbatini  32  23  80 18 10  1  4550040
 7 Jim Furyk       38  24  84 20  8  1  4154046
 8 Zach Johnson    32  23  78 18  5  2  3922338
 9 Sergio Garcia   29  19  67 16  7  0  3721185
10 Aaron Baddeley  27  23  82 19  7  1  3441119
;;;;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

proc template;
define statgraph bartable ;
 mvar T1 T2 T3 T4 T5 T6 T7 T8 T9 P1 P2 P3 P4 P5 P6 P7 P8 P9;
 begingraph / designwidth=600px designheight=400px;
    entrytitle "Professional Golf Statistics for 2007";
    layout lattice / rows=2 rowgutter=0 rowweights=(.75 .25);
    layout overlay / xaxisopts=(display=(tickvalues))
    yaxisopts=(griddisplay=on
    linearopts=(tickvalueformat=(extractscale=true)) );
    layout gridded / valign=top halign=right border=true
        opaque=true backgroundcolor=GraphWalls:color;
        entry "Tigers 2007 Wins" / textattrs=(weight=bold);
        layout gridded /columns=2 opaque=true backgroundcolor=GraphWalls:color;
        entry halign=left T1; entry halign=right P1;
        entry halign=left T2; entry halign=right P2;
        entry halign=left T3; entry halign=right P3;
        entry halign=left T4; entry halign=right P4;
        entry halign=left T5; entry halign=right P5;
        entry halign=left T6; entry halign=right P6;
        entry halign=left T7; entry halign=right P7;endlayout;endlayout;
        barchart x=LastName y=Earnings /
        barlabel=true barlabelformat=dollar12. fillattrs=graphdata1
        skin=satin outlineattrs=(color=black);
    endlayout;
    layout overlay / xaxisopts=(type=discrete display=none) walldisplay=(fill);
       blockplot x=LastName block=stat / class=statName display=(outline values label)
       valuehalign=right repeatedvalues=true
       labelattrs=(size=7pt);endlayout;
    endlayout;
endgraph;
end;
run;quit;

ods graphics on / reset=all width=8in
   imagename="utl_how_to_make_a_table_and_corresponding_bar_graph" imagefmt=png;
ods listing gpath="d:/pdf";
proc sgrender data=PGA2007 template=bartable;
run;quit;

