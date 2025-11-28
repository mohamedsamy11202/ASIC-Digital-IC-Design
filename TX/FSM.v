module FSM(
    input  wire       CLK,        // System CLK
    input  wire       RST,        // System RST
    input  wire       DATA_VALID, //
    input  wire       PAR_EN,     // 
    input  wire       ser_done,   //

    output reg        ser_en,     //
    output reg [3:0]  mux_sel,    //
    output reg        Busy
);

localparam 		IDLE    = 3'b000;
localparam    	START   = 3'b001;
localparam    	DATA    = 3'b011;
localparam   	PARITY  = 3'b010;
localparam    	STOP    = 3'b110 ;


reg [2:0] current_state, next_state;

// state transition
always @(posedge CLK or negedge RST) begin
    if (!RST)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

// next_state logic
always @(*) begin
    case (current_state)
        IDLE: begin
            if (DATA_VALID && !Busy)
                next_state <= START;
            else
                next_state <= IDLE;
        end
        START: begin
            if (CLK)
                next_state <= START;
            else
                next_state <= DATA;
        end
        DATA: begin
            if (!ser_done)
                next_state <= DATA;
            else if (PAR_EN)
                next_state <= PARITY;
            else
                next_state <= STOP;
        end
        PARITY: begin
            if (CLK)
                next_state <= PARITY;
            else
                next_state <= STOP;
        end
        STOP: begin
            if (CLK)
                next_state <= STOP;
            else
                next_state <= IDLE;
        end
        default: next_state <= IDLE;
    endcase
end

// output logic	
always @(*) begin
    mux_sel = 3'b000;
    Busy    = 1'b1;
    ser_en  = 1'b0; 
    case (current_state)
        IDLE: begin 
            Busy    = 1'b0;
            mux_sel = 3'b000;
        end
        START: begin					
            mux_sel = 3'b001;
            if (DATA_VALID)
                ser_en  = 1'b1;
        end
        DATA:    mux_sel = 3'b011;
        PARITY:  mux_sel = 3'b010;
        STOP:    mux_sel = 3'b110;
        default: begin
            mux_sel = 3'b000;
            Busy    = 1'b1;
            ser_en  = 1'b0;
        end
    endcase
end	

endmodule
