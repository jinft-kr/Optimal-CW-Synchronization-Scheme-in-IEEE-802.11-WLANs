clc
clear all

% Parameter %
%for n=2:1:5% n은 MS의 수 + AP의 수(1개)
for W=2:1:33% n은 MS의 수 + AP의 수(1개)
n=8;
%payload_byte = 1000; % packer size 고정
payload = 10000;
MAC = 272;
PHY = 128;
beacon = 696;
ACK = 112;
CTS = 112;
RTS = 160;
SIFS = 28 * 10^(-6);    %10^(-6): micro
PIFS =  30* 10^(-6);
DIFS = 128 * 10^(-6);
p_delay = 1 * 10^(-6);
slot_time = 50 * 10^(-6);
data_rate =  500*10^6; % Data rate
basic_rate = 10*10^6;

m = 0; % backoff stage 개수 (0~6)
%W = 25; % backoff time 개수 (0~31)

tao = 2/(W+1); % m=0 인 경우 tao 구하는 식
p = 1 - (1 - tao)^(n-1);
%p = 0;
T_data = PHY/basic_rate + (MAC + payload)/data_rate; %ok
T_PHY = PHY / basic_rate;
T_ACK = ACK / basic_rate + T_PHY;
T_RTS = RTS / basic_rate + T_PHY;
T_CTS = CTS / basic_rate + T_PHY;

 
P_tr = 1 - (1-tao)^n;
%P_tr = tao;
P_s = ((n*tao)*(1-tao)^(n-1))/(1-(1-tao)^n);
%P_s=1;

T_s_bas = DIFS + T_data + p_delay + SIFS + T_ACK + p_delay; % success in baisic mode transmission
T_c_bas = DIFS + T_data + p_delay; % collision in basic transmission

T_s_rts = DIFS + (T_RTS ) + p_delay + SIFS + (T_CTS ) + p_delay + SIFS + T_data + p_delay + SIFS + (T_ACK ) + p_delay; %success in RTS/CTS transmission
T_c_rts = DIFS + (T_RTS + T_PHY) + p_delay; % collision in RTS/CTS transmission

E_S_bas = ((1-P_tr)*slot_time + P_tr*P_s*T_s_bas + P_tr*(1-P_s)*T_c_bas); % slot의 평균 길이  
E_S_rts = ((1-P_tr)*slot_time + P_tr*P_s*T_s_rts+ P_tr*(1-P_s)*T_c_rts);

E_X_bas = ((1-2*p)*(W+1)+p*W*(1-(2*p)^m))/(2*(1-2*p)*(1-p)); % m이 0일 때 1나누기 b0,0 -> 전송시 slot의 평균 개수
E_X_rts = ((1-2*p)*(W+1)+p*W*(1-(2*p)^m))/(2*(1-2*p)*(1-p));

Thru_bas_2 = (P_s*P_tr*payload)/E_S_bas/(10^6); %비앙키 논문 방식
Thru_bas = (n*payload/(E_S_bas*E_X_bas))/(10^6)
Thru_rts = (n*payload/(E_S_rts*E_X_rts))/(10^6); %IEICE 논문 방식


%plot(n,(P_s*P_tr*payload/E_S_bas)/(data_rate),'^')

%plot(n,Thru_rts,'+')

%hold on
plot(W,Thru_bas,'*')
%plot(W,Thru_bas_2,'+')
    hold on   
    
%old on
end