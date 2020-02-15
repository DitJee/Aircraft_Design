%% Variables                 
%{
    AR = Aspect ratio
    CDTO =  Drag coefficient during T-O run
    CDmin =  Minimum drag coefficient
    CLTO = Lift coefficient during T-O run
    CLmax = Maximum lift coefficient
    e = Oswald efficiency 
    g = Acceleration due to gravity [ft/s^2]
    Hcruise = Cruise altitude [ft]
    HCelling = Celling altitude [ft]
    k = Coefficient for lift-induced drag
    KCAS = Knots calibrated airspeed [knots]
    KTAS = Knots true airspeed [knots]
    n = Load factor
    q = Dynamic pressure [lbf/ft^2]
    qstall = Dynamic pressure @ stall condition [lbf/ft2]
    ROC = Rate of climb [ft/min] 
    S = Surface area [ft^2]
    SFC = Specific fuel consumption [lbf/(hr*BHP)]
    SG = Ground run [ft] 
    T = Thrust [lbf]
    TtoW = Thrust-to-weight ratio
    V = Airspeed [ft/s]
    VC = Cruise speed [ft/s]
    VLOF = Liftoff speed [ft/s]
    Vs = Stall speed [ft/s]
    VV = Vertical speed [ft/s]
    W = Weight [lbf]
    WtoS = Wing loading [lbf/ft^2]
    mu = Ground friction constant
    eta = Propeller efficiency factor
    rho = Density [slugs/ft^3]
%}



%% input data
    W = 2000; %(lbf)
    WtoS = linspace(5,58);%(lbf/ft^2)
    AR = 9;
    CDTO =  0.04;
    CDmin =  0.025;
    CLTO = 0.8;
    e = 1.78*(1-(0.045*(AR)^0.68))-0.64;
    g = 32.174; %(ft/s^2)
    Hcruise = 8000;%(ft)
    HCelling = 20000;%(ft)
    k = 1/(pi*AR*e);
    n = 2; % n=(1/cos(bank angle))
    ROC = 1500; %(ft/min)
    Vclimb = 80;%(KCAS)
    VC = 150;%(KTAS)
    VLOF = 65;%(KCAS)
    Vs = 0.3*VC;%(ft/s)
    VV = ROC/60;%(ft/s)
    rhoTO = 0.002378; %international standard atmosphere (slugs/ft^3)
    qcruise = 0.5*rhocal(Hcruise)*(1.688*VC)^2;%(lbf/ft^2)
    qTO = 0.5*rhoTO*((1.688*VLOF)/(2)^(1/2))^2;%(lbf/ft^2)
    qclimb = 0.5*rhoTO*(1.688*Vclimb)^2;%(lbf/ft^2)
    qstall = 0.5*rhocal(Hcruise)*(1.688*Vs)^2;%(lbf/ft^2)
    SG = 900;%(ft)
    mu = 0.04;
    eta = 0.80;
    CLmax = (1/qstall).*WtoS;
   
    
%% T/W for a Level Constant-velocity Turn
    TtoW = qcruise*((CDmin./WtoS)+(k*(n/qcruise)^2).*(WtoS));

    plot(WtoS,TtoW)
    title('Constraint Diagram')
    xlabel('Wing Loading, W/S') 
    ylabel('Thrust Loading, T/W') 
    ylim([0 1])
    %legend({'Turn Requirement'},'Location','northeast')
    hold on
    
%% T/W for a Desired Rate of Climb 
    TtoW = (VV/(1.688*Vclimb))+((qclimb./WtoS))*CDmin + ((k/qclimb).*WtoS);
    plot(WtoS,TtoW)
    %legend({'Turn Requirement','Climb Requirement'},'Location','northeast')
    hold on

%% T/W for a Desired T-O Distance 
    %disp(qTO)
    TtoW = (((1.688*VLOF)^2)/(2*g*SG)) + ((qTO*CDTO)./WtoS) + mu.*(1-((qTO*CLTO)./WtoS));
    plot(WtoS,TtoW)
    %legend({'Turn Requirement','Climb Requirement','T-O Requirement'},'Location','northeast')
     hold on
     
