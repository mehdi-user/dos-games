Program Tetris_Number; { ver 2.5 }{      Mehdi       }
Uses
  crt;
Const
  An=80;
  Am=25;
  Dly=100;
Var
  m,n,Rnd:integer;
Procedure Swap(var a,b:integer);
  begin
    a:=a+b;
    b:=a-b;
    a:=a-b;
  end;
Var
  A:Array[1..An] of integer;
Procedure RandA;
  var
    i:integer;
  begin
    Randomize;
    For i:= 1 to n do
      A[i]:=Random(Rnd)+1;
  end;
Var
  A2:Array[1..An] of integer;
Procedure RandA2;
  var
    i:integer;
  begin
    {Randomize;}
    For i:= 1 to n do
      A2[i]:=Random(Rnd)+1;
  end;
Var
  B:Array[1..Am,1..An] of integer;
  i:integer;
  Score:integer;
  mode:byte;
Procedure Show(No:byte);
  procedure Col(cl:byte);
    begin TextColor(cl); Write(chr(219)); TextColor(7); end;
  var
    j,k:integer;
  begin
    ClrScr;textcolor(15);
    Writeln('Numbered Tetris (ver 2.5)');textcolor(7);
    IF mode=3 then
    begin
    For j:=1 to 2*n do
      Write('-');
    Writeln;
    For j:=1 to n do
      col(A2[j]);
    Writeln;
    For j:=1 to 2*n do
      Write('-');
    Writeln;
    For j:=1 to m-i-1 do
      Writeln;
    IF No=1 then For j:=1 to n do
      col(A[j]);
    Writeln;
    For j:=i downto 1 do
      begin
        For k:=1 to n do
          IF B[j,k]<>0 then col(B[j,k])
          Else Write(' ');
        Writeln;
      end;
    For j:=1 to 2*n do
      Write('-');
    end;
    IF (mode=1) OR (mode=2) then
    begin
    For j:=1 to 2*n do
      Write('-');
    Writeln;
    For j:=1 to n do
      begin textcolor(A2[j]+6); Write(A2[j],' '); textcolor(7); end;
    Writeln;
    For j:=1 to 2*n do
      Write('-');
    Writeln;
    For j:=1 to m-i-1 do
      Writeln;
    IF No=1 then For j:=1 to n do
      begin textcolor(A[j]+6); Write(A[j],' '); textcolor(7); end;
    Writeln;
    For j:=i downto 1 do
      begin
        For k:=1 to n do
          IF B[j,k]<>0 then begin textcolor(B[j,k]+6); Write(B[j,k],' '); textcolor(7); end
          Else Write('  ');
        Writeln;
      end;
    For j:=1 to 2*n do
      Write('-');
    end;
    Writeln;textcolor(15);
    Writeln('* Play: Right, Left and Down Arrow keys **********************');
    Writeln('* Exit: Alt+X or F6                     *  Your Score: ',Score,' *');
    Writeln('* Play Again: F10                       **********************');textcolor(7);
    IF No=2 then Write('>>>>Processing<<<<');
  end;
Procedure NoZero;
  var
    j,k,l,t:integer;
  begin
    For k:=1 to n do
      For j:=1 to m-1 do
        For t:=1 to m do
          IF (B[j,k]=0) then
            begin
              For l:= j to m-1 do
              Swap(B[l,k],B[l+1,k]);
            end;
  end;
Var
  max:integer;
Procedure Wmax;
  var
    Flag:boolean;
    j,k:integer;
  begin
  Flag:=False;
  For j:=m downto 1 do
    begin
      For k:=1 to n do
        IF B[j,k]<>0 then Flag:=True;
        IF Flag then
          begin
            max:=j;
            break;
          end;
    end;
  end;
Procedure Eva;
  begin
    NoZero;
    Wmax;
  end;
Var
  j,k,l,x,y:integer;
  c:char;
  Flag:boolean;
