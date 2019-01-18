library ieee;
use ieee.std_logic_1164.all;

entity random_number_generator is
port (
   clk: in std_logic;
   button: in std_logic;
   segments: out std_logic_vector(6 downto 0);
   button_out: out std_logic
);
end random_number_generator;

architecture structure of random_number_generator is
   signal counter: integer range 1 to 6;
   signal number: integer range 1 to 6;

   signal db_button: std_logic;
   signal db_hist: std_logic_vector(7 downto 0) := X"00";
begin

randomize: process(clk)
   variable cnt: integer range 0 to 6 := 0;
begin
   if (rising_edge(clk)) then
     cnt := cnt + 1;
     if (cnt = 6) then
       cnt := 0;
     end if;
     counter <= (cnt + 1);
   end if;
end process;

debounce: process(clk)
   variable db_cnt: integer range 0 to 50000 := 0;
begin
   if (rising_edge(clk)) then
     if db_cnt < 40000 then
       db_cnt := db_cnt + 1;
     else
       db_hist <= db_hist(6 downto 0) & button;
       db_cnt := 0;
       if db_hist = X"FF" then
         db_button <= '1';
       elsif db_hist = X"00" then
         db_button <= '0';
       end if;
     end if;
   end if;
end process;

show: process(db_button)
begin
   if falling_edge(db_button) then
     number <= counter;
   end if;
end process;

button_out <= db_button;

segments <= "1001111" when number = 1 else
            "0010010" when number = 2 else
            "0000110" when number = 3 else
            "1001100" when number = 4 else
            "0100100" when number = 5 else
            "0100000";

end structure;