%% T/W for a Desired Cruise Airspeed
    %disp(qcruise)
    TtoW = ((qcruise*CDmin)./WtoS) + (k/qcruise).*WtoS;
    plot(WtoS,TtoW)
    %legend({'Turn Requirement','Climb Requirement','T-O Requirement','Airspeed Requirement'},'Location','northeast')
     hold on
    
%% T/W for a Service Ceiling
    %disp(rhocal(HCelling))
    TtoW = (1.667./((2./rhocal(HCelling)).*WtoS.*(k./(3*CDmin)).^(1/2)).^(1/2)) + 4*((k*CDmin)./3).^(1/2);
     plot(WtoS,TtoW)
    %legend({'Turn Requirement','Climb Requirement','T-O Requirement','Airspeed Requirement','Service Celling'},'Location','northeast')
     hold on
    %disp(TtoW)
     
%% CLmax for a Desired Stalling Speed
    %disp(CLmax)
    yyaxis right
    ylim([0 5])
    for i = 30:10:70
        qstall = 0.5*rhocal(Hcruise)*(1.688*i)^2;
        CLmax = (1/qstall).*WtoS;
        %disp(CLmax)
        plot(WtoS,CLmax)
        SlopeBetweenPoints = diff(CLmax)./diff(WtoS);
        disp(SlopeBetweenPoints)
        disp(5.*SlopeBetweenPoints(1))
        %text(1,1,'h');%strcat(int2str(i),' KCAS')
        text(double(5),double((5.*SlopeBetweenPoints(1))),strcat(int2str(i),' KCAS'),'FontSize', 5)
        hold on
    end
    ylabel('Required CLMAX') 
    
    legend({'Turn Requirement','Climb Requirement','T-O Requirement','Airspeed Requirement','Service Celling','Stall speed'},'Location','northeast')
    qstall = 0.5*rhocal(Hcruise)*(1.688*Vs)^2;
    CLmax = (1/qstall).*WtoS;
    plot(WtoS,CLmax)
    SlopeBetweenPoints = diff(CLmax)./diff(WtoS);
    %disp(SlopeBetweenPoints)
    VsText = strcat('VS = ',mat2str(Vs));
    text(5,(5.*SlopeBetweenPoints(1)),strcat(VsText,' KCAS'),'FontSize', 5)
    hold on
    
    qstall = 0.5*rhocal(Hcruise)*(1.688*61)^2;
    CLmax = (1/qstall).*WtoS;
    plot(WtoS,CLmax)
    SlopeBetweenPoints = diff(CLmax)./diff(WtoS);
    %disp(SlopeBetweenPoints)
    text(5,(5.*SlopeBetweenPoints(1)),'VS = 61 KCAS','FontSize',5) %FAR 23 limit
    hold on
     legend({'Turn Requirement','Climb Requirement','T-O Requirement','Airspeed Requirement','Service Celling','Stall speed','Stall speed Vs = 45 KCAS(LSA Limit)','Stall speed Vs = 61 KCAS(FAR 21 Limit)'},'Location','northeast')
    hold off
    figure
    
