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
entity full_adder is
    port (a,b,c_in: in std_logic;
          s,c_out : out std_logic);
end full_adder;

architecture Behavioral of full_adder is
signal s1,c1,c2: std_logic;
begin
    s1<=a xor b; c1<=a and b;        --half_adder(a,b,s1,c1);
    s<=s1 xor c_in; c2<=s1 and c_in; --half_adder(s1,c_in,s,c2);
    c_out<=c1 or c2;
end Behavioral;
