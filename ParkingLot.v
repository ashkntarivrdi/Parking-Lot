module ParkingLot #(
    parameter UNI_CAP = 500,
    parameter PUB_CAP = 200,
    parameter PHASE = 50
)(
    input wire car_entered,
    input wire is_uni_car_entered,
    input wire car_exited,
    input wire is_uni_car_exited,
    input wire [5:0] hour,
    output reg signed [9:0] uni_parked_car = 0,
    output reg signed [9:0] parked_car = 0,
    output reg signed [9:0] uni_vacated_space = UNI_CAP,
    output reg signed [9:0] vacated_space = PUB_CAP, 
    output wire uni_is_vacated_space,
    output wire is_vacated_space
);

reg [9:0] uni_entire_space;
reg [9:0] entire_space;


task update_spaces;
    input [5:0] hour;
    begin
        if (hour >= 13 && hour < 16) begin
            uni_entire_space = UNI_CAP - (hour - 12) * PHASE;
            entire_space = PUB_CAP + (hour - 12) * PHASE;
        end else begin
            uni_entire_space = PUB_CAP;
            entire_space = UNI_CAP;
        end
    end
endtask

task handle_uni_overflow;
    begin
        if (uni_entire_space < uni_parked_car) begin
            parked_car = parked_car + (uni_parked_car - uni_entire_space);
            uni_parked_car = uni_entire_space;
            vacated_space = entire_space - parked_car;
        end
    end
endtask

task handle_car_enter;
    input is_uni;
    begin
        if (is_uni) begin
            if (uni_is_vacated_space) begin
                uni_vacated_space = uni_vacated_space - 1;
                uni_parked_car = uni_parked_car + 1;
            end
            else if(is_vacated_space) begin
                vacated_space = vacated_space - 1;
                parked_car = parked_car + 1;
            end
        end else if (is_vacated_space) begin
            vacated_space = vacated_space - 1;
            parked_car = parked_car + 1;
        end
    end
endtask

task handle_car_exit;
    input is_uni;
    begin
        if (is_uni && uni_parked_car > 0) begin
            uni_parked_car = uni_parked_car - 1;
            uni_vacated_space = uni_vacated_space + 1;
        end else if (!is_uni && parked_car > 0) begin
            parked_car = parked_car - 1;
            vacated_space = vacated_space + 1;
        end
    end
endtask

always @(posedge car_entered or posedge car_exited) begin
    update_spaces(hour);

    if ((hour >= 13 && hour < 16) || hour >= 16) begin
        handle_uni_overflow();
    end

    if (car_entered && hour >= 8) begin
        handle_car_enter(is_uni_car_entered);
    end

    if (car_exited && hour >= 8) begin
        handle_car_exit(is_uni_car_exited);
    end
end

assign uni_is_vacated_space = (uni_vacated_space > 0);
assign is_vacated_space = (vacated_space > 0);

endmodule