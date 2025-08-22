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

-- need 16 clk
entity add_16bit is
	port (clk: in std_logic;
		  a,b: in std_logic_vector(15 downto 0);
		  res: out std_logic_vector(15 downto 0)
         );
end add_16bit;

architecture Behavioral of add_16bit is
    component full_adder is
    port (a,b,c_in: in std_logic;
          s,c_out : out std_logic);
    end component;
signal res_reg: std_logic_vector(15 downto 0);
signal p:std_logic_vector(15 downto 0);
begin
	FA0: full_adder port map(a(0),b(0),'0',res_reg(0),p(0));
	FA1: full_adder port map(a(1),b(1),p(0),res_reg(1),p(1));
	FA2: full_adder port map(a(2),b(2),p(1),res_reg(2),p(2));
	FA3: full_adder port map(a(3),b(3),p(2),res_reg(3),p(3));
	FA4: full_adder port map(a(4),b(4),p(3),res_reg(4),p(4));
	FA5: full_adder port map(a(5),b(5),p(4),res_reg(5),p(5));
	FA6: full_adder port map(a(6),b(6),p(5),res_reg(6),p(6));
	FA7: full_adder port map(a(7),b(7),p(6),res_reg(7),p(7));
	FA8: full_adder port map(a(8),b(8),p(7),res_reg(8),p(8));
	FA9: full_adder port map(a(9),b(9),p(8),res_reg(9),p(9));
	FA10: full_adder port map(a(10),b(10),p(9),res_reg(10),p(10));
	FA11: full_adder port map(a(11),b(11),p(10),res_reg(11),p(11));
	FA12: full_adder port map(a(12),b(12),p(11),res_reg(12),p(12));
	FA13: full_adder port map(a(13),b(13),p(12),res_reg(13),p(13));
	FA14: full_adder port map(a(14),b(14),p(13),res_reg(14),p(14));
	FA15: full_adder port map(a(15),b(15),p(14),res_reg(15),p(15));
	
	process (clk)
	begin
		if rising_edge(clk) then
            res<=res_reg;
		end if;
	end process;
end Behavioral;
