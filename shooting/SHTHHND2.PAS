Program Shooting_Club__Hand; {     Mehdi       }

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
    SetFillStyle(1,12);
    Bar(0,0,320,240);
    SetFillStyle(1,10);
    Bar(320,0,640,240);
    SetFillStyle(1,9);
    Bar(0,240,320,480);
    SetFillStyle(1,14);
    Bar(320,240,640,480);

  end;
Function TargetDraw(qdist:integer):byte;
  var
    ic:integer;
  begin
    For ic:=7 downto 1 do
    begin
      SetFillStyle(1,15-ic);
      FillEllipse(320,240,qdist*ic,qdist*ic);
    end;
  end;


{Function Sahmi:byte;}

{Function Mirror:byte;
  begin


  end;
  }

{Function Hand:byte;
  begin
  end;}

Function Shoot:byte;
  begin
    ReadMouse;
    IF rg.bx=1 then
      begin
        HideCursor;
        SetFillStyle(1,0);
        FillEllipse(rg.cx,rg.dx,2,2);
        ShowCursor;
      end;
  end;

Var
  GrD,GrM:integer;
  ExitHandFlag:boolean;
  Randx,Randy:integer;
  MoveR,Dest:integer;
  ch:char;

Begin
  ClrScr;

  MoveR:=2;
  Dest:=10;
  textcolor(15);

  gotoxy(1,10);
  Writeln('Choose target distance using \/ and /\ :');
  Writeln('Choose game level using <- and -> :');
  Writeln;
  Writeln('         Press ENTER when finished');

  Repeat
    TextColor(0);
    Gotoxy(50,10);
    Write('лл');
    Gotoxy(50,11);
    Write('лл');


    TextColor(14);
    Gotoxy(50,10);
    Write(31-dest);
    Gotoxy(50,11);
    Write(MoveR);


    ch:=Readkey;



    IF ch=chr(80) then {writeln('Down!');} IF Dest>2 then Dec(dest);
    IF ch=chr(72) then {'Up!'} IF dest<30 then inc(Dest);
    IF ch=chr(75) then {writeln('Left!');} IF MoveR>1 then dec(moveR);
    IF ch=chr(77) then {writeln('Right!');} IF MoveR<5 then inc(moveR);

  Until ch=chr(13);






  DetectGraph(GrD,GrM);
  InitGraph(GrD,GrM,'Z:\TP');
  BackDraw;
  TargetDraw(Dest);
  ShowCursor;
  ExitHandFlag:=False;
  Randomize;
  Repeat
    ReadMouse;
    Randx:=Random(9)-4;
    Randy:=Random(9)-4;
    rg.cx:=rg.cx+MoveR*Randx;
    rg.dx:=rg.dx+MoveR*Randy;
    Setmouse;
    Delay(40);
    Shoot;
    {ReadMouse;
    rg.cx:=rg.cx-MoveR*Randx;
    rg.dx:=rg.dx-MoveR*Randy;
    Setmouse;
    Delay(40);
    Shoot;}
  Until {ExitHandFlag}KeyPressed;
  {Readln;}
  CloseGraph;
End.