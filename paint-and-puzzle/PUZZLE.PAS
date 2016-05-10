Program Puzzle; {      Mehdi       }
Uses Crt,Graph,Dos;




Var
  rg:registers;
(*============================== Mouse Functions =======================*)

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

(*=========================== END Mouse Func =============================*)







Procedure Swap(var a,b:integer);
  var c:integer;
  begin
    c:=a;
    a:=b;
    b:=c;
  end;

Var
PA:Array[1..4,1..4,1..6] of integer;


{Function Rand:byte;
  var
    i,j,rn:byte;
    B:Array[1..16] of byte;
  begin
    For i:=1 to 16 do B[i]:=0;
    Randomize;
    For i:=1 to 4 do
     For j:=1 to 4 do
      begin
        Repeat
          rn:=Random(16)+1;
          PA[i,j,1]:=rn;
        Until B[rn]=0;
        B[rn]:=1;
      end;
  end;}

Function FillPA:byte;
  var
    i,j:byte;
  begin
   For j:=1 to 4 do
    For i:=1 to 4 do
      begin
        PA[i,j,3]:=(i-1)*100;
        PA[i,j,4]:=(j-1)*100;
        PA[i,j,5]:=2+i*100-3;
        PA[i,j,6]:=2+j*100-3;
    end;
  end;


Var
p,q,r:Pointer;

Function SwRand:byte;
  var
    i,j,t,rni,rnj:byte;
    size1,size2:Word;
  begin
    For j:=1 to 4 do
      For i:=1 to 4 do
        begin
          PA[i,j,1]:=i;
          PA[i,j,2]:=j;
        end;
    Randomize;
    For t:=1 to 30 do
      begin
        rni:=Random(4)+1;
        rnj:=Random(4)+1;
        Size2:=Imagesize(PA[rni,rnj,3],PA[rni,rnj,4],PA[rni,rnj,5],PA[rni,rnj,6]);
        Getmem(q,size2);
        Size1:=Imagesize(PA[1,1,3],PA[1,1,4],PA[1,1,5],PA[1,1,6]);
        Getmem(p,size1);
        GetImage(PA[rni,rnj,3],PA[rni,rnj,4],PA[rni,rnj,5],PA[rni,rnj,6],Q^);
        GetImage(PA[1,1,3],PA[1,1,4],PA[1,1,5],PA[1,1,6],P^);
        Swap(PA[1,1,1],PA[rni,rnj,1]);
        Swap(PA[1,1,2],PA[rni,rnj,2]);
        PutImage(PA[1,1,3],PA[1,1,4],Q^,NormalPut);
        PutImage(PA[rni,rnj,3],PA[rni,rnj,4],P^,Normalput);
        Freemem(p,size1);
        Freemem(q,size2);
      end;
  end;


Var
  BA:array[1..4,1..4] of boolean;

Function ObjClick(i,j:integer):byte;
  var
   ix,jy:integer;
  begin

          IF (BA[i,j]=False) and (rg.bx=1) then
            IF (PA[i,j,3]<rg.cx) AND (rg.cx<PA[i,j,5]) AND (PA[i,j,4]<rg.dx) AND (rg.dx<PA[i,j,6]) then
              begin
                For jy:=1 to 4 do
                  For ix:=1 to 4 do
                    BA[ix,jy]:=False;
                BA[i,j]:=True;
              end;
          IF (BA[i,j]=True) and (rg.bx=0) then
            IF (PA[i,j,3]<rg.cx) AND (rg.cx<PA[i,j,5]) AND (PA[i,j,4]<rg.dx) AND (rg.dx<PA[i,j,6]) then
              begin
                BA[i,j]:=False;
                ObjClick:=1;
                exit;
              end;

    ObjClick:=0;
  end;




Function IFWon:Boolean;
  var
    i,j:integer;
  begin
    IFwon:=True;
    For j:=1 to 4 do
      For i:=1 to 4 do
        IF PA[i,j,1]<>i then IFWon:=False;
    For j:=1 to 4 do
      For i:=1 to 4 do
        IF PA[i,j,2]<>j then IFWon:=False;
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
    {OutTextxy(450,30,'__c: Clear');
    Outtextxy(450,50,'__s: Save');}
    Outtextxy(450,70,'o: Open new file');
    {Outtextxy(450,90,'__p: Pen');
    OutTextxy(450,110,'__t: Thick pen');
    Outtextxy(450,130,'__zero: Black');}
    For li:=1 to 15 do
      begin
        SetColor(li);Outtextxy(450,140+8*li,chr(219)+'лллл'+chr(219));
        SetColor(15);
      end;
    setcolor(tempcolor);
    {Outtextxy(10,425,'current color'+chr(219)+chr(219)+chr(219)+chr(219)+chr(219)+chr(219)+chr(219));
    SetColor(15);
    IF tempcolor=0 then outtextxy(10,425,'current color: Black');}
    SetColor(15);
    SetViewPort(2,2,401,401,True);
    setcolor(tempcolor);
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
  FileName:String;
  c:char;
  StartFlag:Boolean;
  ExitFlag,ExitProFlag:Boolean;

  i,j,ii,jj:integer;
  indicate:byte;
  size1,size2:word;
  Prm:boolean;

