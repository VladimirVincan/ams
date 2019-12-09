library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_path is
   port (clk                : in  std_logic;
         reset              : in  std_logic;
         -- ********* Interfejs za prihvat instrukcije iz datapath-a*********
         instruction_i      : in  std_logic_vector (31 downto 0);
         -- ********* Kontrolni intefejs *************************************
         mem_to_reg_o       : out std_logic;
         alu_op_o           : out std_logic_vector(4 downto 0);
         pc_next_sel_o      : out  std_logic;
         alu_src_o          : out std_logic;
         jmp_u_o          : out std_logic;
         jal_o          : out std_logic;
         rd_we_o            : out std_logic;
         --********** Ulazni Statusni interfejs **************************************
         branch_condition_i : in  std_logic_vector (5 downto 0);
         --********** Izlazni Statusni interfejs **************************************
         data_mem_we_o      : out std_logic_vector(3 downto 0)
         );
end entity;


architecture behavioral of control_path is
   signal alu_2bit_op_s : std_logic_vector(1 downto 0);
   signal data_mem_we_s : std_logic;
   signal branch_s: std_logic_vector (5 downto 0);
   signal branch_res_s: std_logic_vector (5 downto 0);
   signal jal_s : std_logic;
begin

  jal_o <= jal_s;
  and1: for i in 0 to 5 generate
    branch_res_s(i) <= branch_s(i) and branch_condition_i(i);
  end generate and1;

  pc_next_sel_o <= branch_res_s(0) or branch_res_s(1) or branch_res_s(2) or branch_res_s(3) or branch_res_s(4) or branch_res_s(5) or jal_s;

   ctrl_dec : entity work.ctrl_decoder(behavioral)
      port map(
         opcode_i      => instruction_i(6 downto 0),
         funct3_i      => instruction_i(14 downto 12),
         branch_o      => branch_s,
         mem_to_reg_o  => mem_to_reg_o,
         data_mem_we_o => data_mem_we_s,
         alu_src_o     => alu_src_o,
         jmp_u_o     => jmp_u_o,
         jal_o     => jal_s,
         rd_we_o       => rd_we_o,
         alu_2bit_op_o => alu_2bit_op_s);

   alu_dec : entity work.alu_decoder(behavioral)
      port map(
         alu_2bit_op_i => alu_2bit_op_s,
         funct3_i      => instruction_i(14 downto 12),
         funct7_i      => instruction_i(31 downto 25),
         alu_op_o      => alu_op_o);

   --***************Izlazi************************
   data_mem_we_o <= (others => (data_mem_we_s));


end architecture;
