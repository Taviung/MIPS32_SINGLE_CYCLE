----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2024 03:29:31 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port ( sw:in std_logic_vector(15 downto 0);
            btn:in std_logic_vector(5 downto 0);
            cat:out std_logic_vector(6 downto 0);
            clk:in std_logic;
            an:out std_logic_vector(7 downto 0);
            led:out std_logic_vector(15 downto 0));
end test_env;

architecture Behavioral of test_env is

signal Branch_Address: std_logic_vector(31 downto 0);

signal Jump:std_logic;
signal JumpR:std_logic;
signal PCSrc:std_logic;
signal EN:std_logic;
signal RST:std_logic;
signal ExtOp:std_logic;
signal RegDst:std_logic;
signal RegWrite:std_logic;
signal ALUSrc:std_logic;
signal ALUOp:std_logic_vector(2 downto 0);
signal ZERO:std_logic;
signal MemWrite:std_logic;
signal Memtoreg:std_logic;
signal branch:std_logic;
signal branchN:std_logic;

signal JumpAddress:std_logic_vector(31 downto 0);
signal JRAddress:std_logic_vector(31 downto 0);
signal Instruction:std_logic_vector(31 downto 0);
signal RD1:std_logic_vector(31 downto 0);
signal RD2:std_logic_vector(31 downto 0);
signal ExtImm:std_logic_vector(31 downto 0);
signal WD:std_logic_vector(31 downto 0);
signal PC4:std_logic_vector(31 downto 0);
signal ALURes:std_logic_vector(31 downto 0);
signal MemData:std_logic_vector(31 downto 0);
signal AluResOut:std_logic_vector(31 downto 0);
signal MUX:std_logic_vector(31 downto 0);
signal func:std_logic_vector(5 downto 0);
signal sa:std_logic_vector(4 downto 0);

component ID is
    Port(
    
    RD1:out std_logic_vector(31 downto 0);
    RD2:out std_logic_vector(31 downto 0);
    Ext_Imm:out std_logic_vector(31 downto 0);
    func:out std_logic_vector(5 downto 0);
    sa:out std_logic_vector(4 downto 0);
    
    WD:in std_logic_vector(31 downto 0);
    Instr:in std_logic_vector(25 downto 0);
    clk:in std_logic;
    en: in std_logic;
    regWrite: in std_logic;
    regDst: in std_logic;
    ExtOp: in std_logic);
end component;

component EX is
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
end component;

component MEM is
    Port ( MemWrite : in STD_LOGIC;
           ALURes : in STD_LOGIC_VECTOR (31 downto 0);
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           CLK : in STD_LOGIC;
           EN : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (31 downto 0);
           ALURes_out : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component UC is
    Port ( Instr : in STD_LOGIC_VECTOR (5 downto 0);
    
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           AluSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR(2 downto 0);
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC;
           JumpR : out STD_LOGIC;
           Branchn: out STD_LOGIC);
end component;

component MPG is
    Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

component SSD
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(7 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0));
end component;

component IFetch is
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
end component;

begin
   MPGC:MPG port map(EN,btn(0),clk);
   rst<=btn(1);
   Fetch:IFetch port map(Jump,JumpR,JumpAddress,JRAddress,PCSrc,Branch_Address,EN,rst,Instruction,PC4,clk);
   IDC:ID port map(RD1,RD2,ExtImm,func,sa,WD,Instruction(25 downto 0),clk,
   EN,regWrite,regDst,ExtOp);
   EXC:EX port map(RD1,RD2,ExtImm,ALUSrc,sa,func,ALUOp,PC4,ALURes,Branch_Address,Zero);
   MEMC:MEM port map(MemWrite,AluRes,rd2,clk,en,memdata,AluResOut);
   
   with memtoreg select WD<=
        ALUresOut when '0',
        MemData when '1';

   JumpAddress<=PC4(31 downto 28)&Instruction(25 downto 0)&"00";
   
   UCC:UC port map(Instruction(31 downto 26),REGDST,EXTOP,ALUSRC,BRANCH,JUMP,ALUOP,
   MEMWRITE,MEMTOREG,REGWRITE,JUMPR,BRANCHN);
   
   PCSRC<=(zero and branch) or (branchn and not zero);
   
   led(0)<=regWrite;
   led(1)<=memtoreg;
   led(2)<=memwrite;
   led(10 downto 8)<=AluOp;
   led(3)<=Jump;
   led(4)<=branch;
   led(5)<=ALUSrc;
   led(6)<=extop;
   led(7)<=regdst;
   
   with sw(7 downto 5) select mux<=
        Instruction when "000",
        PC4 when "001",
        RD1 WHEN "010",
        RD2 WHEN "011",
        EXTIMM WHEN "100",
        ALURes when "101",
        MemData when"110",
        WD WHEN "111";
    SSDC: SSD port map(clk,mux,an,cat);
    
end Behavioral;
