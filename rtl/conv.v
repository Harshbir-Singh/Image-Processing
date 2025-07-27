`timescale 1ns / 1ps
module conv(
input        i_clk,
input [71:0] i_pixel_data,
input        i_pixel_data_valid,
input [1:0]  i_conv_mode,
output reg [7:0] o_convolved_data,
output reg   o_convolved_data_valid
);
    
integer i; 
reg [7:0] kernel1 [8:0];
reg [7:0] kernel2 [8:0];
reg [7:0] kernel3 [8:0];
reg [7:0] kernel  [8:0];
reg [7:0] kernel4 [8:0];


reg [10:0] multData1[8:0];
reg [10:0] multData2[8:0];
reg [15:0] multData3[8:0];
reg [15:0] multData4[8:0];
reg [15:0] multData[8:0];


reg [10:0] sumDataInt1;
reg [10:0] sumDataInt2;
reg [15:0] sumDataInt3;
reg [15:0] sumDataInt4;
reg [15:0] sumDataInt;


reg [10:0] sumData1;
reg [10:0] sumData2;
reg [15:0] sumData3;
reg [15:0] sumData4;
reg [15:0] sumData;

reg multDataValid;
reg sumDataValid;


reg [20:0] convolved_data_int1;
reg [20:0] convolved_data_int2;
reg [15:0] convolved_data_int3;
wire [21:0] convolved_data_int;
reg convolved_data_int_valid;

reg [1:0] conv_mode;

initial
begin
    kernel1[0] =  1;
    kernel1[1] =  0;
    kernel1[2] = -1;
    kernel1[3] =  2;
    kernel1[4] =  0;
    kernel1[5] = -2;
    kernel1[6] =  1;
    kernel1[7] =  0;
    kernel1[8] = -1;
    
    kernel2[0] =  1;
    kernel2[1] =  2;
    kernel2[2] =  1;
    kernel2[3] =  0;
    kernel2[4] =  0;
    kernel2[5] =  0;
    kernel2[6] = -1;
    kernel2[7] = -2;
    kernel2[8] = -1;
    
    for(i=0;i<9;i=i+1)
      begin
        kernel[i] = 1;
      end
    
    kernel4[0] =  0;  
    kernel4[1] = -1;   
    kernel4[2] =  0;  
    kernel4[3] = -1;  
    kernel4[4] =  5;  
    kernel4[5] = -1;  
    kernel4[6] =  0;  
    kernel4[7] = -1;  
    kernel4[8] =  0;  
      
    kernel3[0] = -2;  
    kernel3[1] = -1;   
    kernel3[2] =  0;  
    kernel3[3] = -1;  
    kernel3[4] =  0;  
    kernel3[5] =  1;  
    kernel3[6] =  0;  
    kernel3[7] =  1;  
    kernel3[8] =  2;  
    
end    

always@(posedge i_clk)
  begin
    conv_mode <= i_conv_mode;
  end   
always @(posedge i_clk)
begin
  if(conv_mode == 2'b00)
    begin
    for(i=0;i<9;i=i+1)
      begin
        multData1[i] <= $signed(kernel1[i])*$signed({1'b0,i_pixel_data[i*8+:8]});
        multData2[i] <= $signed(kernel2[i])*$signed({1'b0,i_pixel_data[i*8+:8]});
      end
    end
  else if(conv_mode == 2'b01)
    begin
    for(i=0;i<9;i=i+1)
      begin
        multData[i] <= kernel[i]*i_pixel_data[i*8+:8];
      end
    end
  else if(conv_mode == 2'b10)
    begin
    for(i=0;i<9;i=i+1)
      begin
        multData3[i] <= $signed(kernel3[i])*$signed({1'b0,i_pixel_data[i*8+:8]});
      end
    end
  else
    begin
    for(i=0;i<9;i=i+1)
      begin
        multData4[i] <= kernel4[i]*i_pixel_data[i*8+:8];
      end
    end
  multDataValid <= i_pixel_data_valid;
end


always @(*)
begin
  sumDataInt1 = 0;
  sumDataInt2 = 0;
  sumDataInt = 0;
  sumDataInt3 = 0;
  sumDataInt4 = 0;
  if(conv_mode ==2'b00)
    begin
    for(i=0;i<9;i=i+1)
      begin
        sumDataInt1 = $signed(sumDataInt1) + $signed(multData1[i]);
        sumDataInt2 = $signed(sumDataInt2) + $signed(multData2[i]);
      end
    end
  else if(conv_mode ==2'b01)
    begin
    for(i=0;i<9;i=i+1)
      begin
        sumDataInt = sumDataInt + multData[i];
      end
    end
  else if(conv_mode ==2'b10)
    begin
    for(i=0;i<9;i=i+1)
      begin
        sumDataInt3 = $signed(sumDataInt3) + $signed(multData3[i]);
      end
    end
  else 
    begin
    for(i=0;i<9;i=i+1)
      begin
        sumDataInt4 = sumDataInt4 + multData4[i];
      end
    end
end

always @(posedge i_clk)
begin
  if(conv_mode == 2'b00)
    begin
    sumData1 <= sumDataInt1;
    sumData2 <= sumDataInt2;
    end
  else if(conv_mode == 2'b01)
    begin
       sumData <= sumDataInt;
    end
  else if(conv_mode == 2'b10)
    begin
       sumData3 <= sumDataInt3;
    end
  else
    begin
       sumData4 <= sumDataInt4;
    end
  sumDataValid <= multDataValid;
end

always @(posedge i_clk)
begin
  if(conv_mode == 2'b00)
    begin
    convolved_data_int1 <= $signed(sumData1)*$signed(sumData1);
    convolved_data_int2 <= $signed(sumData2)*$signed(sumData2);
    end
  else if(conv_mode == 2'b10)
    begin
    convolved_data_int3 <= $signed(sumData3*3)+ 128;
    end
  convolved_data_int_valid <= sumDataValid;
end

assign convolved_data_int = convolved_data_int1+convolved_data_int2;

    
always @(posedge i_clk)
begin
  if(conv_mode == 2'b00)
    begin
    if(convolved_data_int > 4000)
        o_convolved_data <= 8'hff;
    else
        o_convolved_data <= 8'h00;
    o_convolved_data_valid <= convolved_data_int_valid;
    end
  else if(conv_mode == 2'b01)
    begin
      o_convolved_data <= sumData/9;
      o_convolved_data_valid <= sumDataValid;
    end
  else if(conv_mode == 2'b10)
    begin
      if(convolved_data_int3<0)
        o_convolved_data <= 8'h0A;
      else if(convolved_data_int3> 245)
        o_convolved_data <= 8'hF5;
      else
        o_convolved_data <= convolved_data_int3[7:0];
      o_convolved_data_valid <= convolved_data_int_valid;
    end
  else 
    begin
      o_convolved_data <= sumData4;
      o_convolved_data_valid <= sumDataValid;
    end
end
endmodule