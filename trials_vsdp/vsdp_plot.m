function vsdp_plot(results_path, est, qtile);
% VSDP_PLOT

%% Constants
solver_names = {'mosek' 'sdpt3' 'sedumi' 'linprog' 'mosek_INTPNT_ITR' 'mosek_INTPNT_BAS' 'mosek_INTPNT_ONLY'};


if nargin <2
   est = true; %default
end

if nargin < 3
    qtile = 0.3; %default parameter for line fitting
end
%% I/O
load(results_path, 'data');
start_point = data.start_point; 
stop_point = data.stop_point;
steps = data.steps; 
nout = data.nout;
basis = data.basis;
slack = data.slack;

interval = (stop_point-start_point)/steps;
range_ = start_point:interval:stop_point;

%% Get list of solvers in actual data
counter = 0;
solvers = {};
for solver = solver_names
    if isfield(data, [solver{1} '_lbs'])
        counter = counter + 1;
        solvers{counter} = solver{1};
    end
end

%% Print stats for all data
% all_nums = [];
% for solver = solvers
%     lbs = data.([solver{1} '_lbs']);
%     ubs = data.([solver{1} '_ubs']);
%     all_nums = [all_nums lbs ubs];
% end
% 
% fprintf('Number of +Inf = %d\n', sum(all_nums == inf));
% fprintf('Number of -Inf = %d\n', sum(all_nums == -inf));
% fprintf('Number of NaN = %d\n', sum(isnan(all_nums)));
% all_nums = all_nums(isfinite(all_nums));
% fprintf('Max = %e\n', max(all_nums));
% fprintf('Min = %e\n', min(all_nums));

%% Calculate best y range for plotting
max_ = -inf;
min_ = inf;

for solver = solvers
    lbs = data.([solver{1} '_lbs']);
    ubs = data.([solver{1} '_ubs']);
    lbs_fin = lbs(isfinite(lbs));
    ubs_fin = ubs(isfinite(ubs));
    % Statistics for group data
    fprintf('##########%s##########\n',solver{1});
    fprintf('----Upper----\n');
    fprintf('Number of +Inf = %d\n', sum(ubs == inf));
    fprintf('Number of -Inf = %d\n', sum(ubs == -inf));
    fprintf('Number of NaN = %d\n', sum(isnan(ubs)));
    fprintf('Max = %e\n', max(ubs_fin));
    fprintf('Min = %e\n', min(ubs_fin));
    fprintf('----Lower----\n');
    fprintf('Number of +Inf = %d\n', sum(lbs == inf));
    fprintf('Number of -Inf = %d\n', sum(lbs == -inf));
    fprintf('Number of NaN = %d\n', sum(isnan(lbs)));
    fprintf('Max = %e\n', max(lbs_fin));
    fprintf('Min = %e\n', min(lbs_fin));
    
    if est
        % Fit line using the lower 30% quantile
        ubs_fin = sort(ubs_fin);
        y = ubs_fin(1:round(qtile*length(ubs_fin)));
        x = zeros(1, length(y));
        for idx = 1:length(y)
            k = find(ubs==y(idx));
            if length(k) == 0
                error('No k found');
            elseif length(k) > 1
                error('Multiple k found');
            else
                x(idx) = range_(k);
            end
        end
        coefs = polyfit(x,y,1);
        est_max = start_point*coefs(1) + coefs(2);
        est_min = min(lbs_fin);
    else
        est_max = max(ubs_fin);
        est_min = min(lbs_fin);
    end
    max_ = max(est_max, max_);
    min_ = min(est_min, min_);
    
end

% add margin
margin_ratio = 0.1;
margin_width = (max_ - min_) * margin_ratio;
max_ = max_ + margin_width;
min_ = min_ - margin_width;

%% Plotting
figure();
for idx = 1:length(solvers)
    solver = solvers{idx};
    lbs = data.([solver '_lbs']);
    ubs = data.([solver '_ubs']);
    
    ax = subplot(length(solvers),1,idx);
    plot(range_, lbs, range_, ubs,'LineWidth',2);
    xlim([start_point stop_point]);
    ylim([min_ max_]);
    grid('on');
    title(['   basis:' solver '   basis:' basis '   ' slack], 'Interpreter','none');
    if idx == length(solvers)
        xlabel('eta');
    end
    ylabel('primal obj. bounds');
    outerpos = ax.OuterPosition;
    ti = ax.TightInset; 
    left = outerpos(1) + ti(1);
    bottom = outerpos(2) + ti(2);
    ax_width = outerpos(3) - ti(1) - ti(3);
    ax_height = outerpos(4) - ti(2) - ti(4);
    ax.Position = [left bottom ax_width ax_height];
end

%plot([position(1) x1],[position(2) y1],'w','LineWidth',8);
%fig=gcf;
%fig.Position
%NewPos = [Tight(1) Tight(2) 1-Tight(1)-Tight(3) 1-Tight(2)-Tight(4)]; %New plot position [X Y W H]
%set(gca, 'Position', NewPos);

end