Program PaintBrush; {      Mehdi       }
Uses Crt,Graph,Dos;
Var
  rg:registers;
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
Var
  Oldx,Oldy:integer;
  PenState:Byte;
Function Pen:byte;
  var
    i:integer;
    {Oldx,Oldy:integer;}
  begin
    {While NOT(Keypressed) do}
      begin
        delay(25);
        ReadMouse;
        IF rg.bx=0 then
          begin
            oldx:=rg.cx;
            oldy:=rg.dx;
          end;
        IF rg.bx=1 then
          begin
            HideCursor;
            SetLineStyle(0, $C3,PenState);
            line(oldx,oldy,rg.cx,rg.dx);
            SetLineStyle(0, $C3,1);
            oldx:=rg.cx;
            oldy:=rg.dx;
            ShowCursor;
          end;
      end;
  end;
Function Interf:byte;
  var
    tempcolor:byte;
    li:integer;
  begin
    tempcolor:=getcolor;
    setcolor(15);
    SetViewPort(0,0,GetMaxX,GetMaxY,True);
    Rectangle(1,1,402,402);
    OutTextxy(450,10,'x: Exit');
    OutTextxy(450,30,'c: Clear');
    Outtextxy(450,50,'s: Save');
    Outtextxy(450,70,'o: Open new file');
    Outtextxy(450,90,'p: Pen');
    OutTextxy(450,110,'t: Thick pen');
    Outtextxy(450,130,'zero: Black');
    For li:=1 to 15 do
      begin
        SetColor(li);Outtextxy(450,130+20*li,chr(219)+'лл '+chr(li+48)+' лл'+chr(219));
        SetColor(15);
      end;
    setcolor(tempcolor);
    Outtextxy(10,425,'current color'+chr(219)+chr(219)+chr(219)+chr(219)+chr(219)+chr(219)+chr(219));
    SetColor(15);
    IF tempcolor=0 then outtextxy(10,425,'current color: Black');
    SetColor(15);
    SetViewPort(2,2,401,401,True);
    setcolor(tempcolor);
  end;
Function ClearInterF:byte;
  begin
    HideCursor;
    ClearDevice;
    Interf;
    ShowCursor;
  end;
Function state(stx,sty:integer;st:string;colo:byte):byte;
  var
    tempcolor:byte;
  begin
    tempcolor:=getcolor;
    setcolor(colo);
    SetViewPort(0,0,GetMaxX,GetMaxY,True);
    OutTextxy(stx,sty,st);
    Setcolor(tempcolor);
    interf;
  end;
Function Save(xs,ys,w,h:integer;FileName:string):byte;
  var
    F:File of Byte;
    i,j:integer;
    tw1,tw2,th1,th2,tF:byte;
  begin
    State(10,440,'Saving...',15);
    HideCursor;
    tw1:=w;
    tw2:=w ShR 8;
    th1:=h;
    th2:=h ShR 8;
    Assign(F,FileName);
    Rewrite(F);
    Write(F,tw1);
    Write(F,tw2);
    Write(F,th1);
    Write(F,th2);
    For j:=0 to H-1 do
      For i:=0 to W-1 do
        begin
          tF:=GetPixel(xs+i,ys+j);
          Write(F,tF);
        end;
    Close(F);
    State(10,440,'ллллллллл',0);
    ShowCursor;
  end;
Function Open(xs,ys:integer;FileName:string):byte;
  var
    F:File of Byte;
    tw1,tw2,th1,th2,tF:byte;
    w,h,i,j:integer;
  begin
    State(10,440,'Opening...',15);
    HideCursor;
    Assign(F,FileName);
    Reset(F);
    Read(F,tw1);
    Read(F,tw2);
    w:=(tw2 ShL 8)+tw1;
    Read(F,th1);
    Read(F,th2);
    h:=(th2 ShL 8)+th1;
    For j:=0 to H-1 do
      For i:=0 to W-1 do
        begin
          Read(F,tF);
          Putpixel(xs+i,ys+j,tF);
        end;
    Close(F);
    State(10,440,'лллллллллл',0);
    ShowCursor;
  end;
Var
  CurTool:byte;
Function Tool:byte;
  begin
    Case CurTool of
      1:Pen;
      {2:Lin;
      3:Rect;}
    end;
  end;

(*+++++++++++++++++++++++ Menu System ++++++++++++++++++++++++++++++*)
Const
  mnuPMax=4;
Var
  mnuS:Array [1..mnuPMax] of string;
  mnuMax:byte;
  mnuSelCol:byte;
  mnuPointer:string;
  mnuDefaultCol:byte;
  mnuCur:byte;    mTit:string;
Var
  menu:byte;
