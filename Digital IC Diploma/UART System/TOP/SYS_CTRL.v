
module SYS_CTRL #(parameter WIDTH = 8, ADDR = 4 )

(
input    wire                 CLK,
input    wire                 RST,
input    wire   [WIDTH-1:0]   SC_RdData,
input    wire                 SC_RdData_VLD,
input    wire   [WIDTH*2-1:0] ALU_OUT,
input    wire                 ALU_OUT_VLD, 
input    wire   [WIDTH-1:0]   UART_RX_DATA, 
input    wire                 UART_RX_VLD,
input    wire                 FIFO_FULL,
output   reg                  ALU_EN,
output   reg    [3:0]         ALU_FUN,  
output   reg                  CLKGate_EN, 
output   reg                  CLKDIV_EN,
output   reg                  SC_WrEn,
output   reg                  SC_RdEn,
output   reg   [ADDR-1:0]     SC_Address,
output   reg   [WIDTH-1:0]    SC_WrData,
output   reg   [WIDTH-1:0]    UART_TX_DATA, 
output   reg                  UART_TX_VLD
);


// state encoding
localparam  [3:0] IDLE         = 4'b0000 ;
localparam  [3:0] WRITE_ADD_S  = 4'b0001 ;
localparam  [3:0] WRITE_DAT_S  = 4'b0011 ;
localparam  [3:0] READ_ADD_S   = 4'b0110 ;
localparam  [3:0] SEND_RF_RD_DAT_S  = 4'b0100 ;
localparam  [3:0] ALU_WP_OPA_S = 4'b1000 ;
localparam  [3:0] ALU_WP_OPB_S = 4'b1001 ;					   
localparam  [3:0] ALU_OP_FUN_S = 4'b1100 ;
localparam  [3:0] ALU_OUT_STORE_S = 4'b1110 ;
localparam  [3:0] ALU_WAIT_1st_byte_S = 4'b1111 ;
localparam  [3:0] ALU_WAIT_2nd_byte_S = 4'b1101 ;
					   
localparam  [7:0] RF_WRITE_CMD  = 8'hAA ;
localparam  [7:0] RF_READ_CMD   = 8'hBB ;
localparam  [7:0] ALU_W_OP_CMD  = 8'hCC ;
localparam  [7:0] ALU_WN_OP_CMD = 8'hDD ;
					   
reg         [3:0]      current_state ; 
reg         [3:0]      next_state    ;

reg         [7:0]      RF_ADDR_REG  ;
reg  [2*WIDTH-1:0]     ALU_OUT_REG  ;

reg                    RF_ADDR_SAVE ;
reg                    ALU_OUT_SAVE  ;		

					   
always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    current_state <= IDLE ;
   end
  else
   begin
    current_state <= next_state ;
   end
 end
 

