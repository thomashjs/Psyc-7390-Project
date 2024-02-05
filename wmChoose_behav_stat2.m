root = '/Users/thomas/Desktop/Sprague Lab'; % specifies the directory where the data files are
subj = {'sub001','sub002','sub003','sub004','sub005','sub006','sub007','sub008','sub009','sub010','sub011','sub012','sub013','sub014','sub015','sub017','sub018'}; % define cell array of subject IDs
% up to S11 for exp1
% up to S18 for exp2
% ROIs = {'V1','V2','V3','V3AB','IPS0','IPS1','IPS2','IPS3','iPCS','sPCS'}; % define ROI array

%% scatter plot
utilities;
targ = [];

for ss = 1:length(subj)
    sub = sprintf('wmChooseData/%s_wmChooseUnc_behav.mat', subj{ss});
    load(sub);
    % cartesian to polar coordinates
    targ1 = cart2pol(coords_all{1,1}(:,1), coords_all{1,1}(:,2))/pi*180;
    targ2 = cart2pol(coords_all{1,2}(:,1), coords_all{1,2}(:,2))/pi*180;

end

%% 
figure;

for ss = 1:length(subj)
    subplot(3,6,ss); hold on;
    sub = sprintf('wmChooseData/%s_wmChooseUnc_behav.mat', subj{ss});
    load(sub);

    scatter(c_all(:,2),resp_all(:,4),10,'r','filled', 'markerfacealpha',.5);

    if ss == 1
        xlabel('Target location (°)'); ylabel('Reported location (°)');
    end

    xlim([0 360]);ylim([0 360]);
    set(gca,'TickDir','out','XTick',[0 180 360],'YTick',[0 180 360]);
    title(subj{ss});
    axis square;
end

%% Single subj error scatter
load('wmChooseData/sub007_wmChooseUnc_behav.mat')
b = [c_all(:,2) resp_all(:,4)];
error = min([abs(b(:,2)-b(:,1)), abs(b(:,2)-b(:,1)-360), abs(b(:,2)-b(:,1)+360)],[], 2);
figure;
scatter(b(:,1), error);

%% Single Subject error binned
load('wmChooseData/sub005_wmChooseUnc_behav.mat')
figure;
n_bin = 12+1;
edge = [0,10,35,55,80,100,125,145,170,190,215,225,260,280,305,325,360];
ss = 4;
sub = sprintf('wmChooseData/%s_wmChooseUnc_behav.mat', subj{ss});
load(sub);
b = [c_all(:,2) resp_all(:,4)];
newb = sortrows(b);
bins = discretize(newb(:,1), edge);
error = min([abs(newb(:,2)-newb(:,1)), abs(newb(:,2)-newb(:,1)+360), ...
    abs(newb(:,2)-newb(:,1)-360)],[],2); % response - target
c = [bins, newb, error];

boxchart(bins, c(:,4))

ax = gca(); 
ax.XTick = 1:max(bins);
ylim([0 40])
ax.XTickLabel = compose('[%.0f, %.0f] ',edge(1:length(edge)-1)', ...
    edge(2:length(edge))');
xlabel('Target location (°)'); ylabel('Absolute Error (°)');

%% All subjects error
n_bin = 12+1;
edge = linspace(0, 360, n_bin);
figure;
for ss = 1:length(subj)
    subplot(3,6,ss); hold on;
    if ss == 1
        xlabel('Target location (°)'); ylabel('Absolute Error (°)');
    end
    sub = sprintf('wmChooseData/%s_wmChooseUnc_behav.mat', subj{ss});
    load(sub);
    b = [c_all(:,2) resp_all(:,4)];
    newb = sortrows(b);
    bins = discretize(newb(:,1), edge);
    error = min([abs(newb(:,2)-newb(:,1)), abs(newb(:,2)-newb(:,1)+360), ...
        abs(newb(:,2)-newb(:,1)-360)],[],2); % response - target but circular
    c = [bins, newb, error];

    boxchart(bins, c(:,4))

    ax = gca(); 
    ax.XTick = 1:max(bins);
    ylim([0 40])
    ax.XTickLabel = compose('[%.0f, %.0f] ',edge(1:length(edge)-1)', ...
        edge(2:length(edge))');
end

%% Model 1 Parameter Finding
P = [];
lh = [];
v = @(y, q, t) (-q*cos(y*2*pi/90)+q+t); % model variance as a function of target position
% the variance is modeled to be highest at oblique angles and lowest at cardinals
for ss = 1:length(subj)
    sub = sprintf('wmChooseData/%s_wmChooseUnc_behav.mat', subj{ss});
    load(sub);
    x = c_all(:,2);
    xr = resp_all(:,4);
    f = @(b,c) sum(-(x-xr).^2./(2*v(x,b,c).^2) - log(v(x,b,c)*sqrt(2*pi))); 
    XT = fmincon(@(q) -f(q(1),q(2)), [10, 40], [], [], [], [])';
    P = [P XT];
    lh = [lh f(XT(1),XT(2))];
end
%% Plotting Model 1 Variances
figure;
y = linspace(0, 360,200)';
plot(y,v(y,20,20));
xlabel('Target Position'); ylabel('Variance')
ylim([0,80]);
xlim([0,360])


%% Model 2 Parameter Finding
P2=[];
lh2 = [];
for ss = 1:length(subj)
    sub = sprintf('wmChooseData/%s_wmChooseUnc_behav.mat', subj{ss});
    load(sub);
    x = c_all(:,2);
    xr = resp_all(:,4);
    f = @(vr) sum(-(x-xr).^2/(2*vr^2) - log(vr*sqrt(2*pi))); 
    XT = fmincon(@(b)-f(b), 10, [], [], [], []);
    P2 = [P2 XT];
    lh2 = [lh2 f(XT)];
end

%% Group Plot Variances of 2 Models
figure;
y = linspace(0, 360,200)';
plot(y,v(y,P(1,4),P(2,4))); hold on;
yline(P2(4)); hold off;
xlabel('Target Position (°)'); ylabel('variance')
legend('FVM','CVM')

figure;
for ss = 1:length(subj)
    subplot(3,6,ss); hold on;
    plot(y,v(y,P(1,ss),P(2,ss))); hold on;
    yline(P2(4)); hold off;
    ylim([0 140]);
    if ss==1
        xlabel('Target Position (°)'); ylabel('variance');
        legend('FVM','CVM');
    end
end

%% Results
% the fitted variances are opposite to what was expected
% the amplitude parameter was tuned to be a negative number
% which gives variances that are highest around cardinal angles.
% the cause for this is unclear
%% Likelihood Plots
modelsuccess = lh>=lh2;
figure;
ax = categorical(subj);
scatter(ax,lh); hold on;
scatter(ax,lh2)
xlabel('Subject Number'); ylabel('Log Likelihoods'); legend('FVM','CVM');

%% BIC
nn = ones(1,length(subj));
for ss = 1:length(subj)
    sub = sprintf('wmChooseData/%s_wmChooseUnc_behav.mat', subj{ss});
    load(sub);
    nn(ss) = length(c_all);
end

bic1 = 2*log(nn)-2*lh;
bic2 = log(nn)-2*lh2;

figure;
ax = categorical(subj);
scatter(ax, bic1); hold on;
scatter(ax, bic2);
xlabel('Subject Number'); ylabel('BIC'); legend({'FVM','CVM'});