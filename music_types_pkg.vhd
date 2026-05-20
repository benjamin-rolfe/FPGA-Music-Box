library ieee;
use ieee.std_logic_1164.all; 

--without AI, I came up with the idea to use a custom data type to represent the music
--type pitch_t is all the notes that the music box can play
--type song_t is just an array of pitch_t
--thus, songs can be written as a string of notes seperated by commmas.

--In my implementation, each note on in the music is an eight note, and the default tempo is very fast

--There are hard coded div_values, which are used in the FSM to divide the clock down to the frequency of a desired note

--Making this type into its own package is essential. Custom data types to not work between different files without it

package music_types_pkg is

   --------------------------------------------------------------------
   -- 1. Musical notes enumeration
   --------------------------------------------------------------------
   type pitch_t is (
		REST,     -- no sound
		C2, CS2, D2, DS2, E2, F2, FS2, G2, GS2,
		A2, AS2, B2,
		
      C3, CS3, D3, DS3, E3, F3, FS3, G3, GS3,
      A3, AS3, B3,
		
		C4, CS4, D4, DS4, E4, F4, FS4, G4, GS4,
      A4, AS4, B4,
		
      C5, CS5, D5, DS5, E5, F5, FS5, G5, GS5,
      A5, AS5, B5,
		
      C6, CS6, D6, DS6, E6, F6, FS6, G6, GS6,
      A6, AS6, B6
      -- Add more octaves here if needed
   );

   --------------------------------------------------------------------
   -- 2. Note divider constants for clock_divide
   --    Adjust these values to match your FPGA clock (50 MHz here)
   --------------------------------------------------------------------
   constant DIV_REST : integer := -1;
	
	-- 2nd octave (NEWLY ADDED)
	constant DIV_C2  : integer := 382_224; 
	constant DIV_CS2 : integer := 360_448; 
	constant DIV_D2  : integer := 340_136; 
	constant DIV_DS2 : integer := 321_408; 
	constant DIV_E2  : integer := 303_364; 
	constant DIV_F2  : integer := 286_344; 
	constant DIV_FS2 : integer := 270_272; 
	constant DIV_G2  : integer := 255_104; 
	constant DIV_GS2 : integer := 240_836; 
	constant DIV_A2  : integer := 227_273; 
	constant DIV_AS2 : integer := 214_480; 
	constant DIV_B2  : integer := 202_428;

	
	
    -- 3rd octave 
   constant DIV_C3   : integer := 191_112;
	constant DIV_CS3  : integer := 180_224;
	constant DIV_D3   : integer := 170_068;
	constant DIV_DS3  : integer := 160_704;
	constant DIV_E3   : integer := 151_682;
	constant DIV_F3   : integer := 143_172;
	constant DIV_FS3  : integer := 135_136;
	constant DIV_G3   : integer := 127_552;
	constant DIV_GS3  : integer := 120_418;
	constant DIV_A3   : integer := 113_636;
	constant DIV_AS3  : integer := 107_240;
	constant DIV_B3   : integer := 101_214;

	
   -- 4th octave
   constant DIV_C4   : integer := 95_556;
   constant DIV_CS4  : integer := 90_112;
   constant DIV_D4   : integer := 85_034;
   constant DIV_DS4  : integer := 80_352;
   constant DIV_E4   : integer := 75_841;
   constant DIV_F4   : integer := 71_586;
   constant DIV_FS4  : integer := 67_568;
   constant DIV_G4   : integer := 63_776;
   constant DIV_GS4  : integer := 60_209;
   constant DIV_A4   : integer := 56_818;
   constant DIV_AS4  : integer := 53_620;
   constant DIV_B4   : integer := 50_607;

	 -- 5th octave
   constant DIV_C5   : integer := 47_778;
   constant DIV_CS5  : integer := 45_056;
   constant DIV_D5   : integer := 42_517;
   constant DIV_DS5  : integer := 40_176;
   constant DIV_E5   : integer := 37_921;
   constant DIV_F5   : integer := 35_793;
   constant DIV_FS5  : integer := 33_784;
   constant DIV_G5   : integer := 31_888;
   constant DIV_GS5  : integer := 30_105;
   constant DIV_A5   : integer := 28_409;
   constant DIV_AS5  : integer := 26_810;
   constant DIV_B5   : integer := 25_303;

   -- 6th octave
   constant DIV_C6   : integer := 23_889;
   constant DIV_CS6  : integer := 22_528;
   constant DIV_D6   : integer := 21_259;
	constant DIV_DS6  : integer := 20_088;
   constant DIV_E6   : integer := 18_961;
   constant DIV_F6   : integer := 17_896;
   constant DIV_FS6  : integer := 16_892;
   constant DIV_G6   : integer := 15_944;
   constant DIV_GS6  : integer := 15_053;
   constant DIV_A6   : integer := 14_204;
   constant DIV_AS6  : integer := 13_405;
   constant DIV_B6   : integer := 12_652;

   --------------------------------------------------------------------
   -- 3. Song / scale definitions
   --------------------------------------------------------------------
   type song_t is array(natural range <>) of pitch_t;
	 
	constant REST_SONG: song_t := (REST, REST, REST, REST);
	
	constant C5_SONG: song_t := (C5, C5, C5, C5,C5, C5, C5, C5,C5, C5,
		C5, C5,C5, C5, C5, C5,C5, C5, C5, C5,C5, C5, C5, C5,C5, C5, C5, C5,
		C5, C5, C5, C5,C5, C5, C5, C5,C5, C5, C5, C5,C5, C5, C5, C5,C5, C5,
		C5, C5,C5, C5, C5, C5,C5, C5, C5, C5,C5, C5, C5, C5,C5, C5, C5, C5,C5,
		C5, C5, C5,C5, C5, C5, C5); 

		
	constant my_fur_elise : song_t := (REST, E5, DS5, E5, DS5, E5, B4, D5, C5, A4, A4, 
	REST, C4, E4, A4, B4, B4, REST, E4, GS4, B4, C5, C5, REST, E4, E5, DS5, E5, DS5, E5, 
	B4, D5, C5, A4, A4, REST, C4, E4, A4, B4, B4, REST, E4, C5, B4, A4, A4, REST, REST, 
	E5, DS5, E5, DS5, E5, B4, D5, C5, A4, A4, REST, C4, E4, A4, B4, B4, REST, E4, GS4, 
	B4, C5, C5, REST, E4, E5, DS5, E5, DS5, E5, B4, D5, C5, A4, A4, REST, C4, E4, A4, 
	B4, B4, REST, E4, C5, B4, A4, A4, REST, B4, C5, D5, E5, E5, REST, G4, F3, E3, D3, 
	D3, REST, F4, E5, D5, C5, C5, REST, E4, D5, C5, B4, B4, E4, E4, E5, E4, E5, E5, E6, 
	DS5, E5, DS5, E5, DS5, E5, B4, D5, C5, A4, A4, REST, C4, E4, A4, B4, B4, REST, E4, GS4, 
	B4, C5, C5, REST, E4, E5, DS5, E5, DS5, E5, B4, D5, C5, A4, A4, REST, C4, E4, A4, B4,
	B4, REST, E4, C5, B4, A4, REST, REST);
	

end package music_types_pkg;
