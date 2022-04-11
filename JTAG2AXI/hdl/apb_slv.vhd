library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity apb_slv is
 Generic(
 addrWidth : integer := 32;
 dataWidth : integer := 32
 );
 Port (   clk     : in STD_LOGIC;
          rst   : in STD_LOGIC;
          paddr   : in STD_LOGIC_VECTOR (addrWidth-1 downto 0);
          pwrite  : in STD_LOGIC;
          psel    : in STD_LOGIC;
          penable : in STD_LOGIC;
          pwdata  : in STD_LOGIC_VECTOR (dataWidth-1 downto 0);
          prdata  : out STD_LOGIC_VECTOR (dataWidth-1 downto 0) := (others => '0');
		  pready  : out STD_LOGIC;
		  pslverr  : out STD_LOGIC
		);
end apb_slv;

architecture RTL of apb_slv is

 type mem_arr is array (0 to 255) of std_logic_vector(31 downto 0);
 signal mem : mem_arr := (others => (others => '0'));

 type state_type is (idle_state, setup_state, access_state);
 signal state   : state_type := idle_state;
  
begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			if rst = '1' then
				prdata <= x"00000000";
				pready <= '0';
				pslverr <= '0';
				mem <= (others => (others => '0'));
				state  <= idle_state;
			else
				case state is 
					when idle_state=>
					    if (psel = '0') then
					        state <= idle_state;
						else
							state <= setup_state;
						end if;
					pready <= '0';
					
					when setup_state=>
                       if (penable = '1') then 
                           state <= access_state;
					   else
						   state <= idle_state;
                       end if;
					   pready <= '0';

					when access_state=>				
						if    ( psel = '1' and penable = '1' and pwrite = '1') then 
								mem(to_integer(unsigned(paddr))) <= pwdata;
								pready <= '1';
								state <= setup_state;
									
						elsif ( psel = '1' and penable = '1' and pwrite = '0') then
								prdata <= mem(to_integer(unsigned(paddr)));
						        pready <= '1'; 
								state <= setup_state;
						else
								state <= idle_state;
						
						end if;	
												
					when others=> 
						state <= idle_state; 
						
				end case;
			end if;
		end if;
	end process;
end RTL;