unit menus;


interface
uses
  crt, Classes, SysUtils, SDL2, SDL2_image, GestionProfil, SDL2_ttf, drawunit;
procedure mainMenu(var choix : String);
procedure profileMenu();
procedure afficherTexte(message : String);
function demandeNom(): String;
function StringToPChar(message : String) : PChar;


implementation


function inRectangle(xmax, xmin, ymax, ymin : LongInt) : Boolean;
var mouse_x, mouse_y : ^LongInt;
begin
  new(mouse_x);
  new(mouse_y);
  SDL_GetMouseState(mouse_x, mouse_y);
  inRectangle :=  (mouse_x^ > xmin) and (mouse_x^ < xmax) and (mouse_y^ > ymin) and (mouse_y^ < ymax);
  Dispose(mouse_x);
  Dispose(mouse_y);

end;

procedure mainMenu(var choix : String);
var
  sdlWindow1: PSDL_Window;
  sdlRenderer: PSDL_Renderer;
  sdlTexture1: PSDL_Texture;
  sdlEvent1: PSDL_Event;
  Running: Boolean = True;


begin

  //initilization of video subsystem
  if SDL_Init(SDL_INIT_VIDEO) < 0 then Halt;

  sdlWindow1 := SDL_CreateWindow('Menu Principal', 100, 100, 1000, 700, SDL_WINDOW_SHOWN);
  SDL_SetWindowIcon(sdlWindow1, SDL_LoadBMP('images/divers/icon.bmp'));
  sdlRenderer := SDL_CreateRenderer(sdlWindow1,-1,2);

  // load image file
  sdlTexture1 := IMG_LoadTexture(sdlRenderer, 'images/divers/mainmenu.png');
  if sdlTexture1 = nil then
    Halt;
  SDL_RenderCopy( sdlRenderer, sdlTexture1, nil, nil );


  SDL_RenderPresent(sdlRenderer);

  new(sdlEvent1);

  while Running do
  begin
      while SDL_PollEvent(sdlEvent1) = 1 do
          case sdlEvent1^.type_ of
            SDL_WINDOWEVENT:
              case sdlEvent1^.window.event of
                SDL_WINDOWEVENT_CLOSE: begin
                    Running := false;
                    choix := 'quitter';
                end;
              end;

          end;


     case sdlEvent1^.type_ of
      SDL_MOUSEBUTTONDOWN:
        case sdlEvent1^.button.clicks of
             1: begin
                  if inRectangle(820,130,370,287)  then begin // rectangle jouer
                     choix := 'jouer';
                     Running := False;
                  end
                  else if  inRectangle(820,130,478,405) then begin//rectangle profil
                     choix := 'profil';
                     Running := False;
                  end
                  else if inRectangle(820,130,670,605) then begin  // rectangle quitter
                     choix := 'quitter';
                     Running := False;
                  end;

                end;

        end;
     end;

  end;



  // clear memory
  SDL_DestroyTexture(sdlTexture1);
  SDL_DestroyRenderer(sdlRenderer);
  SDL_DestroyWindow (sdlWindow1);
  Dispose(sdlEvent1);
  //closing SDL2
  SDL_Quit;
end;


function StringToPchar(message : String) : Pchar;
begin
  StringToPchar := StrAlloc( length (message) +1) ;
    StrPCopy(StringToPchar , message);
end;

procedure profileMenu();
var
  sdlWindow1: PSDL_Window;
  sdlRenderer: PSDL_Renderer;
  sdlTexture1: PSDL_Texture;
  sdlEvent1: PSDL_Event;
  Running: Boolean = True;


