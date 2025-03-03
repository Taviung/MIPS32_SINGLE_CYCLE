----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2024 02:48:01 PM
-- Design Name: 
-- Module Name: IFetch - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IFetch is
   Port ( Jump:in std_logic;
          JumpR:in std_logic;
          Jump_Address:in std_logic_vector(31 downto 0);
          JR_Address:in std_logic_vector(31 downto 0);
          PcSrc:in std_logic; 
          Branch_Address:in std_logic_vector(31 downto 0);
          EN:in std_logic;
          rst:in std_logic;
          Instruction: out std_logic_vector(31 downto 0);
          PC4:out std_logic_vector(31 downto 0);
          clk:in std_logic);
end IFetch;

architecture Behavioral of IFetch is
signal D:std_logic_vector(31 downto 0);
signal Q:std_logic_vector(31 downto 0);
signal mux:std_logic_vector(31 downto 0);

type rom_type is array(0 to 31) of std_logic_vector(31 downto 0);
signal mem:rom_type:=( B"000001_00000_01010_0000000000000001", --00:addi &10,&0,1 40A0001 initializare registru 10 cu 1
                       B"000001_00000_01001_0000000000000100", --01:addi &9,&0,4 4090004 initializare registru 9 cu 4(va fi folosit pentru accesarea memoriei)
                       B"000001_00000_01000_0000000000000000", --02:addi &8,&0,0 4080000 initializare registru 8 cu 0 (contor bucla)
                       B"000001_00000_00010_0000000000000000", --03:addi $2,$0,0 4020000 initializare registru 2 cu 0 (contor memorie)
                       B"000001_00000_00001_0000000000000000", --04:addi $1,$0,0 4010000 initializare registru 1 cu 0 (contor rezultat)
                       B"000010_00000_00100_0000000000000100", --05:lw &4,4($0) 8040004 incarcare in recistrul 4 dimensiunea vectorului
                       
                       B"000010_00010_00011_0000000000001000", --06:lw &3,8($2) 8430008 citirea din memorie de la adresa 8+&2 si incarcare in registrul 3
                       B"000100_00100_01000_0000000000000111", --07:beq&4,&8,7 10880008  verificam daca am parcurs tot vectorul 
                       B"000000_00011_01010_00101_00000_000100", --08:and&5,&3,&10 6A2804 verificam daca valoarea din registrul 3 este para sau impara
                       B"000000_00000_00011_00110_00000_000111", --09:slt &6,&0,&3 33007 verificam daca valoare din registrul 3 este negativa sau pozitiva
                       B"000101_00110_00101_0000000000000001",--10:bne&6,&5,1 14C50001 verificam daca numarul este impar si pozitiv
                       B"000000_00001_01010_00001_00000_000000",--11:add&1,&1,&10 2A0800 adunam contorul pentru rezultat daca verificarea precedenta este pozitiva
                       B"000000_01000_01010_01000_00000_000000",--12:add&8,&8,&10 1A4000 adunam contorul buclei
                       B"000000_00010_01001_00010_00000_000000",--13:add&2,&2,&9 491000 adunam 4 la contorul pentru accesul in memorie
                       B"000111_00000000000000000000000110", --14:j 6 1C000006 sarim la instructiunea 6
                       
                       B"000000_00010_01001_00010_00000_000000",--15:add&2,&2,&10 491000 adunam 1 la registrul 2
                       B"000011_00010_00001_0000000000001000", --16:sw&1,8(&2) C410008 scriem in memorie valoarea rezultatului
                       others=> B"000011_00010_00001_0000000000001000");                 
begin

    process(clk,rst)
    begin
    if rst='1' then
        Q<=(others=>'0');
    elsif rising_edge(clk) then
        if en='1' then
            Q<=D;
        end if;
    end if;
    end process;
    
    PC4<=4+Q;
    
    with PCSrc select mux<=
        Branch_Address when '1',
        Q+4 when '0';
        
    with Jump select D<=
        Jump_Address when '1',
        mux when '0'; 
        
    Instruction<=mem(conv_integer(Q(6 downto 2)));
    
end Behavioral;
