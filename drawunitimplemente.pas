unit drawunit;

interface

uses
  SDL2, SDL2_image, SysUtils;

const
  TILE_SIZE = 32;

  CASE_DECALE_G = 7;
  CASE_DECALE_D = 5;
  CASE_DECALE_H = 3;
  CASE_DECALE_B = 3;

  PLATEAU_WIDTH_TILE_NUMBER = 40;
  PLATEAU_HEIGHT_TILE_NUMBER = 40;
  PLATEAU_WIDTH = TILE_SIZE * PLATEAU_WIDTH_TILE_NUMBER;
  PLATEAU_HEIGHT = TILE_SIZE * PLATEAU_HEIGHT_TILE_NUMBER;

  WINDOW_WIDTH_TILE_NUMBER = 30;
  WINDOW_HEIGHT_TILE_NUMBER = 20;
  WINDOW_WIDTH = TILE_SIZE * WINDOW_WIDTH_TILE_NUMBER;
  WINDOW_HEIGHT = TILE_SIZE * (WINDOW_HEIGHT_TILE_NUMBER+1); // +1 for HUD
const
  PLATEAU_VIEWPORT: TSDL_Rect = (x: 0; y: TILE_SIZE; w: WINDOW_WIDTH; h: WINDOW_HEIGHT);
  HUD_VIEWPORT: TSDL_Rect = (x: 0; y: 0; w: WINDOW_WIDTH; h: TILE_SIZE);


var
    strongMur,
    mur,
    terre,
    diamant,
    boule,
    vide: PSDL_Texture;

type
  Tile = record
      rect: TSDL_Rect;
      index: Char;
  end;

  Plateau = record
      rect: TSDL_Rect;
      texture: PSDL_Texture;
      cases: Array [1..PLATEAU_HEIGHT_TILE_NUMBER, 1..PLATEAU_WIDTH_TILE_NUMBER] of Tile;
  end;

  Point = array [0..1] of Integer;
  Fichier = Array[1..40,1..40] of char;

procedure initializePlateau(renderer: PSDL_Renderer; var plate: Plateau);

procedure decalePlateau(var plate: Plateau; playerAbsPosition, playerRelPosition: Point);

procedure drawPlateau(renderer: PSDL_Renderer; plate: Plateau);

procedure showPlateauText(p: Plateau);
procedure showGrid(renderer: PSDL_Renderer);


implementation

function chargementFichier(filename : String): Fichier;
  var p : Fichier;
      f: Text;
      i, j : Integer;
      ligne : String;
  begin
      assign(f, filename);
      reset(f);
      for i := 1 to 40 do
          begin
          readln(f, ligne);
          for j := 1 to 40 do
              begin
              p[i,j] := ligne[j];
              end;
          end;
      close(f);
      chargementFichier := p;

  end;

procedure initializeCase(renderer: PSDL_Renderer; var plate: Plateau);

var x, y : Integer;
    t: Tile;
    p : Fichier;

begin
  strongMur := IMG_LoadTexture(renderer, PChar('images/strong-wall.png'));
  mur := IMG_LoadTexture(renderer, PChar('images/wall.png'));
  terre := IMG_LoadTexture(renderer, PChar('images/dirt.png'));
  diamant := IMG_LoadTexture(renderer, PChar('images/diamond.png'));
  boule := IMG_LoadTexture(renderer, PChar('images/stone.png'));
  vide := IMG_LoadTexture(renderer, PChar('images/recolted.png'));
  p := chargementFichier('map1.txt');
  t.rect.w := TILE_SIZE;
  t.rect.h := TILE_SIZE;

   for y := 1 to PLATEAU_HEIGHT_TILE_NUMBER do
     for x := 1 to PLATEAU_WIDTH_TILE_NUMBER do
       begin
         t.index := p[y,x] ;
         t.rect.x := (x-1) * TILE_SIZE;
         t.rect.y := (y-1) * TILE_SIZE;

         plate.cases[y][x] := t;
       end;
end;

