function lb_plot(results_path);
% VSDP_PLOT

%% Constants
solver_names = {'mosek' 'sdpt3' 'sedumi' 'linprog' 'mosek_INTPNT_ITR' 'mosek_INTPNT_BAS' 'mosek_INTPNT_ONLY'};

%% I/O
load(results_path, 'data');
start_point = data.start_point; 
stop_point = data.stop_point;
steps = data.steps; 
nout = data.nout;
basis = data.basis;
const_type = data.const_type;

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

%% Plotting
figure();
hold('on');
for idx = 1:length(solvers)
    solver = solvers{idx};
    lbs = data.([solver '_lbs']);
    fprintf('##########%s##########\n',solver);
    fprintf('Number of +Inf = %d\n', sum(lbs == inf));
    fprintf('Number of -Inf = %d\n', sum(lbs == -inf));
    plot(range_, lbs, 'LineWidth', 1, 'Marker', '+');
    xlim([start_point stop_point]);
    %ylim([min_ max_]);
end
legend(solvers);
hold('off');

grid('on');
title(['basis:' basis '   ' const_type], 'Interpreter','none');
xlabel('eta');
ylabel('primal obj. bounds');

% outerpos = ax.OuterPosition;
% ti = ax.TightInset; 
% left = outerpos(1) + ti(1);
% bottom = outerpos(2) + ti(2);
% ax_width = outerpos(3) - ti(1) - ti(3);
% ax_height = outerpos(4) - ti(2) - ti(4);
% ax.Position = [left bottom ax_width ax_height];

%plot([position(1) x1],[position(2) y1],'w','LineWidth',8);
%fig=gcf;
%fig.Position
%NewPos = [Tight(1) Tight(2) 1-Tight(1)-Tight(3) 1-Tight(2)-Tight(4)]; %New plot position [X Y W H]
%set(gca, 'Position', NewPos);

end