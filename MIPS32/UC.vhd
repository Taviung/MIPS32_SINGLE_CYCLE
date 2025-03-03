----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2024 03:25:16 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC is
    Port ( Instr : in STD_LOGIC_VECTOR (5 downto 0);
    
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           AluSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (2 downto 0);
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC;
           JumpR : out STD_LOGIC;
           Branchn : out STD_LOGIC
           );
end UC;

architecture Behavioral of UC is

begin
process(Instr)
begin
           RegDst<='0';
           ExtOp<='0';
           AluSrc<='0';
           Branch<='0';
           Branchn<='0';
           Jump<='0';
           ALUOp<="000";
           MemWrite<='0';
           MemtoReg<='0';
           RegWrite<='0';
           JumpR<='0';
           
           case Instr is
                when "000000"=> --add,sub,sll,srl,and,or,slt,xor
                    RegDst<='1';
                    ExtOp<='X';
                    AluSrc<='0';
                    Branch<='0';
                    Jump<='0';
                    JumpR<='0';
                    MemWrite<='0';
                    MemtoReg<='0';
                    RegWrite<='1';
                    AluOp<="111";--codR
                       
                when "000001"=> --addi
                    RegDst<='0';
                    ExtOp<='1';
                    AluSrc<='1';
                    Branch<='0';
                    Jump<='0';
                    MemWrite<='0';
                    MemtoReg<='0';
                    RegWrite<='1';
                    AluOp<="000";--add
                    JumpR<='0';
                when "000010"=> --lw
                    RegDst<='0';
                    ExtOp<='1';
                    AluSrc<='1';
                    Branch<='0';
                    Jump<='0';
                    MemWrite<='0';
                    MemtoReg<='1';
                    RegWrite<='1';
                    AluOp<="000";--add
                    JumpR<='0';
                when "000011"=> --sw
                    RegDst<='X';
                    ExtOp<='1';
                    AluSrc<='1';
                    Branch<='0';
                    Jump<='0';
                    MemWrite<='1';
                    MemtoReg<='X';
                    RegWrite<='0';
                    AluOp<="000";--add
                    JumpR<='0';
                when "000100"=> --beq
                    RegDst<='X';
                    ExtOp<='1';
                    AluSrc<='0';
                    Branch<='1';
                    Jump<='0';
                    MemWrite<='0';
                    MemtoReg<='X';
                    RegWrite<='0';
                    AluOp<="001";--sub
                    JumpR<='0';
                when "000101"=> --bne
                    RegDst<='X';
                    ExtOp<='1';
                    AluSrc<='0';
                    BRANCH<='0';
                    Branchn<='1';
                    Jump<='0';
                    MemWrite<='0';
                    MemtoReg<='X';
                    RegWrite<='0';
                    AluOp<="001";--sub
                    JumpR<='0';
                when "000110"=> --ori
                    RegDst<='0';
                    ExtOp<='0';
                    AluSrc<='0';
                    Branch<='0';
                    Jump<='0';
                    MemWrite<='0';
                    MemtoReg<='0';
                    RegWrite<='1';
                    AluOp<="101";--|
                    JumpR<='0';
                    
                when "000111"=> --jump
                    jump<='1';
                when "001000"=> --jumpR
                   jump<='1';
                   jumpR<='1';
                   
               when others =>
                RegDst <= 'X'; ExtOp <= 'X'; ALUSrc <= 'X';
                Branch <= 'X'; Jump <= 'X'; MemWrite <= 'X';
                MemtoReg <= 'X'; ALUOp <= "XXX"; RegWrite <= 'X';
           end case;
end process;

end Behavioral;
