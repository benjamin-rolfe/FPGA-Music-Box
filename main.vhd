library ieee;
use ieee.std_logic_1164.all;
use work.music_types_pkg.all;

entity main is

   port(
		clk    : in  std_logic;
		key4_l : in  std_logic;
		buzzer : out std_logic
	);
	
end entity main;


architecture main of main is
	
	signal key4: std_logic;
	
begin
	
	--Reset Key
	key4 <= not key4_l;

	--Create an instance of the Music_Box_FSM
	--inputs: clock, song, reset
	--(song is a custom data type that I made, explained later)
	--outputs: buzzer
	--(this is a modulation of the clock so that the buzzer plays frequencies of notes)
	music_box: entity work.music_box_fsm port map (clk=> clk, song => my_fur_elise, reset => key4, buzzer => buzzer);
	
end main;