Procedure Proc;
  procedure Inside;
    begin
      B[j,k]:=0;
      B[x+j,y+k]:=0;
      Eva;
      inc(Score,5);
      Show(2);
      Delay(Dly);
    end;
  begin
    For j:=1 to m do
          For k:=1 to n do
            IF B[j,k]<>0 then
              For x:=-1 to 1 do
                For y:=-1 to 1 do
                  IF (x+j<=m) and (x+j>=1) and (y+k<=n) and (y+k>=1) and (not((x+j=j) and (y+k=k))) then
                    IF (mode=1) OR (mode=3) then begin IF B[x+j,y+k]=B[j,k] then
                      begin
                      Inside;
                      end
                    end
                    ELSE IF mode=2 then
                      IF (B[x+j,y+k]+(-1)*B[j,k]=0) OR
                         (B[x+j,y+k]+(-1)*B[j,k]=-1) OR
                         (B[x+j,y+k]+(-1)*B[j,k]=1) then
                         begin
                        Inside;
                      end;

  end;
Const
  mnuPMax=4;
Var
  mnuS:Array [1..mnuPMax] of string;
  mnuMax:byte;
  mnuSelCol:byte;
  mnuPointer:string;
  mnuDefaultCol:byte;
  mnuCur:byte;
  mTit:string;
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
     mnuMax:=4;
     mnuPointer:='->'; {pointing character}

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

Procedure Exit;
  begin
    ClrScr;
    Writeln;
    Writeln('Thank you for playing the game Numbered Tetris.');
    Writeln('I hope you enjoyed it.');
    Writeln('        Mehdi         ');
    Writeln;
  end;
Label 1,3;
{I have used Lables for game over}
Var
  level,lev2:byte;
Procedure Welcome;
  var
    beep:byte;
    lv:byte;
    ch:char;
  begin
    ClrScr;
    {For beep:=1 to 3 do Write(chr(7));}
    Textcolor(2);
    Write('              ');
    For lv:= 1 to 82-39+1 do write(chr(220));
    Writeln;
    Write('              ',chr(219));
    Textcolor(14);Write('  Welcome to Numbered Tetris Game Ver 2.5 ');Textcolor(2);Writeln(chr(219));
    Write('              ',chr(219));
    Textcolor(14);Write('                    by                    ');Textcolor(2);Writeln(chr(219));
    Write('              ',chr(219));
    Textcolor(14);Write('                  Mehdi                   ');Textcolor(2);Writeln(chr(219));
    Write('              ');
    Textcolor(2);
    For lv:= 1 to 82-39+1 do write(chr(223));
    Writeln;
    Textcolor(7);
    mTit:='             Choose game mode:';
    mnuS[1]:='Only equal numbers';
    mnuS[2]:='Equal numbers, one less and one more';
    mnuS[3]:='Color box mode';
    mnuS[4]:='Exit';
    mnuMax:=4;
    mnuPointer:='>>>'; {pointing character}
    mnuSelCol:=10; {Bright Yellow}
    mnuDefaultCol:=15; {Bright White}
    mnuCur:=1;

    {Writeln('Choose game mode:');
    Writeln('1: Only equal numbers');
    Writeln('2: Equal numbers, one less and one more');
    Writeln('3: Color box mode');
    mode:=0;
    While (mode<1) OR (mode>3) do begin Write('1, 2 or 3 ?');Readln(mode); end;}
    MenuS;
    Textcolor(15);
    mode:=menu;
    IF mode=4 then begin Exit; HALT; end;
    Writeln;
    Write('             Choose game speed using <- and -> :');
    level:=8;
    {While (level<1) OR (level>8) do begin Write('Between 1 and 8 ?');Readln(level); end;}
    While not (ch=chr(13)) do
      begin
        Gotoxy(50,13);Write(level);
        IF Keypressed then
          begin
            ch:=readkey;
            IF ch=chr(0) then
             begin
              ch:=readkey;
              if ord(ch)=77 {Right} then
               begin
                    if level<8 then inc(level);  {select next item in menu}
                    (*if level>8 then {check if it exceeds the last number}
                       level:=1;*)
               end;
               if ord(ch)=75 {Left} then
               begin
                    if level>1 then dec(level);  {check if it exceed the first}
                    {if level<1 then
                       level:=8;}
               end;
             end;
          end;
        end;
    Writeln;
    Writeln;
    Writeln;
    Writeln;textcolor(9);
    Writeln('             ** How to play:**************************');textcolor(15);
    Writeln('             * Play: Right, Left and Down Arrow keys *');
    Writeln('             * Exit: Alt+X or F6                     *');textcolor(9);
    Writeln('             *****************************************');
    textcolor(7);Writeln;
    Write('             Press ENTER to start');
    textcolor(7);
    Readln;
    lev2:=9-level
  end;
