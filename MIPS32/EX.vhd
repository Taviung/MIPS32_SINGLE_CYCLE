----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2024 04:41:26 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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
use IEEE.STD_LOGIC_arith.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity EX is
Port ( RD1 : in STD_LOGIC_VECTOR (31 downto 0);
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           Ext_imm : in STD_LOGIC_VECTOR (31 downto 0);
           ALUSrc : in STD_LOGIC;
           sa : in STD_LOGIC_VECTOR (4 downto 0);
           func : in STD_LOGIC_VECTOR (5 downto 0);
           ALUOp : in STD_LOGIC_VECTOR (2 downto 0);
           PC : in STD_LOGIC_VECTOR (31 downto 0);
           ALURes : out STD_LOGIC_VECTOR (31 downto 0);
           Branch_Address : out STD_LOGIC_VECTOR (31 downto 0);
           Zero : out STD_LOGIC);
end EX;

architecture Behavioral of EX is
signal C: std_logic_vector(31 downto 0);
signal B: std_logic_vector(31 downto 0);
signal A: std_logic_vector(31 downto 0);
signal ALUCtrl: std_logic_vector(2 downto 0);

begin

with ALUSrc select B<=
    RD2 when '0',
    Ext_Imm when '1';

ALUControl:process(AluOp,func)
begin 
    case AluOp is
        when "111" =>
            case func is 
                when "000000"=>ALUCtrl<="000";--add
                when "000001"=>ALUCtrl<="001";--sub
                when "000010"=>ALUCtrl<="010";--<<
                when "000011"=>ALUCtrl<="011";-->>
                when "000100"=>ALUCtrl<="100";--&
                when "000101"=>ALUCtrl<="101";--|
                when "000110"=>ALUCtrl<="110";--^
                WHEN "000111"=>ALUCtrl<="111";--cmp
                when others=>ALUCtrl<=(others=>'X');
            end case;
        when "000"=>ALUCtrl<="000";--add
        when "001"=>ALUCtrl<="001";--sub
        when "010"=>ALUCtrl<="101";--|
        when others=>ALUCtrl<=(others=>'X');
    end case;
end process;

Branch_Address<=(Ext_imm(29 downto 0) & "00")+PC;
A<=RD1;

ALU:process(B,A,ALUCtrl,SA)
begin  
    case ALUCtrl is
        when "000"=>C<=A+B;
        when "001"=>C<=A-B;
        when "010"=>C<=to_stdlogicvector(to_bitvector(B) sll conv_integer(sa));
        when "011"=>C<=to_stdlogicvector(to_bitvector(B) srl conv_integer(sa));
        when "100"=>C<=A AND B;
        when "101"=>C<=A OR B;
        when "110"=>C<=A XOR B;
        when "111"=> if signed(A)<signed(B) then C<=X"00000001";
                                            else C<=X"00000000";
                                            end if;
        when others=>ALURes<=(others=>'X');
    end case;
    
end process;
    ALURes<=C;
    
    with C select ZERO<=
        '1' when X"00000000",
        '0' when OTHERS;
       
end Behavioral;