always @ (*)
 begin
  case(current_state)
  IDLE : begin
		if(UART_RX_VLD)
	         begin
                case(UART_RX_DATA)  
		   RF_WRITE_CMD : begin
		   next_state = WRITE_ADD_S ;				
		 end
		    RF_READ_CMD  : begin
					next_state = READ_ADD_S ;				
					end
					ALU_W_OP_CMD : begin
							  next_state = ALU_WP_OPA_S ;				
					end
					ALU_WN_OP_CMD: begin
			                                next_state = ALU_OP_FUN_S ;				
					 end							   
					default      : begin
							    next_state = IDLE ;				
						       end
					endcase	
				  end
				else
				  begin
					next_state = IDLE ;
				  end
				end			  							  			
  WRITE_ADD_S : begin
		  if(UART_RX_VLD)
		    begin
		     next_state = WRITE_DAT_S ; 				
                   end
		  else
	            begin
		      next_state = WRITE_ADD_S ; 			
                   end			  
                end
  WRITE_DAT_S : begin
		  if(UART_RX_VLD)
		   begin
		     next_state = IDLE ; 				
                   end
	           else
		     begin
		       next_state = WRITE_DAT_S ; 			
                   end			  
                end  		  
  READ_ADD_S  : begin
	          if(UART_RX_VLD)
		  begin
		    next_state = SEND_RF_RD_DAT_S ; 				
                   end
		    else
		  begin
		    next_state = READ_ADD_S ; 			
                   end			  
                end
 SEND_RF_RD_DAT_S : begin
			if(SC_RdData_VLD)
		     begin
					   next_state = IDLE ; 				
                      end
		        else
			begin
			next_state = SEND_RF_RD_DAT_S ; 			
                      end			  
                    end
  ALU_WP_OPA_S: begin
		 if(UART_RX_VLD)
		     begin
			 next_state = ALU_WP_OPB_S ; 				
                   end
		else
		   begin
		      next_state = ALU_WP_OPA_S ; 			
                   end			  
                end	
  ALU_WP_OPB_S: begin
		   if(UART_RX_VLD)
		     begin
		       next_state = ALU_OP_FUN_S ; 				
                   end
		    else
		      begin
			 next_state = ALU_WP_OPB_S ; 			
                   end			  
                end	
  ALU_OP_FUN_S: begin
		   if(UART_RX_VLD)
		     begin
			next_state = ALU_OUT_STORE_S ; 				
		    end
		    else
			begin
							next_state = ALU_OP_FUN_S ; 			
		 end			  
                end	
  ALU_OUT_STORE_S : begin
		   if(ALU_OUT_VLD)
		    begin
			next_state = ALU_WAIT_1st_byte_S ; 				
		    end
		    else
			 begin
				next_state = ALU_OUT_STORE_S ; 			
			end			  
			end
  ALU_WAIT_1st_byte_S : begin
							next_state = ALU_WAIT_2nd_byte_S ; 						  
			end	
  ALU_WAIT_2nd_byte_S : begin
							next_state = IDLE ; 						  
			end				
  default     : begin
		 next_state = IDLE ; 
                end	
  endcase                 	   
 end 