begin

  //initilization of video subsystem
  if SDL_Init(SDL_INIT_VIDEO) < 0 then Halt;

  sdlWindow1 := SDL_CreateWindow('Menu Profil', 100, 100, 1000, 700, SDL_WINDOW_SHOWN);
  SDL_SetWindowIcon(sdlWindow1, SDL_LoadBMP('images/divers/icon.bmp'));
  sdlRenderer := SDL_CreateRenderer(sdlWindow1,-1,2);

  // load image file
  sdlTexture1 := IMG_LoadTexture(sdlRenderer, 'images/divers/profilemenu.png');
  if sdlTexture1 = nil then
    Halt;
  SDL_RenderCopy( sdlRenderer, sdlTexture1, nil, nil );

  // render to window for 2 seconds
  SDL_RenderPresent(sdlRenderer);

  new(sdlEvent1);

  while Running do
  begin
      while SDL_PollEvent(sdlEvent1) = 1 do
          case sdlEvent1^.type_ of
            SDL_WINDOWEVENT:
              case sdlEvent1^.window.event of
                SDL_WINDOWEVENT_CLOSE: begin
                    Running := false;

                end;
              end;

          end;


     case sdlEvent1^.type_ of
      SDL_MOUSEBUTTONDOWN:
        case sdlEvent1^.button.clicks of
             1: begin
                  if inRectangle(820,130,370,287)  then begin // rectangle creer profil
                     CreationProfil();
                     Running := False;
                  end
                  else if  inRectangle(820,130,478,405) then begin//rectangle supprimer profil
                     SupprimerProfil();
                     Running := False;
                  end
                  else if inRectangle(820,130,577,507) then begin // rectangle score
                     AffichageScore();
                     Running := False;
                  end
                  else if inRectangle(820,130,670,605) then begin  // rectangle quitter
                     Running := False;
                  end;

                end;

        end;
     end;

  end;



  // clear memory
  SDL_DestroyTexture(sdlTexture1);
  SDL_DestroyRenderer(sdlRenderer);
  SDL_DestroyWindow (sdlWindow1);
  Dispose(sdlEvent1);
  //closing SDL2
  SDL_Quit;

end;

function demandeNom() : String;
var
  sdlSurface1 : PSDL_Surface;
  ttfFont : PTTF_Font;
  sdlColor1, sdlColor2 : TSDL_Color;
  sdlWindow1 : PSDL_Window;
  sdlRenderer : PSDL_Renderer;
  sdlTexture1, sdlTexture2 : PSDL_Texture;
  rect_saisie_nom : PSDL_Rect;
  nom_joueur : String;
  event : PSDL_Event;
  running : Boolean;
  text_width, text_height : integer;

begin
  //initilization of video subsystem
  if SDL_Init(SDL_INIT_VIDEO) < 0 then HALT;

  sdlWindow1 := SDL_CreateWindow('Saisie nom', 0, 250, 1000, 700, SDL_WINDOW_SHOWN);
  if sdlWindow1 = nil then HALT;

  sdlRenderer := SDL_CreateRenderer(sdlWindow1, -1, 0);
    if sdlRenderer = nil then HALT;

  sdlTexture1 := IMG_LoadTexture(sdlRenderer, 'images/divers/saisie_nom.png');
  if sdlTexture1 = nil then
      Halt;
  //initialization of TrueType font engine and loading of a font
  if TTF_Init = -1 then HALT;
  ttfFont := TTF_OpenFont('fonts\arial.ttf', 35);
  //define colors by RGB values
  sdlColor1.r := 255; sdlColor1.g := 255; sdlColor1.b := 255;
  sdlColor2.r := 0; sdlColor2.g := 0; sdlColor2.b := 0;


  //rendering of the texture

  new(rect_saisie_nom);
  rect_saisie_nom^.x := 575;
  rect_saisie_nom^.y := 310;


  running := true;
  nom_joueur := '';
  new(event);

  while running do
  begin

    SDL_Delay(TICK_INTERVAL);

      while SDL_PollEvent(event) = 1 do
      begin
          if event^.type_ = SDL_WINDOWEVENT then
          begin
               if event^.window.event = SDL_WINDOWEVENT_CLOSE then
                  running := false;
          end;

          if (event^.type_ = SDL_KEYDOWN) and (event^.key.keysym.sym <=122) and (event^.key.keysym.sym >=97) then //si on a appuyé sur une touche et que celle-ci est une touche de a..z alors
	       nom_joueur:=nom_joueur+char(event^.key.keysym.sym);


          if (event^.key.keysym.sym=27) or (event^.key.keysym.sym=13) then

             running:=false;  {13:entrer 27: escape} //si on appuye sur entrer ou echape on quitte la boucle


	  if (event^.key.keysym.sym=8) and (event^.type_ = SDL_KEYDOWN) then //si on appuye sur supprimer on supprime le dernier charactère du nom du Joueur

                delete(nom_joueur,Length(nom_joueur),1);



      end;
  //rendering a text to a SDL_Surface
  sdlSurface1 := TTF_RenderText_Shaded(ttfFont, StringToPchar(nom_joueur) , sdlColor2, sdlColor1);

  //convert SDL_Surface to SDL_Texture
  sdlTexture2 := SDL_CreateTextureFromSurface(sdlRenderer, sdlSurface1);

  text_width := 0;
  text_height := 0;
  SDL_QueryTexture(sdlTexture2, NIL, NIL, @text_width, @text_height);
  rect_saisie_nom^.w := text_width;
  rect_saisie_nom^.h := text_height;


  SDL_SetRenderDrawColor(sdlRenderer, 255, 255, 255, 0);
  SDL_RenderClear(sdlRenderer);

  SDL_RenderCopy(sdlRenderer, sdlTexture1, nil, nil);
  SDL_RenderCopy(sdlRenderer, sdlTexture2, nil, rect_saisie_nom);
  SDL_RenderPresent(sdlRenderer);

  end;



  //cleaning procedure
  TTF_CloseFont(ttfFont);
  TTF_Quit;

  dispose(event);
  dispose(rect_saisie_nom);
  SDL_FreeSurface(sdlSurface1);
  SDL_DestroyTexture(sdlTexture1);
  SDL_DestroyTexture(sdlTexture2);
  SDL_DestroyRenderer(sdlRenderer);
  SDL_DestroyWindow(sdlWindow1);