Begin

  Prm:=False;

  Repeat

    ClrScr;
    StartFlag:=False;
    Repeat
        ClrScr;
        textcolor(12);
        gotoxy(20,4);
        IF (NOT(FileExists(FileName))) and (StartFlag) then Writeln('File not found');

        IF (ParamCount=1) AND (NOT(Prm)) then begin Filename:=Paramstr(1); Prm:=True; end Else begin

        TextColor(14);
        Gotoxy(24,2);
        Writeln('Puzzle Game by       Mehdi       ');
        Gotoxy(18,14);
        TextColor(15);
        Writeln('Enter the Filename (and Address) OR exit');
        Gotoxy(18,15);
        Readln(FileName);

                                                                                               end;
        StartFlag:=True;
        Textcolor(7);
        ClrScr;
    Until (((FileName<>'') and (FileExists(FileName))) OR (FileName='exit'));

    StartFlag:=False;
    TextColor(15);

    IF FileName='exit' then begin ExitFlag:=True; ExitProFlag:=True; end;


    IF NOT(ExitProFlag) then
      begin

        DetectGraph(Gd,Gm);
        InitGraph(Gd,Gm,'Z:\TP');

        SetBKColor(0);
        SetColor(2);
        Interf;
        Open(0,0,FileName);
        FillPA;
        Delay(1500);
        SwRand;
        ShowCursor;
      end;
    For j:=1 to 4 do
      For i:=1 to 4 do
        BA[i,j]:=False;

    Repeat
      IF Keypressed then
        begin
          c:=readkey;
          Case c of
            'x' : begin ExitFlag:=True; ExitProFlag:=True; end;
            'o' : ExitFlag:=True;
          end;
        end;
      {Tool;}


      For j:=1 to 4 do
        For i:=1  to 4 do
          begin
            ReadMouse;
            IF ObjClick(i,j)=1 then

                IF indicate=0 then
                  begin
                    HideCursor;
                    Size1:=Imagesize(PA[i,j,3],PA[i,j,4],PA[i,j,5],PA[i,j,6]);
                    Getmem(p,size1);
                    GetImage(PA[i,j,3],PA[i,j,4],PA[i,j,5],PA[i,j,6],P^);
                    {SetLineStyle(0, $C3,3);}
                    setcolor(12);
                    Rectangle(PA[i,j,3],PA[i,j,4],PA[i,j,5],PA[i,j,6]);
                    SetLineStyle(0, $C3,1);
                    ShowCursor;
                    indicate:=1;
                    ii:=i;
                    jj:=j;
                  end

                Else IF (indicate=1) AND (NOT((ii=i) AND (jj=j))) then
                  begin
                    Size2:=Imagesize(PA[i,j,3],PA[i,j,4],PA[i,j,5],PA[i,j,6]);
                    HideCursor;
                    Getmem(q,size2);
                    GetImage(PA[i,j,3],PA[i,j,4],PA[i,j,5],PA[i,j,6],q^);
                    {SetLineStyle(0, $C3,3);}
                    setcolor(12);
                    Rectangle(PA[i,j,3],PA[i,j,4],PA[i,j,5],PA[i,j,6]);
                    SetLineStyle(0, $C3,1);
                    Delay(200);
                    PutImage(PA[i,j,3],PA[i,j,4],P^,NormalPut);
                    PutImage(PA[ii,jj,3],PA[ii,jj,4],Q^,NormalPut);
                    ShowCursor;
                    Swap(PA[i,j,1],PA[ii,jj,1]);
                    Swap(PA[i,j,2],PA[ii,jj,2]);
                    Freemem(p,size1);
                    Freemem(q,size2);
                    indicate:=0;
                  end;

          end;

    IF IFWon then
      begin
        For i:=1  to 14 do begin setbkcolor(i); delay(200); end;
        ExitFlag:=True;
      end;


      {Readln;}

    Until ExitFlag;

    ExitFlag:=False;

    {Readln;}

    CloseGraph;

    IF IFWon then
      begin
        clrscr;
        textcolor(14);
        gotoxy(26,5);
        Writeln(' YOU WON ');
        gotoxy(28,8);
        textcolor(10);
        Writeln('P: Play again');
        gotoxy(25,10);
        Writeln('Any other key: Exit');
        c:=Readkey;
        IF c<>'p' then ExitProFlag:=True;
        Textcolor(7);
      end;

  Until ExitProFlag=True;
  Textcolor(7);
End.