always @ (*)
 begin
   ALU_EN     = 1'b0 ;
   ALU_FUN    = 4'b0 ;  
   CLKGate_EN    = 1'b0 ; 
   CLKDIV_EN  = 1'b1 ;
   SC_WrEn    = 1'b0 ;
   SC_RdEn    = 1'b0 ;
   SC_Address =  'b0 ;
   SC_WrData  =  'b0 ;
   UART_TX_DATA ='b0 ;
   UART_TX_VLD  = 1'b0 ; 
   ALU_OUT_SAVE = 1'b0 ;
   RF_ADDR_SAVE = 1'b0 ;  
  case(current_state)
  IDLE   	  : begin
			ALU_EN     = 1'b0 ;
			ALU_FUN    = 4'b0 ;  
			CLKGate_EN    = 1'b0 ; 
			CLKDIV_EN  = 1'b1 ;
			SC_WrEn    = 1'b0 ;
			SC_RdEn    = 1'b0 ;
			SC_Address =  'b0 ;
		        SC_WrData  =  'b0 ;
				end			  							  			
  WRITE_ADD_S : begin
		 if(UART_RX_VLD)
		 begin
		 RF_ADDR_SAVE = 1'b1 ; 				
                   end
	           else
		    begin
			RF_ADDR_SAVE = 1'b0 ; 			
                   end					   	  
                end
  WRITE_DAT_S : begin
		  if(UART_RX_VLD)
			begin
			SC_WrEn    = 1'b1 ;
			SC_Address = RF_ADDR_REG[ADDR-1:0]  ;
			SC_WrData  = UART_RX_DATA ;
                   end
		 else
		 begin
			 SC_WrEn    = 1'b0 ;
			SC_Address = RF_ADDR_REG[ADDR-1:0]  ;
			SC_WrData  = UART_RX_DATA ; 			
                   end					   	  
                end
  READ_ADD_S  : begin
			if(UART_RX_VLD)
			   begin
				SC_RdEn    = 1'b1 ;
				SC_Address = UART_RX_DATA[ADDR-1:0] ;
			end	
			 else
			   begin
			   SC_RdEn = 1'b0 ; 			
                   end					   	  
                end				
  SEND_RF_RD_DAT_S : begin
			if(SC_RdData_VLD && !FIFO_FULL)
				begin
			UART_TX_DATA  = SC_RdData ; 
			UART_TX_VLD   = 1'b1 ;	
			end
			else
			begin
			   UART_TX_VLD   = 1'b0 ;	
			end	
				end
  ALU_WP_OPA_S  : begin
			if(UART_RX_VLD)
			  begin
				 SC_WrEn    = 1'b1         ;
				 SC_Address = 'b00         ;
				SC_WrData  = UART_RX_DATA ;
			end	
			else
			  begin
				 SC_WrEn    = 1'b0         ;
				 SC_Address = 'b00         ;
				 SC_WrData  = UART_RX_DATA ; 			
                   end			  
                end	
  ALU_WP_OPB_S: begin
				 if(UART_RX_VLD)
				  begin
				    SC_WrEn    = 1'b1         ;
					SC_Address = 'b01         ;
					SC_WrData  = UART_RX_DATA ;
				  end	
			     else
			       begin
				    SC_WrEn    = 1'b0         ;
					SC_Address = 'b01         ;
					SC_WrData  = UART_RX_DATA ;		
                   end			  
                end	
  ALU_OP_FUN_S: begin
				 CLKGate_EN = 1'b1 ;  
				 if(UART_RX_VLD)
			       begin
                     ALU_EN  = 1'b1 ;
                     ALU_FUN = UART_RX_DATA[3:0] ; 
                   end
			     else
			       begin
                     ALU_EN  = 1'b0 ;
                     ALU_FUN = UART_RX_DATA[3:0] ; 
                   end			  
                end	
  ALU_OUT_STORE_S: begin
			CLKGate_EN = 1'b1 ;
		if(ALU_OUT_VLD)
			begin
				ALU_OUT_SAVE = 1'b1 ;					 
			end
			else
			begin
				ALU_OUT_SAVE   = 1'b0 ;	
			end	
			end						
  ALU_WAIT_1st_byte_S:	begin
			CLKGate_EN = 1'b1 ;
				if(!FIFO_FULL)	
				begin			
				      UART_TX_DATA  = ALU_OUT_REG[WIDTH-1:0] ; 
					UART_TX_VLD   = 1'b1 ;	
				end	
				end	
  ALU_WAIT_2nd_byte_S: 	begin
			  CLKGate_EN = 1'b1 ;
			    if(!FIFO_FULL)	
			     begin	
				UART_TX_DATA  = ALU_OUT_REG[2*WIDTH-1:WIDTH] ; 
				UART_TX_VLD   = 1'b1 ;	
				end
				end	
  default : begin
		    ALU_EN     = 1'b0 ;
		    ALU_FUN    = 4'b0 ;  
		    CLKGate_EN    = 1'b0 ; 
	        CLKDIV_EN  = 1'b1 ;
		    SC_WrEn    = 1'b0 ;
		    SC_RdEn    = 1'b0 ;
		    SC_Address =  'b0 ;
		    SC_WrData  =  'b0 ;
                end	
  endcase                 	   
 end 

always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    RF_ADDR_REG <= 8'b0 ;
   end
  else
   begin
    if (RF_ADDR_SAVE)
	 begin	
      RF_ADDR_REG <= UART_RX_DATA ;
	 end 
   end
 end

always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    ALU_OUT_REG <= 'b0 ;
   end
  else
   begin
    if (ALU_OUT_SAVE)
	 begin	
      ALU_OUT_REG <= ALU_OUT ;
	 end 
   end
 end 
 
endmodule
