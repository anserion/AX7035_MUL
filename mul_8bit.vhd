--Copyright 2025 Andrey S. Ionisyan (anserion@gmail.com)
--Licensed under the Apache License, Version 2.0 (the "License");
--you may not use this file except in compliance with the License.
--You may obtain a copy of the License at
--    http://www.apache.org/licenses/LICENSE-2.0
--Unless required by applicable law or agreed to in writing, software
--distributed under the License is distributed on an "AS IS" BASIS,
--WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--See the License for the specific language governing permissions and
--limitations under the License.
------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- need 48 clk
entity mul_8bit is
	port (clk: in std_logic; a_sgn,b: in std_logic_vector(7 downto 0);
   		res: out std_logic_vector(15 downto 0));
end mul_8bit;

architecture Behavioral of mul_8bit is
    component add_16bit is
    port (clk: in std_logic; a,b: in std_logic_vector(15 downto 0);
          res: out std_logic_vector(15 downto 0));
    end component;

    signal res_reg: std_logic_vector(15 downto 0);
    signal a0,a1,a2,a3,a4,a5,a6,a7: std_logic_vector(15 downto 0);
    signal s01,s23,s45,s67,s0123,s4567:std_logic_vector(15 downto 0);
begin
	a0(15 downto 8)<=(others=>a_sgn(7)) when b(0)='1' else (others=>'0'); 
   a0(7 downto 0)<=a_sgn when b(0)='1' else (others=>'0');
	a1(15 downto 9)<=(others=>a_sgn(7)) when b(1)='1' else (others=>'0'); 
   a1(8 downto 1)<=a_sgn when b(1)='1' else (others=>'0'); a1(0)<='0';
	a2(15 downto 10)<=(others=>a_sgn(7)) when b(2)='1' else (others=>'0'); 
   a2(9 downto 2)<=a_sgn when b(2)='1' else (others=>'0'); a2(1 downto 0)<=(others=>'0');
	a3(15 downto 11)<=(others=>a_sgn(7)) when b(3)='1' else (others=>'0'); 
   a3(10 downto 3)<=a_sgn when b(3)='1' else (others=>'0'); a3(2 downto 0)<=(others=>'0');
	a4(15 downto 12)<=(others=>a_sgn(7)) when b(4)='1' else (others=>'0'); 
   a4(11 downto 4)<=a_sgn when b(4)='1' else (others=>'0'); a4(3 downto 0)<=(others=>'0');
	a5(15 downto 13)<=(others=>a_sgn(7)) when b(5)='1' else (others=>'0'); 
   a5(12 downto 5)<=a_sgn when b(5)='1' else (others=>'0'); a5(4 downto 0)<=(others=>'0');
	a6(15 downto 14)<=(others=>a_sgn(7)) when b(6)='1' else (others=>'0'); 
   a6(13 downto 6)<=a_sgn when b(6)='1' else (others=>'0'); a6(5 downto 0)<=(others=>'0');
	a7(15)<=a_sgn(7) when b(7)='1' else '0'; 
   a7(14 downto 7)<=a_sgn when b(7)='1' else (others=>'0'); a7(6 downto 0)<=(others=>'0');

	s01_chip: add_16bit port map(clk,a0,a1,s01);
	s23_chip: add_16bit port map(clk,a2,a3,s23);
	s45_chip: add_16bit port map(clk,a4,a5,s45);
	s67_chip: add_16bit port map(clk,a6,a7,s67);
	
	s0123_chip: add_16bit port map(clk,s01,s23,s0123);
	s4567_chip: add_16bit port map(clk,s45,s67,s4567);
	
	res_chip: add_16bit port map(clk,s0123,s4567,res_reg);
	
	process (clk)
	begin
		if rising_edge(clk) then
            res<=res_reg;
		end if;
	end process;
end Behavioral;
