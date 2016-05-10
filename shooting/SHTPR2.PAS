Program Shooting_Club__Parabola; {     Mehdi       }

Uses Crt,Graph,Dos;


Var
  rg:registers;

(*======================MOUSE FUNCTIONS====================*)

Function ShowCursor:byte;
  begin
    rg.ax:=1;
    intr(51,rg);
  end;
Function HideCursor:byte;
  begin
    rg.ax:=2;
    intr(51,rg);
  end;
Function ReadMouse:byte;
  begin
    rg.ax:=3;
    intr(51,rg);
  end;
Function SetMouse:byte;
  begin
    rg.ax:=4;
    intr(51,rg);
  end;

(*===========================================================*)

Function BackDraw:byte;
  begin
    setcolor(15);
    Rectangle(10,0,635,440);
    setcolor(0);
    line(10,0,635,0);
    SetColor(15);
  end;

Function TargetDraw(var Trx,Try:integer):byte;
  var
    TarRandx,TarRandy:integer;
  begin
    Randomize;
    TarRandx:=Random(201);
    TarRandy:=Random(411);
    Trx:=TarRandx+380;
    Try:=TarRandy+10;
    SetFillStyle(1,12);
    FillEllipse(Trx,Try,15,15);
  end;

Var
  GrD,GrM:integer;
  t,x,y,V0:integer;
  teta,tetadegree:real;
  Tx,Ty:integer;
  try:byte;
  ch:char;
  V0T,V0TMOD:integer;
  TD,TDMOD:integer;
  noi:byte;
  WinState:boolean;

Begin

  DetectGraph(GrD,GrM);
  InitGraph(GrD,GrM,'Z:\TP');

  BackDraw;
  TargetDraw(Tx,Ty);

  {ShowCursor;}

  WinState:=False;

  V0:=100;
  tetadegree:=30;

  For try:=3 downto 1 do
    begin
      SetColor(14);
      OutTextxy(2,450,'Velocity:          <- ->');{Readln(V0);}
      OutTextxy(2,460,'Degree:            \/ /\');{Readln(tetadegree);}
      SetColor(0);
      OutTextxy(320,450,'                    л');
      SetColor(14);
      OutTextxy(320,450,'Remained Bullet(s): '+chr(try+48));
      OutTextxy(320,460,'Shoot: ENTER');
      SetFillStyle(1,9);
      FillEllipse(25,400,8,8);

      Repeat
        V0T:=V0;
        TD:=Trunc(tetadegree);
        SetColor(0); Moveto(90,450); OutText('лллллллл');
        SetColor(2); Moveto(150,450);
        For noi:=1 to 4 do
          begin
            MoveRel(-20,0);
            V0TMOD:=V0T MOD 10;
            V0T:=V0T DIV 10;
            OutText(chr(V0TMOD+48))
          end;

        SetColor(0); Moveto(90,460); OutText('лллллллл');
        SetColor(2); Moveto(150,460);
        For noi:=1 to 4 do
          begin
            MoveRel(-20,0);
            TDMOD:=TD MOD 10;
            TD:=TD DIV 10;
            OutText(chr(TDMOD+48))
          end;

        ch:=readkey;
        IF ch=chr(0) then
          begin
            ch:=readkey;
            IF ch=chr(80) then {writeln('Down!');} IF tetadegree>0 then tetadegree:=tetadegree-1;
            IF ch=chr(72) then {'Up!'} IF tetadegree<90 then tetadegree:=tetadegree+1;
            IF ch=chr(75) then {writeln('Left!');} IF V0>0 then dec(V0);
            IF ch=chr(77) then {writeln('Right!');} IF V0<2000 then inc(V0);
          end;
      Until ch=chr(13);




      teta:=tetadegree*pi/180;
      t:=0;

      Repeat

        x:=trunc(V0*cos(teta)*(t/10)+25);
        y:=trunc(0.5*10*sqr(t/10)-V0*sin(teta)*(t/10)+400);
        SetColor(2);
        SetFillStyle(1,2);
        FillEllipse(x,y,8,8);
        Delay(50); (***************)
        SetColor(0);
        SetFillStyle(1,0);
        FillEllipse(x,y,8,8);
        IF (Tx-(15+8)<x) AND (x<Tx+(15+8)) AND (Ty-(15+8)<y) AND (y<Ty+(15+8)) then WinState:=True;
        inc(t);

      Until (KeyPressed) OR (x>610) OR (x<18) OR (y>429) OR (WinState);
      IF keypressed then ch:=Readkey;
      IF WinState=True then Break;

    end;
  SetFillStyle(1,15);
  bar(180,150,420,250);
  setcolor(9);
  IF WinState then OutTextxy(270,180,'YOU WON')
    ELSE OutTextxy(270,180,'YOU LOST');
  OutTextxy(190,200,'Press any key to continue...');
  Readkey;
  CloseGraph;
End.
