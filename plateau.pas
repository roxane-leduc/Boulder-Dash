unit plateau;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SDL2, SDL2_image, math;

const
  TILE_SIZE = 48;

  PLATEAU_TILE_NUMBER = 40;
  PLATEAU_WIDTH = TILE_SIZE * PLATEAU_TILE_NUMBER;
  PLATEAU_HEIGHT = TILE_SIZE * PLATEAU_TILE_NUMBER;

  WINDOW_TILE_NUMBER = 30;
  WINDOW_WIDTH = TILE_SIZE * WINDOW_TILE_NUMBER;
  WINDOW_HEIGHT = TILE_SIZE * WINDOW_TILE_NUMBER;

type
  Tile = record
      rect: TSDL_Rect;
      texture: PSDL_Texture;
  end;

  Plate = record
      rect: TSDL_Rect;
      texture: PSDL_Texture;
      cases: Array [1..PLATEAU_TILE_NUMBER, 1..PLATEAU_TILE_NUMBER] of Tile;
  end;

procedure initializePlateau(p: Plateau);
procedure showGrid(renderer: PSDL_Renderer);

implementation

procedure initializePlateau(p: Plateau);
begin
  p.rect.x := 0;
  p.rect.y := 0;
  p.rect.w := PLATEAU_WIDTH;
  p.rect.h := PLATEAU_HEIGHT;
end;

procedure showGrid(renderer: PSDL_Renderer);

var longueur, largeur : Integer;
begin
   SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);

   for longueur := 0 to WINDOW_TILE_NUMBER do
     SDL_RenderDrawLine(renderer, longueur * TILE_SIZE, 0, longueur * TILE_SIZE, WINDOW_HEIGHT);
   for largeur := 0 to WINDOW_TILE_NUMBER do
     SDL_RenderDrawLine(renderer, 0, largeur * TILE_SIZE, WINDOW_WIDTH, largeur * TILE_SIZE);

   SDL_RenderPresent(renderer);
end;

end.

