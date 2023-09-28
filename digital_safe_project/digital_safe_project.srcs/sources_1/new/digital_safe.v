`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2023 15:34:42
// Design Name: 
// Module Name: digital_safe
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module lab2_bcd(A,B,C,D,a,b,c,d,e,f,g);
input A,B,C,D;
output a,b,c,d,e,f,g;


assign a = ~(A | C |(B&D) | (~B&~D));
assign b = ~(~B |(C&D)|(~C&~D));
assign c = ~(~C | D | B) ;
assign d = ~(A | (B&~C&D) | (C&~D) |(~B&C)|(~B&~D));
assign e = ~((C&~D) | (~B&~D));
assign f = ~(A | (B&~D)| (B&~C) | (~C&~D));
assign g = ~(A | (B&~D)| (B&~C) | (~B&C));
endmodule


module priorityencoder_83(en,i,y);
  // declare
  input en;
  input [9:0]i;
  // store and declare output values
  output reg [3:0]y;
  always @(en,i)
  begin
    if(en==1)
      begin
        // priority encoder
        // if condition to choose 
        // output based on priority. 
        if(i[9]==1) y=4'b1001;
        else if(i[8]==1) y=4'b1000;
        else if(i[7]==1) y=4'b0111;
        else if(i[6]==1) y=4'b0110;
        else if(i[5]==1) y=4'b0101;
        else if(i[4]==1) y=4'b0100;
        else if(i[3]==1) y=4'b0011;
        else if(i[2]==1) y=4'b0010;
        else if(i[1]==1) y=4'b0001;

        else
        y=4'b0000;
      end
     // if enable is zero, there is
     // an high impedance value. 
    else y=3'bzzz;
  end
endmodule

module push_to_7seg(en,i,a,b,c,d,e,f,g);
    input en;
    input [9:0]i;
    output a,b,c,d,e,f,g;
    wire [3:0]y;
    priorityencoder_83(en,i,y);
    lab2_bcd(y[3],y[2],y[1],y[0],a,b,c,d,e,f,g);
endmodule

module checkpin(pin,truepin,decision);
    output reg decision;
    output reg [3:0] pin [3:0];
    output reg [3:0] truepin [3:0];
    reg check=1'b0;
    integer i;
    always @(*)
     begin
        decision = 1'b1; // set the default value of decision to 1
        for (i = 0; i < 3; i = i + 1)
         begin
            if (pin[i] != truepin[i])
             begin
                decision = 1'b0; // set decision to 0 if any element in pin is not equal to the corresponding element in truepin
                break; // exit the loop early if a mismatch is found
            end
         end
     end
//    if(pin==truepin)
//    assign decision=1'b1;
//    else
//    assign decision=1'b0;
endmodule

module digital_safe(sysclk,clk,en,pin,truepin,nums);
  input en;
  input sysclk;
  output clk;
  input [9:0] nums;
  output reg [3:0] pin [3:0];
  output reg [3:0] truepin [3:0];
  reg count = 2'b00;
  reg [27:0] clkcount = 0;
  reg [1:0] digcount = 0;
  reg ifequal;

  always @(posedge sysclk) begin
    clkcount <= clkcount + 1;
  end

  assign clk = clkcount[27];

  always @(posedge clk) begin
    if (en == 1) begin 
      if (count != 2'b11) begin
        priorityencoder(en, nums, pin[count]);
        count <= count + 1;
      end
//      else 
//      begin
//        checkpin(pin, truepin, ifequal);
//      end
    end 
  end 
endmodule
