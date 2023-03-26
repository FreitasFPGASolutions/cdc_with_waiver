module cdc (
  input CLK_100_i,
  input EXAMPLE1_i,
  input EXAMPLE2_i,
  input EXAMPLE3_i,
  output EXAMPLE1_o,
  output EXAMPLE2_o,
  output EXAMPLE3_o,
  input [3:0] FIFO_DIN_i,
  output [3:0] FIFO_DOUT_o,
  output LED4_o,
  output LED5_o,
  output LED6_o,
  output LED7_o
);

logic clk_200;
logic mmcm_locked;

clocking_wizard mmcm (
  .clk_out1 (clk_200),
  .locked   (mmcm_locked),
  .clk_in1  (CLK_100_i)
);

logic fifo_rst = 1;
logic fifo_empty;
logic fifo_rd_en;

assign fifo_rd_en = ~fifo_empty;

fifo cdc_fifo (
  .rst    (fifo_rst),
  .wr_clk (CLK_100_i),
  .rd_clk (clk_200),
  .din    (FIFO_DIN_i),
  .wr_en  (1'b1),
  .rd_en  (fifo_rd_en),
  .dout   (FIFO_DOUT_o),
  .full   (), 
  .empty  (fifo_empty)
);

logic [27:0] clk_100_count = 0;
logic clk_100_led = 0;
logic [27:0] clk_200_count = 0;
logic clk_200_led = 0;

assign LED4_o = clk_100_led;
assign LED5_o = clk_200_led;
assign LED6_o = mmcm_locked;
assign LED7_o = 1;

always @ (posedge CLK_100_i)
begin
  clk_100_count <= clk_100_count + 1;
  if (clk_100_count == 28'h5F5E100)
    begin
      fifo_rst <= 0;
      clk_100_led <= ~clk_100_led;
      clk_100_count <= 0;
    end
end

always @ (posedge clk_200)
begin
  clk_200_count <= clk_200_count + 1;
  if (clk_200_count == 28'hBEBC200)
    begin
      clk_200_led <= ~clk_200_led;
      clk_200_count <= 0;
    end
end


logic example1_reg1;
logic example1_reg2;

always @ (posedge CLK_100_i)
begin
  example1_reg1 <= EXAMPLE1_i;
end

always @ (posedge clk_200)
begin
  example1_reg2 <= example1_reg1;
end
assign EXAMPLE1_o = example1_reg2;


logic example2_reg1;
logic example2_reg2;
logic example2_reg3;

always @ (posedge CLK_100_i)
begin
  example2_reg1 <= EXAMPLE2_i;
end

always @ (posedge clk_200)
begin
  example2_reg2 <= example2_reg1;
  example2_reg3 <= example2_reg2;
end
assign EXAMPLE2_o = example2_reg3;


logic example3_reg1;
(* ASYNC_REG = "TRUE" *) logic example3_reg2;
(* ASYNC_REG = "TRUE" *) logic example3_reg3;

always @ (posedge CLK_100_i)
begin
  example3_reg1 <= EXAMPLE3_i;
end

always @ (posedge clk_200)
begin
  example3_reg2 <= example3_reg1;
  example3_reg3 <= example3_reg2;
end
assign EXAMPLE3_o = example3_reg3;

endmodule
