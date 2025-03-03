----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2024 04:38:14 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEM is
    Port ( MemWrite : in STD_LOGIC;
           ALURes : in STD_LOGIC_VECTOR (31 downto 0);
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           CLK : in STD_LOGIC;
           EN : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (31 downto 0);
           ALURes_out : out STD_LOGIC_VECTOR (31 downto 0));
end MEM;

architecture Behavioral of MEM is
type MEM_type is array(0 to 63) of std_logic_vector(31 downto 0);
signal MEM : MEM_type:=(X"00000000",--0
                        X"0000000A",--10
                        X"FFFFFFFF",-- -1
                        X"00000001",--1
                        X"00000002",--2
                        X"00000003",--3
                        X"00000004",--4
                        X"00000005",--5
                        X"00000006",--6
                        X"00000007",--7
                        X"00000008",--8
                        X"00000009",--9
                        X"0000000B",--11 NU SE AJUNGE
                        OTHERS=>X"00000000");
begin

process(clk)
begin
    if rising_edge(clk) then
        if en='1' and MemWrite='1' then
            MEM(conv_integer(ALURes(7 downto 2)))<=RD2;
        end if;
    end if;
end process;

MemData<=MEM(conv_integer(ALURes(7 downto 2)));
ALURes_out<=ALURes;

end Behavioral;