%% BHP Requirement
    
    TtoW = qcruise*((CDmin./WtoS)+(k*(n/qcruise)^2).*(WtoS));
    PBHP = (TtoW.*W.*1.688*VC)./(eta.*550);
    disp(PBHP)
    plot(WtoS,PBHP)
    title('BHP Requirement')
    xlabel('Wing Loading, W/S') 
    ylabel('Brake-horsepower Requirement,BHP') 
    ylim([0 400])
    %legend({'Turn Requirement'},'Location','northeast')
    hold on
    
    TtoW = (VV/(1.688*Vclimb))+((qclimb./WtoS))*CDmin + ((k/qclimb).*WtoS);
    PBHP = (TtoW.*W.*1.688*Vclimb)./(eta.*550);
    plot(WtoS,PBHP)
    %legend({'Turn Requirement','Climb Requirement'},'Location','northeast')
    hold on
    
    TtoW = (((1.688*VLOF)^2)/(2*g*SG)) + ((qTO*CDTO)./WtoS) + mu.*(1-((qTO*CLTO)./WtoS));
    PBHP = (TtoW.*W.*1.688*VLOF)./(eta.*550);
    plot(WtoS,PBHP)
    %legend({'Turn Requirement','Climb Requirement','T-O Requirement'},'Location','northeast')
     hold on
     
    TtoW = ((qcruise*CDmin)./WtoS) + (k/qcruise).*WtoS;
    PBHP = (TtoW.*W.*1.688*VC)./(eta.*550);
    plot(WtoS,PBHP)
    %legend({'Turn Requirement','Climb Requirement','T-O Requirement','Airspeed Requirement'},'Location','northeast')
     hold on
     
    TtoW = (1.667./((2./rhocal(HCelling)).*WtoS.*(k./(3*CDmin)).^(1/2)).^(1/2)) + 4*((k*CDmin)./3).^(1/2);
    PBHP = (TtoW.*W.*1.688*VC)./(eta.*550);
    plot(WtoS,PBHP)
    %legend({'Turn Requirement','Climb Requirement','T-O Requirement','Airspeed Requirement','Service Celling'},'Location','northeast')
     hold on
     
    yyaxis right
    ylim([0 5])
    for i = 30:10:70
        qstall = 0.5*rhocal(Hcruise)*(1.688*i)^2;
        CLmax = (1/qstall).*WtoS;
        plot(WtoS,CLmax)
        SlopeBetweenPoints = diff(CLmax)./diff(WtoS);
        disp(SlopeBetweenPoints)
        text(5,(5.*SlopeBetweenPoints(1)),strcat(int2str(i),' KCAS'),'FontSize', 5)
        hold on
    end
    ylabel('Required CLMAX') 
    
    legend({'Turn Requirement','Climb Requirement','T-O Requirement','Airspeed Requirement','Service Celling','Stall speed'},'Location','northeast')
    
    qstall = 0.5*rhocal(Hcruise)*(1.688*Vs)^2;
    CLmax = (1/qstall).*WtoS;
    plot(WtoS,CLmax)
    SlopeBetweenPoints = diff(CLmax)./diff(WtoS);
    disp(SlopeBetweenPoints)
    
    VsText = strcat('VS = ',mat2str(Vs));
    text(5,(5.*SlopeBetweenPoints(1)),strcat(VsText,' KCAS'),'FontSize', 5)
    
    hold on
        
    qstall = 0.5*rhocal(Hcruise)*(1.688*61)^2;
    CLmax = (1/qstall).*WtoS;
    plot(WtoS,CLmax)
    SlopeBetweenPoints = diff(CLmax)./diff(WtoS);
    %disp(SlopeBetweenPoints)
    text(5,(5.*SlopeBetweenPoints(1)),'VS = 61 KCAS','FontSize',5) %FAR 23 limit
    hold on
     legend({'Turn Requirement','Climb Requirement','T-O Requirement','Airspeed Requirement','Service Celling','Stall speed','Stall speed Vs = 45 KCAS(LSA Limit)','Stall speed Vs = 61 KCAS(FAR 21 Limit)'},'Location','northeast')
    hold off
    figure
     
