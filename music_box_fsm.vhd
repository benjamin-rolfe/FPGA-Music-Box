library ieee;
use ieee.std_logic_1164.all;
use work.music_types_pkg.all;

entity music_box_fsm is
	port (
		clk, reset: in std_logic;
		song: in song_t;
		buzzer: out std_logic);
end entity music_box_fsm;


architecture music_box of music_box_fsm is

	--Instead of explicit ennumeration of every state, the FSM is extensible
	--the number of states in the machine is the number of notes in the song it is playing
	signal present_state, next_state : integer range song'range;
	
	--In the output state block, when a note is to be played, we use a switch statement
	--to obtain the value neccessary to divide the clock so the right note will play
	signal div_value: integer;
	
	--this is the initial divider used to slow down the clock, this becomes the tick
	signal tempo: integer := 3_500_500;
	
	--this is the actual signal being used to determine when the next note plays
	signal tick: std_logic;

begin
	
	--First, slow the clock down according to the tempo. One note plays every tick
	tempo_clock: entity work.clock_divide port map (clkIn=>clk, note_DIV=>tempo, clkOut=>tick);
	---------------------------------------------------
   -- State Register Block of Finite State Machine
	state_register_block: process (tick, reset)
   begin
		if reset = '1' then
			present_state <= 0;
      else
         if rising_edge(tick) then
				present_state <= next_state; 
         end if;
      end if;
   end process;
	
	--The output state simply changes the div_value for the present state
	---------------------------------------------------
   -- Output State Block of Finite State Machine
	output_state_block: process (present_state, song)
	begin
		case song(present_state) is
			when REST   => div_value <= DIV_REST;
			
			-- 2nd octave
			when C2     => div_value <= DIV_C2;
			when CS2    => div_value <= DIV_CS2;
			when D2     => div_value <= DIV_D2;
			when DS2    => div_value <= DIV_DS2;
			when E2     => div_value <= DIV_E2;
			when F2     => div_value <= DIV_F2;
			when FS2    => div_value <= DIV_FS2;
			when G2     => div_value <= DIV_G2;
			when GS2    => div_value <= DIV_GS2;
			when A2     => div_value <= DIV_A2;
			when AS2    => div_value <= DIV_AS2;
			when B2     => div_value <= DIV_B2;

			
			-- 3rd octave
			when C3     => div_value <= DIV_C3;
			when CS3    => div_value <= DIV_CS3;
			when D3     => div_value <= DIV_D3;
			when DS3    => div_value <= DIV_DS3;
			when E3     => div_value <= DIV_E3;
			when F3     => div_value <= DIV_F3;
			when FS3    => div_value <= DIV_FS3;
			when G3     => div_value <= DIV_G3;
			when GS3    => div_value <= DIV_GS3;
			when A3     => div_value <= DIV_A3;
			when AS3    => div_value <= DIV_AS3;
			when B3     => div_value <= DIV_B3;
			
			-- 4th octave
			when C4     => div_value <= DIV_C4;
			when CS4    => div_value <= DIV_CS4;
			when D4     => div_value <= DIV_D4;
			when DS4    => div_value <= DIV_DS4;
			when E4     => div_value <= DIV_E4;
			when F4     => div_value <= DIV_F4;
			when FS4    => div_value <= DIV_FS4;
			when G4     => div_value <= DIV_G4;
			when GS4    => div_value <= DIV_GS4;
			when A4     => div_value <= DIV_A4;
			when AS4    => div_value <= DIV_AS4;
			when B4     => div_value <= DIV_B4;

			-- 5th octave
			when C5     => div_value <= DIV_C5;
			when CS5    => div_value <= DIV_CS5;
			when D5     => div_value <= DIV_D5;
			when DS5    => div_value <= DIV_DS5;
			when E5     => div_value <= DIV_E5;
			when F5     => div_value <= DIV_F5;
			when FS5    => div_value <= DIV_FS5;
			when G5     => div_value <= DIV_G5;
			when GS5    => div_value <= DIV_GS5;
			when A5     => div_value <= DIV_A5;
			when AS5    => div_value <= DIV_AS5;
			when B5     => div_value <= DIV_B5;

			-- 6th octave
			when C6     => div_value <= DIV_C6;
			when CS6    => div_value <= DIV_CS6;
			when D6     => div_value <= DIV_D6;
			when DS6    => div_value <= DIV_DS6;
			when E6     => div_value <= DIV_E6;
			when F6     => div_value <= DIV_F6;
			when FS6    => div_value <= DIV_FS6;
			when G6     => div_value <= DIV_G6;
			when GS6    => div_value <= DIV_GS6;
			when A6     => div_value <= DIV_A6;
			when AS6    => div_value <= DIV_AS6;
			when B6     => div_value <= DIV_B6;
        
			when others => div_value <= DIV_REST; -- default fallback
		end case;
	end process;
	 
	---------------------------------------------------
   -- Next State Block of Finite State Machine
   next_state_block : process(present_state, song)
		begin
			if present_state = song'right then
				next_state <= song'right;   -- or song'left to loop
			else
				next_state <= present_state + 1;
			end if;
		end process;
	 
	------------------------------------------------------------------
   -- Tone generator, when the output block determines the div_value, divide the clock / div_value = frequency of note to play 
   ------------------------------------------------------------------
   tone_gen : entity work.clock_divide
		port map (
					clkIn    => clk,
					note_DIV => div_value,
					clkOut   => buzzer
      );	  
		  
end music_box;