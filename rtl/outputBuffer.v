`timescale 1ns / 1ps

module outputBuffer(
    input  s_aclk,
    input  s_aresetn,
    input  s_axis_tvalid,
    output s_axis_tready,
    input  [7:0] s_axis_tdata,
    output m_axis_tvalid,
    input  m_axis_tready,
    output [7:0] m_axis_tdata,
    output axis_prog_full
);

parameter FIFO_DEPTH = 1024;
parameter ADDR_WIDTH = 10;

reg [7:0] fifo_mem [0:FIFO_DEPTH-1];
reg [ADDR_WIDTH:0] wr_ptr, rd_ptr;
reg [ADDR_WIDTH:0] fifo_count;

// Initialize FIFO
integer init_idx;
initial begin
    for(init_idx = 0; init_idx < FIFO_DEPTH; init_idx = init_idx + 1) begin
        fifo_mem[init_idx] = 8'h00;
    end
    wr_ptr = {ADDR_WIDTH+1{1'b0}};
    rd_ptr = {ADDR_WIDTH+1{1'b0}};
    fifo_count = {ADDR_WIDTH+1{1'b0}};
end

wire fifo_full, fifo_empty;
wire fifo_wr_en, fifo_rd_en;

assign fifo_full = (fifo_count == FIFO_DEPTH);
assign fifo_empty = (fifo_count == 0);
assign axis_prog_full = (fifo_count > (FIFO_DEPTH - 64));

assign fifo_wr_en = s_axis_tvalid && s_axis_tready;
assign fifo_rd_en = m_axis_tvalid && m_axis_tready;

assign s_axis_tready = !fifo_full;
assign m_axis_tvalid = !fifo_empty;

// FIFO write
always @(posedge s_aclk) begin
    if (!s_aresetn) begin
        wr_ptr <= {ADDR_WIDTH+1{1'b0}};
    end else if (fifo_wr_en) begin
        fifo_mem[wr_ptr[ADDR_WIDTH-1:0]] <= s_axis_tdata;
        wr_ptr <= wr_ptr + 1;
    end
end

// FIFO read
always @(posedge s_aclk) begin
    if (!s_aresetn) begin
        rd_ptr <= {ADDR_WIDTH+1{1'b0}};
    end else if (fifo_rd_en) begin
        rd_ptr <= rd_ptr + 1;
    end
end

assign m_axis_tdata = fifo_mem[rd_ptr[ADDR_WIDTH-1:0]];

// FIFO count
always @(posedge s_aclk) begin
    if (!s_aresetn) begin
        fifo_count <= {ADDR_WIDTH+1{1'b0}};
    end else begin
        case ({fifo_wr_en, fifo_rd_en})
            2'b10: fifo_count <= fifo_count + 1;
            2'b01: fifo_count <= fifo_count - 1;
            2'b11: fifo_count <= fifo_count;
            default: fifo_count <= fifo_count;
        endcase
    end
end

endmodule