//shutting down video subsystem
  SDL_Quit;
  demandeNom := nom_joueur;

end;

procedure afficherTexte(message : String);
var
  sdlSurface1 : PSDL_Surface;
  ttfFont : PTTF_Font;
  sdlColor1, sdlColor2 : TSDL_Color;
  sdlWindow1 : PSDL_Window;
  sdlRenderer : PSDL_Renderer;
  sdlTexture1, sdlTexture2 : PSDL_Texture;
  rect_saisie_nom : PSDL_Rect;
  event : PSDL_Event;
  running : Boolean;
  text_width, text_height : integer;

begin
  //initilization of video subsystem
  if SDL_Init(SDL_INIT_VIDEO) < 0 then HALT;

  sdlWindow1 := SDL_CreateWindow('Saisie nom', 0, 250, 1000, 700, SDL_WINDOW_SHOWN);
  if sdlWindow1 = nil then HALT;

  sdlRenderer := SDL_CreateRenderer(sdlWindow1, -1, 0);
  if sdlRenderer = nil then HALT;

  sdlTexture1 := IMG_LoadTexture(sdlRenderer, 'images/divers/blank.png');
  if sdlTexture1 = nil then
    Halt;
  SDL_RenderCopy( sdlRenderer, sdlTexture1, nil, nil );

  //initialization of TrueType font engine and loading of a font
  if TTF_Init = -1 then HALT;
  ttfFont := TTF_OpenFont('fonts\arial.ttf', 35);
  //define colors by RGB values
  sdlColor1.r := 255; sdlColor1.g := 255; sdlColor1.b := 255;
  sdlColor2.r := 0; sdlColor2.g := 0; sdlColor2.b := 0;

  //rendering a text to a SDL_Surface
  sdlSurface1 := TTF_RenderText_Shaded(ttfFont, StringToPchar(message) , sdlColor2, sdlColor1);

  //convert SDL_Surface to SDL_Texture
  sdlTexture2 := SDL_CreateTextureFromSurface(sdlRenderer, sdlSurface1);

  text_width := 0;
  text_height := 0;
  SDL_QueryTexture(sdlTexture2, NIL, NIL, @text_width, @text_height);
  new(rect_saisie_nom);
  rect_saisie_nom^.x := round((1000-text_width)/2);
  rect_saisie_nom^.y := round((700-text_height)/2);
  rect_saisie_nom^.w := text_width;
  rect_saisie_nom^.h := text_height;


  running := true;
  new(event);

  while running do
  begin

      SDL_Delay(TICK_INTERVAL);

      SDL_RenderCopy(sdlRenderer, sdlTexture2, nil, rect_saisie_nom);
      SDL_RenderPresent(sdlRenderer);

      while SDL_PollEvent(event) = 1 do
      begin
          if event^.type_ = SDL_WINDOWEVENT then
            if event^.window.event = SDL_WINDOWEVENT_CLOSE then
                begin
                    running := false;
                end;

      end;
  end;



  //cleaning procedure
  TTF_CloseFont(ttfFont);
  TTF_Quit;

  dispose(event);
  dispose(rect_saisie_nom);
  SDL_FreeSurface(sdlSurface1);
  SDL_DestroyTexture(sdlTexture1);
  SDL_DestroyTexture(sdlTexture2);
  SDL_DestroyRenderer(sdlRenderer);
  SDL_DestroyWindow(sdlWindow1);

//shutting down video subsystem
  SDL_Quit;

end;


end.



