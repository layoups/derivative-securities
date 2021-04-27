%% data
stock = 200;
sigma = 0.2;
rate = 0.04;
T = 2; 
steps = 360 * T;
JumpMean = 0.8;
JumpVol = 0.3;       
JumpFreq = 5;

%% GBM 
mod_gbm = gbm(rate, sigma, 'StartState', stock);

%% simulated GBM
nTrials = 20000;

s = simulate(mod_gbm, steps,...
 'DeltaTime', T/steps, 'nTrials', nTrials);
s = squeeze(s);


%% calculating probability that stock crosses 220 in months 5 and 10
count_event = (max(s([121:151],:)) > 220) & (max(s([271:301],:)) > 220);

%% probability Q1
prob_event = sum(count_event)/nTrials

%% pricing an occupation time option with gbm Q2
days_in_range_gbm = nan(1, nTrials);
for i = 1:nTrials
    days_in_range_gbm(i) = sum(s(:, i) >= 225 & s(:, i) <= 230);
end

price_gbm = mean(exp(-rate*T)*days_in_range_gbm)

%% Jump & Simulation
merton_dynamics = merton(rate,sigma,JumpFreq,JumpMean,JumpVol,...
                'StartState',stock);
t = simulate(merton_dynamics, steps,...
 'DeltaTime', T/steps, 'nTrials', nTrials);
t = squeeze(t);

%% pricing an occupation time option with jump Q3
days_in_range_jump = nan(1, nTrials);
for i = 1:nTrials
    days_in_range_jump(i) = sum(t(:, i) >= 225 & t(:, i) <= 230);
end

price_jump = mean(exp(-rate*T)*days_in_range_jump)

%% Q4 GBM
count_event_1_gbm = s([1:61], :) > 225;
count_event_2_gbm = max(s([1:61], :)) < 225 & max(s([300:361], :)) > 225;
count_event_3_gbm = max(s([1:61], :)) < 225 & max(s([300:361], :)) < 225;

timing_gbm = nan(nTrials,1)';
aux_gbm = [count_event_1_gbm ;ones(1,nTrials)];
for i = 1:nTrials
     timing_gbm(i)=find(aux_gbm(:,i), 1, 'first');
end

payoff_1_gbm = 1000 * max(count_event_1_gbm);
payoff_2_gbm = s(361, :) .* count_event_2_gbm;
payoff_3_gbm = 0 * count_event_3_gbm;

price_q4_gbm = mean(exp(-rate*timing_gbm/360) .* payoff_1_gbm ... 
    + exp(-rate) * payoff_2_gbm)
            
%% Q4 Jump
count_event_1_jump = t([1:61], :) > 225;
count_event_2_jump = max(t([1:61], :)) < 225 & max(t([300:361], :)) > 225;
count_event_3_jump = max(t([1:61], :)) < 225 & max(t([300:361], :)) < 225;

timing_jump = nan(nTrials,1)';
aux_jump = [count_event_1_jump ;ones(1,nTrials)];
for i = 1:nTrials
     timing_jump(i)=find(aux_jump(:,i), 1, 'first');
end

payoff_1_jump = 1000 * max(count_event_1_jump);
payoff_2_jump = t(361, :) .* count_event_2_jump;
payoff_3_jump = 0 * count_event_3_jump;

price_q4_jump = mean(exp(-rate*timing_jump/360) .* payoff_1_jump ... 
    + exp(-rate) * payoff_2_jump)