%% BHP Requirement-Normalized to S-L

    TtoW = qcruise*((CDmin./WtoS)+(k*(n/qcruise)^2).*(WtoS));
    PBHP = (TtoW.*W.*1.688*VC)./(eta.*550);
    PBHPSL = PBHP/(1.132*(rhocal(Hcruise)/rhoTO)-0.132);
    fprintf('PBHPSL is %f',PBHPSL)
   
    plot(WtoS,PBHPSL)
    title('BHP Requirement-Normalized to S-L')
    xlabel('Wing Loading, W/S') 
    ylabel('Brake-horsepower Requirement,BHP') 
    ylim([0 400])
    %legend({'Turn Requirement'},'Location','northeast')
    hold on
    
    TtoW = (VV/(1.688*Vclimb))+((qclimb./WtoS))*CDmin + ((k/qclimb).*WtoS);
    PBHP = (TtoW.*W.*1.688*Vclimb)./(eta.*550);
    PBHPSL = PBHP/(1.132*(rhoTO/rhoTO)-0.132);
    plot(WtoS,PBHPSL)
    %legend({'Turn Requirement','Climb Requirement'},'Location','northeast')
    hold on
    
    TtoW = (((1.688*VLOF)^2)/(2*g*SG)) + ((qTO*CDTO)./WtoS) + mu.*(1-((qTO*CLTO)./WtoS));
    PBHP = (TtoW.*W.*1.688*VLOF)./(eta.*550);
    PBHPSL = PBHP/(1.132*(rhoTO/rhoTO)-0.132);
    plot(WtoS,PBHPSL)
    %legend({'Turn Requirement','Climb Requirement','T-O Requirement'},'Location','northeast')
     hold on
     
    TtoW = ((qcruise*CDmin)./WtoS) + (k/qcruise).*WtoS;
    PBHP = (TtoW.*W.*1.688*VC)./(eta.*550);
    PBHPSL = PBHP/(1.132*(rhocal(Hcruise)/rhoTO)-0.132);
    plot(WtoS,PBHPSL)
    %legend({'Turn Requirement','Climb Requirement','T-O Requirement','Airspeed Requirement'},'Location','northeast')
     hold on
     
    TtoW = (1.667./((2./rhocal(HCelling)).*WtoS.*(k./(3*CDmin)).^(1/2)).^(1/2)) + 4*((k*CDmin)./3).^(1/2);
    PBHP = (TtoW.*W.*1.688*VC)./(eta.*550);
    PBHPSL = PBHP/(1.132*(rhocal(HCelling)/rhoTO)-0.132);
    plot(WtoS,PBHPSL)
    %legend({'Turn Requirement','Climb Requirement','T-O Requirement','Airspeed Requirement','Service Celling'},'Location','northeast')
     hold on
     
    yyaxis right
    ylim([0 5])
    for i = 30:10:70
        qstall = 0.5*rhocal(Hcruise)*(1.688*i)^2;
        CLmax = (1/qstall).*WtoS;
        plot(WtoS,CLmax)
        SlopeBetweenPoints = diff(CLmax)./diff(WtoS);
        disp(SlopeBetweenPoints)
        text(5,(5.*SlopeBetweenPoints(1)),strcat(int2str(i),' KCAS'),'FontSize', 5)
        hold on
    end
    ylabel('Required CLMAX') 
    
    legend({'Turn Requirement','Climb Requirement','T-O Requirement','Airspeed Requirement','Service Celling','Stall speed'},'Location','northeast')
    
    qstall = 0.5*rhocal(Hcruise)*(1.688*Vs)^2;
    CLmax = (1/qstall).*WtoS;
    plot(WtoS,CLmax)
    SlopeBetweenPoints = diff(CLmax)./diff(WtoS);
    disp(SlopeBetweenPoints)
    
    VsText = strcat('VS = ',mat2str(Vs));
    text(5,(5.*SlopeBetweenPoints(1)),strcat(VsText,' KCAS'),'FontSize', 5)
    
    hold on
        
    legend({'Turn Requirement','Climb Requirement','T-O Requirement','Airspeed Requirement','Service Celling','Stall speed','Stall speed Vs = 45 KCAS(LSA Limit)'},'Location','northeast')
    
    qstall = 0.5*rhocal(Hcruise)*(1.688*61)^2;
    CLmax = (1/qstall).*WtoS;
    plot(WtoS,CLmax)
    SlopeBetweenPoints = diff(CLmax)./diff(WtoS);
    %disp(SlopeBetweenPoints)
    text(5,(5.*SlopeBetweenPoints(1)),'VS = 61 KCAS','FontSize',5) %FAR 23 limit
    hold on
      legend({'Turn Requirement','Climb Requirement','T-O Requirement','Airspeed Requirement','Service Celling','Stall speed','Stall speed Vs = 45 KCAS(LSA Limit)','Stall speed Vs = 61 KCAS(FAR 21 Limit)'},'Location','northeast')
    hold off
    
     
     
    
     
     
    
    
    
    
    
    
    
    


