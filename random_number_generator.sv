module random_number_generator(
   input logic clk,
   input logic button,
   output logic [6:0] segments,
   output logic button_out
);

integer counter = 0;

integer number = 6;

integer db_counter = 0;
logic [7:0] db_hist = 8'h00;
logic db_button = 1'b1;

integer i;

always_ff @(posedge clk)
begin
   if (counter >= 5) begin
     counter = 0;
   end else begin
     counter++;
   end
end

always_ff @(posedge clk)
begin
   if (db_counter < 40000) begin
     db_counter++;
   end else begin
     db_hist = {db_hist[6:0], button};
     db_counter = 0;
   end
   if (db_hist == 8'hFF) begin
     db_button <= 1'b1;
   end else if (db_hist == 8'h00) begin
     db_button <= 1'b0;
   end
end

always_ff @(negedge db_button)
begin
   number = counter + 1;
end

assign segments = (number == 1) ? 7'b1001111 :
                  (number == 2) ? 7'b0010010 :
                  (number == 3) ? 7'b0000110 :
                  (number == 4) ? 7'b1001100 :
                  (number == 5) ? 7'b0100100 :
                                  7'b0100000;

assign button_out = db_button;

endmodule
