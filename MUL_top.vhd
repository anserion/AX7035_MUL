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
use IEEE.STD_LOGIC_1164.ALL, IEEE.STD_LOGIC_ARITH.ALL, ieee.std_logic_unsigned.all;

entity MUL_top is
  Port(SYS_CLK,KEY1,KEY2,KEY3,KEY4,RESET: in STD_LOGIC;
       SMG_DATA: out STD_LOGIC_VECTOR (7 downto 0);
       SCAN_SIG: out STD_LOGIC_VECTOR (5 downto 0));
end MUL_top;

architecture RTL of MUL_top is
component CLK_GEN
   Port (CLK_IN,EN,RESET: in STD_LOGIC;
         LOW_NUM, HIGH_NUM: natural;
         CLK_OUT : out  STD_LOGIC);
end component;
component keys_supervisor is
   Port (clk,en: in std_logic; debounce: in natural range 0 to 1023;
         key1,key2,key3,key4,reset: in std_logic;
         op1,op2:out std_logic_vector(7 downto 0));
end component;
component bin24_to_bcd
  Port (clk: in STD_LOGIC; bin: in std_logic_vector(23 downto 0);
        bcd: out std_logic_vector(31 downto 0));
end component;
component SMG_driver
  Port (clk,en: in std_logic; 
        bcd_num: in STD_LOGIC_VECTOR(23 downto 0); 
        mask_dp: in STD_LOGIC_VECTOR(5 downto 0);
        SEG: out STD_LOGIC_VECTOR(7 downto 0); 
        DIG: out STD_LOGIC_VECTOR(5 downto 0));
end component;
component mul_8bit
  Port (clk: in std_logic; a_sgn,b: in std_logic_vector(7 downto 0);
		  res: out std_logic_vector(15 downto 0));
end component;

signal CLK,CLK_SMG: std_logic;
signal op1,op2: std_logic_vector(7 downto 0);
signal product: std_logic_vector(15 downto 0);
signal BCD_op1,BCD_op2,BCD_product: std_logic_vector(31 downto 0);

begin
  MUL_8bit_chip: mul_8bit port map(CLK,op1,op2,product);
  CLK_GEN_1MHz_chip: CLK_GEN port map(SYS_CLK,'1','0',25,25,CLK);
  CLK_GEN_10kHz_chip: CLK_GEN port map(SYS_CLK,'1','0',2500,2500,CLK_SMG);
  KEYS_supervisor_chip: keys_supervisor port map(CLK,'1',1000,KEY1,KEY2,KEY3,KEY4,RESET,op1,op2);
  bin24_to_bcd_op1_chip: bin24_to_bcd port map(CLK,conv_std_logic_vector(0,16)&op1,BCD_op1);
  bin24_to_bcd_op2_chip: bin24_to_bcd port map(CLK,conv_std_logic_vector(0,16)&op2,BCD_op2);
  bin24_to_bcd_product_chip: bin24_to_bcd port map(CLK,conv_std_logic_vector(0,8)&product,BCD_product);
  SMG_driver_chip: SMG_driver port map(CLK_SMG,'1',
                                       BCD_op1(7 downto 0)&BCD_op2(7 downto 0)&BCD_product(7 downto 0),
                                       "101011", SMG_DATA,SCAN_SIG);
end RTL;