procedure initializePlateau(renderer: PSDL_Renderer; var plate: Plateau);
begin
  plate.rect.x := 0;
  plate.rect.y := 0;
  plate.rect.w := PLATEAU_WIDTH;
  plate.rect.h := PLATEAU_HEIGHT;

  initializeCase(renderer, plate);
end;


procedure decalePlateau(var plate: Plateau; playerAbsPosition, playerRelPosition: Point);

var longueur, largeur : Integer;

begin
  for largeur := 1 to PLATEAU_HEIGHT_TILE_NUMBER do
     for longueur := 1 to PLATEAU_WIDTH_TILE_NUMBER do
       begin
         if (playerAbsPosition[0] <= WINDOW_WIDTH_TILE_NUMBER) then
            if (playerRelPosition[0] = WINDOW_WIDTH_TILE_NUMBER - CASE_DECALE_D + 1) then
               plate.cases[largeur][longueur].rect.x -= (PLATEAU_WIDTH_TILE_NUMBER - WINDOW_WIDTH_TILE_NUMBER) * TILE_SIZE
         else if (playerAbsPosition[0]  > PLATEAU_WIDTH_TILE_NUMBER - WINDOW_WIDTH_TILE_NUMBER) then
            if (playerRelPosition[0] = CASE_DECALE_G) then
               plate.cases[largeur][longueur].rect.x += (PLATEAU_WIDTH_TILE_NUMBER - WINDOW_WIDTH_TILE_NUMBER) * TILE_SIZE;
         if (playerAbsPosition[1] <= WINDOW_HEIGHT_TILE_NUMBER) then
            if (playerRelPosition[1] = WINDOW_HEIGHT_TILE_NUMBER - CASE_DECALE_B + 1) then
               plate.cases[largeur][longueur].rect.y -= (PLATEAU_HEIGHT_TILE_NUMBER - WINDOW_HEIGHT_TILE_NUMBER) * TILE_SIZE
         else if (playerAbsPosition[1]  > PLATEAU_HEIGHT_TILE_NUMBER - WINDOW_HEIGHT_TILE_NUMBER) then
            if (playerRelPosition[1] = CASE_DECALE_H) then
               plate.cases[largeur][longueur].rect.y += (PLATEAU_HEIGHT_TILE_NUMBER - WINDOW_HEIGHT_TILE_NUMBER) * TILE_SIZE;
       end;
end;


procedure drawPlateau(renderer: PSDL_Renderer; plate: Plateau);

var i, j : Integer;
    t : Tile;
    texture : PSDL_Texture;

begin
  for i := 1 to PLATEAU_HEIGHT_TILE_NUMBER do
     for j := 1 to PLATEAU_WIDTH_TILE_NUMBER do
       begin
         t := plate.cases[i][j];

         case t.index of
           'S' : texture := strongMur;
           'M' : texture := mur ;
           'D' : texture := diamant;
           'T' : texture := terre;
           'B' : texture := boule;
           'R' : texture := vide
         end;

         SDL_RenderCopy(renderer, texture, nil, @t.rect);
       end;
end;

procedure showGrid(renderer: PSDL_Renderer);

var longueur, largeur : Integer;
begin
   SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);

   for longueur := 0 to WINDOW_WIDTH_TILE_NUMBER do
     SDL_RenderDrawLine(renderer, longueur * TILE_SIZE, 0, longueur * TILE_SIZE, WINDOW_HEIGHT);
   for largeur := 0 to WINDOW_HEIGHT_TILE_NUMBER do
     SDL_RenderDrawLine(renderer, 0, largeur * TILE_SIZE, WINDOW_WIDTH, largeur * TILE_SIZE);
end;

procedure showPlateauText(p: Plateau);

var longueur, largeur : Integer;

begin
  for largeur := 1 to PLATEAU_HEIGHT_TILE_NUMBER do
    begin
     for longueur := 1 to PLATEAU_WIDTH_TILE_NUMBER do
       write(p.cases[largeur, longueur].index + ' ');
     writeln('');
    end;


end;

end.

