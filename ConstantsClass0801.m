classdef ConstantsClass0801
    properties (Constant)
        N_x=1000;
        QCL_LEN = 1e-3; % 1mm
        QCL_WID = 6e-5; % 60um
        % Number of time steps
        N_t= 400000;
        c0=3.e8;
        f_rf = 13.9e9; %higher than THz field's roundtrip frequency%----------changed from 13.9e6
        %M_a = 6; %Amplitude ac -----boundaries not constant for M_a != 0 
        VDC =10; %Source voltage
%         C_ = 9.31e-10; %longwei thesis F/m
%         L_ = 3.04e-7; %longwei thesis H/m
        C_ =2.5351e-10;
        L_ =  6.3377e-07; 
        t0=20; %offset to ease in and out of the source
        spread=10;
        QCL_width = 6e-5;
        G_ = 0;
        COAX_LEN = 10e-3;
        node = 2;
        Z_l = 40;
    end
    properties
        Zs
    end
    methods
        function obj = ConstantsClass0801()
                    obj.Zs = sqrt(obj.L_/obj.C_);
        end
        function r = squareforR_(constants)
            r = sqrt(constants.f_rf)*4.5e-5;
        end
        
        function r = xvariable(constants)
            r = linspace(0,constants.QCL_LEN,constants.N_x);
        end
        
        function r = midlength(constants)
            r =  constants.N_x/2;% Position of the source
        end
        
    end
    
end