clc;

constants = ConstantsClass0801;
R_ = squareforR_(constants);    %longwei thesis ohm/mm
x  = xvariable(constants);
dx = x(2)-x(1);                 %gridpoints difference

% Position of the source
N_x_mid=midlength(constants);

%Distance between grid points n
%the more similar dt and dx the more robust %the morerapidly varying f is,
%the larger the error is, and, consequently, the smaller x must be to reduce the error to desired precision
dt = .9*dx/constants.c0;

l_ = dt/(sqrt(constants.C_*constants.L_));
% Initialize vectors
J           = constants.G_*constants.VDC*ones(1,constants.N_x);
J_prev      = J;
V_Z_l       = zeros(1,constants.N_t);
I_1         = zeros(1,constants.N_t);
I_S         = zeros(1,constants.N_t);
V_S         = zeros(1,constants.N_t);
V_1         = zeros(1,constants.N_t);
V_source    = 0;
V           = zeros(1,constants.N_x);
V_prev      = V;
I           = zeros(1,constants.N_x);
I_prev      = I;
I_prev_prev = I;
I_last      = zeros(1,constants.N_t);
refl_num    = zeros(1,constants.N_t);
V_smax      = zeros(1,constants.N_t);
V_smin      = zeros(1,constants.N_t);
I_pump      = zeros(1,constants.N_t);
I_pump_prev = zeros(1,constants.N_t); 
I_c         = zeros(1,constants.N_t);

alpha   = (((2*constants.C_)-(dt*constants.G_))/((2*constants.C_)+(dt*constants.G_)));
beta    = (2*dt)/(dx*(2*constants.C_ + dt*constants.G_));
gamma   = ((constants.QCL_WID*dt)/((2*constants.C_) + (dt*constants.G_)));
delta   = (((2*constants.L_) - (dt*R_))/((2*constants.L_) + (dt*R_)));
epsilon = ((2*dt)/(dx*((2*constants.L_) + (dt*R_))));

zeta    = (((constants.C_*dx)/dt)-(1/(2*constants.Zs))-((constants.G_*dx)/2));
eta     = (1/(((constants.C_*dx)/dt)+(1/(2*constants.Zs))+((constants.G_*dx)/2)));
theta   = ((constants.Z_l) + ((dx*constants.L_)/dt))^-1;
iota    = (((dx*constants.L_)/dt)-constants.Z_l);
refle   = (constants.Z_l-constants.Zs)/(constants.Z_l+constants.Zs);

%m = round((sqrt(constants.L_*constants.C_)*constants.COAX_LEN)/dt);
m = constants.node;
N = moviein(constants.N_t);
M = moviein(constants.N_t);
T = moviein(constants.N_t);
t0 = 10000;
stdv = 2500;
update_idx = setdiff([2:constants.N_x],[constants.node]);
for t=1:constants.N_t
    
    %transmission line coaxial cabel
    
    %Source at V_1 propagates through cabel like micro strip in QCL does
    %for the last value of the grid use KVL to get voltage at constants.node k of QCL
    %capacity
    V_source   = 1/2*(1+erf((t-t0)/(sqrt(2*stdv^2))))*(constants.VDC);
    V_1(t)           = V_source;

    if t <= m
        V(constants.node)= (zeta*V(constants.node) +  I(constants.node-1)- I(constants.node))*eta;
        V(update_idx) = alpha*V(update_idx) - beta*(I(update_idx)-I(update_idx-1));
        V(1)               = V(2);
        
        I_1(t)           = V_1(t)/constants.Zs;
        V_S(t)           = (V(constants.node)+V_prev(constants.node))/2;
        I_S(t)           = -V_S(t)/constants.Zs ;
        refl_num(t)  = 0;
    end
    
    if t > m

        V(constants.node)= (zeta*V(constants.node) + (V_1(t-m)/constants.Zs) + I_1(t-m) +...
                           I(constants.node-1)- I(constants.node))*eta;
        V(update_idx) = alpha*V(update_idx) - beta*(I(update_idx)-I(update_idx-1));
        V(1)               = V(2);

        I_1(t)           = ((V_1(t) - V_S(t-m))/constants.Zs) + I_S(t-m);
        V_S(t)           = (V(constants.node)+V_prev(constants.node))/2;
        I_S(t)           = ((V_1(t-m) - V_S(t))/constants.Zs) + I_1(t-m);


        %checking results
        V_smax(t) = (V_S(t) + constants.Zs*I_S(t))/2;
        V_smin(t) = (V_S(t) - constants.Zs*I_S(t))/2;
        refl_num(t)  = V_smin(t)/V_smax(t);
    end

    %TL equation -------magnitude difference 
    I(1:constants.N_x-1)   = delta * I(1:constants.N_x-1) - epsilon*(V(2:constants.N_x)-V(1:constants.N_x-1));
    I(constants.N_x)       = theta*(2*V(constants.N_x) + iota*I(constants.N_x)); %!!!!!!!!Verhält sich komisch beim einspeisen. Vielleicht i_k berechnen?



    I_c(t)       = I(constants.N_x);
    V_Z_l(t)               = I(constants.N_x)*constants.Z_l;
    I_pump_prev = I_pump;
    V_prev = V;
    I_prev = I;

    if mod(t,5000) == 0
        
        subplot 411;
        plot(V, 'r');
        title('Voltage in the circuit');
        xlabel('QCL grid points');
        ylabel('Voltage in the TL in Volt');
        M(:,t) = getframe ;
        
        subplot 412;
        plot(I, 'blue');
        title('Current in the circuit');
        xlabel('Lenght of the QCL in meter');
        ylabel('Current in Ampere');
        M(:,t) = getframe ;
        
        subplot 425;
        plot(V_Z_l, 'r');
        title('Voltage at the resistance Z_l');
        xlabel('Lenght of the QCL in meter');
        ylabel('Voltage at Z_l in Volt');
        M(:,t) = getframe ;
        
        subplot 426
        plot(refl_num, 'r');
        title('Reflection index');
        xlabel('steps');
        ylabel('f(reflection)');
        T(:,t) = getframe ;
        
        subplot 427
        plot(V_smax, 'r'); hold on;
        plot( V_smin,'blue');
        title('Reflection  and propagating voltage');
        xlabel('steps');
        ylabel('U_+/U_-');
        T(:,t) = getframe ;

        subplot 428
        plot(I_S, 'black'); hold on;
        plot(I_c, 'green');
        title('Pumping current I_S & I_V_l');
        xlabel('steps');
        ylabel('Current in Ampere');
        T(:,t) = getframe ;
        
    end
end