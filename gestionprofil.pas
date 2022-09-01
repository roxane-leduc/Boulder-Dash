unit GestionProfil;


interface

uses
  SDL2, SDL_ttf, Crt, Classes, SysUtils;

procedure CreationProfil();
procedure SupprimerProfil();
procedure AffichageScore();
function ExistenceProfil(Nom : String) : Boolean;
procedure EnregistrerScore(nom : String; score : Integer);


implementation

uses menus;

const profil = 'Profil/';
  joueurs = profil +'joueurs.txt';

function ExistenceProfil(Nom : String) : Boolean;
var f : Text;
	l : String;
begin
	ExistenceProfil := False;
	assign(f,joueurs);
	reset(f);

	while not(eof(f)) do
		begin
			readln(f,l);
			if l = Nom then ExistenceProfil := True;
		end;
	close(f);
end;



procedure CreationProfil();
var f : Text;
  Nom : String;
  estPresent : Boolean;

begin

  assign(f, joueurs);
  Nom := demandeNom();
  estPresent := ExistenceProfil(Nom);

  if estPresent = False then
  begin
     append(f);
     writeln(f,Nom);
     close(f);
     assign(f,profil+Nom+'.txt');
     rewrite(f);
     close(f);
  end
  else begin
     afficherTexte('Le profil existe deja');
  end;


end;



procedure SupprimerProfil();
var f, h : Text;
    Nom, FichierJoueur, l: String;
    estPresent : Boolean;

begin
  Nom := demandeNom();
  FichierJoueur := profil+ Nom + '.txt';
  estPresent := ExistenceProfil(Nom);
  if estPresent = True then
    begin
      assign(f, FichierJoueur);
      erase(f);
      assign(f, joueurs);
      assign(h, profil + 'transi.txt');
      rewrite(h);
      reset(f);
      while not(eof(f)) do
      begin
          readln(f,l);
	  if (l <> Nom) then writeln(h,l);
      end;
      close(f);
      close(h);
      erase(f);
      rename(h, joueurs);
      afficherTexte('Suppression aboutie');
    end

  else afficherTexte('profil inexistant, pas supprimable');
end;

procedure AffichageScore();
var Nom, Score, transi : String;
    estPresent : Boolean;
    f : Text;

Begin
  Score := '';
  Nom := demandeNom();
  estPresent := ExistenceProfil(Nom);
  if estPresent = True then
  begin
    assign(f,profil+Nom+'.txt');
    reset(f);
    repeat
      readln(f,transi);
      Score := transi;
    until eof(f);
    afficherTexte(Score);
  end
  else afficherTexte('profil inexistant, pas consultable');
end;

procedure EnregistrerScore(Nom : String; score : Integer);
var f : Text;
begin
  assign(f,profil+Nom+'.txt');
  append(f);
  writeln(f,'Score : ', score);
  close(f);

end;

end.

