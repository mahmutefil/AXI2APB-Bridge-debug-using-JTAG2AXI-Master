library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reset_gen is
    Port ( clk : in STD_LOGIC;
           res_out : out STD_LOGIC:= '1');
end reset_gen;

architecture RTL of reset_gen is

begin
process(clk)
variable   counter         : integer range 0 to 255;
variable bool : boolean := true;
begin
if(rising_edge(clk)) then
      res_out <= '1';    
      if bool then
            res_out <= '1';  
            counter := counter + 1;
                if(counter = 100) then
                    bool := false;
                end if;
      else
            res_out <= '0';
      end if;
  end if;
end process;

end RTL;