Procedure MenuS;
  procedure mnuoutput;
    var
      j,i:integer;
      s:string;
    begin
     textcolor(mnuDefaultCol);
     gotoxy(1,6);
     writeln(mTit);
     writeln;
     For i:=1 to mnuMax do
       begin
          s:='             ';
          if mnuCur=i then {add pointing char}
            begin
             textcolor(mnuSelCol);
             s:=s+mnuPointer;
            end
          else  {add spaces instead}
            begin
               textcolor(mnuDefaultCol);
               for j:=1 to length(mnuPointer) do
                   s:=s+chr(32); {adding sufficient spaces}
            end;

          s:=s+'  '; {adding two spaces after the pointer}


          write(s);
          writeln(mnuS[i]);
       end;
     end;
  function mnuFunc:byte;
    var
      n:integer;
      c:char;
    begin
     (*{-Setting menu items}
     mnuS[1]:='Start a new game';
     mnuS[2]:='Load a saved game';
     mnuS[3]:='View high scores';
     mnuS[4]:='Exit';
     mnuMax:=4;      mnuPointer:='->'; {pointing character}

     mnuSelCol:=14; {Bright Yellow}
     mnuDefaultCol:=15; {Bright White}
     mnuCur:=1;*)

     mnuOutput; {draw menu for the first time}

     while {not(c=chr(27)) and} not(c=chr(13)) do  {loop until escape or enter pressed}
     begin
          if keypressed then {loop till keypressed}
             c:=readkey;
          if c=chr(0) then
          begin
               c:=readkey;  {getting the extended character}
               if ord(c)=80 {up} then
               begin
                    mnuCur:=mnuCur+1;  {select next item in menu}
                    if mnuCur>mnuMax then {check if it exceeds the last number}
                       mnuCur:=1;
               end;
               if ord(c)=72 {down} then
               begin
                    mnuCur:=mnuCur-1;  {check if it exceed the first}
                    if mnuCur<1 then
                       mnuCur:=mnuMax;
               end;
               mnuOutput; {draw current state, the changed one}

          end;




     end;  {end while}

     {-- proceeding with selected item:}
     if c=chr(27) then mnuCur:=mnuMax; {set to Exit} {C can be both 27 and 13}

     mnuFunc:=mnuCur; {returns the selected menu}

    end;
  {var
    Menu:byte;}
  begin
    Menu:=mnuFunc;
  end;



{end;}

(*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*)

Function FileExists(FileN: String): Boolean;
{ Boolean function that returns True if the file exists;otherwise,
 it returns False. Closes the file if it exists. }
  var
    Fi: file;
  begin
    {$I-}
    Assign(Fi,FileN);
    (*FileMode := 0;  { Set file access to read only }*)
    Reset(Fi);
    Close(Fi);
    {$I+}
    FileExists := (IOResult = 0) and (FileN <> '');
  end;  { FileExists }

Var
  GD,GM:integer;
  c:char;
  ExitFlag,ExitProFlag:Boolean;
  sel:byte;
  FileName:string;
  Prm:boolean;
Begin

 Prm:=False;

 Repeat

  ClrScr;
  sel:=0;


  (*============================Text Mode========================================*)

  Repeat

    textcolor(12);
    gotoxy(20,4);
    IF (FileName='') and (sel=1) then Writeln('Filename cannot be empty');
    IF (FileExists(FileName)) and (sel=1) then Writeln('File already exits - Use open');
    IF (NOT(FileExists(FileName))) and (sel=2) then Writeln('File not found');

    IF (ParamCount=1) AND (NOT(Prm)) then begin Filename:=Paramstr(1); sel:=2; Prm:=True; end Else begin


    textcolor(7);Gotoxy(60,24);Write('      Mehdi       ');
    textcolor(15);
    mTit:='             What do you want to do?';
    mnuS[1]:='Draw a new picture';
    mnuS[2]:='Open an existing picture';
    {mnuS[3]:='Color box mode';}
    mnuS[3]:='Exit';
    mnuMax:=3;
    mnuPointer:='>>>'; {pointing character}
    mnuSelCol:=10;
    mnuDefaultCol:=15; {Bright White}
    mnuCur:=1;
    MenuS;
    sel:=menu;
    TextColor(15);
    IF sel<>3 then
      begin
        Gotoxy(14,14);
        Writeln('Enter the Filename (and Address):');
        Gotoxy(14,15);
        Readln(FileName);
      end;

                                                                                                   end;

    ClrScr;

  Until ((FileName<>'') and (sel=1) and (NOT(FileExists(FileName)))) OR ((FileExists(FileName)) and (sel=2)) OR (sel=3);


  Textcolor(15);
  (*=====================================================================*)

  IF sel=3 then begin ExitFlag:=True; ExitProFlag:=True; end;
  DetectGraph(GD,GM);
  initGraph(GD,GM,'Z:\TP');
  SetBKColor(0);
  SetColor(2);
  PenState:=1;
  CurTool:=1;
  Interf;
  IF sel=2 then Open(0,0,FileName);
  {FloodFll(50, 50, GetMaxColor);}
  ShowCursor;
  Repeat
    IF Keypressed then
      begin
        c:=readkey;
        Case c of
          'x' : begin ExitFlag:=True; ExitProFlag:=True; end;
          'c' : ClearInterF;
          '0'..'?' : begin setcolor(ord(c)-48); InterF; end;
          's' : Save(0,0,400,400,FileName);
          'o' : ExitFlag:=True;
          'p' : begin curtool:=1; PenState:=1; end;
          't' : begin curtool:=1; PenState:=3; end;
          end;
      end;
    Tool;

    {Readln;}
  Until ExitFlag;
  ExitFlag:=False;
  CloseGraph;

 Until ExitProFlag;

End.