Var
  GO:byte;
Begin
  Repeat
  m:=12;
  n:=7;
  Rnd:=9;
  TextColor(7);
  TextBackground(0);
  Welcome;
  IF mode=3 then begin m:=15; n:=20; Rnd:=15; end;
  1:
  RandA;
  max:=0;
  While max<m do
    begin
      RandA2;
      i:=m;
      While i>max+1 do
        begin
         dec(i);
         For l:=1 to 8 do
           begin
             Delay(lev2*25);
             Write('...');
             While Keypressed do
               begin
                 c:=readkey;
                 if c=chr(0) then
                   begin
                     c:=readkey;
                     If c=chr(80) then {writeln('Down!');} begin l:=8; i:=max+1; end;
                     IF c='@' then begin exit; HALT; end;
                     IF c=chr(45) then begin Exit; HALT; end;
                     IF c=chr(68) then goto 3;
                     If c=chr(72) then writeln(chr(7){'Up!'});
                     If c=chr(75) then {writeln('Left!');}
                       For j:=n downto 2 do
                         Swap(A[n],A[j-1]);
                     If c=chr(77) then {writeln('Right!');}
                       For j:=1 to n-1 do
                         Swap(A[1],A[j+1]);
                   end;
                 Show(1);
               end;
           end;
        Show(1);
        end;
        For j:=1 to n do
          B[i,j]:=A[j];
        Show(2);
        Delay(3*Dly);
        Eva;
        Proc;
        Proc;
        For j:=1 to 16 do
          IF Keypressed then
          begin c:=readkey;
            IF c=chr(0) then
              begin
               c:=readkey;
               IF c='@' then begin exit; HALT; end;
               IF c=chr(45) then begin Exit; HALT; end;
               IF c=chr(68) then goto 3;
              end;
          end;
    For j:=1 to n do
      A[j]:=A2[j];
    end;
  3:
  For j:=1 to m do
    For k:=1 to n do
      B[j,k]:=0;
  ClrScr;
  Writeln;Writeln;Writeln;
  textcolor(12);Writeln('                 ',chr(4),chr(4),chr(4),' GAME OVER!!! ',chr(4),chr(4),chr(4));textcolor(7);
  Writeln;
  {Writeln('Do you want to play again?');
  Writeln('1: Same game');
  Writeln('2: Differnt level');
  Writeln('3: Exit');
  GO:=0;
  While (GO<1) OR (GO>3) do begin Write('1, 2 or 3 ?');Readln(GO); end;}
  Writeln;
    Textcolor(7);
    mTit:='             Do you want to play again?';
    mnuS[1]:='Same game';
    mnuS[2]:='Differnt level';
    mnuS[3]:='Exit';
    mnuMax:=3;
    mnuPointer:='>>>'; {pointing character}
    mnuSelCol:=10; {Bright Yellow}
    mnuDefaultCol:=15; {Bright White}
    mnuCur:=1;
    MenuS;
    Textcolor(7);
    GO:=menu;
  IF GO=1 then goto 1;
  until GO=3;
  Exit;
End.