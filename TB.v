module TB();
    parameter UNI_CAP = 5;
    parameter PUB_CAP = 2;
    parameter PHASE = 1;

    reg car_entered = 0;
    reg is_uni_car_entered = 0;
    reg car_exited = 0;
    reg is_uni_car_exited = 0;
    reg [5:0] hour;

    wire [9:0] uni_parked_car; 
    wire [9:0] parked_car;
    wire [9:0] uni_vacated_space;
    wire [9:0] vacated_space;
    wire uni_is_vacated_space;
    wire is_vacated_space, error;

    ParkingLot #(
        .UNI_CAP(UNI_CAP),
        .PUB_CAP(PUB_CAP),
        .PHASE(PHASE)
    ) uut (
        .car_entered(car_entered),
        .is_uni_car_entered(is_uni_car_entered),
        .car_exited(car_exited),
        .is_uni_car_exited(is_uni_car_exited),
        .hour(hour),
        .uni_parked_car(uni_parked_car),
        .parked_car(parked_car),
        .uni_vacated_space(uni_vacated_space),
        .vacated_space(vacated_space),
        .uni_is_vacated_space(uni_is_vacated_space),
        .is_vacated_space(is_vacated_space)
    );

    initial begin
        car_entered = 0;
        car_exited = 0;
        #480
    repeat(32) begin
        hour = $time / 60;
        if (hour <= 13) begin
            car_entered = 1;
            car_exited = 0;
        end
        else begin
            car_exited = $urandom_range(0, 1);
            car_entered = ~car_exited;
        end
        
        is_uni_car_entered = car_entered & $urandom_range(0, 1);
        is_uni_car_exited = car_exited & $urandom_range(0, 1);
        
        #0
        $display("hour= %02d:%02d | car_entered= %0b | is_uni_car_entered= %0b | car_exited= %0b | is_uni_car_exited= %0b | uni_vacated_space= %0d | vacated_space= %0d | uni_is_vacated_space= %0b | is_vacated_space= %0b | uni_parked_car= %0d | parked_car= %0d",
                hour, $time % 60, car_entered, is_uni_car_entered, car_exited, is_uni_car_exited, uni_vacated_space,
                vacated_space, uni_is_vacated_space, is_vacated_space, uni_parked_car, parked_car);
        
        car_entered = 0;
        car_exited = 0;
        #30;
    end
    end

endmodule