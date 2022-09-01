unit GestionObjet;

interface

uses
  drawunit, SysUtils;

var
  delayChute : Integer = 0;
  delayGlisse : Integer = 0;

const
  BALL_CHUTE_TIME = 150;
  BALL_GLISSE_TIME = 200;

procedure updateBalls(Xboule, Yboule: Integer; var plate: Plateau; playerAbsPosition: Point);

implementation

procedure makeBallFall(Xboule,Yboule: Integer; var plate: Plateau);

begin
  delayChute += TICK_INTERVAL;

  if (delayChute >= BALL_CHUTE_TIME) then
    begin
      plate.cases[Yboule+1, Xboule].index := 'B';
      plate.cases[Yboule+1, Xboule].fallingDistance += 1;

      plate.cases[Yboule, Xboule].index := 'R';
      plate.cases[Yboule, Xboule].fallingDistance := 0;

      delayChute := 0;
    end;
end;

procedure makeBallSlip(Xboule ,Yboule ,sens : Integer; var plate: Plateau);

begin
  delayGlisse += TICK_INTERVAL;

  if (delayGlisse >= BALL_GLISSE_TIME) then
    begin
      plate.cases[Yboule, Xboule + sens].index := 'B';
      plate.cases[Yboule, Xboule].index := 'R';

      delayGlisse := 0;
    end;
end;


procedure updateBalls(Xboule, Yboule: Integer; var plate: Plateau; playerAbsPosition: Point);

begin

  if (plate.cases[Yboule+1, Xboule].index = 'R') then // if nothing below
    if (Xboule = playerAbsPosition[0]) and (yBoule+1 = playerAbsPosition[1]) then // if player is below the ball
      begin
        if (plate.cases[Yboule, Xboule].fallingDistance <> 0) then // ball can fall only if it has minimum 1 falling distance
          makeBallFall(Xboule, Yboule, plate);
      end
    else
      makeBallFall(Xboule, Yboule, plate)
  else
    begin
      plate.cases[Yboule, Xboule].fallingDistance := 0; // reset falling distance when ball is on a ground

      if (plate.cases[Yboule+1, Xboule].index <> 'T') then // if the ball can slip
        begin
          if (plate.cases[Yboule, Xboule-1].index = 'R') and (plate.cases[Yboule+1, Xboule-1].index = 'R') then // if there is no dirt in the 2 left tile
             begin
               if not ((Xboule-1 = playerAbsPosition[0]) and (yBoule+1 = playerAbsPosition[1])) and not ((Xboule-1 = playerAbsPosition[0]) and (Yboule = playerAbsPosition[1])) then
                 makeBallSlip(Xboule, Yboule, -1, plate);
             end
          else if (plate.cases[Yboule, Xboule+1].index = 'R') and (plate.cases[Yboule+1, Xboule+1].index = 'R') then // if there is no dirt in the 2 right tile
             begin
               if not ((Xboule+1 = playerAbsPosition[0]) and (yBoule+1 = playerAbsPosition[1])) and not ((Xboule+1 = playerAbsPosition[0]) and (Yboule = playerAbsPosition[1])) then
                 makeBallSlip(Xboule, Yboule, +1, plate);
             end;
        end;

    end;
end;


end.

